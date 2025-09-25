# State Management and Data Flow

The frontend uses Jotai's atomic state management to handle complex state synchronization between the wiki editor, graph visualization, and real-time collaboration features.

## Jotai Atom Architecture

### Core Application State

**Authentication Atoms:**
- User session and authentication state
- Auth tokens and permissions
- Authentication status derived state

**Knowledge Base Atoms:**
- Active knowledge base selection and metadata
- Available knowledge bases list
- Knowledge base permissions and access control

**Concept State Atoms:**
- Concept data collection and individual concept state
- Concept selection and editing modes
- Form data for concept creation and updates

**Relationship State Atoms:**
- Relationship data and graph connections
- Relationship selection and editing modes
- Bidirectional label management

### UI State Management

**Layout and View State:**
- Split-view interface controls and ratios
- Focused pane management (wiki, graph, both)
- Sidebar and panel visibility states
- Active tab and navigation state

**Graph Visualization State:**
- React Flow nodes and edges data
- Graph viewport position and zoom level
- Graph selection and interaction state
- Grid snapping and layout preferences

**Wiki Editor State:**
- Lexical editor state and content
- Active concept content being edited
- Extracted entity links from wiki content
- Editor focus and cursor position

## Data Flow Patterns

### Wiki-to-Graph Synchronization

**Entity Extraction Flow:**
1. User types in Lexical editor with wiki content
2. Editor state changes trigger entity extraction
3. Wiki-link parser detects `[[Entity Name]]` patterns
4. Extracted links resolve to existing or new entities
5. Graph visualization updates with new/linked entities
6. Bidirectional relationship creation when appropriate

### Real-time Collaboration Flow

**Optimistic Update Pattern:**
1. User makes local change (concept edit, graph manipulation)
2. Local state updates immediately for responsive feedback
3. Change broadcasts via Socket.io to other users
4. Remote users receive and apply real-time updates
5. Conflict resolution handles concurrent editing scenarios
6. Presence indicators show other users' activities

### API Integration Strategy

**Data Loading Flow:**
- Knowledge base selection triggers data loading
- Concepts and relationships fetch in parallel
- Graph data transforms from API responses
- Loading states manage user experience during fetches
- Error states handle network and API failures

## Performance Optimizations

### Selective Re-rendering
- Components subscribe only to required atoms
- Derived atoms prevent unnecessary computations
- Memoization for expensive graph visualizations
- Virtual scrolling for large data sets

### Memory Management
- State cleanup when switching knowledge bases
- Garbage collection for unused graph nodes
- Debounced updates for performance-critical operations
- Lazy loading of detailed concept content
