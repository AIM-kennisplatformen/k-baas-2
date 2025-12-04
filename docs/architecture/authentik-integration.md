# Authentik + FastAPI Integration Research Report

## Executive Summary

**Authentik** is a mature, self-hosted identity provider supporting OAuth2/OIDC, SAML, LDAP, and SCIM. It integrates well with FastAPI backends using standard OIDC token validation. The recommended approach uses JWT validation via the `fastapi-oidc` library or direct JWKS validation.

### Key Decisions

| Decision | Recommendation |
|----------|----------------|
| **Token Format** | JWT (signed, optionally encrypted) |
| **Validation Method** | Local JWT validation via JWKS endpoint |
| **Python Library** | `fastapi-oidc` or `python-jose` + `httpx` |
| **RBAC** | Map Authentik groups to application roles via token claims |
| **Session Strategy** | Stateless JWT for API, cookie-based for web UI |

---

## 1. Architecture Design

### System Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   Frontend      │────▶│   Authentik      │◀────│  Social Logins  │
│   (React)       │     │   (IdP/SSO)      │     │  Google/GitHub  │
└────────┬────────┘     └────────┬─────────┘     └─────────────────┘
         │                       │
         │  JWT Token            │ OIDC/.well-known
         ▼                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                        FastAPI Backend                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │ Auth Deps   │  │ RBAC Check  │  │ Protected Endpoints     │ │
│  │ (JWT Valid) │─▶│ (Groups)    │─▶│ /api/v1/*               │ │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Authentication Flow

1. **User Login**: Frontend redirects to Authentik login
2. **Social/Password Auth**: Authentik handles auth via flows
3. **Token Issuance**: Authentik returns JWT (access + optional refresh)
4. **API Requests**: Frontend sends `Authorization: Bearer <token>`
5. **Validation**: FastAPI validates JWT against Authentik JWKS

---

## 2. Authentik Configuration

### Key Endpoints (per application)

| Endpoint | URL Pattern |
|----------|-------------|
| Authorization | `/application/o/authorize/` |
| Token | `/application/o/token/` |
| Introspection | `/application/o/introspect/` |
| JWKS | `/application/o/<slug>/jwks/` |
| OpenID Config | `/application/o/<slug>/.well-known/openid-configuration` |
| Revocation | `/application/o/revoke/` |

### OAuth2 Provider Settings

```yaml
# Authentik OAuth2 Provider Configuration
name: "K-BAAS-2 API"
authorization_flow: "default-provider-authorization-implicit-consent"
client_type: "confidential"
client_id: "<generated>"
client_secret: "<generated>"
redirect_uris:
  - "http://localhost:6166/callback"
  - "http://localhost:6166/silent-renew"
signing_key: "<select certificate for asymmetric signing>"
access_token_validity: "minutes=30"
refresh_token_validity: "days=30"
scopes:
  - openid
  - profile
  - email
  - offline_access  # Required for refresh tokens
```

### Scopes & Claims

| Scope | Claims Included |
|-------|-----------------|
| `openid` | `sub`, `iss`, `aud`, `exp`, `iat` |
| `profile` | `name`, `preferred_username`, `groups` |
| `email` | `email`, `email_verified` |
| `offline_access` | Enables refresh tokens |
| `goauthentik.io/api` | Authentik API access |

---

## 3. FastAPI Integration Code

### Option A: Using `fastapi-oidc` (Recommended)

```python
# app/auth.py
from typing import Callable
from fastapi import Depends, HTTPException, status
from fastapi_oidc import IDToken, get_auth
from pydantic import BaseModel

from app.config import get_settings

settings = get_settings()

# Custom token model with groups for RBAC
class AuthenticatedUser(IDToken):
    """Extended ID token with Authentik-specific claims."""
    preferred_username: str | None = None
    email: str | None = None
    groups: list[str] = []

    def has_role(self, role: str) -> bool:
        """Check if user has a specific role/group."""
        return role in self.groups

# OIDC Configuration
OIDC_CONFIG = {
    "client_id": settings.authentik_client_id,
    "base_authorization_server_uri": settings.authentik_url,
    "issuer": settings.authentik_issuer,
    "signature_cache_ttl": 3600,
}

# Auth dependency
authenticate_user: Callable = get_auth(**OIDC_CONFIG, token_type=AuthenticatedUser)

def get_current_user(user: AuthenticatedUser = Depends(authenticate_user)) -> AuthenticatedUser:
    """Get current authenticated user."""
    return user

def require_role(role: str):
    """Dependency factory for role-based access."""
    def role_checker(user: AuthenticatedUser = Depends(get_current_user)) -> AuthenticatedUser:
        if not user.has_role(role):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Role '{role}' required"
            )
        return user
    return role_checker

# Role dependencies
require_admin = require_role("kb-admin")
require_editor = require_role("kb-editor")
require_viewer = require_role("kb-viewer")
```

### Option B: Manual JWT Validation (More Control)

```python
# app/auth.py
from typing import Any
import httpx
from jose import jwt, JWTError
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2AuthorizationCodeBearer
from pydantic import BaseModel

from app.config import get_settings

settings = get_settings()

oauth2_scheme = OAuth2AuthorizationCodeBearer(
    authorizationUrl=f"{settings.authentik_url}/application/o/authorize/",
    tokenUrl=f"{settings.authentik_url}/application/o/token/",
)

class AuthenticatedUser(BaseModel):
    sub: str
    email: str | None = None
    preferred_username: str | None = None
    groups: list[str] = []

# Cache for JWKS
_jwks_cache: dict[str, Any] | None = None

async def get_jwks() -> dict[str, Any]:
    """Fetch and cache JWKS from Authentik."""
    global _jwks_cache
    if _jwks_cache is None:
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{settings.authentik_url}/application/o/{settings.authentik_app_slug}/jwks/"
            )
            _jwks_cache = response.json()
    return _jwks_cache

async def get_current_user(token: str = Depends(oauth2_scheme)) -> AuthenticatedUser:
    """Validate JWT and return user."""
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        jwks = await get_jwks()
        payload = jwt.decode(
            token,
            jwks,
            algorithms=["RS256"],
            audience=settings.authentik_client_id,
            issuer=settings.authentik_issuer,
        )
        return AuthenticatedUser(
            sub=payload["sub"],
            email=payload.get("email"),
            preferred_username=payload.get("preferred_username"),
            groups=payload.get("groups", []),
        )
    except JWTError:
        raise credentials_exception
```

### Protected Endpoints Example

```python
# app/routers/knowledge_base.py
from fastapi import APIRouter, Depends
from app.auth import get_current_user, require_editor, AuthenticatedUser

router = APIRouter(prefix="/api/v1/kb", tags=["knowledge-base"])

@router.get("/")
async def list_knowledge_bases(user: AuthenticatedUser = Depends(get_current_user)):
    """List knowledge bases user has access to."""
    return {"user": user.preferred_username, "groups": user.groups}

@router.post("/")
async def create_knowledge_base(user: AuthenticatedUser = Depends(require_editor)):
    """Create new knowledge base (requires editor role)."""
    return {"created_by": user.sub}
```

---

## 4. RBAC Implementation

### Authentik Groups Structure

```
kb-admin        # Full access, manage users
├── kb-editor   # Create/edit content
│   └── kb-viewer   # Read-only access
```

### Group-to-Permission Mapping

| Authentik Group | Application Permissions |
|-----------------|------------------------|
| `kb-admin` | All operations, user management |
| `kb-editor` | Create, read, update knowledge bases |
| `kb-viewer` | Read-only access |
| `kb-owner:{kb_id}` | Owner of specific knowledge base |

### Permission Checking Pattern

```python
# app/permissions.py
from enum import Enum
from fastapi import HTTPException, status
from app.auth import AuthenticatedUser

class Permission(str, Enum):
    KB_CREATE = "kb:create"
    KB_READ = "kb:read"
    KB_UPDATE = "kb:update"
    KB_DELETE = "kb:delete"
    KB_MANAGE_USERS = "kb:manage_users"

ROLE_PERMISSIONS = {
    "kb-admin": [Permission.KB_CREATE, Permission.KB_READ, Permission.KB_UPDATE,
                 Permission.KB_DELETE, Permission.KB_MANAGE_USERS],
    "kb-editor": [Permission.KB_CREATE, Permission.KB_READ, Permission.KB_UPDATE],
    "kb-viewer": [Permission.KB_READ],
}

def check_permission(user: AuthenticatedUser, permission: Permission) -> bool:
    """Check if user has required permission via any of their groups."""
    for group in user.groups:
        if group in ROLE_PERMISSIONS:
            if permission in ROLE_PERMISSIONS[group]:
                return True
    return False

def require_permission(permission: Permission):
    """Dependency for permission-based access."""
    def checker(user: AuthenticatedUser = Depends(get_current_user)):
        if not check_permission(user, permission):
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN)
        return user
    return checker
```

---

## 5. Social Login Configuration

### In Authentik Admin UI

1. **Navigate to**: Directory → Federation & Social login
2. **Add Source** for each provider:

#### Google

- Consumer Key: `<Google OAuth Client ID>`
- Consumer Secret: `<Google OAuth Secret>`
- Scopes: `openid email profile`

#### GitHub

- Consumer Key: `<GitHub OAuth App Client ID>`
- Consumer Secret: `<GitHub OAuth Secret>`
- Scopes: `read:user user:email`

3. **Enable on Login Flow**:
   - Go to Flows → default-authentication-flow → Stage Bindings
   - Edit identification stage → Add sources to "Selected sources"

---

## 6. Self-Service Flows

Authentik provides built-in flows for:

| Flow | Purpose |
|------|---------|
| **Enrollment** | User self-registration |
| **Recovery** | Password reset via email |
| **Stage Configuration** | TOTP/MFA setup |
| **Unenrollment** | Account deletion |

### Enrollment Flow Components

1. **Identification Stage**: Email/username input
2. **Email Verification Stage**: Sends confirmation link
3. **Prompt Stage**: Collects password, name
4. **User Write Stage**: Creates user account
5. **Login Stage**: Automatically logs in new user

---

## 7. Docker Compose Configuration

### Complete Setup for K-BAAS-2

```yaml
# docker-compose.yml
services:
  # ===================
  # AUTHENTIK SERVICES
  # ===================
  authentik-postgresql:
    image: docker.io/library/postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${AUTHENTIK_PG_DB:-authentik}
      POSTGRES_USER: ${AUTHENTIK_PG_USER:-authentik}
      POSTGRES_PASSWORD: ${AUTHENTIK_PG_PASS:?authentik database password required}
    volumes:
      - authentik_database:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -d $${POSTGRES_DB} -U $${POSTGRES_USER}"]
      interval: 30s
      timeout: 5s
      retries: 5
      start_period: 20s

  authentik-redis:
    image: docker.io/library/redis:alpine
    restart: unless-stopped
    command: --save 60 1 --loglevel warning
    volumes:
      - authentik_redis:/data
    healthcheck:
      test: ["CMD-SHELL", "redis-cli ping | grep PONG"]
      interval: 30s
      timeout: 3s
      retries: 5

  authentik-server:
    image: ghcr.io/goauthentik/server:2024.10
    restart: unless-stopped
    command: server
    environment:
      AUTHENTIK_SECRET_KEY: ${AUTHENTIK_SECRET_KEY:?authentik secret key required}
      AUTHENTIK_REDIS__HOST: authentik-redis
      AUTHENTIK_POSTGRESQL__HOST: authentik-postgresql
      AUTHENTIK_POSTGRESQL__NAME: ${AUTHENTIK_PG_DB:-authentik}
      AUTHENTIK_POSTGRESQL__USER: ${AUTHENTIK_PG_USER:-authentik}
      AUTHENTIK_POSTGRESQL__PASSWORD: ${AUTHENTIK_PG_PASS}
    ports:
      - "${AUTHENTIK_PORT_HTTP:-9000}:9000"
      - "${AUTHENTIK_PORT_HTTPS:-9443}:9443"
    volumes:
      - ./authentik/media:/media
      - ./authentik/templates:/templates
    depends_on:
      authentik-postgresql:
        condition: service_healthy
      authentik-redis:
        condition: service_healthy

  authentik-worker:
    image: ghcr.io/goauthentik/server:2024.10
    restart: unless-stopped
    command: worker
    environment:
      AUTHENTIK_SECRET_KEY: ${AUTHENTIK_SECRET_KEY}
      AUTHENTIK_REDIS__HOST: authentik-redis
      AUTHENTIK_POSTGRESQL__HOST: authentik-postgresql
      AUTHENTIK_POSTGRESQL__NAME: ${AUTHENTIK_PG_DB:-authentik}
      AUTHENTIK_POSTGRESQL__USER: ${AUTHENTIK_PG_USER:-authentik}
      AUTHENTIK_POSTGRESQL__PASSWORD: ${AUTHENTIK_PG_PASS}
    user: root
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./authentik/media:/media
      - ./authentik/templates:/templates
      - ./authentik/certs:/certs
    depends_on:
      authentik-postgresql:
        condition: service_healthy
      authentik-redis:
        condition: service_healthy

  # ===================
  # APPLICATION SERVICES
  # ===================
  backend:
    build: ./backend
    environment:
      AUTHENTIK_URL: http://authentik-server:9000
      AUTHENTIK_CLIENT_ID: ${AUTHENTIK_CLIENT_ID}
      AUTHENTIK_CLIENT_SECRET: ${AUTHENTIK_CLIENT_SECRET}
      AUTHENTIK_ISSUER: ${AUTHENTIK_ISSUER:-http://localhost:9000/application/o/k-baas-2/}
      AUTHENTIK_APP_SLUG: k-baas-2
    ports:
      - "${BACKEND_PORT:-6616}:6616"
    depends_on:
      - authentik-server

  frontend:
    build: ./frontend
    environment:
      VITE_AUTHENTIK_URL: ${AUTHENTIK_EXTERNAL_URL:-http://localhost:9000}
      VITE_AUTHENTIK_CLIENT_ID: ${AUTHENTIK_CLIENT_ID}
    ports:
      - "${FRONTEND_PORT:-6166}:6166"
    depends_on:
      - backend

volumes:
  authentik_database:
  authentik_redis:
```

### Environment Variables (.env)

```bash
# Authentik Core
AUTHENTIK_SECRET_KEY=<generate with: openssl rand -base64 36>
AUTHENTIK_PG_PASS=<generate with: openssl rand -base64 36>
AUTHENTIK_PG_DB=authentik
AUTHENTIK_PG_USER=authentik

# Authentik Ports
AUTHENTIK_PORT_HTTP=9000
AUTHENTIK_PORT_HTTPS=9443
AUTHENTIK_EXTERNAL_URL=http://localhost:9000

# OAuth2 Application (set after creating app in Authentik)
AUTHENTIK_CLIENT_ID=<from authentik admin>
AUTHENTIK_CLIENT_SECRET=<from authentik admin>
AUTHENTIK_ISSUER=http://localhost:9000/application/o/k-baas-2/

# Application
BACKEND_PORT=6616
FRONTEND_PORT=6166
```

---

## 8. Implementation Checklist

### Phase 1: Infrastructure Setup
- [ ] Add Authentik services to docker-compose.yml
- [ ] Generate secrets and configure .env
- [ ] Start Authentik and complete initial setup
- [ ] Create OAuth2 Provider for K-BAAS-2
- [ ] Create Application and link to provider

### Phase 2: Backend Integration
- [ ] Install `fastapi-oidc` or `python-jose` + `httpx`
- [ ] Add Authentik config to Settings class
- [ ] Implement auth dependencies (token validation)
- [ ] Implement RBAC helpers
- [ ] Protect API endpoints

### Phase 3: Frontend Integration
- [ ] Add OIDC client library (e.g., `oidc-client-ts`)
- [ ] Implement login/logout flows
- [ ] Store and refresh tokens
- [ ] Add auth header to API requests

### Phase 4: User Management
- [ ] Configure social login sources
- [ ] Set up enrollment flow
- [ ] Configure password recovery
- [ ] Create default groups (admin, editor, viewer)

---

## 9. Security Considerations

| Consideration | Recommendation |
|---------------|----------------|
| **Token Storage** | HttpOnly cookies for web, secure storage for mobile |
| **Token Lifetime** | Access: 15-30 min, Refresh: 7-30 days |
| **HTTPS** | Mandatory in production |
| **CORS** | Restrict to known origins |
| **Rate Limiting** | Enable in Authentik for login endpoints |
| **MFA** | Configure TOTP/WebAuthn for admin users |

---

## Sources

- [Authentik Documentation](https://docs.goauthentik.io/)
- [fastapi-oidc PyPI](https://pypi.org/project/fastapi-oidc/)
- [Authentik GitHub](https://github.com/goauthentik/authentik)
- [FastAPI Security Documentation](https://fastapi.tiangolo.com/tutorial/security/)
