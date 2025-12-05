# K-BAAS-2: Knowledge Graph Wiki Tool

An intuitive, collaborative platform that enables domain experts to build, visualize, and share interconnected knowledge bases without requiring technical expertise.

## Project Overview

K-BAAS-2 combines the rich content capabilities of wikis with the relationship-oriented structure of concept maps, creating a unified platform where users can edit wiki content with rich text formatting while simultaneously visualizing and editing the knowledge graph structure.

### Vision and Goals

**Vision:** Create an intuitive, collaborative platform that enables domain experts to build interconnected knowledge without technical expertise.

**Primary Goals:**
- Develop an intuitive interface for non-technical users to create and edit wiki content and knowledge graph elements
- Implement bidirectional synchronization between wiki content and knowledge graph visualization
- Integrate AI assistance for relationship suggestions, summaries, and knowledge gap identification
- Enable real-time collaboration for teams working on shared knowledge bases
- Provide a system for identifying and addressing incomplete knowledge through structured task lists

### Target Audience

Domain experts with specialized knowledge but limited technical expertise who need to document, organize, and share complex information within their field but lack the technical skills to use traditional knowledge graph tools.

### Core Features (MVP)

- **Integrated Wiki-Graph Interface:** Unified interface for editing wiki content and visualizing knowledge structure
- **Bidirectional Synchronization:** Changes in wiki content automatically update the graph and vice versa
- **Schema-based Knowledge Structure:** Predefined schemas guide users in creating structured knowledge
- **Intuitive Entity Creation:** Multiple pathways for creating entities via wiki links and direct graph manipulation
- **AI-assisted Relationship Suggestions:** System suggests potential relationships for user approval/rejection
- **Knowledge Completion Task Lists:** System-generated lists of incomplete entities and relationships
- **Real-time Collaboration:** Google Docs/Miro-style collaboration for simultaneous multi-user work
- **TypeDB Integration:** Backend integration supporting complex relationship types with properties

### Technology Stack

- **Backend:** FastAPI (Python 3.13) with TypeDB knowledge graph database
- **Frontend:** React 19 with Vite build system
- **Rich Text Editor:** Lexical
- **Graph Visualization:** React Flow
- **Real-time Communication:** Socket.IO
- **Authentication:** Authentik (OAuth2/OIDC identity provider)
- **Package Management:** uv (Python), npm (JavaScript)
- **Containerization:** Docker and Docker Compose with multi-stage builds

## Prerequisites

Before setting up the development environment, ensure you have the following installed:

### Required Software
- **Node.js** (>= 18.0.0) and **npm** (>= 9.0.0)
- **Python** (>= 3.13) with **uv** package manager
- **Docker** (>= 24.0.7) and **Docker Compose** (>= 2.23.0)
- **Git** for version control

### Installation Verification
```bash
# Verify Node.js and npm
node --version  # Should be >= 18.0.0
npm --version   # Should be >= 9.0.0

# Verify Python and uv
python --version  # Should be >= 3.13
uv --version     # Should be installed

# Verify Docker
docker --version         # Should be >= 24.0.7
docker-compose --version # Should be >= 2.23.0
```

## Windows Users (WSL2)

Windows users must use WSL2 (Windows Subsystem for Linux) to run this project. Docker Desktop alone is not sufficient due to shell script requirements.

### Install WSL2 with Ubuntu 24

1. Open PowerShell as Administrator and run:
   ```powershell
   wsl --install -d Ubuntu-24.04
   ```
2. Restart your computer when prompted
3. Complete Ubuntu setup (username/password) when it launches

For detailed instructions, see [Microsoft's WSL2 installation guide](https://learn.microsoft.com/en-us/windows/wsl/install).

### Configure Docker for WSL2

In Docker Desktop: **Settings → Resources → WSL Integration** → Enable integration for Ubuntu-24.04.

Alternatively, install Docker directly in WSL2 following the [Docker Ubuntu installation guide](https://docs.docker.com/engine/install/ubuntu/).

### Required Packages

Inside your WSL2 Ubuntu terminal:
```bash
# Update packages
sudo apt update && sudo apt upgrade -y

# Install required tools
sudo apt install -y git curl

# Optional: Enable opening Windows browser from WSL
sudo apt install -y wslu
```

### VS Code Integration

1. Install the [Remote - WSL extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) in VS Code
2. Clone the repository **inside WSL2** (critical for performance):
   ```bash
   cd ~
   git clone https://github.com/AIM-kennisplatformen/k-baas-2.git
   ```
3. Open in VS Code from WSL2:
   ```bash
   cd k-baas-2
   code .
   ```

> ⚠️ **Performance Warning:** Never clone to `/mnt/c/` (Windows filesystem). Always use the WSL2 native filesystem (`~` or `/home/username/`) for 10-100x faster Docker performance.

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/AIM-kennisplatformen/k-baas-2.git
cd k-baas-2
```

### 2. Environment Configuration

The project uses environment files for configuration. The setup differs slightly between Docker and local development:

```bash
# Copy the example environment file
cp .env.example .env

# Generate required secrets for Authentik (REQUIRED for Docker setup)
# On macOS/Linux:
openssl rand -base64 36  # Use output for AUTHENTIK_SECRET_KEY
openssl rand -base64 36  # Use output for AUTHENTIK_PG_PASS

# Edit .env and set the generated secrets
```

**Key Environment Variables:**

| Variable | Default | Description |
|----------|---------|-------------|
| `FRONTEND_PORT` | 6166 | Vite dev server port |
| `BACKEND_PORT` | 6616 | FastAPI server port |
| `TYPEDB_PORT` | 1729 | TypeDB database port |
| `AUTHENTIK_PORT_HTTP` | 9000 | Authentik identity provider |
| `AUTHENTIK_SECRET_KEY` | (required) | Authentik encryption key |
| `AUTHENTIK_PG_PASS` | (required) | Authentik PostgreSQL password |

> **Note:** For production, copy `.env.production.example` to `.env.production`, configure for your domain, and set secrets via your deployment platform.

### 3. Frontend Setup
```bash
# Navigate to frontend and install dependencies
cd frontend
npm install
```

### 4. Backend Setup
```bash
# Navigate to backend directory
cd backend

# Install Python dependencies using uv
uv sync

# Activate virtual environment
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
```

### 5. Database Setup

The TypeDB database is automatically initialized when running via Docker. The custom init script handles:
- Creating the database
- Loading the schema from `backend/database/schema/schema.tql`
- Loading seed data from `backend/database/schema/seed.tql`

For manual database operations, see [backend/database/README.md](backend/database/README.md).

## Build and Run Instructions

### Quick Start with Docker (Recommended)

The fastest way to get the complete development environment running:

```bash
# First time setup
cp .env.example .env
# Edit .env to set AUTHENTIK_SECRET_KEY and AUTHENTIK_PG_PASS

# Start all services with hot-reload using the kbaas CLI
./kbaas dev

# Or manually with full file specification:
docker compose -f docker-compose.base.yml -f docker-compose.authentik.yml -f docker-compose.yml up -d
```

This starts:
- **Frontend** at http://localhost:6166 (Vite with HMR)
- **Backend API** at http://localhost:6616 (FastAPI with auto-reload)
- **TypeDB gRPC** at localhost:1729
- **TypeDB HTTP API** at http://localhost:1728
- **Authentik** at http://localhost:9000

### K-BAAS CLI

The `kbaas` CLI tool provides a convenient way to manage Docker containers:

```bash
./kbaas --help    # Show full usage information
```

**Usage:** `./kbaas [COMMAND] [OPTIONS]`

**Commands:**
| Command | Description |
|---------|-------------|
| `dev` | Start development environment (default) |
| `prod` | Start production environment |
| `logs` | Show logs for backend and frontend |
| `down` | Stop all services |
| `reset` | Full reset: remove volumes, rebuild images |
| `help`, `-h`, `--help` | Show help message |

**Options:**
| Option | Description |
|--------|-------------|
| `--attached`, `-a` | Run in foreground (attached mode, shows all logs) |
| `--no-auth` | Skip Authentik services (lighter development) |

**Examples:**
```bash
./kbaas dev              # Start dev environment (detached)
./kbaas dev --attached   # Start dev in foreground
./kbaas dev --no-auth    # Start dev without Authentik
./kbaas prod             # Start production environment
./kbaas reset            # Full reset and rebuild
./kbaas logs             # View logs
./kbaas down             # Stop all services
```

**Manual Docker Compose commands:**
```bash
# Full file specification (equivalent to ./kbaas dev)
docker compose -f docker-compose.base.yml -f docker-compose.authentik.yml -f docker-compose.yml up -d

# Stop and remove volumes
docker compose -f docker-compose.base.yml -f docker-compose.authentik.yml -f docker-compose.yml down -v
```

### Local Development (without Docker)

For developing outside Docker containers:

```bash
# Start only TypeDB via Docker
docker compose up -d typedb

# Frontend development server (port 6166)
cd frontend && npm run dev

# Backend development server (port 6616)
cd backend
source .venv/bin/activate
uvicorn app.main:app --reload --port 6616

# Note: Set TYPEDB_HOST=127.0.0.1 in .env for local development
```

**Port Summary:**
| Service | Port | URL |
|---------|------|-----|
| Frontend | 6166 | http://localhost:6166 |
| Backend API | 6616 | http://localhost:6616 |
| TypeDB gRPC | 1729 | localhost:1729 |
| TypeDB HTTP API | 1728 | http://localhost:1728 (use this URL in TypeDB Studio) |
| Authentik | 9000 | http://localhost:9000 |

### Production Build

```bash
# Build and run production environment
./kbaas prod

# Or manually with full file specification:
docker compose -f docker-compose.base.yml -f docker-compose.authentik.yml -f docker-compose.prod.yml up -d --build

# View production logs
docker compose -f docker-compose.base.yml -f docker-compose.authentik.yml -f docker-compose.prod.yml logs -f
```

For production deployment, set secrets via your deployment platform (Dokploy, Portainer, etc.) rather than in files.

### Testing and Linting

```bash
# Run tests
cd backend && uv run pytest
cd frontend && npm run test

# Lint code
cd backend && uv run ruff check .
cd frontend && npm run lint
```

## Project Structure

```
k-baas-2/
├── frontend/                    # React 19 frontend application
│   ├── src/                    # Source code
│   ├── Dockerfile              # Multi-stage Docker build
│   ├── .dockerignore           # Docker build exclusions
│   └── package.json            # Frontend dependencies
├── backend/                    # FastAPI backend application
│   ├── app/                   # Application source code
│   ├── database/              # TypeDB configuration
│   │   ├── Dockerfile         # TypeDB with init script
│   │   ├── init-typedb.sh     # Database initialization
│   │   └── schema/            # Schema and seed files
│   ├── tests/                 # Backend tests
│   ├── Dockerfile             # Multi-stage Docker build
│   ├── .dockerignore          # Docker build exclusions
│   └── pyproject.toml         # Python dependencies
├── authentik/                  # Authentik runtime data (gitignored)
│   ├── media/                 # Uploaded files
│   ├── templates/             # Custom templates
│   └── certs/                 # SSL certificates
├── docs/                      # Project documentation
│   ├── architecture/          # Technical architecture
│   ├── prd/                   # Product requirements
│   └── qa/                    # Quality assurance docs
├── docker-compose.base.yml    # Shared service definitions
├── docker-compose.authentik.yml # Authentik identity provider
├── docker-compose.yml         # Development environment
├── docker-compose.prod.yml    # Production environment
├── kbaas                      # K-BAAS CLI tool
├── .env.example               # Environment template
├── .env.production.example    # Production template (copy to .env.production)
└── README.md                  # This file
```

### Key Directories
- **`frontend/`**: React application with multi-stage Dockerfile
- **`backend/`**: FastAPI application with TypeDB integration
- **`backend/database/`**: TypeDB initialization scripts and schema
- **`authentik/`**: Runtime data for Authentik IdP (gitignored)
- **`docs/`**: Comprehensive project documentation

### Docker Compose Files
The project uses a layered Docker Compose architecture:

| File | Purpose |
|------|---------|
| `docker-compose.base.yml` | Shared service definitions (TypeDB, backend, frontend) |
| `docker-compose.authentik.yml` | Authentik identity provider services |
| `docker-compose.yml` | Development overrides (volume mounts, hot-reload) |
| `docker-compose.prod.yml` | Production overrides (optimized builds) |

## Documentation

For detailed information, consult the following documents:

- **[Docker Setup Guide](docs/docker-setup.md)** - Complete Docker, Compose, and environment variable documentation
- **[Architecture Documentation](docs/architecture/)** - Technical architecture and implementation details
- **[Product Requirements](docs/prd/)** - Comprehensive product specifications
- **[User Stories](docs/User-Stories-Acceptance-Criteria-Deliverables.md)** - Functional requirements
- **[Quality Assurance](docs/qa/)** - Testing strategies and procedures

## Contributing

### Development Workflow
1. Create a feature branch from `main`
2. Make changes following the coding standards
3. Write tests for new functionality
4. Run the full test suite
5. Submit a pull request for review

### Code Standards
- **Frontend**: ESLint + Prettier configuration
- **Backend**: Ruff for formatting and linting
- **Testing**: Comprehensive test coverage required
- **Documentation**: Update docs for significant changes

### Quality Gates
This project uses the BMAD (Business Modeling & Agent Development) framework for structured development workflows and quality assurance. See [AGENTS.md](AGENTS.md) for more information about the development process and available agent personas.

## License

This project is proprietary software owned by AIM Kennisplatformen.