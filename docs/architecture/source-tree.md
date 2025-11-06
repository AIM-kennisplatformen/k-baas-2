# Source Tree

This document provides a comprehensive overview of the K-BAAS-2 project structure, combining both backend architecture and frontend implementation details with project-wide testing structure.

## Complete Project Structure

```
k-baas-2/
├── frontend/                          # React 19 frontend application
│   ├── src/
│   │   ├── app/                      # Main application structure
│   │   │   ├── App.tsx               # Root application component
│   │   │   ├── store/                # Redux Toolkit store configuration
│   │   │   └── router/               # React Router configuration
│   │   ├── components/               # Reusable UI components
│   │   │   ├── common/               # Shared components across features
│   │   │   ├── wiki/                 # Wiki-specific components
│   │   │   ├── graph/                # Knowledge graph visualization components
│   │   │   └── editor/               # Lexical rich text editor components
│   │   ├── features/                 # Feature-based organization
│   │   │   ├── auth/                 # Authentication feature
│   │   │   ├── wiki/                 # Wiki management feature
│   │   │   ├── graph/                # Knowledge graph feature
│   │   │   └── collaboration/        # Real-time collaboration feature
│   │   ├── hooks/                    # Custom React hooks
│   │   ├── services/                 # API client services
│   │   │   ├── api.ts                # Base API configuration
│   │   │   ├── authService.ts        # Authentication API calls
│   │   │   ├── wikiService.ts        # Wiki API calls
│   │   │   └── graphService.ts       # Graph API calls
│   │   ├── utils/                    # Utility functions
│   │   └── types/                    # TypeScript type definitions
│   ├── tests/                        # Frontend-specific tests
│   │   ├── __mocks__/                # Test mocks
│   │   ├── integration/              # Integration tests
│   │   └── setup.ts                  # Test configuration
│   ├── package.json                  # Frontend dependencies
│   ├── tsconfig.json                 # TypeScript configuration
│   ├── vite.config.ts                # Vite build configuration
├── backend/                          # FastAPI backend application
│   ├── app/                         # Application source code
│   │   ├── main.py                  # FastAPI application entry point
│   │   ├── config.py                # Configuration management
│   │   ├── core/                    # Core functionality
│   │   │   ├── auth.py              # JWT and OAuth handling
│   │   │   ├── security.py          # Security utilities and middleware
│   │   │   └── database.py          # Multi-database TypeDB connections
│   │   ├── services/                # Business logic services
│   │   │   ├── auth_service.py      # Authentication (core DB)
│   │   │   ├── kb_service.py        # Knowledge base management (core DB)
│   │   │   ├── concept_service.py   # Concept operations (per-KB DB)
│   │   │   ├── relationship_service.py # Relationship operations (per-KB DB)
│   │   │   ├── collaboration_service.py # Real-time collaboration
│   │   │   └── ai_service.py        # AI integration and LLM management
│   │   ├── repositories/            # Data access layer
│   │   │   ├── core/                # Core database repositories
│   │   │   │   ├── user_repository.py
│   │   │   │   ├── team_repository.py
│   │   │   │   └── kb_repository.py
│   │   │   └── kb/                  # Knowledge base repositories
│   │   │       ├── concept_repository.py
│   │   │       └── relationship_repository.py
│   │   ├── models/                  # Generated Pydantic models
│   │   │   ├── core/                # Core database models
│   │   │   └── kb/                  # Knowledge base models (generated per schema)
│   │   ├── api/                     # API route definitions
│   │   │   ├── auth.py              # Authentication endpoints
│   │   │   ├── knowledge_bases.py   # KB management endpoints
│   │   │   ├── concepts.py          # Concept management
│   │   │   ├── relationships.py     # Relationship management
│   │   │   └── ai.py                # AI integration endpoints
│   │   ├── schemas/                 # TypeDB schema definitions
│   │   │   ├── core-schema.tql      # Core database schema
│   │   │   ├── generic-kb-schema.tql # Generic knowledge base schema
│   │   │   └── templates/           # Domain-specific schema templates
│   │   └── utils/                   # Utility functions
│   │       ├── schema_generator.py  # TypeDB → Pydantic generation
│   │       ├── db_manager.py        # Multi-database management
│   │       └── oauth_handlers.py    # OAuth provider integrations
│   ├── tests/                       # Comprehensive backend test suite
│   │   ├── bdd/                     # Cucumber/Gherkin BDD tests
│   │   │   ├── features/            # Gherkin feature files
│   │   │   └── steps/               # Playwright step definitions
│   │   ├── integration/             # Integration tests with TestContainers
│   │   └── unit/                    # Unit tests for internal logic
│   ├── pyproject.toml              # Python project configuration with uv
│   └── Dockerfile                  # Backend container definition
├── tests/                          # Project-wide testing infrastructure
│   ├── features/                   # Shared Gherkin .feature files for BDD
│   │   ├── auth.feature            # Authentication scenarios
│   │   ├── wiki.feature            # Wiki functionality scenarios
│   │   ├── graph.feature           # Knowledge graph scenarios
│   │   └── collaboration.feature   # Real-time collaboration scenarios
│   ├── steps/                      # Shared Playwright step definitions
│   │   ├── auth_steps.py           # Authentication step implementations
│   │   ├── wiki_steps.py           # Wiki step implementations
│   │   ├── graph_steps.py          # Graph step implementations
│   │   └── collaboration_steps.py  # Collaboration step implementations
│   ├── fixtures/                   # Test data and fixtures
│   └── utils/                      # Testing utilities and helpers
├── docs/                           # Project documentation
│   ├── architecture/               # Sharded architecture documentation
│   │   ├── index.md                # Architecture overview
│   │   ├── tech-stack.md           # Technology decisions
│   │   ├── high-level-architecture.md # System architecture
│   │   ├── data-models.md          # Data model specifications
│   │   ├── components.md           # Component architecture
│   │   ├── rest-api-specification.md # API documentation
│   │   ├── security.md             # Security architecture
│   │   ├── testing-strategy.md     # Testing approach
│   │   ├── infrastructure-and-deployment.md # Deployment strategy
│   │   └── source-tree.md          # This file
│   ├── frontend-architecture/      # Sharded frontend architecture
│   ├── prd/                        # Product requirements documentation
│   └── qa/                         # Quality assurance documentation
├── .bmad-core/                     # BMAD framework configuration
│   ├── core-config.yaml            # Project configuration
│   ├── agents/                     # Agent persona definitions
│   ├── tasks/                      # Structured workflow tasks
│   ├── templates/                  # Document templates
│   ├── checklists/                 # Quality assurance checklists
│   └── data/                       # Reference data and knowledge base
├── .github/                        # GitHub configuration
│   ├── workflows/                  # CI/CD pipeline definitions
│   │   ├── backend-ci.yml          # Backend testing and deployment
│   │   ├── frontend-ci.yml         # Frontend testing and deployment
│   │   └── integration-tests.yml   # Cross-system integration tests
│   └── ISSUE_TEMPLATE/             # Issue templates
├── .ai/                            # AI development artifacts
│   └── debug-log.md                # Development debugging information
├── docker-compose.yml              # Local development environment
├── docker-compose.prod.yml         # Production environment setup
├── .env.example                    # Environment variables template
├── README.md                       # Project overview and setup instructions
└── CONTRIBUTING.md                 # Development guidelines
```

## Key Directory Explanations

### Frontend Structure
- **Feature-based organization**: Each major feature (auth, wiki, graph, collaboration) has its own directory with components, hooks, and services
- **Component co-location**: Tests are placed alongside components (`*.test.tsx` files)
- **Vite build system**: Fast development and optimized production builds

### Backend Structure
- **Service layer architecture**: Clean separation between API routes, business logic, and data access
- **Multi-database support**: Core database for user/auth data, separate knowledge base databases per domain
- **TypeDB integration**: Schema-driven approach with automatic Pydantic model generation
- **Comprehensive testing**: BDD scenarios, integration tests with TestContainers, and unit tests

### Testing Strategy
- **Project-wide BDD**: Shared Gherkin features for end-to-end scenarios
- **Component testing**: Frontend unit tests co-located with components
- **Integration testing**: Backend integration tests with real database containers
- **Cross-system testing**: Full-stack integration tests using Playwright

### Documentation Structure
- **Sharded architecture**: Modular documentation split into focused sections
- **Living documentation**: Architecture docs that evolve with the codebase
- **Quality gates**: BMAD framework ensures comprehensive documentation and review processes

## Development Workflow
1. Feature development follows the sharded architecture documentation
2. All changes require corresponding tests (unit, integration, and BDD scenarios)
3. Quality gates enforced through BMAD checklists and CI/CD pipelines
4. Documentation updated alongside code changes to maintain consistency