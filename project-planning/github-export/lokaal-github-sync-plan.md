# 📋 Lokaal ↔ GitHub Synchronisatie Plan

## 🎯 **Centrale Filosofie: Lokaal als Source of Truth**

**Waarom lokaal eerst?**
- ✅ **Version control** van planning wijzigingen
- ✅ **Offline werken** mogelijk
- ✅ **Bulk editing** van stories en tasks
- ✅ **Consistent formatting** via templates
- ✅ **Backup en historie** via Git

## 📁 **Uitgebreide Project-Planning Structuur**

```
project-planning/
├── README.md                           # Project overview + sync status
├── milestones/                         # Release planning
│   ├── v0.7-mvp-plan.md               ✅ Exists
│   └── REVISED-TIMELINE-SUMMARY.md    ✅ Exists
├── epics/                              # Epic definitions
│   ├── E1-foundation-infrastructure.md ✅ Exists  
│   ├── E2-user-authentication.md      ✅ Exists
│   ├── E3-knowledge-base-schema.md    ✅ Exists
│   ├── E4-wiki-content-management.md  ✅ Exists
│   └── E5-knowledge-graph-visualization.md ✅ Exists
├── stories/v0.7/                       # User stories per version
│   ├── S1.1-nx-monorepo-setup.md      ✅ Exists
│   ├── S1.2-typedb-integration.md     ✅ Exists
│   ├── S1.3-socketio-realtime-integration.md ✅ Exists
│   ├── S2.1-user-registration.md      ✅ Exists
│   ├── S2.2-user-login-jwt.md         📝 To create
│   └── S2.3-team-management.md        ✅ Exists
├── issues/ (📝 NEW - GitHub Mirror)    # 🆕 GitHub Issues Mirror
│   ├── epics/                          # Epic issues (lokale kopieën)
│   │   ├── epic-E1-foundation.md      📝 To create
│   │   ├── epic-E2-authentication.md  📝 To create
│   │   └── epic-E3-schema.md          📝 To create
│   ├── stories/                        # Story issues (lokale kopieën)
│   │   ├── story-S1.1-nx-setup.md     📝 To create
│   │   ├── story-S1.2-typedb.md       📝 To create
│   │   └── story-S1.3-socketio.md     📝 To create
│   ├── tasks/                          # Task issues (lokale kopieën)
│   │   ├── task-T1.1.1-nx-workspace.md 📝 To create
│   │   ├── task-T1.1.2-react-app.md   📝 To create
│   │   └── task-T1.1.3-fastapi-app.md 📝 To create
│   └── sync-status.json               📝 GitHub sync tracking
├── github-export/                      # GitHub implementation guides
│   ├── github-hierarchy-setup.md      ✅ Just moved here
│   ├── implementation-summary.md      ✅ Exists
│   └── epic1-github-setup.md          ✅ Exists
└── templates/                          # Planning templates
    ├── story-template.md               ✅ Exists
    ├── epic-issue-template.md          📝 To create
    ├── story-issue-template.md         📝 To create
    └── task-issue-template.md          📝 To create
```

## 🔄 **Synchronisatie Workflow**

### **Stap 1: Lokale Planning (Source of Truth)**
```bash
# Je werkt in project-planning/
vim project-planning/stories/v0.7/S1.4-new-feature.md
git add . && git commit -m "Add S1.4 new feature story"
```

### **Stap 2: GitHub Issue Generatie**
```bash
# Generate GitHub issues van lokale files
python scripts/generate-github-issues.py --epic E1
# Of handmatig copy-paste van templates
```

### **Stap 3: GitHub → Lokaal Sync**
```bash
# Pull GitHub updates terug naar lokaal
python scripts/sync-from-github.py --update-status
# Updates issue status, comments, assignments
```

## 📝 **Template Systeem voor Sync**

### **Epic Issue Template** (`templates/epic-issue-template.md`)
```markdown
---
title: "[EPIC] {epic_id}: {epic_title}"
labels: ["epic:{epic_name}", "type:epic", "priority:{priority}", "version:{version}"]
assignees: [{assignees}]
milestone: {milestone}
---

{epic_description_from_local_file}

## 🏷️ Child Issues
{auto_generated_story_links}

## 📁 Local Source
**Planning Document:** [epics/{epic_file}.md](./project-planning/epics/{epic_file}.md)
**Local Mirror:** [issues/epics/epic-{epic_id}.md](./project-planning/issues/epics/epic-{epic_id}.md)
```

### **Story Issue Template** (`templates/story-issue-template.md`)
```markdown
---
title: "[STORY] {story_id}: {story_title}"
labels: ["epic:{epic_name}", "type:story", "priority:{priority}", "size:{size}", "version:{version}"]
assignees: [{assignees}]
milestone: {milestone}
---

## 🔗 Parent Epic
**Part of:** #{epic_issue_number} [EPIC] {epic_title}

{story_description_from_local_file}

## 🔧 Implementation Tasks
{auto_generated_task_links}

## 📁 Local Source
**Planning Document:** [stories/{version}/{story_file}.md](./project-planning/stories/{version}/{story_file}.md)
**Local Mirror:** [issues/stories/story-{story_id}.md](./project-planning/issues/stories/story-{story_id}.md)
```

## 🤖 **Automatisering Scripts** (Toekomstige V1)

### **Script 1: Generate GitHub Issues**
```python
# scripts/generate-github-issues.py
def generate_epic_issue(epic_file):
    """Parse lokaal epic bestand → GitHub issue"""
    
def generate_story_issues(epic_id):
    """Parse lokale story bestanden → GitHub issues"""
    
def generate_task_issues(story_id):
    """Parse story tasks → GitHub task issues"""
```

### **Script 2: Sync van GitHub**
```python
# scripts/sync-from-github.py  
def sync_issue_status():
    """GitHub issue status → lokaal sync-status.json"""
    
def sync_comments():
    """GitHub comments → lokale .comments bestanden"""
    
def sync_assignments():
    """GitHub assignments → lokale ASSIGNED.md updates"""
```

## 🗃️ **Sync Status Tracking**

### **sync-status.json** (Auto-generated)
```json
{
  "last_sync": "2025-01-06T10:30:00Z",
  "github_issues": {
    "epic_E1": {
      "github_id": 1,
      "status": "open", 
      "assignees": ["dev1", "dev2"],
      "local_file": "epics/E1-foundation-infrastructure.md",
      "local_mirror": "issues/epics/epic-E1-foundation.md"
    },
    "story_S1.1": {
      "github_id": 2,
      "status": "in_progress",
      "assignees": ["dev1"],
      "local_file": "stories/v0.7/S1.1-nx-monorepo-setup.md", 
      "local_mirror": "issues/stories/story-S1.1-nx-setup.md"
    }
  }
}
```

## 🎯 **Implementatie Volgorde**

### **Phase 1: Manual Setup (Deze Week)**
1. ✅ Maak `issues/` directory structure
2. ✅ Creëer issue templates  
3. ✅ Handmatig Epic 1 issues aanmaken op GitHub
4. ✅ Test hiërarchie en dependency tracking

### **Phase 2: Semi-Automated (Volgende Week)**  
1. 📝 Script voor lokaal → GitHub issue generatie
2. 📝 Manual sync van GitHub status terug naar lokaal
3. 📝 Template validatie en verbetering

### **Phase 3: Full Automation (V0.8)**
1. 🚀 Bidirectionele sync scripts
2. 🚀 GitHub webhooks voor real-time updates
3. 🚀 Dashboard voor sync status monitoring

## ✅ **Voordelen van deze Aanpak**

**Voor Developers:**
- 📝 **Offline planning** mogelijk
- 🔍 **Git historie** van alle planning changes
- 📋 **Bulk editing** van stories via teksteditor
- 🏗️ **Consistent formatting** via templates

**Voor Project Management:**
- 📊 **GitHub project boards** voor visualisatie
- 🔗 **Issue linking** en dependency tracking  
- 📈 **Burndown charts** en progress metrics
- 👥 **Team assignment** en workload balancing

**Voor Team:**
- 🎯 **Single source of truth** (lokaal)
- 🔄 **Sync flexibility** (handmatig of automatisch)
- 📚 **Documentation** blijft bij code
- 🚀 **Scalable** voor grote teams

## 🚀 **Next Steps**

**Vandaag:**
1. Creëer `issues/` directory structure  
2. Maak issue templates
3. Start met Epic 1 handmatige GitHub sync

**Deze Week:**  
1. Test volledig Epic 1 workflow
2. Verfijn templates gebaseerd op ervaring
3. Begin met Epic 2 en 3

**Volgende Week:**
1. Begin met semi-automatisering scripts
2. Scale naar alle epics
3. Team training op nieuwe workflow

**Akkoord met deze aanpak?** 🤔 