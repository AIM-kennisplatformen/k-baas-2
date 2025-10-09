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
- **Frontend:** React 19 with Nx monorepo, Vite build system
- **Rich Text Editor:** Lexical
- **Graph Visualization:** React Flow
- **Real-time Communication:** Socket.IO
- **Package Management:** uv (Python), npm workspaces (JavaScript)
- **Containerization:** Docker and Docker Compose

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

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/AIM-kennisplatformen/k-baas-2.git
cd k-baas-2
```

### 2. Environment Configuration
```bash
# Copy environment template
cp .env.example .env

# Edit .env file with your configuration
# (Database URLs, API keys, etc.)
```

### 3. Frontend Setup
```bash
# Install workspace dependencies
npm install

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
```bash
# Start TypeDB with Docker Compose
docker-compose up -d typedb

# Initialize database schemas
cd backend
python -m app.utils.schema_generator
```

## Build and Run Instructions

### Development Environment
```bash
# Start all services in development mode
npm run dev

# Or start services individually:
# Frontend development server
cd frontend && npm run dev

# Backend development server
cd backend && uvicorn app.main:app --reload

# Database services
docker-compose up -d
```

### Production Build
```bash
# Build all workspaces
npm run build

# Run tests across all workspaces
npm run test

# Lint all code
npm run lint
```

### Docker Development Environment
```bash
# Start complete development environment
docker-compose up

# Start with rebuild
docker-compose up --build
```

## Project Structure

```
k-baas-2/
├── frontend/           # React 19 frontend application
│   ├── src/           # Source code
│   ├── tests/         # Frontend tests
│   └── package.json   # Frontend dependencies
├── backend/           # FastAPI backend application
│   ├── app/          # Application source code
│   ├── tests/        # Backend tests
│   └── pyproject.toml # Python dependencies
├── docs/             # Project documentation
│   ├── architecture/ # Technical architecture
│   ├── prd/          # Product requirements
│   └── qa/           # Quality assurance docs
├── scripts/          # Utility scripts
├── docker-compose.yml # Development environment
├── package.json      # Workspace configuration
└── README.md         # This file
```

### Key Directories
- **`frontend/`**: React application with Nx workspace configuration
- **`backend/`**: FastAPI application with TypeDB integration
- **`docs/`**: Comprehensive project documentation
- **`scripts/`**: Development and deployment utility scripts

## Documentation

For detailed information, consult the following documents:

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