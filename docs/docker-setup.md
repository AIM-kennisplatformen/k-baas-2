# K-BAAS-2 Docker Setup Documentation

This document explains how K-BAAS-2 uses Docker, Docker Compose, and environment variables to provide consistent development and production environments.

## Architecture Overview

K-BAAS-2 uses a layered Docker Compose architecture with four compose files that build upon each other:

```
docker-compose.base.yml        # Shared service definitions
        ↓
docker-compose.authentik.yml   # Authentik identity provider services
        ↓
docker-compose.yml             # Development overrides (hot-reload)
docker-compose.prod.yml        # Production overrides (optimized)
```

Each application service uses multi-stage Dockerfiles with different build targets:
- `development` stage: Volume mounts for live code changes, hot-reload enabled
- `production` stage: Source code baked into image, optimized for deployment

## Services

K-BAAS-2 runs seven Docker services across two groups:

### Application Services

| Service | Container | Port | Description |
|---------|-----------|------|-------------|
| TypeDB | kbaas-typedb | 1729, 1728 | Knowledge graph database (gRPC + HTTP API) |
| Backend | kbaas-backend | 6616 | FastAPI REST API |
| Frontend | kbaas-frontend | 6166 | React/Vite web application |

### Authentik Identity Provider Services

| Service | Container | Port | Description |
|---------|-----------|------|-------------|
| PostgreSQL | kbaas-authentik-db | - | Authentik database |
| Redis | kbaas-authentik-redis | - | Authentik cache/sessions |
| Server | kbaas-authentik-server | 9000, 9443 | Authentik web UI and API |
| Worker | kbaas-authentik-worker | - | Authentik background tasks |

## File Structure

```
k-baas-2/
├── docker-compose.base.yml      # Shared service definitions
├── docker-compose.authentik.yml # Authentik services
├── docker-compose.yml           # Development environment
├── docker-compose.prod.yml      # Production environment
├── kbaas                        # K-BAAS CLI tool
├── .env.example                 # Environment template (committed)
├── .env                         # Development secrets (NOT committed)
├── .env.production.example      # Production template (committed, no secrets)
├── .env.production              # Production config (NOT committed, copy from .example)
│
├── backend/
│   ├── Dockerfile               # Multi-stage Python build
│   ├── .dockerignore            # Build exclusions
│   ├── app/
│   │   └── config.py            # Pydantic settings with env vars
│   └── database/
│       ├── Dockerfile           # TypeDB with init script
│       ├── init-typedb.sh       # Database initialization
│       └── schema/
│           ├── schema.tql       # TypeDB schema
│           └── seed.tql         # Initial data
│
├── frontend/
│   ├── Dockerfile               # Multi-stage Node.js build
│   └── .dockerignore            # Build exclusions
│
└── authentik/                   # Runtime data (gitignored)
    ├── media/                   # Uploaded files
    ├── templates/               # Custom templates
    └── certs/                   # SSL certificates
```

## Docker Compose Files Explained

### 1. Base Compose (`docker-compose.base.yml`)

Defines shared service configurations used by both development and production. Contains:
- Service container names
- Build contexts and Dockerfile paths
- Port mappings (using environment variables)
- Health checks
- Common environment variables
- Network configuration (defined in environment-specific files)

Key features:
- TypeDB uses a custom Dockerfile with automated schema initialization
- Ports are parameterized via `${VARIABLE:-default}` syntax
- No volumes defined here (added by environment-specific files)

### 2. Authentik Compose (`docker-compose.authentik.yml`)

Defines the four Authentik services required for OAuth2/OIDC authentication:

```yaml
services:
  authentik-postgresql:  # Database for Authentik
  authentik-redis:       # Cache and session storage
  authentik-server:      # Main Authentik application
  authentik-worker:      # Background task processor
```

Dependencies ensure proper startup order via health checks.

### 3. Development Compose (`docker-compose.yml`)

Extends base and authentik with development-specific overrides:

```yaml
services:
  backend:
    extends:
      file: docker-compose.base.yml
      service: backend
    build:
      target: development     # Use development stage
    volumes:
      - ./backend:/app        # Source mount for hot-reload
      - /app/.venv            # Anonymous volume (protect container deps)
      - /app/__pycache__      # Anonymous volume
```

Key development features:
- Volume mounts enable hot-reload (code changes reflected immediately)
- Anonymous volumes prevent host directories from overwriting container dependencies
- Build target `development` selects the hot-reload stage in Dockerfile
- Uses `.env` file for configuration (not committed to git)

### 4. Production Compose (`docker-compose.prod.yml`)

Extends base and authentik with production-specific overrides:

```yaml
services:
  backend:
    build:
      target: production      # Use production stage
    # No volumes - code is baked into image
  
  frontend:
    build:
      args:                   # Build-time variables for Vite
        - VITE_BACKEND_URL=${VITE_BACKEND_URL}
        - VITE_AUTHENTIK_URL=${VITE_AUTHENTIK_URL}
```

Key production features:
- No volume mounts - source code is copied into images at build time
- Build target `production` selects optimized stage in Dockerfile
- Frontend build args pass `VITE_*` variables that get inlined during `npm build`
- Uses `.env.production` for non-secret defaults
- Secrets are injected via deployment platform

## Multi-Stage Dockerfiles

### Backend Dockerfile (`backend/Dockerfile`)

```dockerfile
# === BASE STAGE ===
FROM python:3.13-slim AS base
# Install uv package manager and system dependencies
# Install Python dependencies from pyproject.toml

# === DEVELOPMENT STAGE ===
FROM base AS development
# No COPY - code comes from volume mount
CMD ["uv", "run", "uvicorn", "app.main:app", "--reload"]

# === PRODUCTION STAGE ===
FROM base AS production
COPY . .  # Bake source code into image
CMD ["uv", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "6616", "--workers", "2"]
```

The `--reload` flag in development enables automatic restart when files change.

### Frontend Dockerfile (`frontend/Dockerfile`)

```dockerfile
# === BASE STAGE ===
FROM node:22-alpine AS base
# Install npm dependencies

# === DEVELOPMENT STAGE ===
FROM base AS development
# No COPY - code comes from volume mount
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "6166"]

# === PRODUCTION STAGE ===
FROM base AS production
ARG VITE_BACKEND_URL        # Receive build arg
ENV VITE_BACKEND_URL=${...} # Convert ARG to ENV
COPY . .
RUN npm run build           # Vite inlines VITE_* into bundle
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "6166"]
```

Vite requires `VITE_*` variables at build time (they get inlined into the JavaScript bundle).

### TypeDB Dockerfile (`backend/database/Dockerfile`)

Custom TypeDB container with automated initialization:

```dockerfile
FROM typedb/typedb:3.5.5
# Install TypeDB Console for schema management
COPY init-typedb.sh /usr/local/bin/
COPY schema/ /schema/
CMD ["/usr/local/bin/init-typedb.sh"]
```

The `init-typedb.sh` script:
1. Starts TypeDB server
2. Waits for it to be ready
3. Changes the admin password (if `ADMIN_PASSWORD` is set)
4. Creates the database (if `DATABASE_NAME` is set)
5. Loads the schema (if `SCHEMA_NAME` is set)
6. Loads seed data (if `SEED_NAME` is set)

## Environment Variables

### How Variables Flow Through the System

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ENVIRONMENT VARIABLE FLOW                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  .env / .env.production                                                      │
│         │                                                                    │
│         ▼                                                                    │
│  ┌─────────────────────────────────────────────────────────────┐            │
│  │              Docker Compose                                  │            │
│  │                                                              │            │
│  │  1. Port mappings:    ${FRONTEND_PORT:-6166}:6166           │            │
│  │  2. env_file:         loads all vars into containers        │            │
│  │  3. environment:      explicit variable mapping             │            │
│  │  4. build.args:       passed to Dockerfile ARG              │            │
│  └─────────────────────────────────────────────────────────────┘            │
│         │                      │                     │                       │
│         ▼                      ▼                     ▼                       │
│  ┌───────────────┐    ┌───────────────┐    ┌───────────────────────┐        │
│  │    TypeDB     │    │    Backend    │    │       Frontend        │        │
│  │               │    │               │    │                       │        │
│  │ init-typedb.sh│    │ Pydantic      │    │ dev: runtime vars     │        │
│  │ reads env     │    │ BaseSettings  │    │ prod: build args →    │        │
│  │               │    │               │    │       inlined in JS   │        │
│  └───────────────┘    └───────────────┘    └───────────────────────┘        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Three Mechanisms for Passing Variables

#### 1. `env_file` - Load all variables from a file

```yaml
services:
  backend:
    env_file:
      - .env  # All variables become available in container
```

Every variable in `.env` is accessible via `os.environ` in Python.

#### 2. `environment` - Explicit variable mapping

```yaml
services:
  backend:
    environment:
      - PYTHONUNBUFFERED=1                # Hardcoded value
      - TYPEDB_HOST=typedb                # Container hostname
      - JWT_SECRET_KEY=${JWT_SECRET_KEY}  # From .env file
```

Variables from `environment:` override those from `env_file:`.

#### 3. `build.args` - Dockerfile build arguments

```yaml
services:
  frontend:
    build:
      args:
        - VITE_BACKEND_URL=${VITE_BACKEND_URL}  # Only available at build time
```

Build args become `ARG` values in Dockerfile. They must be converted to `ENV` if needed at runtime.

### Variable Categories

#### Category 1: Docker Compose Port Mappings

Used by Docker Compose itself; never enter containers directly:

| Variable | Default | Purpose |
|----------|---------|---------|
| `FRONTEND_PORT` | 6166 | Host port for frontend |
| `BACKEND_PORT` | 6616 | Host port for backend API |
| `TYPEDB_PORT` | 1729 | Host port for TypeDB gRPC |
| `TYPEDB_HTTP_PORT` | 1728 | Host port for TypeDB HTTP API (use this URL in TypeDB Studio) |
| `AUTHENTIK_PORT_HTTP` | 9000 | Host port for Authentik |
| `AUTHENTIK_PORT_HTTPS` | 9443 | Host HTTPS port for Authentik |

#### Category 2: Backend Runtime Variables

Accessed by Python code via Pydantic `BaseSettings` in `backend/app/config.py`:

| Variable | Default | Description |
|----------|---------|-------------|
| `APP_ENV` | development | Environment mode |
| `DEBUG` | true | Enable debug features |
| `TYPEDB_HOST` | 127.0.0.1 | TypeDB server (use `typedb` in Docker) |
| `TYPEDB_PORT` | 1729 | TypeDB port |
| `TYPEDB_DATABASE_NAME` | kennisbaas | Database name |
| `TYPEDB_ADMIN_PASSWORD` | password123 | Admin password |
| `TYPEDB_USER_NAME` | admin | TypeDB username |
| `TYPEDB_USER_PASSWORD` | password123 | User password |
| `TYPEDB_TLS_ENABLED` | false | Enable TLS for TypeDB connection |
| `FRONTEND_URL` | http://localhost:6166 | Frontend URL for CORS configuration |
| `AUTHENTIK_URL` | http://localhost:9000 | Authentik server URL |
| `AUTHENTIK_CLIENT_ID` | (required) | OAuth2 client ID |
| `AUTHENTIK_CLIENT_SECRET` | (required) | OAuth2 client secret |
| `AUTHENTIK_ISSUER` | (auto) | OIDC issuer URL |
| `AUTHENTIK_APP_SLUG` | k-baas-2 | Application slug in Authentik |

#### Category 3: Frontend Variables (VITE_*)

Vite requires special handling - variables must be prefixed with `VITE_`:

| Variable | Dev Access | Prod Access |
|----------|------------|-------------|
| `VITE_BACKEND_URL` | Runtime | Baked into bundle |
| `VITE_AUTHENTIK_URL` | Runtime | Baked into bundle |
| `VITE_AUTHENTIK_CLIENT_ID` | Runtime | Baked into bundle |

In development, Vite reads `VITE_*` from process environment at runtime.
In production, variables must be passed as build args and get inlined during `npm build`.

#### Category 4: Authentik Configuration

| Variable | Secret | Description |
|----------|--------|-------------|
| `AUTHENTIK_SECRET_KEY` | Yes | Encryption key (generate with `openssl rand -base64 36`) |
| `AUTHENTIK_PG_PASS` | Yes | PostgreSQL password |
| `AUTHENTIK_PG_DB` | No | Database name (default: authentik) |
| `AUTHENTIK_PG_USER` | No | Database user (default: authentik) |

#### Category 5: TypeDB Initialization

These are only used on first startup by `init-typedb.sh`:

| Variable | Description |
|----------|-------------|
| `ADMIN_PASSWORD` | New admin password to set |
| `DATABASE_NAME` | Database to create |
| `DATABASE_USER_NAME` | Username for database access |
| `DATABASE_USER_PASSWORD` | Password for database user |
| `SCHEMA_NAME` | Schema file to load (e.g., schema.tql) |
| `SEED_NAME` | Seed data file to load (e.g., seed.tql) |

### Environment Files

| File | Committed | Contains Secrets | Purpose |
|------|-----------|------------------|---------|
| `.env.example` | Yes | No | Template for developers |
| `.env` | No | Yes | Development configuration |
| `.env.production.example` | Yes | No | Production template |
| `.env.production` | No | Yes | Production config (copy from .example) |
| Deployment Platform | N/A | Yes | Production secrets |

### Variable Override Hierarchy

When the same variable is defined in multiple places (highest to lowest priority):

1. **Host environment** - Variables set in your shell
2. **`environment:`** section in compose file
3. **`env_file:`** contents

## Development Workflow

### Quick Start

```bash
# First time setup
cp .env.example .env
# Edit .env to set AUTHENTIK_SECRET_KEY and AUTHENTIK_PG_PASS

# Start development environment (with Authentik)
./kbaas dev

# Or without Authentik for lighter development
./kbaas dev --no-auth

# Or manually with full file specification:
docker compose -f docker-compose.base.yml -f docker-compose.authentik.yml -f docker-compose.yml up -d
```

### Available Commands

```bash
# Start development environment (with Authentik, detached)
./kbaas dev

# Start development in foreground (attached mode - shows all logs)
./kbaas dev --attached

# Start development without Authentik (lighter weight)
./kbaas dev --no-auth

# Reset everything (removes volumes, rebuilds images)
./kbaas reset

# View logs only
./kbaas logs

# Stop all services
./kbaas down

# Or manually:
docker compose -f docker-compose.base.yml -f docker-compose.authentik.yml -f docker-compose.yml down

# Full reset (removes all data)
docker compose -f docker-compose.base.yml -f docker-compose.authentik.yml -f docker-compose.yml down -v
```

### Hot Reload Behavior

In development mode:
- **Backend**: Uvicorn watches for Python file changes and auto-restarts
- **Frontend**: Vite HMR updates the browser without full page reload

Both require volume mounts (`./backend:/app`, `./frontend:/app`) which are configured in `docker-compose.yml`.

### Anonymous Volumes

To prevent host directories from overwriting container dependencies:

```yaml
volumes:
  - ./backend:/app        # Source code mount
  - /app/.venv            # Anonymous volume - container's venv is preserved
  - /app/__pycache__      # Anonymous volume - container's pycache is preserved
```

This pattern ensures that the container's properly-built dependencies aren't replaced by potentially incompatible host files.

## Production Workflow

### Building Production Images

```bash
# Using the kbaas CLI
./kbaas prod

# Or manually with full file specification
docker compose -f docker-compose.base.yml -f docker-compose.authentik.yml -f docker-compose.prod.yml up -d --build
```

### Production Secrets

Never put secrets in `.env.production`. Instead, configure your deployment platform to inject:

- `AUTHENTIK_SECRET_KEY`
- `AUTHENTIK_PG_PASS`
- `AUTHENTIK_CLIENT_ID`
- `AUTHENTIK_CLIENT_SECRET`
- `TYPEDB_ADMIN_PASSWORD`
- `TYPEDB_USER_PASSWORD`
- `JWT_SECRET_KEY`

### Production vs Development Comparison

| Aspect | Development | Production |
|--------|-------------|------------|
| Compose files | `base.yml` + `authentik.yml` + `docker-compose.yml` | `base.yml` + `authentik.yml` + `prod.yml` |
| Command | `./kbaas dev` | `./kbaas prod` |
| Env file | `.env` (not committed) | `.env.production` (committed) |
| Dockerfile target | `development` | `production` |
| Source code | Volume mounted | Baked into image |
| Hot reload | Yes | No |
| Workers | 1 (with --reload) | 2+ |
| Secrets location | `.env` file | Deployment platform |

## Service Communication

### Inside Docker Network

Services communicate using container names as hostnames:

```
Frontend  →  http://backend:6616      (API requests)
Backend   →  typedb:1729              (Database queries)
Backend   →  http://authentik-server:9000  (Token validation)
```

### From Host Machine

Services are exposed on localhost:

```
Frontend:      http://localhost:6166
Backend API:   http://localhost:6616
TypeDB gRPC:   localhost:1729
TypeDB HTTP:   http://localhost:1728 (use this URL in TypeDB Studio)
Authentik:     http://localhost:9000
```

## Troubleshooting

### Container won't start

Check logs for specific service:
```bash
docker compose logs backend
```

### TypeDB connection fails

In Docker, backend must use `TYPEDB_HOST=typedb` (container hostname).
For local development outside Docker, use `TYPEDB_HOST=127.0.0.1`.

### Frontend can't reach backend

- In development: Browser makes requests to `http://localhost:6616`
- Ensure `VITE_BACKEND_URL` is correctly set in `.env`
- Check CORS settings in backend `config.py`

### Authentik setup

After first start:
1. Visit http://localhost:9000/if/flow/initial-setup/
2. Create admin user
3. Create OAuth2 Provider for K-BAAS-2
4. Copy Client ID and Secret to `.env`

### Reset everything

```bash
./kbaas reset

# Or manually:
docker compose -f docker-compose.base.yml -f docker-compose.authentik.yml -f docker-compose.yml down -v
docker compose -f docker-compose.base.yml -f docker-compose.authentik.yml -f docker-compose.yml up -d --build
```

This removes all volumes (including database data) and rebuilds all images.