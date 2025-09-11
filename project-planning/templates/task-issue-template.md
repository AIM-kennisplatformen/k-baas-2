# Task Issue Template

> **📍 Template voor:** GitHub Task Issues  
> **Gebruik:** Copy-paste naar GitHub Issues bij Task creatie  
> **Source:** Implementation tasks uit lokaal story bestand

## 📋 **GitHub Issue Fields**

**Title:** `[TASK] {task_id}: {task_title}`

**Labels:** `epic:{epic_name}`, `type:task`, `priority:{priority}`, `size:{size}`, `version:{version}`

**Assignees:** `{assigned_developer}`

**Milestone:** `{milestone_name}`

## 📝 **Issue Description Template**

```markdown
## 🔧 Task Description
{task_description_from_story}

## 🔗 Parent Story
**Part of:** #{story_issue_number} [STORY] {story_id}: {story_title}

## 🔗 Parent Epic
**Epic:** #{epic_issue_number} [EPIC] {epic_id}: {epic_title}

## 📋 Task Acceptance Criteria
{task_specific_acceptance_criteria}

## 📊 Task Details
**Status:** {status}  
**Estimated Effort:** {effort_days} days  
**Assigned:** {assigned_developer}  
**Priority:** {priority}
**Dependencies:** {dependencies_text}

## 🔧 Implementation Steps
{implementation_steps_from_story}

## ✅ Definition of Done
{task_specific_definition_of_done}

## 📁 Local Source
**Planning Document:** [project-planning/stories/{version}/{story_file}.md](./project-planning/stories/{version}/{story_file}.md) (Task {task_number})
**Local Mirror:** [project-planning/issues/tasks/task-{task_id}.md](./project-planning/issues/tasks/task-{task_id}.md)

## 📊 Progress Tracking
- **Task Status:** {status}
- **Sprint:** {assigned_sprint}
- **Blocked by:** {blocking_tasks}

---

*🔄 This issue is automatically synced with local planning documents. Please update the local files for planning changes.*
```

## 🔄 **Variabelen voor Template**

**Van Lokaal Story Task:**
- `{task_id}` → T1.1.1, T1.1.2, T1.2.1, etc.
- `{task_title}` → Setup Nx workspace structure
- `{task_description_from_story}` → Task description uit story bestand
- `{task_specific_acceptance_criteria}` → Specific AC voor deze task
- `{implementation_steps_from_story}` → Bullet list van steps
- `{task_specific_definition_of_done}` → DoD checklist voor task
- `{task_number}` → 1.1.1, 1.1.2, etc.

**Van Planning Context:**
- `{epic_name}` → foundation, authentication, schema
- `{epic_id}` → E1, E2, E3
- `{epic_title}` → Foundation & Infrastructure
- `{epic_issue_number}` → GitHub issue nummer van grandparent epic
- `{story_id}` → S1.1, S1.2, S2.1
- `{story_title}` → Nx Monorepo Development Environment Setup
- `{story_issue_number}` → GitHub issue nummer van parent story
- `{story_file}` → S1.1-nx-monorepo-setup
- `{version}` → v0.7, v1.0, v2.0
- `{milestone_name}` → V0.7 Foundation

**Van Task Assignment:**
- `{assigned_developer}` → Developer 1, Developer 2, Developer 3
- `{assigned_sprint}` → Sprint 1 (Weeks 1-2)
- `{status}` → Ready, In Progress, Review, Done
- `{priority}` → critical, high, medium, low
- `{size}` → XS, S, M, L, XL
- `{effort_days}` → 2, 3, 1, etc.

**Van Dependencies:**
- `{dependencies_text}` → Blocked by T1.1.1 (Nx workspace)
- `{blocking_tasks}` → T1.1.2, T1.1.3

## 📋 **Voorbeeld Task Definitie (Uit Story)**

### **Van S1.1 Story Bestand:**
```markdown
### **Task 1.1.1:** Setup Nx workspace structure *(Size: M, 2 days, P0-Critical)*
- Initialize Nx workspace with `create-nx-workspace`
- Configure nx.json with build targets for both apps
- Setup shared libs structure for common utilities
- Configure workspace-wide TypeScript/JavaScript settings
- Setup shared dependencies in root package.json
```

### **Wordt GitHub Task Issue:**
```markdown
Title: [TASK] T1.1.1: Setup Nx workspace structure
Labels: epic:foundation, type:task, priority:critical, size:M, version:v0.7
Parent: #2 [STORY] S1.1: Nx Monorepo Development Environment Setup

## 🔧 Task Description
Setup and configure Nx workspace with proper structure for monorepo development.

## 📋 Task Acceptance Criteria
- [ ] Nx workspace initialized with `create-nx-workspace`
- [ ] nx.json configured with build targets for both apps
- [ ] Shared libs structure setup for common utilities
- [ ] Workspace-wide TypeScript/JavaScript settings configured
- [ ] Shared dependencies properly managed in root package.json

## 🔧 Implementation Steps
1. Initialize Nx workspace
2. Configure nx.json with targets
3. Setup shared libraries structure
4. Configure TypeScript/JavaScript settings
5. Setup shared dependencies
6. Test workspace configuration
```

## 🎯 **Task Creation Workflow**

**Stap 1:** Parse story bestand en extract alle tasks  
**Stap 2:** Voor elke task, vul template in met variabelen  
**Stap 3:** Creëer GitHub issue met title, labels, en description  
**Stap 4:** Link task issue aan parent story issue  
**Stap 5:** Update story issue met child task nummers  
**Stap 6:** Creëer lokale mirror in `issues/tasks/`

## 🔄 **Dependencies tussen Tasks**

**Binnen Story (Sequential):**
- T1.1.1 (Nx workspace) → blocks → T1.1.2 (React app)
- T1.1.1 (Nx workspace) → blocks → T1.1.3 (FastAPI app)
- T1.1.2 + T1.1.3 → blocks → T1.1.4 (CI/CD)

**Between Stories:**
- S1.1 (Nx setup) → blocks → S1.2 (TypeDB)
- S1.1 (Nx setup) → blocks → S1.3 (Socket.io)

**GitHub Relationship:**
```
#1 [EPIC] E1 Foundation
  ├── #2 [STORY] S1.1 Nx Setup
  │   ├── #5 [TASK] T1.1.1 Nx workspace (blocks #6, #7)
  │   ├── #6 [TASK] T1.1.2 React app (blocked by #5)
  │   └── #7 [TASK] T1.1.3 FastAPI app (blocked by #5)
  ├── #3 [STORY] S1.2 TypeDB (blocked by #2)
  └── #4 [STORY] S1.3 Socket.io (blocked by #2)
```

## 📊 **Progress Tracking**

**Task Level:**
- Individual developer assignment
- Daily progress updates
- Specific blockers and solutions

**Story Level:**
- Task completion percentage
- Story readiness for testing
- Dependencies resolution

**Epic Level:**
- Overall epic progress
- Cross-story dependencies
- Release readiness 