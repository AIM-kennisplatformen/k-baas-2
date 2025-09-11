# 📅 REVISED MILESTONE TIMELINE - 2 Days/Week Capacity

## 🚨 **CRITICAL PLANNING UPDATE**

**Capaciteit herziening:** 3 developers × 2 dagen/week = **6 developer-dagen/week**  
**Oorspronkelijk:** 3 × 5 dagen = 15 dev-dagen/week (**60% minder!**)

## 📊 **HERZIENE GITHUB MILESTONES**

### 🏗️ **Milestone 1: Foundation & Infrastructure**
- **GitHub ID:** #1
- **Timeline:** Juli - September 2025 (12 weken)
- **Deadline:** 15 september 2025
- **Issues:** 20 open
- **Effort:** 25 developer dagen
- **Description:** Development environment, TypeDB integration, Socket.io foundation

**Stories:**
- S1.1: Nx Monorepo Setup (8 dagen - was 5)
- S1.2: TypeDB Integration (12 dagen - was 8)
- S1.3: Socket.io Integration (5 dagen - was 3)

---

### 🔐 **Milestone 2: Authentication & User Management**
- **GitHub ID:** #3  
- **Timeline:** Oktober - December 2025 (12 weken)
- **Deadline:** 15 december 2025
- **Issues:** 7 open
- **Effort:** 30 developer dagen
- **Description:** User registration, JWT authentication, basic profiles

**Stories:**
- S2.1: User Registration (10 dagen - was 5)
- S2.2: JWT Authentication (12 dagen - was 6)
- S2.3: Basic User Management (8 dagen - was 7)

**⚠️ Scope change:** Teams functionality → V0.8

---

### 🗃️ **Milestone 3: Knowledge Base Core**
- **GitHub ID:** #4
- **Timeline:** Januari - Maart 2026 (12 weken)
- **Deadline:** 15 maart 2026
- **Issues:** 0 (nog aan te maken)
- **Effort:** 35 developer dagen
- **Description:** Schema system, knowledge base creation and management

**Stories:**
- S3.1: Schema Definition System (15 dagen - was 6)
- S3.2: Knowledge Base Creation (12 dagen - was 5)
- S3.3: Basic Schema Application (8 dagen - was 5)

---

### 📝 **Milestone 4: Basic Wiki**
- **GitHub ID:** #5
- **Timeline:** April - Juni 2026 (12 weken)  
- **Deadline:** 15 juni 2026
- **Issues:** 0 (nog aan te maken)
- **Effort:** 40 developer dagen
- **Description:** Simple wiki interface with basic text editing and wiki-links

**Stories:**
- S4.1: Basic Text Editor (15 dagen - simplified from Lexical)
- S4.2: Wiki Page CRUD (12 dagen - was 5)
- S4.3: Simple Wiki-Links (13 dagen - was 4)

**⚠️ Scope change:** Lexical rich editor → Basic textarea + formatting

---

### 📊 **Milestone 5: Basic Graph**
- **GitHub ID:** #6
- **Timeline:** Juli - September 2026 (12 weken)
- **Deadline:** 15 september 2026
- **Issues:** 0 (nog aan te maken)
- **Effort:** 45 developer dagen  
- **Description:** Graph visualization and one-way wiki-to-graph synchronization

**Stories:**
- S5.1: React Flow Setup (15 dagen - was 7)
- S5.2: Basic Graph Display (15 dagen - was 6)
- S5.3: Simple Wiki-Graph Sync (15 dagen - was 5)

---

## 📈 **TIMELINE COMPARISON**

| Aspect | Original | Revised | Change |
|--------|----------|---------|--------|
| **Duration** | 6 maanden | 15 maanden | +150% |
| **End Date** | Dec 2025 | Sep 2026 | +9 maanden |
| **Total Effort** | 168 dev-dagen | 175 dev-dagen | +7 dagen |
| **Weekly Capacity** | 15 dev-dagen | 6 dev-dagen | -60% |
| **Team Availability** | 5 dagen/week | 2 dagen/week | -60% |

## 🚨 **SCOPE REDUCTIONS voor V0.7**

### ❌ **Removed from V0.7 (moved to V0.8):**
- Team management and collaboration
- Real-time multi-user editing
- Document upload and processing
- Advanced graph editing and manipulation
- To-do list generation
- Media embedding in wiki
- Lexical rich text editor
- Performance optimization
- Security hardening
- Advanced authentication features

### ✅ **Retained in V0.7 (Core MVP):**
- Basic development environment
- TypeDB integration with basic CRUD
- Individual user authentication (no teams)
- Basic schema management
- Simple wiki pages with text editing
- Basic graph display (read-only initially)
- One-way synchronization: wiki → graph

## 💰 **BUDGET IMPACT**

**Development Cost Impact:**
- **Original estimate:** 6 maanden × 3 developers = 18 dev-maanden
- **Revised estimate:** 15 maanden × 3 developers × 0.4 FTE = 18 dev-maanden
- **Total budget:** Ongewijzigd in dev-maanden, maar spread over langere periode

**Timeline Impact:**
- **Go-to-market:** Vertraagd met 9 maanden
- **MVP validation:** Uitgesteld naar Q3 2026
- **Revenue start:** Vertraagd naar Q4 2026

## 🎯 **AANBEVELINGEN**

### **Optie A: Accepteer nieuwe timeline** ⭐ **AANBEVOLEN**
- **Voor:** Realistische planning, duurzame ontwikkeling
- **Tegen:** Late marktintroductie, competitieve risico's
- **Impact:** MVP September 2026

### **Optie B: Verhoog team capacity**
- **Voor:** Behoud oorspronkelijke timeline  
- **Tegen:** Hogere kosten, recruitment/training tijd
- **Opties:** 4-5 dagen/week, extra developer, outsourcing

### **Optie C: Verdere scope reductie**
- **Voor:** Snellere MVP (milestone 1-3 alleen)
- **Tegen:** Minder waardevolle MVP, beperkte marktappeal
- **Focus:** Pure TypeDB + basic authentication

## 📋 **VOLGENDE STAPPEN**

### **Immediate (Week 1-2):**
1. **Stakeholder meeting:** Nieuwe timeline presenteren en goedkeuring krijgen
2. **Team alignment:** Bespreken impact op development proces
3. **Sprint herplanning:** 2-dag/week sprint cycles definiëren

### **Short-term (Week 3-4):**
1. **Issue creation:** Nieuwe stories maken voor milestone 3-5
2. **Resource planning:** Developer allocation per milestone finaliseren  
3. **Risk assessment:** Nieuwe risico's identificeren en mitigeren

### **Medium-term (Maand 2-3):**
1. **Development start:** Begin met Milestone 1 stories
2. **Progress tracking:** Wekelijkse voortgang monitoring
3. **Scope validation:** Bevestig MVP scope tijdens ontwikkeling

## 🔄 **SUCCESS METRICS (Adjusted)**

### **Development Velocity:**
- **Target:** 6 developer-dagen/week sustained
- **Buffer:** 10% voor ziekte/vakantie = 5.4 effectieve dagen/week
- **Milestone completion:** On-time delivery binnen 12-week windows

### **Quality Gates:**
- **Code coverage:** >80% voor elke milestone
- **Performance:** Basic requirements voor MVP scale
- **Security:** Basis security requirements voor gebruikersdata

### **Business Validation:**
- **User acceptance:** Positive feedback op elke milestone demo
- **Technical validation:** Architecture schaalt naar V0.8 features  
- **Market readiness:** MVP validatie Q3 2026

---

**📌 Status:** Planning goedgekeurd en geïmplementeerd in GitHub  
**📅 Next review:** Eind Milestone 1 (September 2025)  
**👥 Stakeholders:** Development team, product owner, business stakeholders 