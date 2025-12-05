# K-BAAS-2 Frontend Dockerfile
# Multi-stage build for React/Vite frontend

# =============================================================================
# BASE STAGE: Node.js and npm dependencies installation
# =============================================================================
FROM node:22-alpine AS base

WORKDIR /app

# Copy package files first for better Docker layer caching
# Dependencies only reinstall if package files change
COPY package*.json ./

# Install dependencies
# Using npm ci for reproducible builds from package-lock.json
RUN npm ci

# =============================================================================
# DEVELOPMENT STAGE: Hot-reload (HMR) enabled, expects volume mount
# =============================================================================
FROM base AS development

# Document the port
EXPOSE 6166

# Development command with Vite dev server
# --host 0.0.0.0: Accept connections from outside container
# --port 6166: Use K-BAAS-2's configured port
# Source code comes from volume mount in docker-compose.yml
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "6166"]

# =============================================================================
# PRODUCTION STAGE: Build and serve optimized bundle
# =============================================================================
FROM base AS production

# Accept build arguments for Vite environment variables
# These get inlined into the bundle at build time
ARG VITE_BACKEND_URL
ARG VITE_AUTHENTIK_URL
ARG VITE_AUTHENTIK_CLIENT_ID

# Convert ARGs to ENVs so npm run build can access them
ENV VITE_BACKEND_URL=${VITE_BACKEND_URL}
ENV VITE_AUTHENTIK_URL=${VITE_AUTHENTIK_URL}
ENV VITE_AUTHENTIK_CLIENT_ID=${VITE_AUTHENTIK_CLIENT_ID}

# Copy source code into the image
COPY . .

# Build the production bundle
# Vite reads VITE_* environment variables and inlines them into the bundle
RUN npm run build

# Document the port
EXPOSE 6166

# Production command with Vite preview server
# In a more optimized setup, you'd use nginx to serve the dist folder
# --host 0.0.0.0: Accept connections from outside container
# --port 6166: Use K-BAAS-2's configured port
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "6166"]