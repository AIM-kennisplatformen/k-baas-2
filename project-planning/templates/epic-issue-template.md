# Epic Issue Template

> **📍 Template voor:** GitHub Epic Issues  
> **Gebruik:** Copy-paste naar GitHub Issues bij Epic creatie  
> **Source:** Lokaal epic bestand uit `project-planning/epics/`

## 📋 **GitHub Issue Fields**

**Title:** `[EPIC] {epic_id}: {epic_title}`

**Labels:** `epic:{epic_name}`, `type:epic`, `priority:{priority}`, `version:{version}`

**Assignees:** `{team_members}`

**Milestone:** `{milestone_name}`

## 📝 **Issue Description Template**

```markdown
## 🎯 Epic Overview

**Epic Goal:** {epic_goal_from_local_file}

## 📊 Epic Details
- **Version:** {version}
- **Priority:** {priority}  
- **Estimated Effort:** {total_days} days total
- **Timeline:** {sprint_range}
- **Team:** {team_members}

## 🎯 Business Value
{business_value_from_local_file}

## 📋 Stories in this Epic
{story_list_with_effort}

## ✅ Epic Success Criteria
{success_criteria_from_local_file}

## 🔗 Dependencies
- **Blocks:** {blocking_epics}
- **Blocked by:** {blocked_by_epics}

## 📁 Local Source
**Planning Document:** [project-planning/epics/{epic_file}.md](./project-planning/epics/{epic_file}.md)
**Local Mirror:** [project-planning/issues/epics/epic-{epic_id}.md](./project-planning/issues/epics/epic-{epic_id}.md)

## 🏷️ Child Issues
This epic contains the following child issues:
- [ ] #TBD: [STORY] {story_1_id}: {story_1_title}
- [ ] #TBD: [STORY] {story_2_id}: {story_2_title}  
- [ ] #TBD: [STORY] {story_3_id}: {story_3_title}

## 📊 Progress Tracking
- **Epic Status:** {status}
- **Completed Stories:** 0/{total_stories}
- **Estimated Completion:** {estimated_date}

---

*🔄 This issue is automatically synced with local planning documents. Please update the local files for planning changes.*
```

## 🔄 **Variabelen voor Template**

**Van Lokaal Epic Bestand:**
- `{epic_id}` → E1, E2, E3, etc.
- `{epic_title}` → Foundation & Infrastructure
- `{epic_name}` → foundation, authentication, schema
- `{epic_goal}` → Epic goal uit lokaal bestand
- `{business_value}` → Business value sectie
- `{success_criteria}` → Success criteria checklist
- `{epic_file}` → E1-foundation-infrastructure

**Van Planning Context:**
- `{priority}` → critical, high, medium, low
- `{version}` → v0.7, v1.0, v2.0
- `{total_days}` → Som van alle story estimates
- `{sprint_range}` → Sprint 1-2 (Weeks 1-4)
- `{team_members}` → Developer 1, Developer 2, Developer 3
- `{milestone_name}` → V0.7 Foundation, V0.7 Authentication

**Van Dependencies:**
- `{blocking_epics}` → E2, E3, E4, etc.
- `{blocked_by_epics}` → None (foundational epic)

**Van Story Analysis:**
- `{story_list_with_effort}` → Bullet list met estimates
- `{total_stories}` → Number of stories in epic
- `{story_1_id}`, `{story_1_title}` → Voor child issues

## 📋 **Voorbeeld Gebruik**

### **Input (Lokaal Epic Bestand):**
```
project-planning/epics/E1-foundation-infrastructure.md
```

### **Output (GitHub Issue):**
```
Title: [EPIC] E1: Foundation & Infrastructure  
Labels: epic:foundation, type:epic, priority:critical, version:v0.7
```

## 🎯 **Volgende Stap**

Na aanmaken Epic issue op GitHub:
1. **Update lokaal epic bestand** met GitHub issue nummer
2. **Creëer lokale mirror** in `issues/epics/epic-E1-foundation.md`
3. **Maak child story issues** met parent link naar epic
4. **Update epic issue** met child issue nummers 