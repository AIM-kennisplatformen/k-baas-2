# 🏷️ GitHub Labels Systeem - Exacte Kopie

**Status:** Professioneel en volledig ingericht  
**Gebruik:** Consistent toegepast op alle 29 issues

## 📋 Epic Labels

| Label | Color | Description | Usage |
|-------|-------|-------------|-------|
| `epic:E1-foundation` | #0052cc | Epic 1 - Foundation & Infrastructure | 20 issues |
| `epic:E2-authentication` | #1f883d | Epic 2 - User Authentication & Management | 7 issues |
| `epic:E3-schema` | #8250df | Epic 3 - Knowledge Base Schema | 0 issues |
| `epic:E4-wiki` | #fb8500 | Epic 4 - Wiki Content Management | 0 issues |
| `epic:E5-graph` | #f0a0a0 | Epic 5 - Graph Visualization | 0 issues |

## 📋 Priority Labels

| Label | Color | Description | Usage |
|-------|-------|-------------|-------|
| `priority:P0-critical` | #d73a49 | P0 - Critical/Blocking | Foundation tasks |
| `priority:P1-high` | #fb8500 | P1 - High Priority | Most tasks |
| `priority:P2-medium` | #ffd60a | P2 - Medium Priority | Documentation, UX |
| `priority:P3-low` | #90ee90 | P3 - Low Priority | Future enhancements |

## 📋 Size Labels

| Label | Color | Description | Effort |
|-------|-------|-------------|--------|
| `size:XS` | #90ee90 | Extra Small | 0.5 days |
| `size:S` | #87ceeb | Small | 1 day |
| `size:M` | #dda0dd | Medium | 2-3 days |
| `size:L` | #f0a0a0 | Large | 5 days |
| `size:XL` | #ff6b6b | Extra Large | 8+ days |

## 📋 Team Labels

| Label | Color | Description | Usage |
|-------|-------|-------------|-------|
| `team:backend` | #8250df | Backend development | TypeDB, FastAPI, auth |
| `team:frontend` | #fb8500 | Frontend development | React, UI, components |
| `team:fullstack` | #1f883d | Full-stack work | Integration, Socket.io |
| `team:devops` | #d73a49 | DevOps and infrastructure | CI/CD, deployment |

## 📋 Type Labels

| Label | Color | Description | Usage |
|-------|-------|-------------|-------|
| `type:epic` | #d73a49 | Epic-level work | 0 issues (missing) |
| `type:story` | #fb8500 | User story | 6 issues |
| `type:task` | #ffd60a | Implementation task | 21 issues |
| `type:bug` | #d73a49 | Bug fix | 0 issues |
| `type:enhancement` | #a2eeef | Feature enhancement | 0 issues |

## 📋 Version Labels

| Label | Color | Description | Usage |
|-------|-------|-------------|-------|
| `version:v0.7` | #8250df | MVP Version | All current issues |
| `version:v1.0` | #fb8500 | First major release | Future use |

## 📋 Status Labels (Optional)

| Label | Color | Description | Usage |
|-------|-------|-------------|-------|
| `status:ready` | #0e8a16 | Ready for development | Manual assignment |
| `status:blocked` | #d73a49 | Blocked by dependencies | Manual assignment |
| `status:review` | #f9d71c | In review | Manual assignment |

## 🎯 Label Usage Patterns

### Issue Labeling Formula
**Elke issue heeft minimaal:**
- 1 Epic label (`epic:Ex-name`)
- 1 Type label (`type:story` of `type:task`)  
- 1 Priority label (`priority:Px-level`)
- 1 Size label (`size:X`)
- 1 Version label (`version:v0.7`)
- 1+ Team label (`team:backend/frontend/fullstack`)

### Voorbeeld Issue Labels
```
Story S1.1: Nx Monorepo Setup
├── epic:E1-foundation
├── type:story
├── priority:P0-critical
├── size:L
├── version:v0.7
└── team:fullstack
```

```
Task T1.1.2: Configure React 19 frontend
├── epic:E1-foundation
├── type:task
├── priority:P0-critical
├── size:M
├── version:v0.7
└── team:frontend
```

## 📊 Label Statistics

**Epic Distribution:**
- E1 Foundation: 20 issues (69%)
- E2 Authentication: 7 issues (24%)
- E3-E5: 0 issues (0%) - Missing content

**Type Distribution:**
- Tasks: 21 issues (72%)
- Stories: 6 issues (21%)
- Epics: 0 issues (0%) - Missing level

**Priority Distribution:**
- P0 Critical: ~40% (Foundation tasks)
- P1 High: ~50% (Most development work)
- P2 Medium: ~10% (Documentation, UX)

## ✅ Label System Quality

**Strengths:**
- ✅ Consistent and professional
- ✅ Clear hierarchy and organization
- ✅ Good color coding for visual recognition
- ✅ Complete coverage of all issues

**Areas for Improvement:**
- ⚠️ Missing Epic-level issues (type:epic)
- ⚠️ Epic 3-5 labels exist but have no issues
- ⚠️ Status labels exist but not actively used 