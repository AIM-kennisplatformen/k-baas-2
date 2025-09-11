# Story Issue Template

> **📍 Template voor:** GitHub Story Issues  
> **Gebruik:** Copy-paste naar GitHub Issues bij Story creatie  
> **Source:** Lokaal story bestand uit `project-planning/stories/v0.7/`

## 📋 **GitHub Issue Fields**

**Title:** `[STORY] {story_id}: {story_title}`

**Labels:** `epic:{epic_name}`, `type:story`, `priority:{priority}`, `size:{size}`, `version:{version}`

**Assignees:** `{assigned_developers}`

**Milestone:** `{milestone_name}`

## 📝 **Issue Description Template**

```markdown
## 👤 User Story
**As a** {user_type}  
**I want** {functionality}  
**So that** {business_benefit}

## 🔗 Parent Epic
**Part of:** #{epic_issue_number} [EPIC] {epic_id}: {epic_title}

## 💼 Business Value
{business_value_from_local_file}

## 📋 Acceptance Criteria
{acceptance_criteria_from_local_file}

## 📊 Story Details
**Status:** {status}  
**Estimated Effort:** {effort_days} days  
**Team:** {team_assignment}  
**Dependencies:** {dependencies_text}

## 🔧 Implementation Tasks
This story contains the following implementation tasks:
- [ ] #TBD: [TASK] {task_1_id}: {task_1_title} ({task_1_effort} days)
- [ ] #TBD: [TASK] {task_2_id}: {task_2_title} ({task_2_effort} days)
- [ ] #TBD: [TASK] {task_3_id}: {task_3_title} ({task_3_effort} days)

## 🧪 Testing Strategy
{testing_strategy_from_local_file}

## ⚠️ Risks & Mitigations
{risks_from_local_file}

## 📏 Definition of Done
{definition_of_done_from_local_file}

## 📁 Local Source
**Planning Document:** [project-planning/stories/{version}/{story_file}.md](./project-planning/stories/{version}/{story_file}.md)
**Local Mirror:** [project-planning/issues/stories/story-{story_id}.md](./project-planning/issues/stories/story-{story_id}.md)

## 📊 Progress Tracking
- **Story Status:** {status}
- **Completed Tasks:** 0/{total_tasks}
- **Sprint:** {assigned_sprint}

---

*🔄 This issue is automatically synced with local planning documents. Please update the local files for planning changes.*
```

## 🔄 **Variabelen voor Template**

**Van Lokaal Story Bestand:**
- `{story_id}` → S1.1, S1.2, S2.1, etc.
- `{story_title}` → Nx Monorepo Development Environment Setup
- `{user_type}` → developer, domain expert, administrator
- `{functionality}` → What the user wants to achieve
- `{business_benefit}` → Why this is valuable
- `{business_value}` → Business value sectie uit lokaal bestand
- `{acceptance_criteria}` → AC checklist uit lokaal bestand
- `{testing_strategy}` → Testing approach uit lokaal bestand
- `{risks_from_local_file}` → Risk assessment sectie
- `{definition_of_done}` → DoD checklist uit lokaal bestand
- `{story_file}` → S1.1-nx-monorepo-setup

**Van Planning Context:**
- `{epic_name}` → foundation, authentication, schema
- `{epic_id}` → E1, E2, E3
- `{epic_title}` → Foundation & Infrastructure
- `{epic_issue_number}` → GitHub issue nummer van parent epic
- `{priority}` → critical, high, medium, low
- `{size}` → XS, S, M, L, XL
- `{version}` → v0.7, v1.0, v2.0
- `{effort_days}` → 5, 8, 3, etc.
- `{milestone_name}` → V0.7 Foundation

**Van Team Assignment:**
- `{assigned_developers}` → Developer 1, Developer 2
- `{team_assignment}` → Backend lead + Frontend support
- `{assigned_sprint}` → Sprint 1 (Weeks 1-2)
- `{status}` → Ready, In Progress, Review, Done

**Van Dependencies:**
- `{dependencies_text}` → Blocked by S1.1 (Nx setup)

**Van Task Analysis:**
- `{task_1_id}`, `{task_1_title}`, `{task_1_effort}` → T1.1.1 details
- `{total_tasks}` → Number of implementation tasks

## 📋 **Voorbeeld Gebruik**

### **Input (Lokaal Story Bestand):**
```
project-planning/stories/v0.7/S1.1-nx-monorepo-setup.md
```

### **Output (GitHub Issue):**
```
Title: [STORY] S1.1: Nx Monorepo Development Environment Setup
Labels: epic:foundation, type:story, priority:critical, size:L, version:v0.7
Parent: #1 [EPIC] E1: Foundation & Infrastructure
```

## 🎯 **Volgende Stap**

Na aanmaken Story issue op GitHub:
1. **Update parent epic issue** met child story nummer
2. **Creëer lokale mirror** in `issues/stories/story-S1.1-nx-setup.md`
3. **Maak child task issues** met parent link naar story
4. **Update story issue** met child task nummers 