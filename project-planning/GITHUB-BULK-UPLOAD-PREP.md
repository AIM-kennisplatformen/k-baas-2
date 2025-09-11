# 🚀 GitHub Bulk Upload Preparation - Epic 3-5

**Datum:** 1 juli 2025  
**Doel:** Structured data voor GitHub API bulk upload  
**Target:** Epics 3, 4, 5 → GitHub Milestones & Issues

## 📋 Missing Milestones to Create

### Milestone 6: Knowledge Base Core (Epic 3)
```json
{
  "title": "Milestone 3: Knowledge Base Core", 
  "description": "Schema definition system, knowledge base creation and management. 16 developer days across 4 weeks (Weeks 9-12).",
  "due_on": "2025-10-15T00:00:00Z",
  "state": "open"
}
```

### Milestone 7: Wiki Content Management (Epic 4)  
```json
{
  "title": "Milestone 4: Wiki Content Management",
  "description": "Rich text editing, media embedding, wiki-links with entity creation. 15 developer days across 4 weeks (Weeks 13-16).", 
  "due_on": "2025-11-15T00:00:00Z",
  "state": "open"
}
```

### Milestone 8: Graph Visualization (Epic 5)
```json
{
  "title": "Milestone 5: Graph Visualization & Editing",
  "description": "Interactive graph with React Flow, direct manipulation, property editing. 18 developer days across 4 weeks (Weeks 17-20).",
  "due_on": "2025-12-15T00:00:00Z", 
  "state": "open"
}
```

## 📝 Epic Labels to Create

```bash
# Epic 3 Label
curl -X POST -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/HAN-AIM-CMD-WG/k-baas-2/labels" \
  -d '{"name":"epic:E3-schema","color":"8e44ad","description":"Epic 3: Knowledge Base Schema"}'

# Epic 4 Label  
curl -X POST -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/HAN-AIM-CMD-WG/k-baas-2/labels" \
  -d '{"name":"epic:E4-wiki","color":"e67e22","description":"Epic 4: Wiki Content Management"}'

# Epic 5 Label
curl -X POST -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/HAN-AIM-CMD-WG/k-baas-2/labels" \
  -d '{"name":"epic:E5-graph","color":"2ecc71","description":"Epic 5: Graph Visualization"}'
```

## 🎯 Story Issues to Create

### Epic 3: Knowledge Base Schema (3 Stories)

#### Story 3.1: Pydantic Schema Definition System
```json
{
  "title": "[STORY] S3.1: Pydantic Schema Definition System",
  "body": "## 🎯 User Story\nAs a system architect\nI want a robust Pydantic-based schema definition system\nSo that I can create structured knowledge bases with TypeDB integration\n\n## 🎯 Epic Context\n**Epic:** E3 - Knowledge Base Creation & Schema Management\n**Priority:** High (foundational for all KB functionality)\n**Dependencies:** Epic 1 (TypeDB), Epic 2 (Authentication)\n\n## ✅ Acceptance Criteria\n- [ ] Pydantic models define entity types and properties\n- [ ] Schema validation works for all entity types\n- [ ] TypeDB schema generation from Pydantic models\n- [ ] Schema versioning and migration system\n- [ ] Property type definitions (string, int, date, etc.)\n- [ ] Relationship type definitions between entities\n- [ ] Schema validation API endpoints\n- [ ] Error handling for invalid schemas\n\n## 🔧 Implementation Tasks\n- [ ] Task 3.1.1: Core Pydantic schema models\n- [ ] Task 3.1.2: TypeDB schema generation pipeline\n- [ ] Task 3.1.3: Schema validation system\n- [ ] Task 3.1.4: Schema versioning framework\n- [ ] Task 3.1.5: API endpoints for schema operations\n- [ ] Task 3.1.6: Testing and documentation\n\n## 📊 Technical Details\n**Effort:** 6 developer days\n**Team:** Developer 1 (Backend lead) + Developer 3 (Integration)\n**Components:** Schema definition, TypeDB integration, validation\n**Testing:** Unit tests, integration tests, performance tests\n\n## 🔗 Related Issues\n**Blocks:** S3.2, S3.3, S4.1, S5.1\n**Dependencies:** Foundation Epic 1 completion",
  "labels": ["epic:E3-schema", "type:story", "priority:P1-high", "size:L", "team:backend", "version:v0.7"],
  "milestone": 6
}
```

#### Story 3.2: Knowledge Base Creation with Schema Selection
```json
{
  "title": "[STORY] S3.2: Knowledge Base Creation with Schema Selection", 
  "body": "## 🎯 User Story\nAs a domain expert\nI want to create a knowledge base by selecting a predefined schema\nSo that I can organize knowledge with proper structure from the start\n\n## 🎯 Epic Context\n**Epic:** E3 - Knowledge Base Creation & Schema Management\n**Priority:** High (core user functionality)\n**Dependencies:** S3.1 (Schema Definition System)\n\n## ✅ Acceptance Criteria\n- [ ] Knowledge base creation wizard functional\n- [ ] Schema selection with preview and description\n- [ ] KB initialization with selected schema\n- [ ] Team-based access control integration\n- [ ] KB metadata management (name, description, owner)\n- [ ] Schema application creates TypeDB structure\n- [ ] Error handling for creation failures\n- [ ] Success confirmation and navigation\n\n## 🔧 Implementation Tasks\n- [ ] Task 3.2.1: KB creation UI components\n- [ ] Task 3.2.2: Schema selection interface\n- [ ] Task 3.2.3: KB creation API endpoints\n- [ ] Task 3.2.4: Team access control integration\n- [ ] Task 3.2.5: TypeDB initialization\n- [ ] Task 3.2.6: Testing and validation\n\n## 📊 Technical Details\n**Effort:** 5 developer days\n**Team:** Developer 2 (Frontend lead) + Developer 3 (Backend integration)\n**Components:** KB creation UI, schema selection, access control\n**Testing:** UI tests, integration tests, access control tests",
  "labels": ["epic:E3-schema", "type:story", "priority:P1-high", "size:M", "team:fullstack", "version:v0.7"],
  "milestone": 6
}
```

#### Story 3.3: Schema Application & TypeDB Integration
```json
{
  "title": "[STORY] S3.3: Schema Application & TypeDB Integration",
  "body": "## 🎯 User Story\nAs a system\nI want to apply schemas to TypeDB databases automatically\nSo that knowledge bases have proper structure and validation\n\n## 🎯 Epic Context\n**Epic:** E3 - Knowledge Base Creation & Schema Management\n**Priority:** High (technical foundation)\n**Dependencies:** S3.1 (Schema System), S3.2 (KB Creation)\n\n## ✅ Acceptance Criteria\n- [ ] Schema application to TypeDB databases\n- [ ] Entity and relationship type creation\n- [ ] Property validation enforcement\n- [ ] Schema migration support\n- [ ] Database health checking\n- [ ] Transaction integrity maintained\n- [ ] Performance optimization for large schemas\n- [ ] Error recovery and rollback mechanisms\n\n## 🔧 Implementation Tasks\n- [ ] Task 3.3.1: TypeDB schema application engine\n- [ ] Task 3.3.2: Entity/relationship type creation\n- [ ] Task 3.3.3: Property validation integration\n- [ ] Task 3.3.4: Migration and versioning\n- [ ] Task 3.3.5: Performance optimization\n- [ ] Task 3.3.6: Error handling and recovery\n\n## 📊 Technical Details\n**Effort:** 5 developer days\n**Team:** Developer 1 (Backend lead) + Developer 3 (Testing)\n**Components:** TypeDB integration, schema application, validation\n**Testing:** Integration tests, performance tests, migration tests",
  "labels": ["epic:E3-schema", "type:story", "priority:P1-high", "size:M", "team:backend", "version:v0.7"],
  "milestone": 6
}
```

### Epic 4: Wiki Content Management (3 Stories)

#### Story 4.1: Rich Text Editor with Lexical
```json
{
  "title": "[STORY] S4.1: Rich Text Editor with Lexical",
  "body": "## 🎯 User Story\nAs a content creator\nI want a modern rich text editor for wiki pages\nSo that I can create well-formatted knowledge documentation\n\n## 🎯 Epic Context\n**Epic:** E4 - Wiki Content Management\n**Priority:** High (core content creation)\n**Dependencies:** Epic 3 (Knowledge Base Context)\n\n## ✅ Acceptance Criteria\n- [ ] Lexical editor integrated and functional\n- [ ] Rich text formatting (bold, italic, headers, lists)\n- [ ] Real-time autosave functionality\n- [ ] Cross-browser compatibility verified\n- [ ] Keyboard shortcuts working\n- [ ] Undo/redo functionality\n- [ ] Content persistence across sessions\n- [ ] Performance acceptable with large documents\n\n## 🔧 Implementation Tasks\n- [ ] Task 4.1.1: Lexical editor setup and configuration\n- [ ] Task 4.1.2: Rich text formatting plugins\n- [ ] Task 4.1.3: Autosave system implementation\n- [ ] Task 4.1.4: Cross-browser testing and fixes\n- [ ] Task 4.1.5: Performance optimization\n- [ ] Task 4.1.6: Content persistence system\n\n## 📊 Technical Details\n**Effort:** 6 developer days\n**Team:** Developer 2 (Frontend lead) + Developer 3 (Integration)\n**Components:** Lexical editor, autosave, content management\n**Testing:** Browser compatibility, performance, content persistence",
  "labels": ["epic:E4-wiki", "type:story", "priority:P1-high", "size:L", "team:frontend", "version:v0.7"],
  "milestone": 7
}
```

#### Story 4.2: Media Embedding & Upload System
```json
{
  "title": "[STORY] S4.2: Media Embedding & Upload System",
  "body": "## 🎯 User Story\nAs a content creator\nI want to embed images and videos in wiki pages\nSo that I can create rich, multimedia knowledge documentation\n\n## 🎯 Epic Context\n**Epic:** E4 - Wiki Content Management\n**Priority:** High (rich content support)\n**Dependencies:** S4.1 (Rich Text Editor)\n\n## ✅ Acceptance Criteria\n- [ ] Image upload and embedding functional\n- [ ] Video embedding from URLs\n- [ ] File type validation and security\n- [ ] Image resizing and optimization\n- [ ] Media management interface\n- [ ] Drag-and-drop upload support\n- [ ] Progress indicators for uploads\n- [ ] Error handling for failed uploads\n\n## 🔧 Implementation Tasks\n- [ ] Task 4.2.1: Media upload API endpoints\n- [ ] Task 4.2.2: Image embedding in Lexical\n- [ ] Task 4.2.3: Video embedding support\n- [ ] Task 4.2.4: File validation and security\n- [ ] Task 4.2.5: Media management UI\n- [ ] Task 4.2.6: Upload progress and error handling\n\n## 📊 Technical Details\n**Effort:** 5 developer days\n**Team:** Developer 2 (Frontend) + Developer 1 (Backend) + Developer 3 (Integration)\n**Components:** Media upload, embedding, validation\n**Testing:** Upload functionality, security validation, performance",
  "labels": ["epic:E4-wiki", "type:story", "priority:P1-high", "size:M", "team:fullstack", "version:v0.7"],
  "milestone": 7
}
```

#### Story 4.3: Wiki-Links with Entity Creation
```json
{
  "title": "[STORY] S4.3: Wiki-Links with Entity Creation",
  "body": "## 🎯 User Story\nAs a content creator\nI want wiki-link syntax to automatically create entities in the knowledge graph\nSo that my documentation naturally builds the knowledge structure\n\n## 🎯 Epic Context\n**Epic:** E4 - Wiki Content Management\n**Priority:** High (wiki-graph integration)\n**Dependencies:** S4.1 (Editor), Epic 3 (Schema System)\n\n## ✅ Acceptance Criteria\n- [ ] Wiki-link syntax parsing ([[Entity Name]])\n- [ ] Automatic entity creation in knowledge graph\n- [ ] Link validation and preview\n- [ ] Entity type inference from context\n- [ ] Broken link detection and handling\n- [ ] Link autocomplete functionality\n- [ ] Visual indicators for link states\n- [ ] Integration with schema validation\n\n## 🔧 Implementation Tasks\n- [ ] Task 4.3.1: Wiki-link parser implementation\n- [ ] Task 4.3.2: Entity creation integration\n- [ ] Task 4.3.3: Link validation system\n- [ ] Task 4.3.4: Autocomplete functionality\n- [ ] Task 4.3.5: Visual link indicators\n- [ ] Task 4.3.6: Schema integration testing\n\n## 📊 Technical Details\n**Effort:** 4 developer days\n**Team:** Developer 3 (Full-stack lead) + Developer 1 (Backend support)\n**Components:** Link parsing, entity creation, validation\n**Testing:** Link parsing, entity creation, schema integration",
  "labels": ["epic:E4-wiki", "type:story", "priority:P1-high", "size:S", "team:fullstack", "version:v0.7"],
  "milestone": 7
}
```

### Epic 5: Graph Visualization (3 Stories)

#### Story 5.1: Interactive Graph Visualization with React Flow
```json
{
  "title": "[STORY] S5.1: Interactive Graph Visualization with React Flow",
  "body": "## 🎯 User Story\nAs a knowledge explorer\nI want an interactive graph visualization of my knowledge base\nSo that I can understand relationships and navigate knowledge visually\n\n## 🎯 Epic Context\n**Epic:** E5 - Knowledge Graph Visualization & Editing\n**Priority:** High (core differentiation feature)\n**Dependencies:** Epic 3 (Schema), Epic 4 (Wiki Content)\n\n## ✅ Acceptance Criteria\n- [ ] React Flow integration working smoothly\n- [ ] Graph nodes represent entities correctly\n- [ ] Graph edges show relationships accurately\n- [ ] Zoom and pan functionality\n- [ ] Node selection and highlighting\n- [ ] Performance acceptable with 500+ nodes\n- [ ] Custom node types for different entities\n- [ ] Graph layout algorithms functional\n\n## 🔧 Implementation Tasks\n- [ ] Task 5.1.1: React Flow setup and configuration\n- [ ] Task 5.1.2: Custom node and edge components\n- [ ] Task 5.1.3: Graph data transformation pipeline\n- [ ] Task 5.1.4: Layout algorithms integration\n- [ ] Task 5.1.5: Performance optimization\n- [ ] Task 5.1.6: Cross-browser testing\n\n## 📊 Technical Details\n**Effort:** 7 developer days\n**Team:** Developer 2 (Frontend lead) + Developer 3 (Integration)\n**Components:** React Flow, graph rendering, performance\n**Testing:** Performance benchmarks, browser compatibility",
  "labels": ["epic:E5-graph", "type:story", "priority:P1-high", "size:L", "team:frontend", "version:v0.7"],
  "milestone": 8
}
```

#### Story 5.2: Direct Graph Manipulation & Entity Creation
```json
{
  "title": "[STORY] S5.2: Direct Graph Manipulation & Entity Creation",
  "body": "## 🎯 User Story\nAs a knowledge architect\nI want to create and modify entities directly in the graph view\nSo that I can intuitively build knowledge structures\n\n## 🎯 Epic Context\n**Epic:** E5 - Knowledge Graph Visualization & Editing\n**Priority:** High (direct manipulation)\n**Dependencies:** S5.1 (Graph Visualization)\n\n## ✅ Acceptance Criteria\n- [ ] Drag and drop entity creation\n- [ ] Node dragging and repositioning\n- [ ] Connection creation between entities\n- [ ] Entity deletion with confirmation\n- [ ] Grid snapping for alignment\n- [ ] Undo/redo for graph operations\n- [ ] Visual feedback during operations\n- [ ] Conflict resolution for simultaneous edits\n\n## 🔧 Implementation Tasks\n- [ ] Task 5.2.1: Drag and drop implementation\n- [ ] Task 5.2.2: Entity creation workflows\n- [ ] Task 5.2.3: Connection management\n- [ ] Task 5.2.4: Grid snapping system\n- [ ] Task 5.2.5: Undo/redo functionality\n- [ ] Task 5.2.6: Conflict resolution\n\n## 📊 Technical Details\n**Effort:** 6 developer days\n**Team:** Developer 2 (Frontend) + Developer 1 (Backend) + Developer 3 (Integration)\n**Components:** Direct manipulation, entity creation, state management\n**Testing:** Interaction testing, conflict resolution, undo/redo",
  "labels": ["epic:E5-graph", "type:story", "priority:P1-high", "size:L", "team:fullstack", "version:v0.7"],
  "milestone": 8
}
```

#### Story 5.3: Property Editing & Visual Indicators
```json
{
  "title": "[STORY] S5.3: Property Editing & Visual Indicators",
  "body": "## 🎯 User Story\nAs a knowledge editor\nI want to edit entity properties directly from the graph view\nSo that I can quickly update information without leaving the visual context\n\n## 🎯 Epic Context\n**Epic:** E5 - Knowledge Graph Visualization & Editing\n**Priority:** High (property management)\n**Dependencies:** S5.1 (Graph Visualization), S5.2 (Direct Manipulation)\n\n## ✅ Acceptance Criteria\n- [ ] Property editing side panel functional\n- [ ] Real-time property validation\n- [ ] Visual indicators for entity states\n- [ ] Property change history tracking\n- [ ] Bulk property editing support\n- [ ] Schema-based property forms\n- [ ] Error handling for invalid properties\n- [ ] Auto-save for property changes\n\n## 🔧 Implementation Tasks\n- [ ] Task 5.3.1: Property editing side panel\n- [ ] Task 5.3.2: Schema-based form generation\n- [ ] Task 5.3.3: Visual state indicators\n- [ ] Task 5.3.4: Property validation system\n- [ ] Task 5.3.5: Change tracking and history\n- [ ] Task 5.3.6: Bulk editing functionality\n\n## 📊 Technical Details\n**Effort:** 5 developer days\n**Team:** Developer 3 (Full-stack lead) + Developer 2 (Frontend)\n**Components:** Property editing, validation, visual indicators\n**Testing:** Property validation, form generation, visual consistency",
  "labels": ["epic:E5-graph", "type:story", "priority:P1-high", "size:M", "team:fullstack", "version:v0.7"],
  "milestone": 8
}
```

## 🚀 Upload Execution Plan

### Step 1: Create Missing Labels (5 minutes)
```bash
# Run label creation commands above
```

### Step 2: Create Missing Milestones (10 minutes)
```bash
# Create milestones 6, 7, 8 using milestone API
```

### Step 3: Bulk Upload Stories (30 minutes)
```bash
# Upload 9 story issues using GitHub API
# Use prepared JSON payloads above
```

### Step 4: Verify and Link (15 minutes)
```bash
# Verify all issues created correctly
# Add any missing dependencies
# Update existing Epic 1-2 issues with story parents
```

---

**Total Upload Time:** ~1 hour  
**Result:** Complete Epic 3-5 content on GitHub  
**Next:** Story-level task creation and team assignment 