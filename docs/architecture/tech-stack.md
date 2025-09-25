# Tech Stack

This is the DEFINITIVE technology selection section. All technology choices are based on the PRD requirements and have been selected to work together as a cohesive system. These exact versions must be used to ensure consistency across development environments.

## Cloud Infrastructure
- **Provider:** To be determined (Docker containers for deployment flexibility)
- **Key Services:** Container orchestration platform, blob storage for media files, load balancing for production deployment
- **Deployment Regions:** Europe (single region deployment)

## Technology Stack Table

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| **Language** | Python | 3.13 | Primary backend language | Latest stable release, improved performance, rich ecosystem for AI integration |
| **Framework** | FastAPI | 0.117 | Web framework | High performance, automatic API documentation, excellent type hint support, async capabilities |
| **Database** | TypeDB | 3.5 | Knowledge graph database | Required by PRD, excellent for complex relationships, schema-driven approach, authoritative data source |
| **Package Manager** | uv | 0.8.22 | Python dependency management | Fastest Python package manager, excellent lock file support, reliable dependency resolution |
| **WebSocket** | python-socketio | 5.11.0 | Real-time communication | Mature Socket.io implementation for Python, supports real-time collaboration features |
| **Schema/Validation** | Pydantic | (FastAPI dependency) | Data validation and models | Type safety, automatic documentation, seamless FastAPI integration, generated from TypeDB schema |
| **Authentication** | PyJWT | 2.8.0 | JWT token handling | Industry standard for stateless authentication, secure token management |
| **HTTP Client** | httpx | 0.28 | AI service integration | Modern async HTTP client for external LLM API calls |
| **Container** | Docker | 24.0.7 | Application containerization | Consistent deployment environments, development environment standardization |
| **Build Tool** | Docker Compose | 2.23.0 | Local development orchestration | Multi-container development environment, service coordination |
| **CI/CD** | GitHub Actions | Latest | Automated testing and deployment | Integrated with repository, extensive ecosystem, cost-effective |
| **Testing Framework** | pytest | 8.4 | Unit and integration testing | Comprehensive testing capabilities, excellent fixtures, wide plugin ecosystem |
| **Testing WebSocket** | pytest-asyncio | 1.2 | Async testing support | Testing async operations and Socket.io functionality |
| **Code Quality** | ruff | 0.13 | Code formatting and linting | Extremely fast unified formatter and linter, replaces black and multiple tools |
| **Type Checking** | mypy | 1.18 | Static type analysis | Type safety enforcement, catches bugs early, excellent Pydantic integration |
| **Schema Generation** | TypeDB Python Driver | 3.5 | TypeDB schema introspection | Generate Pydantic models from TypeDB schema definitions |

**Key Technology Integrations:**
- **TypeDB → Pydantic Pipeline:** Custom tooling will introspect TypeDB schema and generate corresponding Pydantic models
- **FastAPI + Pydantic:** Automatic API documentation and request/response validation based on generated models
- **Socket.io + FastAPI:** Real-time collaboration layer integrated with REST API endpoints
- **External LLM Integration:** httpx for async communication with OpenAI, Anthropic, and self-hosted LLM endpoints

**Critical Validation Required:** These exact versions align with the PRD specifications and have been tested for compatibility. Any changes to major versions may impact architectural decisions and must be carefully evaluated.
