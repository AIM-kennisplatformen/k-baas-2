# Security

## Authentication & Authorization

**Identity Provider: Authentik (Self-Hosted)**

All authentication and user management is handled by [Authentik](https://goauthentik.io/), a self-hosted identity provider deployed via Docker Compose. See [Authentik Integration](./authentik-integration.md) for complete implementation details.

**Authentication Features:**
- **SSO via OIDC/OAuth2:** JWT tokens signed asymmetrically (RS256) via Authentik JWKS
- **Social Login:** Google, GitHub, Microsoft configured as Authentik sources
- **Self-Service:** User registration, password recovery, and MFA via Authentik flows
- **Token Management:** Access tokens (30 min), refresh tokens (30 days) with `offline_access` scope

**Authorization (RBAC):**
- Authentik groups mapped to application roles: `kb-admin`, `kb-editor`, `kb-viewer`
- FastAPI `Depends()` validates JWT and checks group claims
- Knowledge base access control through team membership in Authentik
- Per-KB ownership via dynamic groups (e.g., `kb-owner:{kb_id}`)

## Input Validation & API Security

**Request Validation:**
- All external inputs validated using Pydantic models generated from TypeDB schema
- Validation at API boundary before service layer processing
- Whitelist approach for allowed values and formats

**API Protection:**
- Rate limiting: 100 requests per minute per user, 20 requests per minute for AI endpoints
- CORS policy with explicitly allowed origins only
- Security headers: HSTS, CSP, X-Frame-Options, X-Content-Type-Options
- HTTPS enforcement with redirect from HTTP

## Data Protection

**Encryption:**
- TLS 1.3 minimum for all external communications
- Sensitive data fields encrypted at rest in TypeDB
- No secrets, API keys, or sensitive data in logs or error responses

**Secrets Management:**
- Development: Environment variables with `.env` file validation
- Production: External secret management service integration
- Authentik manages JWT signing keys and rotation
- OAuth client secrets stored in Authentik configuration

## Database Security

**Multi-Database Isolation:**
- Core database access restricted to system services only
- Knowledge base databases isolated per-KB with access control
- Database connection pooling with authentication per connection
- TypeDB queries use parameterized queries to prevent injection
