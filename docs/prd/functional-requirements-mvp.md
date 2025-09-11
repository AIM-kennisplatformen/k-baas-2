# Functional Requirements (MVP)

## 1. User Authentication and Management
- V0.7 User registration and authentication system
- V1 User profile management
- V1 Team/workspace creation and management
- V3 Role-based permissions for collaborative editing

## 2. Knowledge Graph Schema Management
- V0.7 Pre-defined schema loading and visualization
- V0.7 Entity and relationship types defined by the schema
- V0.7 Property definition for entities and relationships based on schema

## 3. Wiki Content Management
- V0.7 Rich text editing with Lexical editor
- V0.7 Support for formatting (headings, lists, bold, italic, etc.)
- V0.7 Media embedding (images, videos)
- V0.7 Hyperlink support (internal and external)
- V0.7 Wiki page creation, editing, and deletion
- V0.7 Automatic saving of content changes

## 4. Knowledge Graph Visualization and Editing
- V0.7 Interactive graph visualization using React Flow
- V0.7 Entity creation through direct graph manipulation
- V0.7 Relationship creation through connecting entities
- V0.7 Entity and relationship property editing via form interface
- V? Support for extra fields on entities presented as forms in the UI
- V0.7 Zooming and panning navigation
- V1 Different detail levels at different zoom levels
- V0.7 Visual indicators for entity completeness/importance

## 5. Unidirectional Wiki-to-Graph Synchronization
- V0.7 Entity creation through wiki-links in text
- V0.7 Automatic graph updates when wiki content changes
- V0.7 No automatic wiki content updates when graph changes (one-way synchronization only): graph changes result in todo-items for checking/updating the wiki content
- V0.7 Consistent entity reference maintenance between views

## 6. AI Assistance Features
- V1 Relationship suggestion system (displayed as dotted lines)
- V1 Entity type suggestion for new entities
- V1 Summary/description generation suggestions
- V1 Explicit user approval required for all AI suggestions

## 7. Document Processing
- V0.7 Document upload functionality (PDF, DOCX, TXT, EPUB, Markdown)
- V2 knowledge extraction from text documents
- V2 Image and audio file upload for knowledge extraction
- V2 Entity and relationship extraction from documents
- V2 User review and approval interface for extracted knowledge
- V2 Source document reference maintenance

## 8. Knowledge Completeness Tracking
- V0.7 To-do list generation for incomplete entities/relationships
- V0.7 Completeness criteria based on schema definitions
- V0.7 Visual indicators for completeness status
- V1 Filtering and sorting of to-do items

## 9. Real-time Collaboration
- V1 Concurrent editing of wiki content
- V1 Concurrent editing of graph structure
- V1 User presence indicators
- V2 Change attribution to specific users
- V2 Conflict resolution mechanisms

## 10. TypeDB Integration
- V0.7 TypeDB connection and query management
- V0.7 Schema-compliant data storage and retrieval
- V2 Support for complex relationship types with properties
- V2 Efficient query patterns for graph visualization and navigation

## 11. Commenting and Discussion
- V1 Comment creation on entities and relationships
- V1 Threaded discussions
- V2 Notification system for new comments
- V1 Comment editing and deletion
- V1 @mentions to reference users in comments
