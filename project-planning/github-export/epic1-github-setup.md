# 🎯 Epic 1: GitHub Setup Guide

## 📋 **1. Milestone Aanmaken**
Ga naar: `https://github.com/HAN-AIM-CMD-WG/k-baas-2/milestones/new`

**Title:** Epic 1: Foundation & Infrastructure  
**Due date:** February 28, 2025 (4 weken vanaf nu)  
**Description:**
```
Complete development environment, TypeDB integration, and Socket.io foundation. 
Blocks all other epics. 16 developer days across 3 stories for 3-developer team.

Stories: S1.1 (Nx Setup), S1.2 (TypeDB), S1.3 (Socket.io)
```

## 🏷️ **2. Labels Aanmaken**
Ga naar: `https://github.com/HAN-AIM-CMD-WG/k-baas-2/labels`

Klik "New label" voor elk van deze:

**Epic Labels:**
- Name: `epic:E1-foundation`, Color: `#0052cc`, Description: Foundation & Infrastructure

**Priority Labels:**
- Name: `priority:P0-critical`, Color: `#d73a49`, Description: Critical (blocking)
- Name: `priority:P1-high`, Color: `#fb8500`, Description: High priority  
- Name: `priority:P2-medium`, Color: `#ffd60a`, Description: Medium priority

**Size Labels:**
- Name: `size:S`, Color: `#90ee90`, Description: Small (1 day)
- Name: `size:M`, Color: `#87ceeb`, Description: Medium (2-3 days)  
- Name: `size:L`, Color: `#dda0dd`, Description: Large (5 days)
- Name: `size:XL`, Color: `#f0a0a0`, Description: Extra Large (8+ days)

**Team Labels:**
- Name: `team:fullstack`, Color: `#0e4b99`, Description: Full-stack development
- Name: `team:backend`, Color: `#2ea043`, Description: Backend development

**Type & Version:**
- Name: `type:story`, Color: `#1f883d`, Description: User story
- Name: `version:v0.7`, Color: `#8250df`, Description: MVP version

## 📝 **3. Issues Aanmaken**
Ga naar: `https://github.com/HAN-AIM-CMD-WG/k-baas-2/issues/new`

### **Issue 1: S1.1 - Nx Monorepo Setup**

**Title:** [STORY] S1.1: Nx Monorepo Development Environment Setup

**Labels:** epic:E1-foundation, priority:P0-critical, size:L, type:story, team:fullstack, version:v0.7

**Milestone:** Epic 1: Foundation & Infrastructure

**Description:**
```markdown
## 👤 User Story
**As a** developer on the Knowledge Graph Wiki Tool team  
**I want** a properly configured Nx monorepo with both frontend and backend applications  
**So that** I can efficiently develop, test, and deploy the application with consistent tooling

## 📋 Acceptance Criteria
- [ ] Developer can run `nx build frontend` and get successful production build
- [ ] Developer can run `nx serve backend` and API responds on localhost:8000 with health check
- [ ] Developer can run `nx test frontend` and `nx test backend` with >80% coverage
- [ ] Developer can run `nx lint` and see consistent code style across both apps
- [ ] GitHub Actions CI pipeline runs all nx commands successfully on PR
- [ ] New developer can setup project in <30 minutes following README
- [ ] Hot reload works for both frontend and backend during development
- [ ] Environment variables are properly configured for dev/prod environments

## 🔧 Implementation Tasks
- [ ] Task 1.1.1: Setup Nx workspace structure (2 days)
- [ ] Task 1.1.2: Configure React 19 frontend application (2 days)
- [ ] Task 1.1.3: Configure FastAPI backend application (2 days)
- [ ] Task 1.1.4: Setup GitHub Actions CI/CD pipeline (2 days)
- [ ] Task 1.1.5: Developer experience optimization (1 day)
- [ ] Task 1.1.6: Documentation and onboarding (1 day)

## 📊 Story Details
**Status:** Ready for Development  
**Estimated Effort:** 5 days  
**Team:** All 3 developers involved  
**Dependencies:** None (foundational story)

📁 **Full Details:** [project-planning/stories/v0.7/S1.1-nx-monorepo-setup.md](./project-planning/stories/v0.7/S1.1-nx-monorepo-setup.md)
```

---

### **Issue 2: S1.2 - TypeDB Integration**

**Title:** [STORY] S1.2: TypeDB Knowledge Graph Database Integration

**Labels:** epic:E1-foundation, priority:P0-critical, size:XL, type:story, team:backend, version:v0.7

**Milestone:** Epic 1: Foundation & Infrastructure

**Description:**
```markdown
## 👤 User Story
**As a** backend developer  
**I want** a robust TypeDB integration with connection management and basic CRUD operations  
**So that** I can store and retrieve knowledge graph entities and relationships reliably

## 📋 Acceptance Criteria
- [ ] Backend can connect to TypeDB instance with proper error handling
- [ ] Basic CRUD operations work for entities (create, read, update, delete)
- [ ] Basic CRUD operations work for relationships between entities
- [ ] Connection handles network failures with retry logic and graceful degradation
- [ ] Database schema can be loaded and validated from Pydantic models
- [ ] Health check endpoint reports TypeDB connection status accurately
- [ ] Database operations are transactional and maintain data consistency
- [ ] Performance: Basic queries execute in <100ms for small datasets

## 🔧 Implementation Tasks
- [ ] Task 1.2.1: TypeDB connection setup and configuration (3 days)
- [ ] Task 1.2.2: Pydantic schema definition system (3 days)
- [ ] Task 1.2.3: TypeDB schema generation and deployment (2 days)
- [ ] Task 1.2.4: Basic entity CRUD operations (3 days)
- [ ] Task 1.2.5: Basic relationship CRUD operations (3 days)
- [ ] Task 1.2.6: Database testing framework (2 days)
- [ ] Task 1.2.7: Error handling and monitoring (2 days)

## 📊 Story Details
**Status:** Ready for Development  
**Estimated Effort:** 8 days  
**Team:** Developer 1 (Backend lead) + Developer 3 (Support)  
**Dependencies:** Blocked by S1.1 (Nx setup)

📁 **Full Details:** [project-planning/stories/v0.7/S1.2-typedb-integration.md](./project-planning/stories/v0.7/S1.2-typedb-integration.md)
```

---

### **Issue 3: S1.3 - Socket.io Integration**

**Title:** [STORY] S1.3: Socket.io Real-time Collaboration Integration

**Labels:** epic:E1-foundation, priority:P0-critical, size:M, type:story, team:fullstack, version:v0.7

**Milestone:** Epic 1: Foundation & Infrastructure

**Description:**
```markdown
## 👤 User Story
**As a** full-stack developer  
**I want** Socket.io integration between frontend and backend  
**So that** real-time collaboration features can be built efficiently

## 📋 Acceptance Criteria
- [ ] Socket.io server runs with FastAPI backend successfully
- [ ] Frontend can connect to Socket.io server and maintain connection
- [ ] Basic message passing works (ping/pong, echo)
- [ ] Connection authentication using JWT tokens works
- [ ] Automatic reconnection handles network interruptions
- [ ] Multiple clients can connect simultaneously without conflicts
- [ ] Error handling for connection failures is robust
- [ ] Performance: Message latency <50ms on local development

## 🔧 Implementation Tasks
- [ ] Task 1.3.1: Socket.io server integration with FastAPI (2 days)
- [ ] Task 1.3.2: Frontend Socket.io client setup (1 day)
- [ ] Task 1.3.3: Authentication integration with JWT (2 days)
- [ ] Task 1.3.4: Connection handling and error recovery (1 day)
- [ ] Task 1.3.5: Testing and documentation (1 day)

## 📊 Story Details
**Status:** Ready for Development  
**Estimated Effort:** 3 days  
**Team:** Developer 2 (Frontend) + Developer 3 (Integration)  
**Dependencies:** Blocked by S1.1 (Nx setup)

📁 **Full Details:** [project-planning/stories/v0.7/S1.3-socketio-realtime-integration.md](./project-planning/stories/v0.7/S1.3-socketio-realtime-integration.md)
```

## 🎯 **Epic 1 Summary - Klaar voor Team**

**📊 Epic 1 Status:**
- **Stories:** 3 volledig uitgewerkt ✅
- **Total Effort:** 16 developer dagen  
- **Timeline:** 4 weken 
- **Team:** 3 developers
- **Status:** Ready for implementation ✅

**🔗 Dependencies:**
- S1.1 blokkeert S1.2 en S1.3
- Epic 1 blokkeert alle andere epics

**📋 Development Flow:**
1. **Week 1-2:** S1.1 (alle 3 developers samen) 
2. **Week 3-4:** Parallel: S1.2 (backend) + S1.3 (frontend)

**📁 Alle detailbestanden staan klaar in:**
- `/project-planning/epics/E1-foundation-infrastructure.md`
- `/project-planning/stories/v0.7/S1.1-nx-monorepo-setup.md`
- `/project-planning/stories/v0.7/S1.2-typedb-integration.md`  
- `/project-planning/stories/v0.7/S1.3-socketio-realtime-integration.md` 