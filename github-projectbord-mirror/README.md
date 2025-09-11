# 📊 GitHub Projectbord Mirror - Exacte Kopie

**Aangemaakt:** 1 juli 2025  
**Doel:** Exacte lokale kopie van het bestaande GitHub projectbord  
**Status:** 29 open issues, 5 milestones

## 🎯 Overzicht GitHub Project Status

### Milestone Verdeling
| Milestone | Issues | Status | Deadline |
|-----------|--------|--------|----------|
| **M1: Foundation & Infrastructure** | 20 | Actief | Sep 2025 |
| **M2: Authentication & User Management** | 7 | Actief | Dec 2025 |
| **M3: Knowledge Base Core** | 0 | Leeg | Maa 2026 |
| **M4: Basic Wiki** | 0 | Leeg | Jun 2026 |
| **M5: Basic Graph** | 0 | Leeg | Sep 2026 |

### Labels Systeem
- **Epic:** `epic:E1-foundation`, `epic:E2-authentication`
- **Priority:** `priority:P0-critical`, `priority:P1-high`, `priority:P2-medium`
- **Size:** `size:S`, `size:M`, `size:L`, `size:XL`
- **Team:** `team:backend`, `team:frontend`, `team:fullstack`
- **Type:** `type:story`, `type:task`
- **Version:** `version:v0.7`

## 📁 Directory Structuur

```
github-projectbord-mirror/
├── README.md                          # Dit bestand
├── milestones/                        # GitHub Milestones
│   ├── M1-foundation-infrastructure.md
│   ├── M2-authentication-user-management.md
│   ├── M3-knowledge-base-core.md
│   ├── M4-basic-wiki.md
│   └── M5-basic-graph.md
├── issues/                           # Alle GitHub Issues
│   ├── stories/                      # [STORY] level issues
│   │   ├── story-S1.1-nx-monorepo.md
│   │   ├── story-S1.2-typedb-integration.md
│   │   ├── story-S1.3-socketio-realtime.md
│   │   ├── story-S2.1-user-registration.md
│   │   ├── story-S2.2-user-login-jwt.md
│   │   └── story-S2.3-team-management.md
│   └── tasks/                        # [TASK] level issues
│       ├── epic-1-foundation/        # M1 - 20 tasks
│       │   ├── story-1.1-nx-setup/   # 6 tasks
│       │   ├── story-1.2-typedb/     # 7 tasks
│       │   └── story-1.3-socketio/   # 4 tasks + extra
│       └── epic-2-authentication/    # M2 - 7 tasks
│           ├── story-2.1-registration/# 4 tasks
│           ├── story-2.2-login/      # Missing tasks
│           └── story-2.3-teams/      # Missing tasks
├── labels/                           # GitHub Labels definitie
│   └── labels-system.md
└── project-views/                    # GitHub Project Views
    ├── epic-overview.md
    ├── story-progress.md
    ├── sprint-tasks.md
    └── dependencies.md
```

## 🔍 Issue Nummering Schema

**Patroon:** T{Epic}.{Story}.{Task}
- **Epic 1:** T1.x.x (Foundation & Infrastructure)
- **Epic 2:** T2.x.x (Authentication & User Management)  

**Voorbeelden:**
- T1.1.1: Setup Nx workspace structure
- T1.1.2: Configure React 19 frontend application
- T2.1.4: Registration Form Component

## ⚠️ Disclaimer

Dit is een **exacte kopie** van de GitHub projectbord status per 1 juli 2025. 
Wijzigingen in dit mirror worden **NIET** automatisch gesynchroniseerd met GitHub.

Voor werkelijke projectmanagement: gebruik GitHub directe interface. 