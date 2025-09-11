# 📊 Content Mapping Matrix - Lokaal vs GitHub

**Analysedatum:** 1 juli 2025  
**Doel:** Volledige mapping voor consolidatie planning

## 🎯 Mapping Overzicht

### Summary Statistics
- **Lokale Epics:** 5 (E1-E5 in directory)
- **GitHub Milestones:** 5 (M1-M5)
- **Lokale Stories:** 6 (S1.1-S2.3 in v0.7 directory)
- **GitHub Issues:** 54 total

## 📋 Epic-Level Mapping

| Epic | Lokaal Bestand | GitHub Milestone | GitHub Issues | Status | Gap |
|------|---------------|------------------|---------------|---------|-----|
| **E1** | `E1-foundation-infrastructure.md` | M1: Foundation & Infrastructure | 20 | ✅ OVER-DETAILED | GitHub heeft meer tasks dan lokaal |
| **E2** | `E2-user-authentication.md` | M2: Authentication & User Management | 7 | ✅ ALIGNED | Goed gematched |
| **E3** | `E3-knowledge-base-schema.md` | M3: Knowledge Base Core | 0 | ❌ MISSING | Hele epic ontbreekt |
| **E4** | `E4-wiki-content-management.md` | M4: Basic Wiki | 0 | ❌ MISSING | Hele epic ontbreekt |
| **E5** | `E5-knowledge-graph-visualization.md` | M5: Basic Graph | 0 | ❌ MISSING | Hele epic ontbreekt |

### Extended Epic Analysis

**Epic 1 (Foundation) - OVER-IMPLEMENTED**
- Lokaal: 3 stories (S1.1, S1.2, S1.3)
- GitHub: 20+ detailed tasks
- Issue: GitHub heeft veel meer granulaire tasks dan lokale planning
- Action: Consolideer GitHub tasks naar story level

**Epic 2 (Authentication) - WELL-ALIGNED**  
- Lokaal: 3 stories (S2.1, S2.2, S2.3)
- GitHub: 7 tasks in logical groups
- Issue: Goede match, minor gaps
- Action: Fill remaining story content

**Epic 3-5 - COMPLETELY MISSING**
- Lokaal: Volledige epic bestanden met stories
- GitHub: Alleen lege milestones
- Issue: 60% van project scope ontbreekt
- Action: Bulk upload alle content

## 📝 Story-Level Mapping

### Epic 1: Foundation & Infrastructure

| Story | Lokaal | GitHub Equivalent | Status |
|-------|--------|------------------|---------|
| **S1.1** | Nx Monorepo Setup | T1.1.1 - T1.1.6 (tasks) | ✅ Detailed |
| **S1.2** | TypeDB Integration | T1.2.1 - T1.2.7 (tasks) | ✅ Detailed |
| **S1.3** | Socket.io Realtime | T1.3.1 - T1.3.4 (tasks) | ✅ Detailed |

### Epic 2: Authentication & User Management

| Story | Lokaal | GitHub Equivalent | Status |
|-------|--------|------------------|---------|
| **S2.1** | User Registration | T2.1.1 - T2.1.4 (tasks) | ✅ Good match |
| **S2.2** | User Login JWT | T2.2.x (estimated) | ⚠️ Partial |
| **S2.3** | Team Management | Missing | ❌ Not found |

### Epic 3: Knowledge Base Schema (MISSING)

| Story | Lokaal | GitHub | Status |
|-------|--------|--------|---------|
| **S3.1** | Schema Definition System | None | ❌ Missing |
| **S3.2** | Basic Entity Operations | None | ❌ Missing |
| **S3.3** | Schema Validation | None | ❌ Missing |

### Epic 4: Wiki Content Management (MISSING)

| Story | Lokaal | GitHub | Status |
|-------|--------|--------|---------|
| **S4.1** | Wiki Page Creation | None | ❌ Missing |
| **S4.2** | Wiki Page Editing | None | ❌ Missing |
| **S4.3** | Wiki Navigation | None | ❌ Missing |
| **S4.4** | Wiki Search | None | ❌ Missing |

### Epic 5: Knowledge Graph Visualization (MISSING)

| Story | Lokaal | GitHub | Status |
|-------|--------|--------|---------|
| **S5.1** | Graph Visualization | None | ❌ Missing |
| **S5.2** | Node Interaction | None | ❌ Missing |
| **S5.3** | Graph Navigation | None | ❌ Missing |

## 🔍 Detailed Gap Analysis

### Critical Gaps (P0)
1. **Epic 3-5 Completely Missing**
   - Impact: 60% of MVP scope not on GitHub
   - Risk: Team cannot plan beyond authentication
   - Solution: Bulk upload all epic content

2. **Story-Level Issues Missing**
   - Impact: No parent-child hierarchy
   - Risk: Tasks float without context
   - Solution: Create [STORY] issues for all epics

3. **Acceptance Criteria Inconsistency**
   - Impact: Different quality across issues
   - Risk: Unclear completion criteria
   - Solution: Standardize all issue templates

### Medium Gaps (P1)
1. **Over-Detailed Tasks in Epic 1**
   - Impact: Micromanagement, slow velocity
   - Risk: Developer frustration
   - Solution: Consolidate to story level

2. **Missing Dependencies**
   - Impact: Unclear sequence of work
   - Risk: Blocking issues not visible
   - Solution: Add dependency mapping

3. **Estimate Inconsistency**
   - Impact: Poor sprint planning
   - Risk: Velocity unpredictable
   - Solution: Re-estimate all issues

### Low Gaps (P2)  
1. **Label Inconsistency**
   - Impact: Filtering and sorting issues
   - Risk: Manual label management
   - Solution: Automation rules

2. **Assignment Gaps**
   - Impact: Unclear ownership
   - Risk: Work duplication
   - Solution: Team assignment strategy

## 🚀 Consolidation Priority

### Phase 1: Critical Missing Content (This Week)
1. **Create Epic 3-5 Milestones** (1 hour)
2. **Upload Epic 3-5 Story Issues** (4 hours)
3. **Create Story Parents for Epic 1-2** (2 hours)
4. **Link Existing Tasks to Stories** (2 hours)

### Phase 2: Quality & Consistency (Next Week)
1. **Standardize Acceptance Criteria** (3 hours)
2. **Add Dependencies Mapping** (2 hours)
3. **Re-estimate All Issues** (4 hours)
4. **Create Project Views** (2 hours)

### Phase 3: Team Enablement (Week 3)
1. **Team Training** (4 hours)
2. **Workflow Documentation** (2 hours)
3. **Sprint 1 Planning** (3 hours)
4. **Automation Setup** (2 hours)

## 📊 Content Volume Analysis

### Current State
```
GitHub Issues Distribution:
- Milestone 1: 20 issues (Foundation)
- Milestone 2: 7 issues (Authentication)  
- Milestone 3-5: 0 issues (Missing epics)
- Total: 27 project issues + 27 other

Lokale Planning Distribution:
- Epic 1-2: 6 stories (implemented)
- Epic 3-5: 15+ stories (missing)
- Total: 21+ stories missing from GitHub
```

### Target State
```
Balanced GitHub Structure:
- Epic 1: 3 stories + 15 tasks
- Epic 2: 3 stories + 8 tasks
- Epic 3: 3 stories + 12 tasks
- Epic 4: 4 stories + 16 tasks
- Epic 5: 3 stories + 12 tasks
- Total: 16 stories + 63 tasks
```

## ✅ Action Items Summary

### Immediate (Today)
- [ ] Complete Epic 3-5 content extraction from local files
- [ ] Prepare bulk GitHub upload scripts
- [ ] Create issue templates for stories

### This Week
- [ ] Execute bulk upload Phase 1
- [ ] Restructure existing issues with parent-child
- [ ] Test GitHub project views

### Next Week  
- [ ] Team onboarding and training
- [ ] First sprint planning session
- [ ] Velocity baseline establishment

---

**Status:** Gap analysis complete, ready for consolidation execution  
**Priority:** P0-Critical for team collaboration  
**Owner:** PM + Technical Lead 