# Epic 0.5: Core Interface & Synchronization (V0.7)

**Epic Goal:** Implement the fundamental split-view interface and unidirectional synchronization that forms the core of the knowledge graph wiki experience.

## Story 0.5.1: Split-View Interface
**As a domain expert, I want a split-view interface with wiki editor and graph visualization so that I can work with both views simultaneously.**

### Acceptance Criteria:
- Interface displays wiki editor and graph visualization side by side
- Users can adjust the split ratio between wiki and graph views
- Users can focus on either view independently when needed
- Split-view layout is responsive and maintains usability

### Deliverables:
- Split-view layout component
- Resizable panel system
- Focus mode toggles
- Responsive split-view design

## Story 0.5.2: Unidirectional Wiki-to-Graph Synchronization with Todo Generation
**As a domain expert, I want wiki changes to update the graph automatically, with graph changes creating todo items for wiki updates, so that I maintain control over content consistency.**

### Acceptance Criteria:
- Wiki content changes automatically update the graph in real-time
- Graph changes do not automatically modify wiki content
- Graph modifications generate todo items for manual wiki review
- Todo items specify what wiki content needs review/updating

### Deliverables:
- Unidirectional synchronization engine
- Todo item generation system
- Wiki-graph change detection
- Manual review workflow interface

---
