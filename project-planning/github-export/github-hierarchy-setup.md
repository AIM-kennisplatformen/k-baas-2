# 🏗️ GitHub Issues Hiërarchie Setup - Lokaal ↔ GitHub Sync

> **📍 Locatie:** `project-planning/github-export/github-hierarchy-setup.md`  
> **Doel:** Bidirectionele sync tussen lokale planning en GitHub issues

## 🎯 **Werkwijze: Lokaal → GitHub → Sync**

**Stap 1:** Lokale planning (`project-planning/`) is de **source of truth**  
**Stap 2:** GitHub issues worden gegenereerd vanaf lokale templates  
**Stap 3:** GitHub changes worden terug gesynchroniseerd naar lokaal  

## 📁 **Project-Planning Structuur (Mirror Setup)**

## 📋 **Stap 1: Labels Aanmaken**

Ga naar je GitHub repo → **Labels** → **New label** en maak deze aan:

### Epic Labels
```
Name: epic:foundation
Color: #0052cc
Description: Epic 1 - Foundation & Infrastructure

Name: epic:authentication  
Color: #1f883d
Description: Epic 2 - User Authentication & Management

Name: epic:schema
Color: #8250df
Description: Epic 3 - Knowledge Base Schema Management
```

### Type Labels
```
Name: type:epic
Color: #d73a49
Description: Epic-level work (multiple stories)

Name: type:story
Color: #fb8500
Description: User story (multiple tasks)

Name: type:task
Color: #ffd60a
Description: Implementation task (part of story)
```

### Priority Labels
```
Name: priority:critical
Color: #d73a49
Description: P0 - Critical/Blocking

Name: priority:high
Color: #fb8500
Description: P1 - High Priority

Name: priority:medium
Color: #ffd60a
Description: P2 - Medium Priority
```

### Size Labels
```
Name: size:XS
Color: #90ee90
Description: 0.5 days

Name: size:S
Color: #87ceeb
Description: 1 day

Name: size:M
Color: #dda0dd
Description: 2-3 days

Name: size:L
Color: #f0a0a0
Description: 5 days

Name: size:XL
Color: #ff6b6b
Description: 8+ days
```

### Version Labels
```
Name: version:v0.7
Color: #8250df
Description: MVP Version
```

---

## 📋 **Stap 2: Epic Issues Aanmaken**

### Issue #1: [EPIC] E1: Foundation & Infrastructure

**Title:** `[EPIC] E1: Foundation & Infrastructure`

**Labels:** `epic:foundation`, `type:epic`, `priority:critical`, `version:v0.7`

**Description:**
```markdown
## 🎯 Epic Overview

**Epic Goal:** Establish the foundational infrastructure, repository setup, and core application framework to enable efficient development of subsequent features.

## 📊 Epic Details
- **Version:** V0.7 (MVP)
- **Priority:** P0-Critical  
- **Estimated Effort:** 16 days total
- **Timeline:** Sprint 1-2 (Weeks 1-4)
- **Team:** All 3 developers

## 🎯 Business Value
This epic is foundational for all subsequent development. It establishes:
- Professional development environment with Nx monorepo
- TypeDB knowledge graph database integration
- Real-time collaboration infrastructure via Socket.io
- CI/CD pipeline for quality and deployment

Without this foundation, no other features can be developed efficiently.

## 📋 Stories in this Epic
- **S1.1:** Nx Monorepo Setup (5 days) → Issue #TBD
- **S1.2:** TypeDB Integration (8 days) → Issue #TBD
- **S1.3:** Socket.io Integration (3 days) → Issue #TBD

## ✅ Epic Success Criteria
- [ ] Complete development environment operational
- [ ] TypeDB integration working with basic CRUD
- [ ] Real-time communication established
- [ ] All developers can work efficiently
- [ ] CI/CD pipeline functional
- [ ] Foundation ready for Epic 2 (Authentication)

## 🔗 Dependencies
- **Blocks:** E2 (User Authentication), E3 (Knowledge Base), E4 (Wiki Content), E5 (Graph Visualization)
- **Blocked by:** None (foundational epic)

## 📁 Documentation
**Full Epic Details:** [project-planning/epics/E1-foundation-infrastructure.md](./project-planning/epics/E1-foundation-infrastructure.md)

## 🏷️ Child Issues
This epic contains the following child issues:
- [ ] #TBD: [STORY] S1.1: Nx Monorepo Setup
- [ ] #TBD: [STORY] S1.2: TypeDB Integration  
- [ ] #TBD: [STORY] S1.3: Socket.io Integration
```

---

## 📋 **Stap 3: Story Issues Aanmaken (Children van Epic)**

### Issue #2: [STORY] S1.1: Nx Monorepo Setup

**Title:** `[STORY] S1.1: Nx Monorepo Development Environment Setup`

**Labels:** `epic:foundation`, `type:story`, `priority:critical`, `size:L`, `version:v0.7`

**Description:**
```markdown
## 👤 User Story
**As a** developer on the Knowledge Graph Wiki Tool team  
**I want** a properly configured Nx monorepo with both frontend and backend applications  
**So that** I can efficiently develop, test, and deploy the application with consistent tooling

## 🔗 Parent Epic
**Part of:** #1 [EPIC] E1: Foundation & Infrastructure

## 📋 Acceptance Criteria
- [ ] Developer can run `nx build frontend` and get successful production build
- [ ] Developer can run `nx serve backend` and API responds on localhost:8000 with health check
- [ ] Developer can run `nx test frontend` and `nx test backend` with >80% coverage
- [ ] Developer can run `nx lint` and see consistent code style across both apps
- [ ] GitHub Actions CI pipeline runs all nx commands successfully on PR
- [ ] New developer can setup project in <30 minutes following README
- [ ] Hot reload works for both frontend and backend during development
- [ ] Environment variables are properly configured for dev/prod environments

## 📊 Story Details
**Status:** Ready for Development  
**Estimated Effort:** 5 days  
**Team:** All 3 developers involved  
**Dependencies:** None (foundational story)

## 🔧 Implementation Tasks
This story contains the following implementation tasks:
- [ ] #TBD: [TASK] T1.1.1: Setup Nx workspace structure (2 days)
- [ ] #TBD: [TASK] T1.1.2: Configure React 19 frontend application (2 days)  
- [ ] #TBD: [TASK] T1.1.3: Configure FastAPI backend application (2 days)
- [ ] #TBD: [TASK] T1.1.4: Setup GitHub Actions CI/CD pipeline (2 days)
- [ ] #TBD: [TASK] T1.1.5: Developer experience optimization (1 day)
- [ ] #TBD: [TASK] T1.1.6: Documentation and onboarding (1 day)

## 📁 Full Details
[project-planning/stories/v0.7/S1.1-nx-monorepo-setup.md](./project-planning/stories/v0.7/S1.1-nx-monorepo-setup.md)
```

### Issue #3: [STORY] S1.2: TypeDB Integration

**Title:** `[STORY] S1.2: TypeDB Knowledge Graph Database Integration`

**Labels:** `epic:foundation`, `type:story`, `priority:critical`, `size:XL`, `version:v0.7`

**Description:**
```markdown
## 👤 User Story
**As a** backend developer  
**I want** a robust TypeDB integration with connection management and basic CRUD operations  
**So that** I can store and retrieve knowledge graph entities and relationships reliably

## 🔗 Parent Epic
**Part of:** #1 [EPIC] E1: Foundation & Infrastructure

## 📋 Acceptance Criteria
- [ ] Backend can connect to TypeDB instance with proper error handling
- [ ] Basic CRUD operations work for entities (create, read, update, delete)
- [ ] Basic CRUD operations work for relationships between entities
- [ ] Connection handles network failures with retry logic and graceful degradation
- [ ] Database schema can be loaded and validated from Pydantic models
- [ ] Health check endpoint reports TypeDB connection status accurately
- [ ] Database operations are transactional and maintain data consistency
- [ ] Performance: Basic queries execute in <100ms for small datasets

## 📊 Story Details
**Status:** Ready for Development  
**Estimated Effort:** 8 days  
**Team:** Developer 1 (Backend lead) + Developer 3 (Support)  
**Dependencies:** Blocked by S1.1 (Nx setup)

## 🔧 Implementation Tasks
This story contains the following implementation tasks:
- [ ] #TBD: [TASK] T1.2.1: TypeDB connection setup and configuration (3 days)
- [ ] #TBD: [TASK] T1.2.2: Pydantic schema definition system (3 days)
- [ ] #TBD: [TASK] T1.2.3: TypeDB schema generation and deployment (2 days)
- [ ] #TBD: [TASK] T1.2.4: Basic entity CRUD operations (3 days)
- [ ] #TBD: [TASK] T1.2.5: Basic relationship CRUD operations (3 days)
- [ ] #TBD: [TASK] T1.2.6: Database testing framework (2 days)
- [ ] #TBD: [TASK] T1.2.7: Error handling and monitoring (2 days)

## 📁 Full Details
[project-planning/stories/v0.7/S1.2-typedb-integration.md](./project-planning/stories/v0.7/S1.2-typedb-integration.md)
```

### Issue #4: [STORY] S1.3: Socket.io Integration

**Title:** `[STORY] S1.3: Socket.io Real-time Collaboration Integration`

**Labels:** `epic:foundation`, `type:story`, `priority:critical`, `size:M`, `version:v0.7`

**Description:**
```markdown
## 👤 User Story
**As a** full-stack developer  
**I want** Socket.io integration between frontend and backend with reliable connection handling  
**So that** I can implement real-time collaboration features like presence indicators, live editing, and instant updates

## 🔗 Parent Epic
**Part of:** #1 [EPIC] E1: Foundation & Infrastructure

## 📋 Acceptance Criteria
- [ ] Backend can establish Socket.io connections with proper authentication
- [ ] Frontend can connect to Socket.io server and handle connection states
- [ ] Real-time message passing works bidirectionally between frontend and backend
- [ ] Connection handles network interruptions with automatic reconnection
- [ ] Multiple clients can connect simultaneously and receive broadcasts
- [ ] Socket.io integration works with JWT authentication from existing auth system
- [ ] Performance: Messages delivered in <200ms under normal network conditions
- [ ] Connection state is properly managed in frontend state (Jotai)

## 📊 Story Details
**Status:** Ready for Development  
**Estimated Effort:** 3 days  
**Team:** Developer 3 (lead) + Developer 1 (support)  
**Dependencies:** Blocked by S1.1 (Nx setup)

## 🔧 Implementation Tasks
This story contains the following implementation tasks:
- [ ] #TBD: [TASK] T1.3.1: Backend Socket.io server setup (1.5 days)
- [ ] #TBD: [TASK] T1.3.2: Frontend Socket.io client integration (1.5 days)
- [ ] #TBD: [TASK] T1.3.3: Authentication integration with JWT (1 day)
- [ ] #TBD: [TASK] T1.3.4: Connection handling and reconnection logic (1 day)
- [ ] #TBD: [TASK] T1.3.5: Testing and documentation (1 day)

## 📁 Full Details
[project-planning/stories/v0.7/S1.3-socketio-realtime-integration.md](./project-planning/stories/v0.7/S1.3-socketio-realtime-integration.md)
```

---

## 📋 **Stap 4: Task Issues Aanmaken (Children van Stories)**

### Story S1.1 Tasks:

#### Issue #5: [TASK] T1.1.1: Setup Nx workspace structure

**Title:** `[TASK] T1.1.1: Setup Nx workspace structure`

**Labels:** `epic:foundation`, `type:task`, `priority:critical`, `size:M`, `version:v0.7`

**Description:**
```markdown
## 🔧 Task Description
Setup and configure Nx workspace with proper structure for monorepo development.

## 🔗 Parent Story
**Part of:** #2 [STORY] S1.1: Nx Monorepo Development Environment Setup

## 📋 Task Acceptance Criteria
- [ ] Nx workspace initialized with `create-nx-workspace`
- [ ] nx.json configured with build targets for both apps
- [ ] Shared libs structure setup for common utilities
- [ ] Workspace-wide TypeScript/JavaScript settings configured
- [ ] Shared dependencies properly managed in root package.json

## 📊 Task Details
**Status:** Ready  
**Estimated Effort:** 2 days  
**Assigned:** All developers (setup task)  
**Priority:** P0-Critical

## 🔧 Implementation Steps
1. Initialize Nx workspace
2. Configure nx.json with targets
3. Setup shared libraries structure
4. Configure TypeScript/JavaScript settings
5. Setup shared dependencies
6. Test workspace configuration

## ✅ Definition of Done
- [ ] `nx --version` shows correct Nx installation
- [ ] Workspace structure follows Nx best practices
- [ ] Build targets configured and working
- [ ] Shared libraries structure ready for use
- [ ] Documentation updated with workspace setup
```

#### Issue #6: [TASK] T1.1.2: Configure React 19 frontend application

**Title:** `[TASK] T1.1.2: Configure React 19 frontend application`

**Labels:** `epic:foundation`, `type:task`, `priority:critical`, `size:M`, `version:v0.7`

**Description:**
```markdown
## 🔧 Task Description
Generate and configure React 19 frontend application with modern tooling.

## 🔗 Parent Story
**Part of:** #2 [STORY] S1.1: Nx Monorepo Development Environment Setup

## 📋 Task Acceptance Criteria
- [ ] React app generated with `nx g @nx/react:app frontend`
- [ ] Vite configured as build tool for faster development
- [ ] Tailwind CSS 4 setup with proper configuration
- [ ] Shadcn/ui component library installed and configured
- [ ] Basic routing setup with React Router
- [ ] Environment variables handling configured

## 📊 Task Details
**Status:** Ready  
**Estimated Effort:** 2 days  
**Assigned:** Developer 2 (Frontend lead)  
**Priority:** P0-Critical  
**Dependencies:** Blocked by T1.1.1 (Nx workspace)

## 🔧 Implementation Steps
1. Generate React application with Nx
2. Configure Vite build tool
3. Setup Tailwind CSS 4
4. Install and configure Shadcn/ui
5. Setup React Router
6. Configure environment variables
7. Test application startup

## ✅ Definition of Done
- [ ] `nx serve frontend` starts development server
- [ ] React 19 features working correctly
- [ ] Tailwind CSS styling functional
- [ ] Shadcn/ui components available
- [ ] Basic routing working
- [ ] Environment variables loading
```

#### Issue #7: [TASK] T1.1.3: Configure FastAPI backend application

**Title:** `[TASK] T1.1.3: Configure FastAPI backend application`

**Labels:** `epic:foundation`, `type:task`, `priority:high`, `size:M`, `version:v0.7`

**Description:**
```markdown
## 🔧 Task Description
Setup FastAPI backend application with Python 3.14 and modern tooling.

## 🔗 Parent Story
**Part of:** #2 [STORY] S1.1: Nx Monorepo Development Environment Setup

## 📋 Task Acceptance Criteria
- [ ] Python FastAPI app structure generated
- [ ] Python 3.14 configured with uv package manager
- [ ] FastAPI setup with uvicorn server
- [ ] Basic health check endpoint (`/health`) created
- [ ] CORS configured for frontend-backend communication
- [ ] Environment variables setup with python-dotenv

## 📊 Task Details
**Status:** Ready  
**Estimated Effort:** 2 days  
**Assigned:** Developer 1 (Backend lead)  
**Priority:** P1-High  
**Dependencies:** Blocked by T1.1.1 (Nx workspace)

## 🔧 Implementation Steps
1. Generate Python FastAPI application structure
2. Configure Python 3.14 with uv package manager
3. Setup FastAPI with uvicorn
4. Create health check endpoint
5. Configure CORS settings
6. Setup environment variables with python-dotenv
7. Test API startup and health endpoint

## ✅ Definition of Done
- [ ] `nx serve backend` starts API server
- [ ] Health endpoint returns 200 OK
- [ ] CORS configured for frontend communication
- [ ] Environment variables loading correctly
- [ ] API accessible from frontend
- [ ] uvicorn serving FastAPI properly
```

#### Issue #8: [TASK] T1.1.4: Setup GitHub Actions CI/CD pipeline

**Title:** `[TASK] T1.1.4: Setup GitHub Actions CI/CD pipeline`

**Labels:** `epic:foundation`, `type:task`, `priority:high`, `size:M`, `version:v0.7`

**Description:**
```markdown
## 🔧 Task Description
Create comprehensive GitHub Actions CI/CD pipeline for automated testing and deployment.

## 🔗 Parent Story
**Part of:** #2 [STORY] S1.1: Nx Monorepo Development Environment Setup

## 📋 Task Acceptance Criteria
- [ ] `.github/workflows/ci.yml` created with build/test/lint jobs
- [ ] Dependency caching configured for faster builds
- [ ] Matrix builds setup for different environments
- [ ] Automated testing configured on PR
- [ ] Branch protection rules requiring CI success
- [ ] Deployment pipeline basics configured (placeholder for later)

## 📊 Task Details
**Status:** Ready  
**Estimated Effort:** 2 days  
**Assigned:** Developer 3 (DevOps lead)  
**Priority:** P1-High  
**Dependencies:** Blocked by T1.1.2, T1.1.3 (Apps configured)

## 🔧 Implementation Steps
1. Create GitHub Actions workflow file
2. Configure dependency caching
3. Setup matrix builds
4. Configure automated testing
5. Setup branch protection rules
6. Create deployment pipeline foundation
7. Test CI/CD pipeline with sample PR

## ✅ Definition of Done
- [ ] CI pipeline runs on every PR
- [ ] All tests pass in CI environment
- [ ] Build artifacts generated successfully
- [ ] Branch protection rules enforced
- [ ] Caching working to speed up builds
- [ ] Pipeline completes in reasonable time (<10 minutes)
```

#### Issue #9: [TASK] T1.1.5: Developer experience optimization

**Title:** `[TASK] T1.1.5: Developer experience optimization`

**Labels:** `epic:foundation`, `type:task`, `priority:medium`, `size:S`, `version:v0.7`

**Description:**
```markdown
## 🔧 Task Description
Optimize developer experience with tooling, scripts, and configurations.

## 🔗 Parent Story
**Part of:** #2 [STORY] S1.1: Nx Monorepo Development Environment Setup

## 📋 Task Acceptance Criteria
- [ ] VSCode workspace settings and extensions configured
- [ ] Prettier and eslint configurations setup
- [ ] Development scripts created for common tasks
- [ ] Git hooks configured with husky for pre-commit checks
- [ ] Docker-compose setup for local development environment

## 📊 Task Details
**Status:** Ready  
**Estimated Effort:** 1 day  
**Assigned:** Developer 3 (DX lead)  
**Priority:** P2-Medium  
**Dependencies:** Blocked by T1.1.2, T1.1.3 (Apps configured)

## 🔧 Implementation Steps
1. Configure VSCode workspace settings
2. Setup prettier and eslint
3. Create development scripts
4. Configure git hooks with husky
5. Setup docker-compose for local development
6. Test developer workflow end-to-end

## ✅ Definition of Done
- [ ] VSCode opens with proper settings and extensions
- [ ] Code formatting works automatically
- [ ] Pre-commit hooks prevent bad commits
- [ ] Development scripts work correctly
- [ ] Docker-compose starts full development environment
- [ ] New developer onboarding smooth
```

#### Issue #10: [TASK] T1.1.6: Documentation and onboarding

**Title:** `[TASK] T1.1.6: Documentation and onboarding`

**Labels:** `epic:foundation`, `type:task`, `priority:medium`, `size:S`, `version:v0.7`

**Description:**
```markdown
## 🔧 Task Description
Create comprehensive documentation and onboarding materials for new developers.

## 🔗 Parent Story
**Part of:** #2 [STORY] S1.1: Nx Monorepo Development Environment Setup

## 📋 Task Acceptance Criteria
- [ ] Comprehensive README written with setup instructions
- [ ] Common development workflows documented
- [ ] Troubleshooting guide created for common issues
- [ ] Setup video walkthrough recorded
- [ ] Developer onboarding checklist created

## 📊 Task Details
**Status:** Ready  
**Estimated Effort:** 1 day  
**Assigned:** Developer 2 (Documentation lead)  
**Priority:** P2-Medium  
**Dependencies:** Blocked by all other T1.1.x tasks

## 🔧 Implementation Steps
1. Write comprehensive README
2. Document development workflows
3. Create troubleshooting guide
4. Record setup walkthrough video
5. Create onboarding checklist
6. Test documentation with fresh developer perspective

## ✅ Definition of Done
- [ ] README covers all setup steps clearly
- [ ] Development workflows documented
- [ ] Troubleshooting guide comprehensive
- [ ] Video walkthrough under 15 minutes
- [ ] Onboarding checklist complete
- [ ] Documentation tested by team member
```

---

## 📋 **Stap 5: Issues Koppelen en Update Parent Issues**

### Na aanmaken van alle issues:

1. **Update Epic #1** - voeg child issue nummers toe:
   ```markdown
   ## 🏷️ Child Issues
   This epic contains the following child issues:
   - [ ] #2: [STORY] S1.1: Nx Monorepo Setup
   - [ ] #3: [STORY] S1.2: TypeDB Integration  
   - [ ] #4: [STORY] S1.3: Socket.io Integration
   ```

2. **Update Story #2** - voeg task issue nummers toe:
   ```markdown
   ## 🔧 Implementation Tasks
   This story contains the following implementation tasks:
   - [ ] #5: [TASK] T1.1.1: Setup Nx workspace structure (2 days)
   - [ ] #6: [TASK] T1.1.2: Configure React 19 frontend application (2 days)  
   - [ ] #7: [TASK] T1.1.3: Configure FastAPI backend application (2 days)
   - [ ] #8: [TASK] T1.1.4: Setup GitHub Actions CI/CD pipeline (2 days)
   - [ ] #9: [TASK] T1.1.5: Developer experience optimization (1 day)
   - [ ] #10: [TASK] T1.1.6: Documentation and onboarding (1 day)
   ```

3. **Voeg Dependencies toe** in elk issue:
   - In issue comments: "Blocks #X" en "Blocked by #Y"
   - GitHub detecteert dit automatisch

---

## 📋 **Stap 6: GitHub Project Board Setup**

1. **Create Project:** "Knowledge Graph Wiki Tool Development"
2. **Add Views:**
   - **Epic View:** Group by Epic label
   - **Sprint View:** Group by Milestone  
   - **Team View:** Group by Assignee
   - **Dependencies View:** Show blocking relationships

---

## 🎯 **Resultaat:**

Na deze setup heb je:
- ✅ **Visuele hiërarchie** Epic → Story → Task
- ✅ **Dependency tracking** tussen issues
- ✅ **Progress tracking** op alle niveaus
- ✅ **Individual task assignment**
- ✅ **Burndown charts** per epic/story
- ✅ **Professional project management**

## 🚀 **Volgende Stap:**

**Wil je dat ik de volgende epics (E2: Authentication, E3: Schema) ook uitwerk op dezelfde manier?** 