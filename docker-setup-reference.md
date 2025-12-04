# Docker & Compose Setup Reference

This document describes a Docker Compose architecture for a full-stack application with React/Vite frontend, Python/FastAPI backend, and TypeDB database. The setup supports both development (with hot-reloading) and production environments.

## Architecture Overview

The setup uses **three Docker Compose files** that build upon each other:

```
docker-compose.base.yml    ← Shared service definitions
       ↓
docker-compose.yml         ← Development overrides (extends base)
docker-compose.prod.yml    ← Production overrides (extends base)
```

Each environment uses **multi-stage Dockerfiles** with different build targets:
- `development` stage: Volume mounts for live code changes
- `preview` stage: Source code copied into container, optimized builds

---

## File Structure

```
project_root/
├── .env                        # Development environment (not committed)
├── .env.production             # Production environment (committed, no secrets)
├── .gitignore
├── docker-compose.base.yml     # Shared service definitions
├── docker-compose.yml          # Development config
├── docker-compose.prod.yml     # Production config
├── docker-start.sh             # Convenience startup script
│
├── project_backend/
│   ├── .dockerignore
│   ├── .env.example
│   ├── Dockerfile
│   ├── requirements.txt        # Or pyproject.toml for uv
│   └── main.py
│
└── project_frontend/
    ├── .dockerignore
    ├── Dockerfile
    ├── package.json
    └── src/
```

---

## 1. Base Compose File

**File: `docker-compose.base.yml`**

This file defines the shared configuration for all services. Environment-specific files extend from here.

```yaml
# This is the base Docker Compose file, used in both development and production.

services:
  typedb:
    # https://github.com/typedb/typedb/releases/tag/3.4.0
    container_name: project_typedb
    image: typedb/typedb:3.4.0
    restart: unless-stopped
    ports:
      - "${TYPEDB_PORT}:1729"
      - "${TYPEDB_STUDIO_PORT}:8000" # TypeDB Studio web interface
    volumes:
      - typedb-data:/opt/typedb-all-linux-x86_64/server/data
    platform: linux/amd64

  backend:
    container_name: project_backend
    depends_on:
      - typedb
    build:
      context: ./project_backend
    environment:
      - PYTHONUNBUFFERED=1 # Ensures Python output is sent straight to terminal without buffering
      - PYTHONDONTWRITEBYTECODE=1 # Prevents Python from writing .pyc files
      - PYTHONPATH=/app # Sets the Python path to /app to enable module imports
    ports:
      - ${BACKEND_PORT}:${BACKEND_PORT}
    networks:
      - project-network

  frontend:
    container_name: project_frontend
    build:
      context: ./project_frontend
    environment:
      - VITE_BACKEND_HOST=${VITE_BACKEND_HOST}  
      - VITE_BACKEND_PORT=${VITE_BACKEND_PORT}
      - VITE_APP_NAME=${VITE_APP_NAME}
      - VITE_APP_VERSION=${VITE_APP_VERSION}
    networks:
      - project-network

volumes:
  typedb-data:
```

**Key points:**
- Environment variables like `${TYPEDB_PORT}` are interpolated from `.env` files
- The `platform: linux/amd64` is important for TypeDB on Apple Silicon
- No networks defined here - each environment adds its own

---

## 2. Development Compose File

**File: `docker-compose.yml`**

This extends the base file for development with volume mounts for hot-reloading.

```yaml
# Development Docker Compose file.
# In production, use docker-compose.prod.yml instead.

services:
  typedb:
    extends:
      file: docker-compose.base.yml
      service: typedb
    env_file:
      - .env
    networks:
      - project-network

  backend:
    extends:
      file: docker-compose.base.yml
      service: backend
    build:
      target: development  # Use development stage
    env_file:
      - .env
    volumes:
      - ./project_backend:/app  # Volume mount for development
      - /app/__pycache__        # Anonymous volume to prevent host __pycache__ from mounting
    networks:
      - project-network

  frontend:
    extends:
      file: docker-compose.base.yml
      service: frontend
    build:
      target: development  # Use development stage
    env_file:
      - .env
    ports:
      - "${FRONTEND_PORT}:5173"  # Vite dev server port
    volumes:
      - ./project_frontend:/app  # Volume mount for development
      - /app/node_modules        # Anonymous volume to prevent host node_modules from mounting
    networks:
      - project-network

volumes:
  typedb-data:

networks:
  project-network:
    driver: bridge
```

**Key points:**
- Uses `extends` to inherit from `docker-compose.base.yml`
- `build.target: development` selects the development stage in Dockerfile
- Volume mounts enable hot-reloading: changes in host files are reflected immediately
- Anonymous volumes (`/app/__pycache__`, `/app/node_modules`) prevent host directories from overwriting container directories
- Uses `.env` file (not committed to git)

---

## 3. Production Compose File

**File: `docker-compose.prod.yml`**

This extends the base file for production with optimized settings.

```yaml
# Production Docker Compose file.
# Uses environment variables set in deployment platform (e.g., Dokploy).

services:
  typedb:
    extends:
      file: docker-compose.base.yml
      service: typedb
    env_file:
      - .env.production  
    networks:
      - project-network

  backend:
    extends:
      file: docker-compose.base.yml
      service: backend
    build:
      target: preview  # Use preview/production stage
    env_file:
      - .env.production  
    environment:
      - TYPEDB_NEW_PASSWORD=${TYPEDB_NEW_PASSWORD}  # Secret from deployment platform
      - PYTHONUNBUFFERED=1
      - PYTHONDONTWRITEBYTECODE=1
      - PYTHONPATH=/app
    # No volumes - source code is copied into container
    networks:
      - project-network
    
  frontend:
    extends:
      file: docker-compose.base.yml
      service: frontend
    build:
      target: preview  # Use preview/production stage
      args:
        - VITE_BACKEND_HOST=${VITE_BACKEND_HOST}
        - VITE_BACKEND_PORT=${VITE_BACKEND_PORT}
    env_file:
      - .env.production 
    ports:
      - "${FRONTEND_PORT}:4173"  # Vite preview server port
    # No volumes - source code is copied into container
    networks:
      - project-network

volumes:
  typedb-data:

networks:
  project-network:
    driver: bridge    
```

**Key points:**
- `build.target: preview` selects the production stage in Dockerfile
- **No volume mounts** - source code is baked into the image at build time
- Frontend build args pass environment variables needed at build time (Vite inlines them)
- Uses `.env.production` file (committed to git, but without secrets)
- Secrets like `TYPEDB_NEW_PASSWORD` are injected via deployment platform

---

## 4. Backend Dockerfile

**File: `project_backend/Dockerfile`**

Multi-stage Dockerfile for Python/FastAPI backend.

```dockerfile
# Backend Dockerfile

FROM python:3.13-bullseye AS base

WORKDIR /app

# System dependencies needed for typedb-driver native extensions
RUN apt-get update && apt-get install -y \
    build-essential \
    libpython3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Development stage - expects volume mount for live reloading
FROM base AS development
EXPOSE ${BACKEND_PORT}
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port 8000 --reload"]

# Preview/Production stage - copies source code for deployment
FROM base AS preview
COPY . .
EXPOSE ${BACKEND_PORT}
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${BACKEND_PORT} --workers 1 --log-level debug"]
```

**For uv users, modify the base stage:**

```dockerfile
FROM python:3.13-bullseye AS base

WORKDIR /app

# Install uv
RUN pip install uv

# System dependencies for typedb-driver
RUN apt-get update && apt-get install -y \
    build-essential \
    libpython3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml uv.lock ./
RUN uv sync --frozen
```

**Key points:**
- `base` stage: Install system dependencies and Python packages
- `development` stage: Just expose port and run with `--reload` (code comes from volume mount)
- `preview` stage: Copy source code, then run with production settings
- The `--reload` flag only makes sense in development (watches for file changes)

---

## 5. Frontend Dockerfile

**File: `project_frontend/Dockerfile`**

Multi-stage Dockerfile for React/Vite frontend.

```dockerfile
# Frontend Dockerfile

FROM node:22-alpine AS base
WORKDIR /app

# Install dependencies only when needed
COPY package*.json ./
RUN npm ci

# Development stage - expects volume mount for live reloading
FROM base AS development
EXPOSE 5173
CMD ["sh", "-c", "npm run dev -- --host 0.0.0.0"]

# Preview/Production stage - builds and serves optimized bundle
FROM base AS preview
ARG VITE_BACKEND_HOST
ARG VITE_BACKEND_PORT
ENV VITE_BACKEND_HOST=${VITE_BACKEND_HOST}
ENV VITE_BACKEND_PORT=${VITE_BACKEND_PORT}
COPY . .
RUN npm run build
EXPOSE 4173
CMD ["sh", "-c", "npm run preview -- --host 0.0.0.0"]
```

**Key points:**
- `base` stage: Install npm dependencies
- `development` stage: Run Vite dev server (code comes from volume mount)
- `preview` stage: 
  - Accept build arguments for environment variables
  - Copy source code
  - Run `npm run build` to create production bundle
  - Serve with `npm run preview`
- Vite requires `VITE_*` environment variables at **build time** (they get inlined into the bundle)

---

## 6. Environment Variable Deep Dive

This section explains how environment variables flow through the Docker Compose system and affect each container.

### Variable Lifecycle Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        ENVIRONMENT VARIABLE FLOW                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  .env / .env.production                                                     │
│         │                                                                   │
│         ▼                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐           │
│  │              docker-compose.yml / prod.yml                   │           │
│  │                                                              │           │
│  │  1. Port mappings:     ${FRONTEND_PORT}:5173                │           │
│  │  2. env_file:          loads all vars into services         │           │
│  │  3. environment:       explicit var mapping                 │           │
│  │  4. build.args:        passed to Dockerfile ARG             │           │
│  └─────────────────────────────────────────────────────────────┘           │
│         │                      │                    │                       │
│         ▼                      ▼                    ▼                       │
│  ┌───────────────┐    ┌───────────────┐    ┌───────────────────────┐       │
│  │    TypeDB     │    │    Backend    │    │       Frontend        │       │
│  │   Container   │    │   Container   │    │       Container       │       │
│  │               │    │               │    │                       │       │
│  │ Receives all  │    │ Receives all  │    │ dev: receives runtime │       │
│  │ vars from     │    │ vars from     │    │ prod: build args →    │       │
│  │ env_file      │    │ env_file +    │    │       Dockerfile ARG  │       │
│  │               │    │ environment   │    │       → npm build     │       │
│  └───────────────┘    └───────────────┘    └───────────────────────┘       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Three Mechanisms for Passing Variables

Docker Compose provides three ways to pass environment variables to containers:

#### 1. `env_file` - Load all variables from a file

```yaml
services:
  backend:
    env_file:
      - .env  # All variables in .env become available inside the container
```

**Effect:** Every variable in the `.env` file is available as an environment variable inside the container. The backend Python code can access them via `os.environ["TYPEDB_HOST_NAME"]`.

#### 2. `environment` - Explicit variable mapping

```yaml
services:
  backend:
    environment:
      - PYTHONUNBUFFERED=1                    # Hardcoded value
      - TYPEDB_NEW_PASSWORD=${TYPEDB_NEW_PASSWORD}  # From env file/host
```

**Effect:** Sets specific environment variables. Variables can be:
- Hardcoded values (`PYTHONUNBUFFERED=1`)
- References to variables from `.env` or host environment (`${TYPEDB_NEW_PASSWORD}`)
- Variables from `env_file` can be overridden here

#### 3. `build.args` - Passed to Dockerfile at build time

```yaml
services:
  frontend:
    build:
      args:
        - VITE_BACKEND_HOST=${VITE_BACKEND_HOST}
```

**Effect:** These become `ARG` values in the Dockerfile, available during `docker build`. They are **not** automatically available at runtime unless converted to `ENV` in the Dockerfile.

---

### Variable Categories

#### Category 1: Docker Compose Interpolation Variables

These variables are used by Docker Compose itself to configure services (port mappings, etc.). They never enter the containers directly.

| Variable | Purpose | Used In |
|----------|---------|---------|
| `FRONTEND_PORT` | Host port for frontend | `ports: - "${FRONTEND_PORT}:5173"` |
| `BACKEND_PORT` | Host port for backend | `ports: - ${BACKEND_PORT}:${BACKEND_PORT}` |
| `TYPEDB_PORT` | Host port for TypeDB | `ports: - "${TYPEDB_PORT}:1729"` |
| `TYPEDB_STUDIO_PORT` | Host port for TypeDB Studio | `ports: - "${TYPEDB_STUDIO_PORT}:8000"` |

**How they work:**
```yaml
# In docker-compose.base.yml
ports:
  - "${FRONTEND_PORT}:5173"
  
# Docker Compose reads .env and replaces ${FRONTEND_PORT} with the value
# If FRONTEND_PORT=5173, this becomes:
ports:
  - "5173:5173"
```

#### Category 2: Backend Runtime Variables

These variables are passed to the backend container and accessed by Python code at runtime.

| Variable | Purpose | Defined In | Accessed Via |
|----------|---------|------------|--------------|
| `TYPEDB_DB_NAME` | Database name | `.env` | `os.environ["TYPEDB_DB_NAME"]` |
| `TYPEDB_HOST_NAME` | TypeDB container hostname | `.env` | `os.environ["TYPEDB_HOST_NAME"]` |
| `TYPEDB_SERVER_ADDR` | Full TypeDB address | `.env` | `os.environ["TYPEDB_SERVER_ADDR"]` |
| `TYPEDB_EDITION` | TypeDB edition (Core/Cloud) | `.env` | `os.environ["TYPEDB_EDITION"]` |
| `TYPEDB_USERNAME` | TypeDB username | `.env` | `os.environ["TYPEDB_USERNAME"]` |
| `TYPEDB_PASSWORD` | TypeDB password | `.env` (dev) | `os.environ["TYPEDB_PASSWORD"]` |
| `TYPEDB_NEW_PASSWORD` | Production password | Dokploy UI | `os.environ["TYPEDB_NEW_PASSWORD"]` |
| `PYTHONUNBUFFERED` | Disable output buffering | compose file | Affects Python runtime |
| `PYTHONDONTWRITEBYTECODE` | No .pyc files | compose file | Affects Python runtime |
| `PYTHONPATH` | Module import path | compose file | Affects Python runtime |

**How `TYPEDB_SERVER_ADDR` references other variables:**
```ini
# In .env
TYPEDB_HOST_NAME=typedb
TYPEDB_PORT=1729
TYPEDB_SERVER_ADDR=${TYPEDB_HOST_NAME}:${TYPEDB_PORT}
# Results in: TYPEDB_SERVER_ADDR=typedb:1729
```

**How secrets differ between environments:**
```yaml
# Development (.env):
TYPEDB_PASSWORD=password  # Simple password for local development

# Production (docker-compose.prod.yml):
environment:
  - TYPEDB_NEW_PASSWORD=${TYPEDB_NEW_PASSWORD}  # Set in Dokploy UI, not in any file
```

#### Category 3: Frontend Variables (VITE_*)

Vite's bundler requires special handling. Variables must:
1. Be prefixed with `VITE_`
2. Be available at **build time** (for production)

| Variable | Purpose | Dev Access | Prod Access |
|----------|---------|------------|-------------|
| `VITE_BACKEND_HOST` | API server hostname | Runtime env var | Baked into bundle |
| `VITE_BACKEND_PORT` | API server port | Runtime env var | Baked into bundle |
| `VITE_APP_NAME` | Application name | Runtime env var | Baked into bundle |
| `VITE_APP_VERSION` | App version | Runtime env var | Baked into bundle |

**Development (runtime access):**
```yaml
# docker-compose.yml
frontend:
  env_file:
    - .env  # VITE_* vars available at runtime
  # Vite dev server reads process.env.VITE_* and serves them to the browser
```

**Production (build-time baking):**
```yaml
# docker-compose.prod.yml
frontend:
  build:
    args:
      - VITE_BACKEND_HOST=${VITE_BACKEND_HOST}  # Passed as build arg
      - VITE_BACKEND_PORT=${VITE_BACKEND_PORT}
```

```dockerfile
# Frontend Dockerfile
FROM base AS preview
ARG VITE_BACKEND_HOST           # Receive build arg
ARG VITE_BACKEND_PORT
ENV VITE_BACKEND_HOST=${VITE_BACKEND_HOST}  # Convert ARG to ENV for npm build
ENV VITE_BACKEND_PORT=${VITE_BACKEND_PORT}
COPY . .
RUN npm run build  # Vite reads VITE_* from environment and inlines into bundle
```

**In React code:**
```javascript
// src/services.js
const API_HOST = import.meta.env.VITE_BACKEND_HOST;
const API_PORT = import.meta.env.VITE_BACKEND_PORT;
// Vite replaces import.meta.env.VITE_* with actual values at build time
```

---

### Environment Files Summary

| File | Committed | Contains Secrets | Purpose |
|------|-----------|------------------|---------|
| `.env` | ❌ No | ✅ Yes | Development configuration |
| `.env.production` | ✅ Yes | ❌ No | Production defaults (non-secret) |
| `.env.example` | ✅ Yes | ❌ No | Template for developers |
| Dokploy UI | N/A | ✅ Yes | Production secrets |

### Variable Override Hierarchy

When the same variable is defined in multiple places, Docker Compose uses this precedence (highest to lowest):

1. **Host environment** - Variables set in your shell
2. **`environment:` section** - Explicit values in compose file
3. **`env_file:` file** - Values from the referenced file

**Example:**
```bash
# Host shell
export TYPEDB_PASSWORD=from_host

# .env file
TYPEDB_PASSWORD=from_dotenv

# docker-compose.yml
environment:
  - TYPEDB_PASSWORD=from_compose
```

Result: Container sees `TYPEDB_PASSWORD=from_compose` (explicit `environment:` wins)

---

## 7. Environment Variable Files

### Development: `.env` (not committed)

```ini
# Docker Compose Variables
FRONTEND_PORT=5173
BACKEND_PORT=8000
TYPEDB_PORT=1729
TYPEDB_STUDIO_PORT=8000

# Backend Configuration
TYPEDB_DB_NAME=project_db
TYPEDB_HOST_NAME=typedb
TYPEDB_SERVER_ADDR=${TYPEDB_HOST_NAME}:${TYPEDB_PORT}
TYPEDB_EDITION=Core
TYPEDB_USERNAME=admin
TYPEDB_PASSWORD=password

# Frontend Configuration (must start with VITE_)
VITE_BACKEND_HOST=localhost
VITE_BACKEND_PORT=8000
VITE_APP_NAME="My Project"
VITE_APP_VERSION=0.1.0
```

### Production: `.env.production` (committed, no secrets)

```ini
# Docker Compose Variables
FRONTEND_PORT=4173
BACKEND_PORT=7000

# Backend Configuration (non-secret)
TYPEDB_DB_NAME=project_db
TYPEDB_HOST_NAME=typedb
TYPEDB_PORT=1729
TYPEDB_STUDIO_PORT=1728
TYPEDB_SERVER_ADDR=${TYPEDB_HOST_NAME}:${TYPEDB_PORT}
TYPEDB_EDITION=Core
TYPEDB_USERNAME=admin
TYPEDB_DEFAULT_PASSWORD=password

# Frontend Configuration (non-secret)
VITE_BACKEND_HOST=api.myproject.example.com
VITE_BACKEND_PORT=443
VITE_APP_NAME="My Project"
VITE_APP_VERSION=1.0.0

# Secrets - DO NOT SET HERE! Set in deployment platform (e.g., Dokploy)
# TYPEDB_NEW_PASSWORD=<set in Dokploy UI>
```

### Backend Example: `.env.example` (template for developers)

```ini
# TypeDB Connection Settings
TYPEDB_DB_NAME=project_db
TYPEDB_SERVER_ADDR=127.0.0.1:1729
TYPEDB_EDITION=Core
TYPEDB_USERNAME=admin
TYPEDB_PASSWORD=password
```

---

## 8. .dockerignore Files

### Backend: `project_backend/.dockerignore`

```
# Python bytecode and cache
__pycache__/
*.py[cod]
*.so

# Python virtual environments
.Python
env/
.env
.env.local
venv/
.venv/
ENV/
.virtualenvs/

# Build and distribution
build/
dist/
*.egg-info/

# IDE and editor files
.idea/
.vscode/
*.swp
.DS_Store

# Logs
*.log

# Docker files
Dockerfile
.dockerignore
docker-compose*.yml

# TypeDB specific
*.sock

# Git
.git/
.gitignore

# Testing
tests/
.pytest_cache/
coverage/
htmlcov/
.coverage
test_*.py
*_test.py
```

### Frontend: `project_frontend/.dockerignore`

```
# Node specific
node_modules/
.npm
.yarn-integrity

# Build outputs
dist/
build/
.cache/
.vite/

# Environment and IDE
.env
.env.*
!.env.example
.idea/
.vscode/
*.swp
.eslintcache

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Docker
.dockerignore
Dockerfile
docker-compose*.yml

# Git
.git/
.gitignore

# Testing
coverage/
tests/
__tests__/
*.test.js
*.spec.js

# OS specific
.DS_Store
Thumbs.db
```

---

## 9. Convenience Startup Script

**File: `docker-start.sh`**

```bash
#!/bin/bash

# Docker Startup Script
#
# Usage:
#   ./docker-start.sh           # Start containers
#   ./docker-start.sh reset     # Reset: remove volumes, rebuild images, start fresh
#

RESET_ARG=""
if [[ "$1" == "reset" || "$1" == "-reset" ]]; then
  RESET_ARG="reset"
fi

if [[ "$RESET_ARG" == "reset" ]]; then
  echo "Resetting services..."
  echo "Stopping and removing containers, networks, and volumes..."
  docker compose down --volumes
  echo "Building images and starting services..."
  docker compose up -d --build
else
  echo "Starting services..."
  docker compose up -d
fi

echo "Allowing a few seconds for services to initialize..."
sleep 5

# Open browser (macOS/Linux)
URL="http://localhost:5173"
echo "Opening browser to $URL..."
if command -v xdg-open &> /dev/null; then
  xdg-open "$URL"
elif command -v open &> /dev/null; then
  open "$URL"
else
  echo "Please open $URL in your browser manually."
fi

# Stream logs
echo "Showing logs (press Ctrl+C to stop log streaming)..."
docker compose logs -f backend frontend --tail 20
```

---

## 10. .gitignore (Root)

```
# Root Environment variables (development secrets)
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Frontend Dependencies
project_frontend/node_modules
project_frontend/.pnp
project_frontend/.pnp.js

# Frontend Build Outputs
project_frontend/build
project_frontend/dist

# Frontend Environment
project_frontend/.env
project_frontend/.env.local

# Frontend Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Editor directories
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store

# Backend Python
project_backend/venv/
project_backend/.venv/
project_backend/__pycache__/
*.pyc
*.pyo
*.pyd
.Python

# Backend Environment
project_backend/.env
project_backend/.env.local

# Backend Testing
project_backend/.coverage
project_backend/htmlcov/
project_backend/.pytest_cache/

# Backend Logs
project_backend/*.log
```

---

## Summary: Development vs Production

| Aspect | Development | Production |
|--------|-------------|------------|
| **Compose file** | `docker-compose.yml` | `docker-compose.prod.yml` |
| **Env file** | `.env` (not committed) | `.env.production` (committed) |
| **Dockerfile target** | `development` | `preview` |
| **Source code** | Volume mounted from host | Copied into container |
| **Frontend port** | 5173 (Vite dev server) | 4173 (Vite preview) |
| **Hot reloading** | Yes | No |
| **Secrets** | In `.env` file | In deployment platform |

---

## Running the Application

### Development

```bash
# Create .env from example
cp projojo_backend/.env.example .env
# (edit .env as needed)

# Start development environment
./docker-start.sh

# Or manually:
docker compose up -d

# Reset everything (useful when dependencies change)
./docker-start.sh reset
```

### Production

```bash
# Using production compose file explicitly
docker compose -f docker-compose.prod.yml up -d --build

# Or configure your deployment platform (e.g., Dokploy) to:
# 1. Use docker-compose.prod.yml
# 2. Set secrets like TYPEDB_NEW_PASSWORD in the UI