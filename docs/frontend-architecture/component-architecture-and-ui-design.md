# Component Architecture and UI Design

The component architecture follows the visual design specifications from the Kennisbaas Visual Design document, implementing a clean, minimal interface centered around the split-view paradigm with integrated sidebar navigation.

## Core Layout Components

### AppShell Component
**Responsibility:** Root layout container managing the overall application structure
- Top navigation bar with breadcrumbs and user controls
- Left sidebar with collapsible navigation panels
- Main content area with split-view or full-view modes
- Toast notifications and modal overlays

### NavigationSidebar Component
**Responsibility:** Left sidebar navigation following the visual design specifications
- **Knowledge Base Selector:** Dropdown/list for switching between accessible knowledge bases
- **Navigation Tabs:** Concept overview, Relationship browser, AI suggestions, To-do items
- **Concept Tree View:** Hierarchical display of concepts with expand/collapse functionality
- **Search Integration:** Unified search across concepts and relationships
- **User Presence:** Real-time indicators showing other active users

### SplitViewContainer Component
**Responsibility:** Main content area implementing the core split-view interface
- **Flexible Layout:** Adjustable split between wiki editor and graph editor
- **View Mode Controls:** Toggle between split-view, wiki-only, or graph-only modes
- **Responsive Breakpoints:** Adapts to different screen sizes and orientations
- **State Persistence:** Remembers user's preferred split ratios and view modes

## Primary Interface Components

### WikiEditorPane Component
**Responsibility:** Wiki editing area with integrated property controls
- **Lexical Editor Integration:** Full-featured rich text editing with custom plugins
- **Entity Link Detection:** Real-time parsing of [[Entity Name]] syntax
- **Auto-suggestions:** Dropdown suggestions for entity names as user types
- **Formatting Toolbar:** Clean toolbar matching the visual design aesthetic
- **Integrated Property Panel:** Contextual editing panel visually integrated into the wiki pane
- **Auto-save Indicators:** Visual feedback for save status and conflicts
- **Collaborative Cursors:** Show other users' editing positions in real-time

### GraphEditor Component (React Flow Integration)
**Responsibility:** Full graph editing environment with complete manipulation capabilities
- **Complete Node Editing:** Create, delete, edit, and style concept nodes
- **Relationship Management:** Create, modify, and delete relationships between concepts
- **Node Type Selection:** Choose concept types and apply appropriate styling
- **Bulk Operations:** Multi-select for bulk editing and operations
- **Layout Controls:** Auto-layout algorithms and manual positioning tools
- **Schema Validation:** Real-time validation against knowledge base schema
- **Import/Export:** Graph data import and export capabilities
- **Undo/Redo:** Complete edit history with granular undo/redo

## Specialized UI Components

### React Flow Custom Components

**ConceptNode Component (React Flow Custom Node)**
**Responsibility:** Custom React Flow node for concept visualization and inline editing
- **Inline Editing:** Direct text editing within the node
- **Type Indicators:** Visual styling based on concept type
- **Completeness Status:** Visual indicators for incomplete concepts
- **Connection Handles:** Properly positioned handles for relationship creation
- **Context Menu Integration:** Right-click actions specific to concept nodes

**RelationshipEdge Component (React Flow Custom Edge)**
**Responsibility:** Custom React Flow edge for relationship visualization
- **Directional Labels:** Display forward/backward labels using ➤ format
- **Inline Label Editing:** Direct editing of relationship labels
- **Visual Styling:** Appropriate styling based on relationship type
- **Selection States:** Visual feedback for selected relationships
- **Hover Information:** Tooltip details on hover

### Integrated Property Components

**ConceptPropertyPanel Component**
**Responsibility:** Property editing integrated into WikiEditorPane
- **Seamless Integration:** Visually part of the wiki editing area
- **Context Switching:** Automatically shows properties for selected concept
- **Schema-based Forms:** Dynamic forms based on concept type schema
- **Validation Feedback:** Real-time validation with clear error messages
- **Field Suggestions:** AI-powered suggestions for property values

**RelationshipPropertyPanel Component**
**Responsibility:** Relationship editing integrated into WikiEditorPane
- **Relationship Details:** Edit relationship type and directional labels
- **Property Management:** Schema-based property editing for relationships
- **Connection Validation:** Ensure valid connections between concept types
- **Bulk Relationship Editing:** Edit multiple relationships simultaneously

## Design System Implementation

### Color Scheme (Based on Visual Design)
- **Primary Colors:** Clean whites and soft grays for main interface
- **Accent Colors:** Subtle blues and greens for interactive elements
- **Status Colors:** Semantic colors for validation, errors, and success states
- **Graph Colors:** Distinct color palette for different concept types
- **Single Mode:** Light mode only, no dark theme support

### Typography Hierarchy
- **Interface Text:** Clean sans-serif fonts (system fonts) for UI elements
- **Content Text:** Serif fonts for user-generated wiki content
- **Incomplete Concepts:** Comic Sans-like font for concepts that aren't finished yet
- **Code Elements:** Monospace fonts for technical content and IDs
- **Headings:** Clear hierarchy with appropriate font weights and sizes

### Component Spacing and Layout
- **Grid System:** 8px base grid for consistent spacing throughout
- **Component Padding:** Consistent internal spacing for all components
- **Margin Consistency:** Standardized margins between component groups
- **Responsive Breakpoints:** Desktop-first approach with minimum 1400×900 resolution

## Interaction Patterns

### Graph Editor Interactions
- **Node Creation:** Click empty space or use toolbar to create new concepts
- **Relationship Creation:** Drag from node handle to another node
- **Multi-selection:** Rubber band selection and Ctrl/Cmd+click for multiple items
- **Direct Editing:** Double-click nodes/edges for inline editing
- **Canvas Navigation:** Pan and zoom with mouse/trackpad
- **Grid Snapping:** Optional grid snapping for precise positioning

### Integrated Property Editing
- **Context-aware Display:** Property panel shows based on current selection
- **Seamless Transitions:** Smooth transitions between different property contexts
- **Form Validation:** Real-time validation with immediate feedback
- **Auto-completion:** Intelligent suggestions for property values

### Real-time Collaboration UI
- **User Avatars:** Small avatar indicators showing who is editing what
- **Cursor Sharing:** Collaborative cursor positions in wiki editor
- **Graph Presence:** Show other users' selections in graph editor
- **Conflict Indicators:** Visual warnings when multiple users edit same content

## Accessibility Considerations

### Keyboard Navigation
- **Tab Order:** Logical tab order through all interactive elements
- **Focus Indicators:** Clear visual focus states for keyboard users
- **Shortcut Keys:** Consistent keyboard shortcuts for common actions
- **Graph Navigation:** Keyboard navigation within React Flow graph editor

### Visual Accessibility
- **Color Contrast:** WCAG AA compliance for all text and interactive elements
- **Font Scaling:** Support for browser zoom and system font size settings
- **Motion Reduction:** Respect for user's reduced motion preferences
- **High Contrast Mode:** Enhanced contrast options for low-vision users

## Component Composition Example

```
AppShell
├── NavigationSidebar
│   ├── KnowledgeBaseSelector
│   ├── ConceptTreeView
│   ├── SearchInterface
│   └── UserPresenceList
├── SplitViewContainer
│   ├── WikiEditorPane
│   │   ├── LexicalEditor
│   │   ├── FormattingToolbar
│   │   ├── EntityLinkSuggestion
│   │   ├── ConceptPropertyPanel (integrated)
│   │   ├── RelationshipPropertyPanel (integrated)
│   │   └── CollaborativeCursors
│   └── GraphEditor (React Flow)
│       ├── ConceptNode (custom React Flow node)
│       ├── RelationshipEdge (custom React Flow edge)
│       ├── GraphToolbar
│       └── GraphControls
└── ModalOverlays
    ├── SettingsModal
    └── HelpModal
```

This component architecture ensures proper integration with React Flow's custom node/edge system while maintaining clean separation between the wiki editing environment and the full graph editing capabilities.
