# 🔗 GitHub Sub-Issues Capability Analyse

**Datum:** 1 juli 2025  
**Vraag:** Kunnen we echte parent-child relationships maken tussen issues?  
**Antwoord:** ✅ JA! Maar het wordt momenteel nog niet gebruikt.

## 🎯 Huidige Situatie

### Wat We Nu Hebben (Pseudo-Hiërarchie)
```
📊 [STORY] S1.1: Nx Monorepo Setup
    Body contains: 
    - [ ] **Task 1.1.1:** Setup Nx workspace structure
    - [ ] **Task 1.1.2:** Configure React frontend
    - [ ] **Task 1.1.3:** Configure FastAPI backend
    - [ ] **Task 1.1.4:** Setup GitHub Actions
    - [ ] **Task 1.1.5:** Developer experience
    - [ ] **Task 1.1.6:** Documentation

⚡ [TASK] T1.1.1: Setup Nx workspace structure (separate issue)
⚡ [TASK] T1.1.2: Configure React 19 frontend (separate issue)
⚡ [TASK] T1.1.3: Configure FastAPI backend (separate issue)
⚡ [TASK] T1.1.4: Setup GitHub Actions (separate issue)
⚡ [TASK] T1.1.5: Developer experience (separate issue)
⚡ [TASK] T1.1.6: Documentation (separate issue)
```

**Probleem:** Geen functionele relatie tussen story en tasks!

### Wat Mogelijk Is (Echte Sub-Issues)
```
📊 [STORY] S1.1: Nx Monorepo Setup (Parent Issue #5)
├── ⚡ [TASK] T1.1.1: Setup Nx workspace (#XX) → Sub-issue of #5
├── ⚡ [TASK] T1.1.2: Configure React frontend (#XX) → Sub-issue of #5  
├── ⚡ [TASK] T1.1.3: Configure FastAPI backend (#XX) → Sub-issue of #5
├── ⚡ [TASK] T1.1.4: Setup GitHub Actions (#XX) → Sub-issue of #5
├── ⚡ [TASK] T1.1.5: Developer experience (#XX) → Sub-issue of #5
└── ⚡ [TASK] T1.1.6: Documentation (#XX) → Sub-issue of #5
```

**Voordeel:** Functionele parent-child relaties met progress tracking!

## 📋 GitHub Sub-Issues Features (April 2024)

### ✅ Wat Beschikbaar Is
1. **Parent-Child Relationships:** Via GraphQL API of UI
2. **Cross-Repository:** Sub-issues kunnen in andere repos zijn
3. **Progress Tracking:** Automatische voortgangsweergave in parent
4. **Project Integration:** Sub-issue progress fields in GitHub Projects
5. **Visual Hierarchy:** Nested weergave in issue view
6. **API Access:** GraphQL API met sub_issues feature flag

### ⚙️ API Permissions Check
```json
Repository Permissions:
- "admin": true ✅
- "push": true ✅  
- "has_issues": true ✅
- "has_projects": true ✅
```
**Conclusie:** We hebben alle benodigde rechten!

## 🔧 Technische Implementatie

### GraphQL API Calls
```graphql
# Header Required
GraphQL-Features: sub_issues

# Add Sub-Issue Relationship
mutation addSubIssue {
  addSubIssue(input: { 
    issueId: "I_12345", 
    subIssueId: "I_67890" 
  }) {
    issue { title }
    subIssue { title }
  }
}

# Get Sub-Issues Progress
query getProgress {
  node(id: "I_12345") {
    ... on Issue {
      subIssuesSummary {
        total
        completed
        percentCompleted
      }
    }
  }
}
```

### REST API Alternative
```bash
# Currently sub-issues require GraphQL
# No REST API endpoints available yet
```

## 🚀 Implementatie Strategie

### Fase 1: Epic 1 & 2 Sub-Issue Conversion (30 minuten)
```bash
# Voor elke Story → Task relatie:
# S1.1 (#5) als parent van T1.1.1-T1.1.6
# S1.2 (#X) als parent van T1.2.1-T1.2.7  
# S1.3 (#X) als parent van T1.3.1-T1.3.4
# S2.1 (#X) als parent van T2.1.1-T2.1.4
```

### Fase 2: GitHub Projects Configuration
```bash
# Enable Sub-issue Progress field in Projects
# Enable Parent Issue field for grouping
# Create views grouped by parent issue
```

### Fase 3: Epic 3-5 met Sub-Issues from Start
```bash
# Nieuwe issues direct als sub-issues aanmaken
# Gebruik proven parent-child pattern
```

## 📊 Voor- en Nadelen

### ✅ Voordelen van Sub-Issues
1. **Automatic Progress Tracking:** Parent shows completion %
2. **Visual Hierarchy:** Clear nested structure in GitHub
3. **Project Integration:** Native support in GitHub Projects
4. **Cross-Repository:** Works across multiple repos
5. **Team Workflow:** Native issue assignment and tracking

### ⚠️ Uitdagingen
1. **Manual Setup:** Requires API calls or manual UI work
2. **GraphQL Only:** No REST API support yet
3. **Learning Curve:** Team moet nieuwe workflow leren
4. **Migration Effort:** Existing issues moeten worden gekoppeld

## 🎯 Aanbeveling

### Option A: Convert to Real Sub-Issues (AANBEVOLEN)
**Voordelen:**
- Native GitHub functionality
- Automatic progress tracking
- Better team visibility
- Future-proof solution

**Inspanning:** 2-3 uur voor Epic 1-2 conversion

### Option B: Behoud Huidige Pseudo-Hiërarchie
**Voordelen:**
- Geen wijzigingen nodig
- Team kent het al

**Nadelen:**
- Geen automatische progress tracking
- Handmatige maintenance van relationships
- Mist native GitHub benefits

## 🔧 Immediate Next Steps

**Als we voor Option A gaan:**

1. **Test Sub-Issue Creation (15 min)**
   ```bash
   # Create 1 test sub-issue relationship
   # Verify functionality and team workflow
   ```

2. **Convert Epic 1 Stories (45 min)**
   ```bash
   # S1.1 → T1.1.1-T1.1.6 relationships
   # S1.2 → T1.2.1-T1.2.7 relationships  
   # S1.3 → T1.3.1-T1.3.4 relationships
   ```

3. **Project Views Setup (30 min)**
   ```bash
   # Enable sub-issue progress fields
   # Create parent-issue grouped views
   # Test team workflow
   ```

**Resultaat:** Echte hiërarchische GitHub project management!

---

**Beslissing:** Zullen we de conversion naar echte sub-issues uitvoeren?  
**Impact:** Better team workflow + native GitHub functionality  
**Tijd:** ~2 uur total effort voor complete Epic 1-2 conversion 