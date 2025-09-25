# K-BAAS-2 Frontend Implementation Tips

This document contains detailed implementation examples and code patterns for the K-BAAS-2 frontend architecture. These examples demonstrate how to implement the patterns described in the frontend architecture document.

## Jotai Atom Implementation Examples

### Core Application State Examples

**Authentication Atoms:**
```javascript
// User session and authentication state
const userAtom = atom(null)
const authTokenAtom = atom(null)
const isAuthenticatedAtom = atom((get) => !!get(authTokenAtom))
```

**Knowledge Base Atoms:**
```javascript
// Active knowledge base and metadata
const activeKnowledgeBaseAtom = atom(null)
const knowledgeBasesAtom = atom([])
const kbPermissionsAtom = atom({})
```

**Concept State Atoms:**
```javascript
// Concept data and selections
const conceptsAtom = atom([])
const selectedConceptAtom = atom(null)
const conceptEditModeAtom = atom(false)
const conceptFormDataAtom = atom({})
```

**Relationship State Atoms:**
```javascript
// Relationship data and graph connections
const relationshipsAtom = atom([])
const selectedRelationshipAtom = atom(null)
const relationshipEditModeAtom = atom(false)
```

### UI State Implementation

**Layout and View State:**
```javascript
// Split-view interface controls
const splitViewRatioAtom = atom(0.5) // 50/50 split default
const focusedPaneAtom = atom('both') // 'wiki', 'graph', 'both'
const sidebarOpenAtom = atom(true)
const activeTabAtom = atom('concepts')
```

**Graph Visualization State:**
```javascript
// React Flow specific state
const graphNodesAtom = atom([])
const graphEdgesAtom = atom([])
const graphViewportAtom = atom({ x: 0, y: 0, zoom: 1 })
const graphSelectionAtom = atom([])
const gridSnapEnabledAtom = atom(true)
```

**Wiki Editor State:**
```javascript
// Lexical editor state
const editorStateAtom = atom(null)
const activeConceptContentAtom = atom('')
const extractedLinksAtom = atom([])
const editorFocusedAtom = atom(false)
```

## Data Flow Implementation Patterns

### Wiki-to-Graph Synchronization Implementation

**Entity Extraction Flow:**
```javascript
// Derived atom for entity extraction
const extractedEntitiesAtom = atom(async (get) => {
  const content = get(activeConceptContentAtom)
  const kbId = get(activeKnowledgeBaseAtom)?.kb_id

  if (!content || !kbId) return []

  // Extract [[Entity Name]] patterns
  const links = extractWikiLinks(content)

  // Resolve entities via API
  return await resolveEntities(kbId, links)
})

// Effect to update graph when entities change
const syncGraphWithEntitiesAtom = atom(
  null,
  (get, set, entities) => {
    const currentNodes = get(graphNodesAtom)
    const newNodes = entities.map(entity => ({
      id: entity.concept_id,
      type: 'concept',
      data: entity,
      position: calculatePosition(entity)
    }))

    set(graphNodesAtom, [...currentNodes, ...newNodes])
  }
)
```

### Real-time Collaboration Flow Implementation

**Optimistic Update Pattern:**
```javascript
// Optimistic update atom
const optimisticUpdateAtom = atom(
  null,
  (get, set, { type, data, optimistic = true }) => {
    // Apply optimistic update immediately
    if (optimistic) {
      applyLocalUpdate(get, set, type, data)
    }

    // Queue for real-time broadcast
    queueSocketUpdate({ type, data, timestamp: Date.now() })
  }
)

// Socket event handler for remote updates
const handleRemoteUpdateAtom = atom(
  null,
  (get, set, remoteUpdate) => {
    const { type, data, userId, timestamp } = remoteUpdate

    // Skip if this update originated from current user
    if (userId === get(userAtom)?.user_id) return

    // Apply remote update with conflict resolution
    applyRemoteUpdate(get, set, type, data, timestamp)
  }
)
```

## Data Persistence Implementation

### Local State Persistence

**Auto-save Implementation:**
```javascript
// Debounced auto-save for concept content
const autoSaveAtom = atom(
  null,
  async (get, set, conceptId) => {
    const content = get(activeConceptContentAtom)
    const kbId = get(activeKnowledgeBaseAtom)?.kb_id

    try {
      await fetch(`/api/v1/kb/${kbId}/concepts/${conceptId}`, {
        method: 'PUT',
        body: JSON.stringify({ description: content }),
        headers: { 'Content-Type': 'application/json' }
      })

      // Update success state
      set(lastSavedAtom, Date.now())
    } catch (error) {
      // Handle save error
      set(saveErrorAtom, error.message)
    }
  }
)
```

### Fetch-based Data Loading Implementation

**Knowledge Base Loading:**
```javascript
// Knowledge base loading atom
const loadKnowledgeBaseAtom = atom(
  null,
  async (get, set, kbId) => {
    set(loadingStateAtom, { type: 'kb', loading: true })

    try {
      const [kb, concepts, relationships] = await Promise.all([
        fetch(`/api/v1/knowledge-bases/${kbId}`).then(r => r.json()),
        fetch(`/api/v1/kb/${kbId}/concepts`).then(r => r.json()),
        fetch(`/api/v1/kb/${kbId}/relationships`).then(r => r.json())
      ])

      set(activeKnowledgeBaseAtom, kb)
      set(conceptsAtom, concepts.items)
      set(relationshipsAtom, relationships)

      // Transform data for graph visualization
      const nodes = concepts.items.map(conceptToNode)
      const edges = relationships.map(relationshipToEdge)

      set(graphNodesAtom, nodes)
      set(graphEdgesAtom, edges)

    } catch (error) {
      set(errorStateAtom, error.message)
    } finally {
      set(loadingStateAtom, { type: 'kb', loading: false })
    }
  }
)
```

## Performance Optimization Implementation

### State Cleanup Implementation

**Knowledge Base Cleanup:**
```javascript
// Cleanup atom for unmounting knowledge bases
const cleanupKnowledgeBaseAtom = atom(
  null,
  (get, set) => {
    set(activeKnowledgeBaseAtom, null)
    set(conceptsAtom, [])
    set(relationshipsAtom, [])
    set(graphNodesAtom, [])
    set(graphEdgesAtom, [])
    set(selectedConceptAtom, null)
    set(editorStateAtom, null)
  }
)
```

### Component Optimization Examples

**Memoized Graph Component:**
```javascript
const GraphVisualization = React.memo(({ nodes, edges, onNodeClick }) => {
  const [reactFlowInstance, setReactFlowInstance] = useState(null)

  const onNodesChange = useCallback((changes) => {
    // Handle node changes with debouncing
    debouncedNodeUpdate(changes)
  }, [])

  return (
    <ReactFlow
      nodes={nodes}
      edges={edges}
      onNodesChange={onNodesChange}
      onNodeClick={onNodeClick}
      fitView
    />
  )
})
```

**Selective Atom Subscriptions:**
```javascript
const ConceptEditor = () => {
  // Subscribe only to specific atoms needed
  const selectedConcept = useAtomValue(selectedConceptAtom)
  const editMode = useAtomValue(conceptEditModeAtom)
  const setContent = useSetAtom(activeConceptContentAtom)

  // Don't subscribe to entire concepts list
  // Only what this component needs

  return (
    <div>
      {editMode && selectedConcept && (
        <LexicalEditor
          initialContent={selectedConcept.description}
          onChange={setContent}
        />
      )}
    </div>
  )
}
```

## Socket.io Integration Examples

### Real-time Event Handling

**Socket Connection Management:**
```javascript
const socketAtom = atom(null)

const connectSocketAtom = atom(
  null,
  (get, set, kbId) => {
    const socket = io('/socket.io', {
      auth: {
        token: get(authTokenAtom)
      }
    })

    socket.emit('join_knowledge_base', { kb_id: kbId })

    socket.on('concept_updated', (data) => {
      set(handleRemoteUpdateAtom, {
        type: 'concept_updated',
        data,
        userId: data.updated_by,
        timestamp: data.updated_at
      })
    })

    socket.on('relationship_updated', (data) => {
      set(handleRemoteUpdateAtom, {
        type: 'relationship_updated',
        data,
        userId: data.updated_by,
        timestamp: data.updated_at
      })
    })

    set(socketAtom, socket)
  }
)
```

### Conflict Resolution Implementation

**Last-Writer-Wins with Timestamps:**
```javascript
const applyRemoteUpdate = (get, set, type, data, timestamp) => {
  if (type === 'concept_updated') {
    const concepts = get(conceptsAtom)
    const existingIndex = concepts.findIndex(c => c.concept_id === data.concept_id)

    if (existingIndex >= 0) {
      const existing = concepts[existingIndex]

      // Check if remote update is newer
      if (new Date(timestamp) > new Date(existing.updated_at)) {
        const updatedConcepts = [...concepts]
        updatedConcepts[existingIndex] = data
        set(conceptsAtom, updatedConcepts)

        // Update graph if this concept is visualized
        updateGraphNode(get, set, data)
      }
    }
  }
}
```

These implementation examples provide concrete patterns for building the K-BAAS-2 frontend according to the architectural specifications.