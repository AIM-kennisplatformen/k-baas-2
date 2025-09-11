# Epic 1: Project Foundation & Infrastructure (V0.7)

**Epic Goal:** Establish the foundational infrastructure, repository setup, and core application framework to enable efficient development of subsequent features.

**Project Board:** [HAN-AIM-CMD-WG/k-baas-2 Project Board #9](https://github.com/HAN-AIM-CMD-WG/k-baas-2/projects/9)

## Story 1.1a: Basic Repository Structure Setup
**As a developer, I want a well-organized repository structure with clear project boundaries so that I can efficiently navigate and maintain the codebase.**

### Acceptance Criteria:
- [ ] Repository has a clear root-level directory structure with separate frontend and backend folders
- [ ] README.md exists with project overview, setup instructions, and contribution guidelines
- [ ] .gitignore is configured for both Node.js and Python artifacts
- [ ] Directory structure follows monorepo best practices
- [ ] Documentation folder structure is established with placeholder files

### Deliverables:
- Root directory structure (frontend/, backend/, docs/, etc.)
- Comprehensive README.md
- Properly configured .gitignore
- Basic documentation framework

### Definition of Done:
- Repository structure is validated by peer review
- README instructions are tested by another team member
- All generated files are properly ignored by git

## Story 1.1b: Frontend Project Configuration
**As a frontend developer, I want a properly initialized React 19 project with JavaScript and essential UI libraries so that I can begin developing UI components without configuration overhead.**

### Acceptance Criteria:
- [ ] we use npm instead of yarn or pnpm
- [ ] React 19.0.0 application is created using Vite 7.0+ (Installation: npm create vite@latest {project name} -- --template react-swc)
- [ ] JavaScript is configured as the primary language (not TypeScript initially)
- [ ] Package.json includes all necessary React 19 dependencies
- [ ] Tailwind CSS 4.0+ is installed and configured with proper setup (Installation: https://ui.shadcn.com/docs/installation/vite)
- [ ] Shadcn/ui 3.2 is installed and configured with basic component library (Installation: https://ui.shadcn.com/docs/installation/vite)
- [ ] Jotai 2.14.0+ is installed and configured for state management (Installation: https://jotai.org - `npm i jotai`)
- [ ] Lexical (@lexical/react 0.35.0+) is installed and configured for rich text editing capabilities (Installation: https://lexical.dev/docs/getting-started/react)
- [ ] React Flow 11.11.4+ is installed and configured for graph visualization (Installation: https://reactflow.dev/learn/getting-started/installation-and-requirements)
- [ ] Development server starts successfully on a designated port
- [ ] Hot module replacement is working for development efficiency
- [ ] Basic folder structure follows React best practices (src/, public/, components/)
- [ ] Initial App component renders "Hello World" successfully

### Deliverables:
- Initialized React 19 project in frontend/ directory
- Configured package.json with correct dependencies
- Tailwind CSS 4 configuration and setup
- Shadcn/ui component library integration
- Jotai state management setup
- Lexical rich text editor configuration
- React Flow graph visualization setup
- Working development server
- Basic component folder structure
- Simple landing page confirming setup

### Definition of Done:
- Frontend application starts without errors
- Hot reload functionality is verified
- Another developer can run `npm install` and `npm start` successfully

## Story 1.1c: Backend Project Configuration
**As a backend developer, I want a properly configured Python 3.14 FastAPI project so that I can begin implementing API endpoints without infrastructure concerns.**

### Acceptance Criteria:
- [ ] Python 3.14.0+ virtual environment is created and documented (Installation: https://www.python.org/downloads/)
- [ ] FastAPI latest version is installed and configured (Installation: https://fastapi.tiangolo.com - `pip install "fastapi[standard]"`)
- [ ] pyproject.toml includes all necessary dependencies with pinned versions
- [ ] Basic FastAPI application structure is established
- [ ] Development server starts successfully on a designated port
- [ ] Simple health check endpoint returns HTTP 200 with JSON response
- [ ] Project follows Python package structure best practices
- [ ] Environment variable configuration system is established

### Deliverables:
- Python virtual environment setup documentation
- FastAPI application in backend/ directory
- Basic API application structure
- Health check endpoint implementation
- Environment configuration system

### Definition of Done:
- Backend server starts without errors
- Health check endpoint is accessible via HTTP
- Another developer can follow setup documentation to run the backend
- All dependencies are properly documented

## Story 1.1d: Development Tooling Setup
**As a developer, I want consistent code formatting and linting across both frontend and backend so that code quality is maintained and team productivity is enhanced.**

### Acceptance Criteria:
- [ ] ESLint 9.35.0+ is configured for the frontend with appropriate React rules (Installation: https://eslint.org/docs/latest/use/getting-started - `npm i eslint`)
- [ ] Prettier latest version is configured for frontend JavaScript code formatting (Installation: https://prettier.io/docs/install.html)
- [ ] Ruff 0.12.12+ is configured for Python code formatting (Installation: https://docs.astral.sh/ruff/ - `pip install ruff`)
- [ ] Ruff 0.12.12+ is configured for Python linting
- [ ] Pre-commit hooks are configured to run linting and formatting (Installation: https://pre-commit.com/ - `pip install pre-commit`)
- [ ] VS Code workspace configuration includes formatter and linter settings
- [ ] npm scripts and Python commands are documented for manual tool execution
- [ ] All existing code passes linting and formatting checks

### Deliverables:
- Frontend linting configuration (.eslintrc.js)
- Frontend formatting configuration (.prettierrc)
- Backend linting configuration (pyproject.toml or setup.cfg)
- Pre-commit hooks configuration
- VS Code workspace settings
- Documentation for development tools usage

### Definition of Done:
- Pre-commit hooks prevent commits with linting/formatting errors
- All team members can run formatting and linting commands successfully
- Existing codebase passes all configured quality checks
- Documentation includes troubleshooting common tool issues

## Story 1.1e: CI/CD Pipeline Configuration
**As a team member, I want automated testing and deployment pipelines so that code quality is verified and deployment processes are consistent and reliable.**

### Acceptance Criteria:
- [ ] GitHub Actions workflow is configured for pull request validation (Guide: https://github.com/features/actions)
- [ ] Frontend linting and formatting checks run automatically on PR creation
- [ ] Backend linting and formatting checks run automatically on PR creation
- [ ] Frontend build process is validated in CI pipeline
- [ ] Backend application startup is validated in CI pipeline
- [ ] CI pipeline fails appropriately when tests or linting fail
- [ ] Status checks are required before merging pull requests
- [ ] Basic deployment workflow is configured (Guide: https://github.blog/enterprise-software/ci-cd/build-ci-cd-pipeline-github-actions-four-steps/)

### Deliverables:
- GitHub Actions workflow files (.github/workflows/)
- PR validation pipeline
- Build verification for both frontend and backend
- Branch protection rules configuration
- Basic deployment workflow template

### Definition of Done:
- Pull requests trigger automated checks
- CI pipeline provides clear feedback on failures
- Branch protection prevents merging without successful checks
- Documentation explains how to interpret CI results
- Pipeline runs successfully with current codebase

## Story 1.2: Frontend Application Shell
**As a developer, I want a basic frontend application shell with React 19, Tailwind 4, and Shadcn/ui so that I can start building UI components.**

### Acceptance Criteria:
- React application is initialized with JavaScript
- Tailwind 4 and Shadcn/ui are configured and functional
- Basic layout components are created
- Jotai state management is set up
- Application loads without errors

### Deliverables:
- React 19 application shell
- Tailwind 4 + Shadcn/ui integration
- Basic layout components
- Jotai state management setup
- Theme system foundation

## Story 1.3: Backend API Foundation
**As a developer, I want a basic backend API with FastAPI so that I can start implementing data storage and retrieval.**

### Acceptance Criteria:
- FastAPI application structure is established
- TypeDB connection code is integrated
- Health check endpoints are functional
- Authentication framework is configured
- CORS and security headers are properly set

### Deliverables:
- FastAPI application structure
- TypeDB integration
- Authentication framework
- API health check endpoints
- Security configuration

## Story 1.4: Real-time Communication Setup
**As a developer, I want Socket.io integration between frontend and backend so that I can implement real-time collaboration features.**

### Acceptance Criteria:
- python-socketio is configured on the backend
- Socket.io client is configured on the frontend
- Basic connection handling is implemented
- Test endpoints verify real-time communication

### Deliverables:
- Socket.io backend integration
- Socket.io frontend client
- Connection management system
- Real-time communication test endpoints

---
