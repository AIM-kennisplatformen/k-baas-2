# 🚀 GitHub Consolidatie Actieplan - Eindversie Realisatie

**Datum:** 1 juli 2025  
**Deadline:** 8 juli 2025 (1 week)  
**Doel:** Haalbare eindversie op GitHub voor teamwerk

## 📋 Situatie Samenvatting

### Huidige Status
- **GitHub:** 54 issues, 5 milestones, professioneel label systeem
- **Lokaal:** 50+ stories over 11 epics, uitgebreide planning
- **Discrepantie:** GitHub focust op E1-E2, lokaal heeft volledige scope

### Kernprobleem  
GitHub heeft excellente infrastructuur maar mist 70% van de lokale planning content. Team kan niet starten zonder volledige project scope.

## 🎯 Consolidatie Doelen

### Primair Doel: Team-Ready GitHub
1. **Volledige Scope:** Alle lokale epics/stories op GitHub
2. **Werkbare Planning:** Realistische timeline met haalbare sprints  
3. **Team Workflow:** Duidelijke processen voor daily work
4. **Traceabiliteit:** Epic → Story → Task hiërarchie

### Secundair Doel: Planning Optimalisatie
1. **Effort Calibratie:** Realistische estimates voor 3-dev team
2. **Scope Prioritering:** Duidelijke MVP vs Nice-to-Have
3. **Risk Mitigation:** Dependencies en blockers geïdentificeerd

## 📅 7-Dagen Actieplan

### Dag 1-2: Content Audit & Transfer (Ma-Di)

#### Task 1: GitHub Issues Volledig Mappen
```bash
# Script voor analyse
curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/HAN-AIM-CMD-WG/k-baas-2/issues?state=all&per_page=100" \
  | jq '.[] | {number, title, milestone: .milestone.title, labels: [.labels[].name]}' \
  > github_complete_mapping.json
```

#### Task 2: Lokale Content Inventaris
- Alle `epics/E*.md` bestanden scannen
- `stories/v0.7/*.md` bestanden mappen
- Missing content lijst maken

#### Task 3: Gap Analysis Matrix
| Epic | Lokaal Stories | GitHub Issues | Status | Action |
|------|---------------|---------------|--------|--------|
| E1 | S1.1-S1.3 | 20 tasks | ✅ Over-detailed | Consolideer |
| E2 | S2.1-S2.3 | 7 tasks | ✅ Good match | Minor updates |
| E3-E11 | S3.1-S11.3 | 0 | ❌ Missing | Bulk upload |

### Dag 3-4: Bulk GitHub Upload (Wo-Do)

#### Task 4: Missing Milestones & Epics
```markdown
# Nieuwe Milestones Aanmaken:
- M6: Document Processing (E8)
- M7: Knowledge Management (E9)  
- M8: System Quality (E10)
- M9: Release Preparation (E11)
```

#### Task 5: Story-Level Issues Aanmaken
Voor elke epic/story combinatie:
```markdown
Title: [STORY] S3.1: Schema Definition System
Labels: epic:E3-schema, type:story, priority:P1-high, size:L, version:v0.7
Milestone: M3: Knowledge Base Core

## User Story
As a domain expert...

## Acceptance Criteria  
- [ ] Schema creation interface working
- [ ] Validation rules active
- [ ] TypeDB integration functional

## Sub-Tasks
- [ ] Task 3.1.1: Schema model design (#XX)
- [ ] Task 3.1.2: UI components (#XX)
- [ ] Task 3.1.3: API integration (#XX)
```

#### Task 6: Bestaande Tasks Herstructureren
- Parent-child relationships toevoegen
- Duplicate tasks consolideren  
- Missing acceptance criteria aanvullen

### Dag 5-6: Project Configuration (Vr-Za)

#### Task 7: GitHub Project Views
1. **Roadmap View**
   - Group by: Milestone
   - Filter: All open issues
   - Timeline: Gantt-style layout

2. **Sprint Planning View**  
   - Group by: Sprint milestone
   - Filter: Current + next sprint
   - Sorting: Priority → Size

3. **Team Assignment View**
   - Group by: Assignee
   - Filter: In Progress + To Do
   - Quick assignment interface

4. **Epic Progress View**
   - Group by: Epic label  
   - Show: Story completion %
   - Burndown tracking

#### Task 8: Automation Setup
```yaml
# GitHub Actions Workflow
name: Project Management
on:
  issues:
    types: [opened, edited, closed]
    
jobs:
  auto-label:
    # Auto-assign epic labels based on title pattern
    # Update parent story progress
    # Notify team on milestone completion
```

### Dag 7: Team Onboarding (Zo)

#### Task 9: Workflow Documentatie
```markdown
# Developer Workflow Guide
1. Pick issue from Sprint Backlog
2. Create feature branch: `feature/T1.2.3-short-description`
3. Implement with tests
4. PR with "Closes #issue" in description
5. Review → Merge → Auto-close issue
```

#### Task 10: Planning Calibratie
- Historical velocity data review
- Effort estimation guidelines  
- Sprint capacity calculation (2 dagen/week × 3 devs = 6 dagen/sprint)

## 🔧 Technische Implementatie

### GitHub API Scripts
```bash
# 1. Bulk Issue Creation
cat epic_content.json | while read epic; do
  curl -X POST \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    "https://api.github.com/repos/HAN-AIM-CMD-WG/k-baas-2/issues" \
    -d "$epic"
done

# 2. Milestone Management  
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/HAN-AIM-CMD-WG/k-baas-2/milestones" \
  -d '{"title":"M6: Document Processing","due_on":"2026-06-15T00:00:00Z"}'

# 3. Project View Configuration
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/orgs/HAN-AIM-CMD-WG/projects" \
  -d '{"name":"Knowledge Graph Wiki - Roadmap","body":"Epic progress tracking"}'
```

### Content Generation Templates
```python
# Epic → Stories → Tasks Generator
def generate_github_issues(epic_file):
    epic = parse_epic(epic_file)
    for story in epic.stories:
        create_story_issue(story)
        for task in story.tasks:
            create_task_issue(task, parent=story.github_id)
```

## 📊 Haalbare Planning Aanpassingen

### MVP Scope Herdefiniëren
**V0.7 MVP (Haalbaar voor 3 devs, 6 maanden):**
- E1: Foundation ✅ (al op GitHub)
- E2: Authentication ✅ (al op GitHub)  
- E3: Basic Schema (simplified)
- E4: Basic Wiki (core features only)
- E5: Simple Graph (read-only visualization)

**V0.8+ Future (Nice-to-Have):**
- E6: Real-time sync
- E7: Quality management  
- E8: Document processing
- E9: Advanced knowledge management
- E10: Performance optimization
- E11: Production deployment

### Sprint Planning Realistisch
```markdown
# Sprint Strukture (2 weken, 6 dev-dagen)
Sprint 1 (Jul 1-15):  S1.1, S1.2 (Foundation)
Sprint 2 (Jul 15-29): S1.3, S2.1 (Auth Start)  
Sprint 3 (Jul 29-Aug 12): S2.2, S2.3 (Auth Complete)
Sprint 4 (Aug 12-26): S3.1 (Schema Start)
...
```

## ✅ Success Criteria

### Week 1 Success (8 Juli)
- [ ] Alle lokale epics hebben GitHub milestone
- [ ] Top 20 stories hebben GitHub issues met tasks
- [ ] Project views zijn geconfigureerd
- [ ] Team heeft toegang en training

### Month 1 Success (1 Augustus)  
- [ ] Sprint 1 succesvol afgerond
- [ ] Developer workflow loopt soepel
- [ ] Issues → Branches → PRs → Merges werken
- [ ] Velocity tracking aktief

### MVP Success (Januari 2026)
- [ ] V0.7 MVP deployed en werkend
- [ ] Team werkt volledig via GitHub
- [ ] Stakeholders kunnen progress tracken
- [ ] Basis voor V0.8 planning gelegd

## 🚨 Risico's & Mitigatie

### Technische Risico's
- **GitHub API Rate Limits:** Bulk operations spreiden over tijd
- **Content Volume:** Incrementele upload, niet alles tegelijk
- **Team Adoptie:** Geleidelijke overgang, parallel systemen tijdelijk

### Planning Risico's  
- **Scope Creep:** Strikt MVP focus aanhouden
- **Estimate Accuracy:** Buffer inbouwen, retrospectives doen
- **Dependencies:** Blocker management protocol

---

**Eigenaar:** Wouter (PM) + Technical Lead  
**Review:** Dagelijkse progress check  
**Escalatie:** Bij meer dan 1 dag vertraging team meeting 