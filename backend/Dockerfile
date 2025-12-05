# K-BAAS-2 Backend Dockerfile
# Multi-stage build for Python/FastAPI backend with uv package manager

# =============================================================================
# BASE STAGE: System dependencies and Python package installation
# =============================================================================
FROM python:3.13-slim AS base

WORKDIR /app

# Install uv package manager (fast Python package installer)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# System dependencies required for typedb-driver native extensions:
# - build-essential: C/C++ compilers for extension compilation
# - libpython3-dev: Python C API headers needed for Python extensions
# - curl: For health checks and debugging
RUN apt-get update && apt-get install -y \
    build-essential \
    libpython3-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY pyproject.toml ./
# Copy uv.lock if it exists (for reproducible builds)
COPY uv.lock* ./

# Install dependencies only (not the project itself, since app/ isn't copied yet)
# --frozen: Use exact versions from lockfile
# --no-cache: Don't cache packages (smaller image)
# --no-install-project: Skip installing the backend package (only deps)
RUN uv sync --frozen --no-cache --no-install-project || uv sync --no-cache --no-install-project

# =============================================================================
# DEVELOPMENT STAGE: Hot-reload enabled, expects volume mount
# =============================================================================
FROM base AS development

# Development-specific packages (linters, test tools)
# In dev mode, source code comes from volume mount, so still skip project install
RUN uv sync --frozen --no-cache --all-extras --no-install-project || uv sync --no-cache --all-extras --no-install-project

# Document the port
EXPOSE 6616

# Development command with hot-reload enabled
# Source code comes from volume mount in docker-compose.yml
CMD ["uv", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "6616", "--reload"]

# =============================================================================
# PRODUCTION STAGE: Optimized, source code baked in
# =============================================================================
FROM base AS production

# Copy application source code into the image
COPY . .

# Document the port
EXPOSE 6616

# Production command without hot-reload
# Multiple workers for better performance
CMD ["uv", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "6616", "--workers", "2"]