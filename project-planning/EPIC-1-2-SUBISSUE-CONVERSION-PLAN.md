# 🔗 Epic 1-2 Sub-Issue Conversion Plan

**Datum:** 1 juli 2025  
**Doel:** Convert Epic 1 & 2 naar echte GitHub sub-issues  
**Status:** Ready for execution

## 📋 Huidige Mapping

### Epic 1: Foundation & Infrastructure

#### Story S1.1: Nx Monorepo Setup (6 tasks)
```
Parent: [STORY] S1.1: Nx Monorepo Development Environment Setup
├── [TASK] T1.1.1: Setup Nx workspace structure
├── [TASK] T1.1.2: Configure React 19 frontend application  
├── [TASK] T1.1.3: Configure FastAPI backend application
├── [TASK] T1.1.4: Setup GitHub Actions CI/CD pipeline
├── [TASK] T1.1.5: Developer experience optimization
└── [TASK] T1.1.6: Documentation and onboarding
```

#### Story S1.2: TypeDB Integration (7 tasks)
```
Parent: [STORY] S1.2: TypeDB Knowledge Graph Database Integration
├── [TASK] T1.2.1: TypeDB connection setup and configuration
├── [TASK] T1.2.2: Pydantic schema definition system
├── [TASK] T1.2.3: TypeDB schema generation and deployment
├── [TASK] T1.2.4: Basic entity CRUD operations
├── [TASK] T1.2.5: Basic relationship CRUD operations
├── [TASK] T1.2.6: Database testing framework
└── [TASK] T1.2.7: Error handling and monitoring
```

#### Story S1.3: Socket.io Realtime (4 tasks)
```
Parent: [STORY] S1.3: Socket.io Real-time Collaboration Integration
├── [TASK] T1.3.1: Backend Socket.io server setup
├── [TASK] T1.3.2: Frontend Socket.io client integration
├── [TASK] T1.3.3: Real-time message infrastructure
└── [TASK] T1.3.4: Connection reliability and testing
```

### Epic 2: Authentication & User Management

#### Story S2.1: User Registration (4 tasks) ✅ 
```
Parent: [STORY] S2.1: User Registration System
├── [TASK] T2.1.1: User Model & Database Schema
├── [TASK] T2.1.2: Registration API Endpoint  
├── [TASK] T2.1.3: Security Implementation
└── [TASK] T2.1.4: Registration Form Component ✅ (Already linked as test)
```

#### Story S2.2: User Login JWT (0 tasks) ❌ MISSING
```
Parent: [STORY] S2.2: User Login & JWT Authentication
└── [MISSING: Need to create T2.2.x tasks]
```

#### Story S2.3: Team Management (0 tasks) ❌ MISSING  
```
Parent: [STORY] S2.3: Team Creation & Management
└── [MISSING: Need to create T2.3.x tasks]
```

## 🚀 Execution Steps

### Stap 1: Complete Epic 2 First (Missing Tasks)
```bash
# Create missing tasks for S2.2 and S2.3
# Then link them as sub-issues
```

**S2.2 Missing Tasks:**
- T2.2.1: JWT Token Service Implementation
- T2.2.2: Login API Endpoint
- T2.2.3: Frontend Login Component
- T2.2.4: Token Refresh Mechanism

**S2.3 Missing Tasks:**
- T2.3.1: Team Model & Database Schema
- T2.3.2: Team Management API
- T2.3.3: Team Creation UI
- T2.3.4: Team Member Invitation System

### Stap 2: Epic 1 Sub-Issue Linking (17 relationships)
```bash
# Use GitHub UI "Create sub-issue" → "Add existing issue" 
# For each story, link all corresponding tasks
```

### Stap 3: Epic 2 Sub-Issue Linking (12 relationships)
```bash
# Link existing S2.1 tasks (3 remaining, 1 already done)
# Link new S2.2 tasks (4 new)
# Link new S2.3 tasks (4 new)
```

### Stap 4: Verify & Test
```bash
# Check progress indicators working
# Verify parent-child navigation
# Test team workflow
```

## 🔧 Manual UI Process per Story

### Voor elke Story Issue:
1. **Open Story Issue** (bijv. S1.1)
2. **Click "Create sub-issue"**
3. **Select "Add existing issue"**
4. **Search for "T1.1.1"** (first task)
5. **Click task** → automatisch gekoppeld
6. **Repeat** voor T1.1.2, T1.1.3, etc.

### Resultaat per Story:
```
📊 [STORY] S1.1: Nx Monorepo Setup
   Progress: 0 of 6 (0%)
   Sub-issues:
   ├── ⚡ T1.1.1: Setup Nx workspace
   ├── ⚡ T1.1.2: Configure React frontend
   ├── ⚡ T1.1.3: Configure FastAPI backend
   ├── ⚡ T1.1.4: Setup GitHub Actions
   ├── ⚡ T1.1.5: Developer experience
   └── ⚡ T1.1.6: Documentation
```

## ⏱️ Time Estimates

| Epic | Stories | Tasks | Sub-Issue Links | Time |
|------|---------|-------|-----------------|------|
| **Epic 1** | 3 | 17 existing | 17 links | 25 min |
| **Epic 2** | 3 | 4 existing + 8 new | 12 links | 35 min |
| **Testing** | - | - | Verify workflow | 10 min |
| **Total** | 6 | 29 total | 29 links | **70 min** |

## ✅ Success Criteria

### Visual Verification:
- [ ] Each story shows "X of Y" progress indicator
- [ ] Sub-issues section visible with nested tasks
- [ ] "Create sub-issue" button available for additions

### Functional Verification:
- [ ] Completing task updates parent story progress
- [ ] GitHub Projects shows sub-issue progress fields
- [ ] Parent Issue field available for grouping

### Team Workflow:
- [ ] Tasks can be assigned independently
- [ ] Sprint planning works with story-level progress
- [ ] Dependencies clear between stories and tasks

## 🎯 Expected Outcome

**Before:** Pseudo-hierarchy via markdown checklists  
**After:** Native GitHub sub-issues with automatic progress tracking

**Benefits:**
- Real-time progress visualization
- Native GitHub Projects integration  
- Better sprint planning capabilities
- Professional team workflow

---

**Ready to Execute:** All Epic 1 tasks identified, Epic 2 completion plan ready  
**Next Action:** Start with Epic 2 missing tasks, then bulk sub-issue linking  
**Estimated Completion:** 70 minutes total 