# Knowledge Graph Wiki Tool Product Requirements Document (PRD).

## Goal, Objective and Context

The Knowledge Graph Wiki Tool aims to solve a critical gap in knowledge management tools for domain experts. While traditional wikis offer rich content capabilities but lack structured relationship representation, and graph databases provide powerful relationship modeling but require technical expertise, this tool will combine the strengths of both approaches in an intuitive interface.

**Primary Objective:** Create a web-based platform that enables non-technical domain experts to collaboratively build, visualize, and share interconnected knowledge through an integrated wiki and knowledge graph interface.

**Key Business Goals:**
1. Empower domain experts to create and maintain complex knowledge structures without requiring technical skills
2. Facilitate knowledge discovery through relationship visualization and AI-assisted suggestions
3. Enable real-time collaboration among teams of experts
4. Improve knowledge completeness and quality through structured tracking of information gaps

**Context:**
- Target users are domain experts with specialized knowledge but limited technical expertise
- Users work in collaborative teams where knowledge sharing is essential
- The system must use TypeDB as the backend knowledge graph database
- The interface must be intuitive, minimalistic, and beautiful
- AI assistance must enhance user capabilities without removing user agency or control

This tool will allow users to create wiki pages with rich text and media, while simultaneously building a structured knowledge graph where entities and their relationships are visually represented. The bidirectional synchronization between these views will ensure consistency and provide multiple ways to interact with the same knowledge base.

*Important:* We annotate each requirement with V0.7, V1, V2, V3 and V?. These are version-indicators.

## Functional Requirements (MVP)

### 1. User Authentication and Management
- V0.7 User registration and authentication system
- V1 User profile management
- V1 Team/workspace creation and management
- V3 Role-based permissions for collaborative editing

### 2. Knowledge Graph Schema Management
- V0.7 Pre-defined schema loading and visualization
- V0.7 Entity and relationship types defined by the schema
- V0.7 Property definition for entities and relationships based on schema

### 3. Wiki Content Management
- V0.7 Rich text editing with Lexical editor
- V0.7 Support for formatting (headings, lists, bold, italic, etc.)
- V0.7 Media embedding (images, videos)
- V0.7 Hyperlink support (internal and external)
- V0.7 Wiki page creation, editing, and deletion
- V0.7 Automatic saving of content changes

### 4. Knowledge Graph Visualization and Editing
- V0.7 Interactive graph visualization using React Flow
- V0.7 Entity creation through direct graph manipulation
- V0.7 Relationship creation through connecting entities
- V0.7 Entity and relationship property editing via form interface
- V? Support for extra fields on entities presented as forms in the UI
- V0.7 Zooming and panning navigation
- V1 Different detail levels at different zoom levels
- V0.7 Visual indicators for entity completeness/importance

### 5. Unidirectional Wiki-to-Graph Synchronization
- V0.7 Entity creation through wiki-links in text
- V0.7 Automatic graph updates when wiki content changes
- V0.7 No automatic wiki content updates when graph changes (one-way synchronization only): graph changes result in todo-items for checking/updating the wiki content
- V0.7 Consistent entity reference maintenance between views

### 6. AI Assistance Features
- V1 Relationship suggestion system (displayed as dotted lines)
- V1 Entity type suggestion for new entities
- V1 Summary/description generation suggestions
- V1 Explicit user approval required for all AI suggestions

### 7. Document Processing
- V0.7 Document upload functionality (PDF, DOCX, TXT, EPUB, Markdown)
- V2 knowledge extraction from text documents
- V2 Image and audio file upload for knowledge extraction
- V2 Entity and relationship extraction from documents
- V2 User review and approval interface for extracted knowledge
- V2 Source document reference maintenance

### 8. Knowledge Completeness Tracking
- V0.7 To-do list generation for incomplete entities/relationships
- V0.7 Completeness criteria based on schema definitions
- V0.7 Visual indicators for completeness status
- V1 Filtering and sorting of to-do items

### 9. Real-time Collaboration
- V1 Concurrent editing of wiki content
- V1 Concurrent editing of graph structure
- V1 User presence indicators
- V2 Change attribution to specific users
- V2 Conflict resolution mechanisms

### 10. TypeDB Integration
- V0.7 TypeDB connection and query management
- V0.7 Schema-compliant data storage and retrieval
- V2 Support for complex relationship types with properties
- V2 Efficient query patterns for graph visualization and navigation

### 11. Commenting and Discussion
- V1 Comment creation on entities and relationships
- V1 Threaded discussions
- V2 Notification system for new comments
- V1 Comment editing and deletion
- V1 @mentions to reference users in comments

## Non-Functional Requirements (MVP)

### 1. Performance Requirements
- V1 Page load time: Initial application load under 3 seconds on standard broadband connection
- V1 Graph rendering: Smooth visualization and interaction with up to 500 nodes
- V0.7 Wiki editor responsiveness: No perceptible lag during typing or formatting
- V2 Document processing: Upload and extraction processing within 60 seconds for documents up to 10MB
- V1 API response time: 95% of API requests complete within 500ms
- V1 Real-time collaboration: Changes propagate to all users within 2 seconds

### 2. Scalability Requirements
- V1 Support for knowledge graphs with up to 10,000 entities in MVP
- V1 Support for up to 20 concurrent users editing the same knowledge base
- V1 Support for knowledge bases up to 1GB in total size (excluding media)

### 3. Security Requirements
- V0.7 User authentication with industry-standard protocols (OAuth 2.0)
- V0.7 Data encryption in transit (HTTPS/TLS)
- Team-based (V0.7) and role-based (V2) access control for knowledge base editing
- V0.7 Input validation to prevent injection attacks
- V0.7 Protection against common web vulnerabilities (XSS, CSRF)
- V1 Secure handling of AI service API keys

### 4. Usability Requirements
- V0.7 Intuitive interface requiring minimal training for domain experts
- V1 Consistent design language throughout the application
- V0.7 Optimized for desktop use (1280×720 minimum resolution)
- V1 Limited mobile functionality (wiki viewing/editing only, no graph editing)
- V0.7 Clear visual feedback for user actions
- V2 Optional audio feedback for important actions and notifications
- V0.7 Helpful error messages that suggest resolution steps
- V1 Tooltips and contextual help for complex features
- V1 Undo/redo functionality for both wiki and graph edits

### 5. Reliability Requirements
- V0.7 System availability of 99.5% during business hours
- V0.7 Automatic saving of user changes to prevent data loss
- V2 Graceful handling of network interruptions with offline editing capability where possible
- V2 Automatic recovery from temporary TypeDB connection issues
- V0.7 Comprehensive error logging for troubleshooting

### 6. Compatibility Requirements
- V0.7 Support for modern web browsers: Chrome (latest 2 versions), Firefox (latest 2 versions), Safari (latest 2 versions), Edge (latest 2 versions)
- V0.7 No dependency on browser plugins or extensions
- V0.7 Support for standard image formats (JPG, PNG, GIF, SVG)
- V1 Support for standard video formats (MP4, WebM)
- V0.7 Support for standard audio formats (MP3, WAV)
- Support for document formats:
  - V0.7 PDF
  - V1 DOCX
  - V0.7 TXT
  - V1 EPUB
  - V0.7 Markdown (.md, .markdown)

### 7. Localization Requirements
- V1 Support for English and Dutch languages
- V0.7 UTF-8 encoding for proper handling of special characters
- V0.7 Design accommodates future localization (string externalization, flexible layouts)

### 8. Compliance Requirements
- V0.7 GDPR compliance for user data handling
- V1 WCAG 2.1 AA level accessibility compliance
- V0.7 Proper attribution for open-source components
- V0.7 Compliance with TypeDB licensing requirements

### 9. Maintainability Requirements
- V0.7 Well-documented codebase following industry best practices
- V0.7 Modular architecture allowing for component updates
- V0.7 Comprehensive test coverage (unit, integration, E2E with CodeceptJS)
- V0.7 Consistent code style and formatting
- V0.7 Dependency management with clear versioning

### 10. Deployment Requirements
- V0.7 Containerized application components for consistent deployment
- V0.7 Configuration via environment variables
- V0.7 Automated build and deployment pipeline
- V1 Minimal downtime during updates
- V1 Ability to roll back to previous versions if issues are detected

## User Interaction and Design Goals

### Overall Vision & Experience

The Knowledge Graph Wiki Tool should provide a clean, intuitive, and visually appealing interface that makes complex knowledge structures accessible to non-technical domain experts. The experience should feel modern, professional, and focused, with a minimalist design that reduces cognitive load while working with complex information. The interface should inspire confidence and make users feel empowered to organize and visualize their domain knowledge without requiring technical expertise.

### Key Interaction Paradigms

1. V0.7 **Split-View Interface**: The primary interface should feature a flexible split-view layout with the wiki content editor on one side and the knowledge graph visualization on the other. Users should be able to adjust the split ratio or focus on either view as needed.

2. V0.7 **Direct Manipulation with Grid Snapping**: The graph visualization should support intuitive direct manipulation, allowing users to:
   - Drag entities to reposition them (with automatic snapping to a grid)
   - Click to select and view/edit properties
   - Edit labels and short descriptions directly in the graph
   - Drag between entities to create relationships
   - Use pinch/scroll gestures for zooming
   - Click and drag the canvas for panning
   - Trigger auto-layout of the graph via a dedicated control

3. V0.7 **Wiki-Link Entity Creation with Type Specification**: Within the Lexical text editor, users should be able to create new entities by using a special wiki-link syntax (e.g., [[Entity Name]]) with optional type specification (e.g., [[type:Entity Name]]) or through a contextual menu option.

4. V0.7 **Side-Panel Property Editing**: Entity and relationship properties should be edited through clean, structured forms that appear in a side panel when an element is selected.

5. V1 **Suggestion Review Interface**: AI-generated suggestions should appear in a non-intrusive but visible manner (e.g., dotted lines for relationships, highlight for entity type suggestions) with clear accept/reject controls.

6. V0.7 **To-Do List Workflow**: The to-do list should be accessible through a dedicated panel or tab, allowing users to quickly identify and address incomplete knowledge elements.

7. V0.7 **Contextual Document Upload**: Document uploading should be available as a contextual feature of entities and relationships, allowing users to attach and extract knowledge from documents directly in the context of the relevant graph elements.

### Core Screens/Views

1. V0.7 **Main Editor View**: The primary interface with split wiki/graph visualization, toolbars, and property panels.

2. V1 **Knowledge Base Dashboard**: Entry point showing available knowledge bases, team access information, and creation/import options.

3. V2 **User/Team Management**: Interface for managing users, teams, and permissions.

4. V0.7 **To-Do List View**: Dedicated interface for viewing and addressing incomplete knowledge elements.

5. V2 **Settings & Configuration**: Interface for adjusting user preferences and system settings.

6. V0.7 **Publishing View**: Interface for configuring and generating published versions of the knowledge base.

### Accessibility Aspirations

- V1 All functionality should be accessible via keyboard navigation
- V1 Multiple color schemes (light mode, dark mode, and high contrast)
- V0.7 Interactive elements should have appropriate focus states
- V1 Screen reader compatibility for all core functions
- V1 Support for system font size adjustments
- V2 Audio feedback option for important actions

### Branding Considerations

- V0.7 The interface should use a color palette centered on black and white, with pastel colors for accents and data types
- V0.7 Typography should use sans-serif fonts for UI elements and a modern, low-contrast serif font for user-entered content
- V0.7 Visual elements should convey precision and clarity
- V0.7 The overall aesthetic should feel contemporary and trustworthy

### Target Devices/Platforms

- V0.7 Primary focus on desktop web browsers with minimum 1400×900 resolution
- V2 Limited functionality on tablets and mobile devices (wiki viewing/editing only)
- V0.7 Optimized for mouse/keyboard interaction, with touch support as a secondary consideration
- V0.7 No dependency on mobile-specific features

## Technical Assumptions

### V0.7 Technology Stack

#### Frontend
- **Framework**: React 19
- **Styling**: Tailwind 4
- **UI Components**: Shadcn/ui
- **Text Editor**: Lexical
- **Graph Visualization**: React Flow
- **State Management**: Jotai
- **Testing**: CodeceptJS for BDD-style E2E testing
- **Language**: JavaScript (not TypeScript)

#### Backend
- **Framework**: FastAPI
- **Language**: Python 3.14
- **Database**: TypeDB 3.3 (connection code will be provided)
- **Package Manager**: uv
- **WebSockets**: python-socketio

### Architecture & Integration

- **Application Architecture**: Modern web application with a clear separation between frontend and backend components
- **API Design**: RESTful API with JSON payloads for most operations, with Socket.io for real-time collaboration features
- **Authentication**: JWT-based authentication with secure token handling
- **State Management**: Client-side state management with Jotai, synchronized via Socket.io for collaborative features
- **Real-time Updates**: Socket.io connections for propagating changes between users in real-time
- **AI Integration**: Integration with both external LLM services and self-hosted LLMs running in our own infrastructure

### Data Management

- **Knowledge Graph Storage**: TypeDB for storing and querying the knowledge graph structure
- **Media Storage**: Separate blob storage for media files with reference links in TypeDB
- **Schema Management**: Schemas defined using Pydantic, with TypeDB schema files generated from those definitions
- **Search Functionality**: Full-text search capabilities for wiki content and entity properties

### Development & Deployment

- **Repository & Service Architecture**: Single repository structure containing both frontend and backend components
- **Project Organization**: Standard directory structure without monorepo management tools
- **Build System**: Modern build pipeline with optimization for production deployment
- **Containerization**: Docker-based containerization for consistent deployment
- **Environment Configuration**: Environment variable-based configuration for different deployment scenarios
- **CI/CD**: GitHub Actions for automated testing and deployment

### Testing requirements

- **Unit Testing**: Comprehensive unit tests for both frontend and backend components
- **Integration Testing**: API-level integration tests to verify component interactions
- **E2E Testing**: CodeceptJS for BDD-style end-to-end testing of critical user flows
- **Performance Testing**: Load testing to verify performance under expected user loads
- **Accessibility Testing**: Automated and manual testing for accessibility compliance

### Security Considerations

- **Authentication**: Secure, industry-standard authentication mechanisms
- **Authorization**: Team and role-based access control for all operations
- **Data Protection**: HTTPS/TLS for all data in transit
- **Input Validation**: Thorough validation of all user inputs to prevent injection attacks
- **API Security**: Rate limiting and appropriate security headers

### Browser & Device Support

- **Browsers**: Latest two versions of Chrome, Firefox, Safari, and Edge
- **Minimum Resolution**: 1400×900 pixels
- **Responsive Design**: Optimized for desktop with limited functionality on mobile devices
- **JavaScript Required**: Application requires JavaScript to function

## Epic Overview

- **V0.7 Epic 1: Project Foundation & Infrastructure**
  - Goal: Establish the foundational infrastructure, repository setup, and core application framework to enable efficient development of subsequent features.
  - V0.7 Story 1: As a developer, I want a properly configured repository with both frontend and backend projects so that I can efficiently develop and test the application.
    - V0.7 Set up repository with appropriate project structure
    - V0.7 Configure JavaScript for frontend
    - V0.7 Configure Python for backend
    - V0.7 Set up linting and formatting rules
    - V0.7 Configure basic CI/CD with GitHub Actions
  - V0.7 Story 2: As a developer, I want a basic frontend application shell with React 19, Tailwind 4, and Shadcn/ui so that I can start building UI components.
    - V0.7 Initialize React application with JavaScript
    - V0.7 Configure Tailwind and Shadcn/ui
    - V0.7 Create basic layout components
    - V1 Implement theme switching (light/dark/high contrast)
    - V0.7 Set up Jotai for state management
  - V0.7 Story 3: As a developer, I want a basic backend API with FastAPI so that I can start implementing data storage and retrieval.
    - V0.7 Set up FastAPI application structure
    - V0.7 Integrate provided TypeDB connection code
    - V0.7 Implement basic health check endpoints
    - V0.7 Set up authentication framework
    - V0.7 Configure CORS and security headers
  - V0.7 Story 4: As a developer, I want Socket.io integration between frontend and backend so that I can implement real-time collaboration features.
    - V0.7 Set up python-socketio on the backend
    - V0.7 Configure Socket.io client on the frontend
    - V0.7 Implement basic connection handling
    - V0.7 Create test endpoints to verify real-time communication

- **V1 Epic 2: User Authentication & Management**
  - Goal: Implement a secure and user-friendly authentication system with team-based access control.
  - V0.7 Story 1: As a user, I want to register for an account so that I can access the knowledge graph wiki tool.
    - V0.7 Create registration form UI
    - V0.7 Implement backend registration endpoint
    - V0.7 Add validation for user inputs
    - V1 Implement email verification flow
    - V0.7 Store user data securely
  - V0.7 Story 2: As a user, I want to log in to my account so that I can access my knowledge bases.
    - V0.7 Create login form UI
    - V0.7 Implement JWT-based authentication
    - V0.7 Create secure token handling
    - V1 Implement "remember me" functionality
    - V1 Add protection against brute force attacks
  - V1 Story 3: As a user, I want to create and manage teams so that I can collaborate with others.
    - V1 Create team management UI
    - V1 Implement team CRUD operations
    - V1 Add user invitation system
    - V1 Implement team role assignment
    - V1 Create team settings page
  - V3 Story 4: As a team administrator, I want to manage permissions for team members so that I can control access to knowledge bases.
    - V3 Create permission management UI
    - V3 Implement role-based access control
    - V3 Add permission checking to API endpoints
    - V2 Create audit logging for permission changes
    - V3 Implement permission inheritance rules

- **V0.7 Epic 3: Knowledge Base Creation & Schema Management**
  - Goal: Enable users to create knowledge bases with predefined schemas and manage their properties.
  - V1 Story 1: As a user, I want to create a new knowledge base so that I can start organizing my domain knowledge.
    - V1 Create knowledge base creation UI
    - V1 Implement knowledge base CRUD operations
    - V1 Add team access assignment
    - V1 Create knowledge base settings page
    - V1 Implement knowledge base listing and search
  - V0.7 Story 2: As a developer, I want to implement Pydantic schema definition and TypeDB schema generation so that knowledge bases have proper structure.
    - V0.7 Create Pydantic schema definition system
    - V0.7 Implement TypeDB schema generation from Pydantic models
    - V0.7 Add validation for schema definitions
    - V2 Create schema versioning system
    - V2 Implement schema migration utilities
  - V0.7 Story 3: As a user, I want to select from predefined schemas when creating a knowledge base so that I can quickly start with an appropriate structure.
    - V0.7 Create schema selection UI
    - V0.7 Implement schema preview functionality
    - V0.7 Add schema metadata display
    - V0.7 Create schema application process
    - V0.7 Implement initial knowledge base setup based on schema

- **V0.7 Epic 4: Wiki Content Management**
  - Goal: Implement a rich, user-friendly wiki editing experience with support for various content types.
  - V0.7 Story 1: As a user, I want to create and edit wiki pages with a rich text editor so that I can document my knowledge.
    - V0.7 Integrate Lexical editor
    - V0.7 Implement basic text formatting controls
    - V0.7 Add support for headings, lists, and other structures
    - V0.7 Create autosave functionality
    - V1 Implement draft and publishing workflow
  - V0.7 Story 2: As a user, I want to embed media in wiki pages so that I can include visual and audio content.
    - V0.7 Implement media upload functionality
    - V0.7 Add support for image embedding and resizing
    - V0.7 Implement video and audio embedding
    - V1 Create media browser for reusing existing media
    - V1 Add media metadata editing
  - V0.7 Story 3: As a user, I want to create wiki-links with optional type specification so that I can connect wiki content to the knowledge graph.
    - V0.7 Implement wiki-link syntax parsing
    - V0.7 Create entity creation from wiki-links
    - V0.7 Add type specification support (e.g., [[type:Entity Name]])
    - V0.7 Implement entity reference resolution
    - V0.7 Create visual indicators for linked entities

- **V0.7 Epic 5: Knowledge Graph Visualization & Editing**
  - Goal: Create an intuitive, interactive graph visualization that allows users to directly manipulate knowledge structures.
  - V0.7 Story 1: As a user, I want to visualize my knowledge graph so that I can understand relationships between entities.
    - V0.7 Integrate React Flow
    - V0.7 Implement graph data transformation
    - V0.7 Create node and edge rendering
    - V0.7 Add zooming and panning controls
    - V1 Implement detail level changes based on zoom
  - V0.7 Story 2: As a user, I want to directly manipulate the graph by adding, moving, and connecting entities so that I can build my knowledge structure visually.
    - V0.7 Implement entity creation in graph
    - V0.7 Add grid-snapping for entity positioning
    - V0.7 Create relationship drawing functionality
    - V0.7 Implement selection and multi-selection
    - V1 Add context menus for common operations
  - V0.7 Story 3: As a user, I want to edit entity and relationship properties directly in the graph so that I can quickly update information.
    - V0.7 Implement in-graph label editing
    - V0.7 Create in-graph description editing
    - V0.7 Add visual indicators for editing state
    - V0.7 Implement validation for in-graph edits
    - V1 Create undo/redo functionality for graph edits
  - V1 Story 4: As a user, I want to use auto-layout functionality so that I can automatically organize my graph for better readability.
    - V1 Implement multiple auto-layout algorithms
    - V1 Create layout customization options
    - V1 Add animation for layout transitions
    - V2 Implement partial layout for selected nodes
    - V1 Create layout presets for common patterns

- **V0.7 Epic 6: Bidirectional Synchronization & Property Editing**
  - Goal: Implement seamless synchronization between wiki content and graph visualization with comprehensive property editing.
  - V0.7 Story 1: As a user, I want changes in wiki content to automatically update the graph so that both views remain consistent.
    - V0.7 Implement wiki content change detection
    - V0.7 Create entity extraction from wiki content
    - V1 Add relationship inference from content
    - V0.7 Implement graph update mechanism
    - V0.7 Create visual indicators for wiki-sourced graph elements
  - V0.7 Story 2: As a user, I want to edit entity and relationship properties through a side panel so that I can manage detailed information.
    - V0.7 Create side panel property editor UI
    - V0.7 Implement form generation from schema
    - V0.7 Add validation based on schema rules
    - V1 Create property change history
    - V1 Implement property templates for common patterns
  - V2 Story 3: As a user, I want to attach and process documents to entities and relationships so that I can extract additional knowledge.
    - V0.7 Implement document upload in entity/relationship context
    - V2 Create document processing pipeline
    - V2 Add entity and relationship extraction from documents
    - V2 Implement suggestion review interface
    - V2 Create document reference management

- **V1 Epic 7: AI Assistance & Knowledge Quality**
  - Goal: Integrate AI capabilities to enhance knowledge creation and maintain knowledge quality.
  - V1 Story 1: As a user, I want AI-suggested relationships between entities so that I can discover connections I might have missed.
    - V1 Implement relationship suggestion algorithms
    - V1 Create LLM integration for relationship inference
    - V1 Add suggestion visualization (dotted lines)
    - V1 Implement accept/reject controls
    - V1 Create suggestion quality feedback mechanism
  - V1 Story 2: As a user, I want AI-generated summaries and descriptions so that I can quickly add content.
    - V1 Implement summary generation with LLMs
    - V1 Create description generation for entities and relationships
    - V1 Add context-aware suggestion capabilities
    - V1 Implement suggestion review interface
    - V1 Create suggestion customization options
  - V0.7 Story 3: As a user, I want a to-do list of incomplete entities and relationships so that I can systematically improve knowledge quality.
    - V0.7 Create to-do list generation based on schema completeness
    - V0.7 Implement to-do list UI
    - V1 Add filtering and sorting options
    - V1 Create to-do item prioritization
    - V1 Implement to-do completion tracking

- **V1 Epic 8: Real-time Collaboration**
  - Goal: Enable multiple users to work simultaneously on the same knowledge base with awareness of each other's actions.
  - V1 Story 1: As a user, I want to see other users' presence and actions in real-time so that I can collaborate effectively.
    - V1 Implement user presence indicators
    - V1 Create cursor position sharing
    - V1 Add selection sharing
    - V1 Implement activity feed
    - V1 Create notification system for important changes
  - V1 Story 2: As a user, I want to collaborate on wiki editing in real-time so that multiple people can work on the same content.
    - V1 Implement operational transformation for text editing
    - V2 Create conflict resolution mechanisms
    - V2 Add edit attribution
    - V2 Implement edit locking for conflict prevention
    - V1 Create collaborative editing indicators
  - V1 Story 3: As a user, I want to collaborate on graph editing in real-time so that multiple people can work on the same knowledge structure.
    - V1 Implement real-time graph update propagation
    - V2 Create conflict resolution for graph operations
    - V1 Add visual indicators for others' graph actions
    - V1 Implement temporary state visualization
    - V2 Create undo/redo with multi-user awareness

- **V1 Epic 9: Publishing & Sharing**
  - Goal: Enable users to publish and share their knowledge bases with controlled access.
  - V1 Story 1: As a user, I want to publish my knowledge base as interactive web content so that others can explore it.
    - V0.7 Create publishing configuration UI
    - V1 Implement public website publishing (completed entities only)
    - V1 Add basic customization options for published view
    - V1 Create permalink generation
    - V3 Implement analytics for published content
  - V3 Story 2: As a user, I want to control access to my published knowledge base so that I can share it with specific audiences.
    - V3 Implement access control for published content
    - V3 Create invitation system for private access
    - V3 Add password protection option
    - V3 Implement expiring access links
    - V3 Create access audit logging

- **V2 Epic 10: System Administration & Monitoring**
  - Goal: Provide tools for system administration, monitoring, and maintenance.
  - V1 Story 1: As an administrator, I want to monitor system performance and usage so that I can ensure optimal operation.
    - V1 Implement performance metrics collection
    - V2 Create admin dashboard
    - V2 Add usage statistics visualization
    - V1 Implement alerting for performance issues
    - V1 Create resource utilization tracking
  - V2 Story 2: As an administrator, I want to manage user accounts and teams so that I can maintain system security and organization.
    - V2 Create user management interface
    - V2 Implement account actions (suspend, delete, reset)
    - V2 Add team management capabilities
    - V2 Create audit logging for admin actions
    - V2 Implement bulk operations for user management

- **V1 Epic 11: Commenting and Discussion**
  - Goal: Implement a commenting and discussion system to enable collaborative knowledge refinement.
  - V1 Story 1: As a user, I want to add comments to entities and relationships so that I can provide additional context or ask questions.
    - V1 Create comment creation UI
    - V1 Implement comment storage and retrieval
    - V1 Add comment formatting options
    - V2 Create comment notification system
    - V1 Implement comment visibility controls
  - V1 Story 2: As a user, I want to participate in threaded discussions so that I can engage in detailed conversations about specific knowledge elements.
    - V1 Implement threaded reply structure
    - V1 Create discussion view UI
    - V1 Add sorting and filtering options
    - V1 Implement discussion activity tracking
    - V1 Create discussion summary view
  - V1 Story 3: As a user, I want to mention other users in comments so that I can bring specific points to their attention.
    - V1 Implement @mention functionality
    - V1 Create user suggestion dropdown
    - V2 Add notification system for mentions
    - V2 Implement email notifications for mentions
    - V1 Create mention highlighting in comments

## Key Reference Documents

This section will be populated as the project progresses. It will contain references to important documents that provide additional context, specifications, or guidelines for the project.

## Out of Scope Ideas Post MVP

The following features and capabilities are explicitly out of scope for the MVP but may be considered for future versions:

### Advanced Query Capabilities
- Complex query builder interface for advanced knowledge graph exploration
- Query templates and saved queries
- Query result visualization options

### Advanced Analytics
- Knowledge graph analytics and metrics
- Usage pattern analysis
- Content quality scoring and recommendations

### Extended Collaboration Features
- User activity timelines and contribution metrics
- Collaborative editing sessions with voice/video communication

### Enhanced AI Integration
- Automated knowledge graph construction from large document sets
- Semantic similarity search across knowledge bases
- AI-driven knowledge gap identification and recommendations
- Automated knowledge base quality assessment

### External System Integration
- API for third-party applications to access knowledge base data
- Integration with external knowledge sources and databases
- Webhook support for triggering external actions based on knowledge changes
- Import/export capabilities for additional formats

### Advanced Publishing Features
- Custom themes and branding for published knowledge bases
- Interactive guided tours of published knowledge
- Embeddable knowledge graph components for external websites
- Presentation mode for knowledge sharing sessions

### Mobile Application
- Full-featured mobile applications (iOS/Android)
- Offline editing capabilities
- Mobile-optimized graph visualization

### Enterprise Features
- Single sign-on (SSO) integration
- Advanced audit logging and compliance features
- Custom roles and fine-grained permissions
- Multi-tenant deployment options

### Accessibility Enhancements
- LLM-supported voice/speech interface for people with reduced eyesight
- Advanced screen reader optimizations
- Keyboard-only navigation improvements
- Alternative input method support

## [OPTIONAL: For Simplified PM-to-Development Workflow Only] Core Technical Decisions & Application Structure

### Technology Stack Selections

- **Primary Backend Language/Framework:** Python 3.14 with FastAPI
- **Primary Frontend Language/Framework:** JavaScript with React 19
- **Database:** TypeDB 3.3
- **Key Libraries/Services (Backend):**
  - python-socketio for WebSocket communication
  - Pydantic for schema definition and validation
  - uv as Python package manager
  - Custom TypeDB connection code (to be provided)
- **Key Libraries/Services (Frontend):**
  - Tailwind 4 for styling
  - Shadcn/ui for UI components
  - Lexical for rich text editing
  - React Flow for graph visualization
  - Jotai for state management
  - Socket.io client for real-time communication
- **Deployment Platform/Environment:** Docker containers (specific hosting platform TBD)
- **Version Control System:** Git with GitHub

### Proposed Application Structure

```
/
├── README.md                    # Project documentation
├── package.json                 # Root package.json for JavaScript dependencies
├── requirements.txt             # Python dependencies
├── docker-compose.yml           # Local development environment
├── .github/                     # GitHub Actions workflows
│   └── workflows/
│       ├── ci.yml               # CI workflow
│       └── deploy.yml           # Deployment workflow
├── frontend/                    # React frontend application
│   │   ├── public/              # Static assets
│   │   ├── src/                 # Source code
│   │   │   ├── components/      # Reusable UI components
│   │   │   ├── hooks/           # Custom React hooks
│   │   │   ├── pages/           # Page components
│   │   │   ├── store/           # Jotai state management
│   │   │   ├── utils/           # Utility functions
│   │   │   ├── services/        # API and service integrations
│   │   │   └── App.js           # Main application component
│   └── package.json             # Frontend dependencies
├── backend/                     # FastAPI backend application
│       ├── app/                 # Application code
│       │   ├── api/             # API endpoints
│       │   ├── core/            # Core functionality
│       │   ├── db/              # Database interactions
│       │   ├── models/          # Data models
│       │   ├── schemas/         # Pydantic schemas
│       │   └── services/        # Business logic services
│       ├── tests/               # Backend tests
│   └── main.py                  # Application entry point
└── scripts/                     # Development and build tools
```

- **Repository Structure:** Single repository containing both frontend and backend applications with standard directory organization. This approach simplifies development, testing, and deployment while maintaining clear separation of concerns.

- **Key Modules/Components and Responsibilities:**
  - **Frontend Application:** Responsible for the user interface, including the wiki editor, graph visualization, and user interactions.
  - **Backend API:** Provides data access, authentication, and business logic services to the frontend.
  - **Shared Code:** Common utilities and configurations shared between frontend and backend where appropriate.
  - **TypeDB Integration:** Manages the connection to TypeDB and provides data access methods.
  - **Real-time Collaboration:** Handles WebSocket connections and real-time updates between users.
  - **Document Processing:** Manages document uploads and knowledge extraction.

- **Data Flow Overview (Conceptual):**
  1. User interacts with the frontend application (React)
  2. Frontend makes API requests to the backend (FastAPI)
  3. Backend processes requests and interacts with TypeDB
  4. Real-time updates are propagated via Socket.io
  5. Data is returned to the frontend and displayed to the user

## Change Log

| Change      | Date       | Version | Description          | Author                |
| ----------- | ---------- | ------- | -------------------- | --------------------- |
| Initial PRD | 06/06/2025 | 0.1     | Initial draft of PRD | Pim (Product Manager) |

## Checklist Results Report

### Category Statuses
| Category                         | Status | Critical Issues |
| -------------------------------- | ------ | --------------- |
| 1. Problem Definition & Context  | PASS   | None            |
| 2. MVP Scope Definition          | PASS   | None            |
| 3. User Experience Requirements  | PASS   | None            |
| 4. Functional Requirements       | PASS   | None            |
| 5. Non-Functional Requirements   | PASS   | None            |
| 6. Epic & Story Structure        | PASS   | None            |
| 7. Technical Guidance            | PASS   | None            |
| 8. Cross-Functional Requirements | PASS   | None            |
| 9. Clarity & Communication       | PASS   | None            |

### Critical Deficiencies
- No critical deficiencies identified.

### Recommendations
- Consider conducting user research to validate the proposed UI/UX approach with target users.
- Develop a detailed technical spike for the TypeDB integration to validate performance assumptions.
- Create early prototypes of the graph visualization to test usability with domain experts.

### Final Decision
- **READY FOR ARCHITECT**: The PRD and epics are comprehensive, properly structured, and ready for architectural design.

## Prompt for Design Architect (UI/UX Specification Mode)

**Objective:** Elaborate on the UI/UX aspects of the Knowledge Graph Wiki Tool defined in this PRD.
**Mode:** UI/UX Specification Mode
**Input:** This completed PRD document.
**Key Tasks:**

1. Review the product goals, user stories, and UI-related notes herein.
2. Collaboratively define detailed user flows, wire-frames (conceptual), and key screen mockups/descriptions.
3. Specify usability requirements and accessibility considerations.
4. Populate or create the `front-end-spec-tmpl` document.
5. Ensure that this PRD is updated or clearly references the detailed UI/UX specifications derived from your work, so that it provides a comprehensive foundation for subsequent architecture and development phases.

Please guide the user through this process to enrich the PRD with detailed UI/UX specifications.

## Initial Architect Prompt

Based on our discussions and requirements analysis for the Knowledge Graph Wiki Tool, I've compiled the following technical guidance to inform your architecture analysis and decisions to kick off Architecture Creation Mode:

### Technical Infrastructure

- **Repository & Service Architecture Decision:** Single repository structure containing both frontend and backend applications without monorepo management tools.
- **Starter Project/Template:** None specified; the project will be built from scratch following the defined structure.
- **Hosting/Cloud Provider:** To be determined, but the application will be containerized for deployment flexibility.
- **Frontend Platform:** React 19 with JavaScript, Tailwind 4, Shadcn/ui, Lexical for text editing, and React Flow for graph visualization.
- **Backend Platform:** Python 3.14 with FastAPI, python-socketio for WebSockets, and Pydantic for schema definition.
- **Database Requirements:** TypeDB 3.3 with connection code to be provided.

### Technical Constraints

- Must use the specified technology stack (React, FastAPI, TypeDB, etc.)
- Must support real-time collaboration via Socket.io
- Must integrate with both external and self-hosted LLMs
- Must generate TypeDB schema files from Pydantic definitions
- Must support document processing for various formats (PDF, DOCX, EPUB, Markdown, images, audio)
- Must implement grid-snapping and auto-layout for graph visualization

### Deployment Considerations

- Containerized deployment using Docker
- CI/CD through GitHub Actions
- Environment configuration via environment variables
- Support for different deployment environments (development, staging, production)

### Local Development & Testing Requirements

- Local development environment using Docker Compose
- E2E testing with CodeceptJS
- Unit testing for both frontend and backend components
- Performance testing for graph visualization with large datasets

### Other Technical Considerations

- Security implementation for team and role-based access control
- Real-time collaboration architecture with conflict resolution
- Efficient TypeDB query patterns for graph visualization and navigation
- Document processing pipeline for knowledge extraction
- Integration with LLM services for AI assistance features
- Commenting and discussion system implementation

Please analyze these requirements and constraints to develop a comprehensive architecture that addresses the functional and non-functional requirements while providing a solid foundation for development.

## Key Reference Documents

This section will be populated as the project progresses. It will contain references to important documents that provide additional context, specifications, or guidelines for the project.

## Out of Scope Ideas Post MVP

The following features and capabilities are explicitly out of scope for the MVP but may be considered for future versions:

### Advanced Query Capabilities
- Complex query builder interface for advanced knowledge graph exploration
- Query templates and saved queries
- Query result visualization options

### Advanced Analytics
- Knowledge graph analytics and metrics
- Usage pattern analysis
- Content quality scoring and recommendations

### Extended Collaboration Features
- User activity timelines and contribution metrics
- Collaborative editing sessions with voice/video communication

### Enhanced AI Integration
- Automated knowledge graph construction from large document sets
- Semantic similarity search across knowledge bases
- AI-driven knowledge gap identification and recommendations
- Automated knowledge base quality assessment

### External System Integration
- API for third-party applications to access knowledge base data
- Integration with external knowledge sources and databases
- Webhook support for triggering external actions based on knowledge changes
- Import/export capabilities for additional formats

### Advanced Publishing Features
- Custom themes and branding for published knowledge bases
- Interactive guided tours of published knowledge
- Embeddable knowledge graph components for external websites
- Presentation mode for knowledge sharing sessions

### Mobile Application
- Full-featured mobile applications (iOS/Android)
- Offline editing capabilities
- Mobile-optimized graph visualization

### Enterprise Features
- Single sign-on (SSO) integration
- Advanced audit logging and compliance features
- Custom roles and fine-grained permissions
- Multi-tenant deployment options

### Accessibility Enhancements
- LLM-supported voice/speech interface for people with reduced eyesight
- Advanced screen reader optimizations
- Keyboard-only navigation improvements
- Alternative input method support

## [OPTIONAL: For Simplified PM-to-Development Workflow Only] Core Technical Decisions & Application Structure

### Technology Stack Selections

- **Primary Backend Language/Framework:** Python 3.14 with FastAPI
- **Primary Frontend Language/Framework:** JavaScript with React 19
- **Database:** TypeDB 3.3
- **Key Libraries/Services (Backend):**
  - python-socketio for WebSocket communication
  - Pydantic for schema definition and validation
  - uv as Python package manager
  - Custom TypeDB connection code (to be provided)
- **Key Libraries/Services (Frontend):**
  - Tailwind 4 for styling
  - Shadcn/ui for UI components
  - Lexical for rich text editing
  - React Flow for graph visualization
  - Jotai for state management
  - Socket.io client for real-time communication
- **Deployment Platform/Environment:** Docker containers (specific hosting platform TBD)
- **Version Control System:** Git with GitHub

### Proposed Application Structure

```
/
├── README.md                    # Project documentation
├── package.json                 # Root package.json for JavaScript dependencies
├── requirements.txt             # Python dependencies
├── docker-compose.yml           # Local development environment
├── .github/                     # GitHub Actions workflows
│   └── workflows/
│       ├── ci.yml               # CI workflow
│       └── deploy.yml           # Deployment workflow
├── frontend/                    # React frontend application
│   │   ├── public/              # Static assets
│   │   ├── src/                 # Source code
│   │   │   ├── components/      # Reusable UI components
│   │   │   ├── hooks/           # Custom React hooks
│   │   │   ├── pages/           # Page components
│   │   │   ├── store/           # Jotai state management
│   │   │   ├── utils/           # Utility functions
│   │   │   ├── services/        # API and service integrations
│   │   │   └── App.js           # Main application component
│   └── package.json             # Frontend dependencies
├── backend/                     # FastAPI backend application
│       ├── app/                 # Application code
│       │   ├── api/             # API endpoints
│       │   ├── core/            # Core functionality
│       │   ├── db/              # Database interactions
│       │   ├── models/          # Data models
│       │   ├── schemas/         # Pydantic schemas
│       │   └── services/        # Business logic services
│       ├── tests/               # Backend tests
│   └── main.py                  # Application entry point
└── scripts/                     # Development and build tools
```

- **Repository Structure:** Single repository containing both frontend and backend applications with standard directory organization. This approach simplifies development, testing, and deployment while maintaining clear separation of concerns.

- **Key Modules/Components and Responsibilities:**
  - **Frontend Application:** Responsible for the user interface, including the wiki editor, graph visualization, and user interactions.
  - **Backend API:** Provides data access, authentication, and business logic services to the frontend.
  - **Shared Code:** Common utilities and configurations shared between frontend and backend where appropriate.
  - **TypeDB Integration:** Manages the connection to TypeDB and provides data access methods.
  - **Real-time Collaboration:** Handles WebSocket connections and real-time updates between users.
  - **Document Processing:** Manages document uploads and knowledge extraction.

- **Data Flow Overview (Conceptual):**
  1. User interacts with the frontend application (React)
  2. Frontend makes API requests to the backend (FastAPI)
  3. Backend processes requests and interacts with TypeDB
  4. Real-time updates are propagated via Socket.io
  5. Data is returned to the frontend and displayed to the user

## Change Log

| Change      | Date       | Version | Description          | Author                |
| ----------- | ---------- | ------- | -------------------- | --------------------- |
| Initial PRD | 06/06/2025 | 0.1     | Initial draft of PRD | Pim (Product Manager) |

## Checklist Results Report

### Category Statuses
| Category                         | Status | Critical Issues |
| -------------------------------- | ------ | --------------- |
| 1. Problem Definition & Context  | PASS   | None            |
| 2. MVP Scope Definition          | PASS   | None            |
| 3. User Experience Requirements  | PASS   | None            |
| 4. Functional Requirements       | PASS   | None            |
| 5. Non-Functional Requirements   | PASS   | None            |
| 6. Epic & Story Structure        | PASS   | None            |
| 7. Technical Guidance            | PASS   | None            |
| 8. Cross-Functional Requirements | PASS   | None            |
| 9. Clarity & Communication       | PASS   | None            |

### Critical Deficiencies
- No critical deficiencies identified.

### Recommendations
- Consider conducting user research to validate the proposed UI/UX approach with target users.
- Develop a detailed technical spike for the TypeDB integration to validate performance assumptions.
- Create early prototypes of the graph visualization to test usability with domain experts.

### Final Decision
- **READY FOR ARCHITECT**: The PRD and epics are comprehensive, properly structured, and ready for architectural design.

## Prompt for Design Architect (UI/UX Specification Mode)

**Objective:** Elaborate on the UI/UX aspects of the Knowledge Graph Wiki Tool defined in this PRD.
**Mode:** UI/UX Specification Mode
**Input:** This completed PRD document.
**Key Tasks:**

1. Review the product goals, user stories, and UI-related notes herein.
2. Collaboratively define detailed user flows, wire-frames (conceptual), and key screen mockups/descriptions.
3. Specify usability requirements and accessibility considerations.
4. Populate or create the `front-end-spec-tmpl` document.
5. Ensure that this PRD is updated or clearly references the detailed UI/UX specifications derived from your work, so that it provides a comprehensive foundation for subsequent architecture and development phases.

Please guide the user through this process to enrich the PRD with detailed UI/UX specifications.

## Initial Architect Prompt

Based on our discussions and requirements analysis for the Knowledge Graph Wiki Tool, I've compiled the following technical guidance to inform your architecture analysis and decisions to kick off Architecture Creation Mode:

### Technical Infrastructure

- **Repository & Service Architecture Decision:** Single repository structure containing both frontend and backend applications without monorepo management tools.
- **Starter Project/Template:** None specified; the project will be built from scratch following the defined structure.
- **Hosting/Cloud Provider:** To be determined, but the application will be containerized for deployment flexibility.
- **Frontend Platform:** React 19 with JavaScript, Tailwind 4, Shadcn/ui, Lexical for text editing, and React Flow for graph visualization.
- **Backend Platform:** Python 3.14 with FastAPI, python-socketio for WebSockets, and Pydantic for schema definition.
- **Database Requirements:** TypeDB 3.3 with connection code to be provided.

### Technical Constraints

- Must use the specified technology stack (React, FastAPI, TypeDB, etc.)
- Must support real-time collaboration via Socket.io
- Must integrate with both external and self-hosted LLMs
- Must generate TypeDB schema files from Pydantic definitions
- Must support document processing for various formats (PDF, DOCX, EPUB, Markdown, images, audio)
- Must implement grid-snapping and auto-layout for graph visualization

### Deployment Considerations

- Containerized deployment using Docker
- CI/CD through GitHub Actions
- Environment configuration via environment variables
- Support for different deployment environments (development, staging, production)

### Local Development & Testing Requirements

- Local development environment using Docker Compose
- E2E testing with CodeceptJS
- Unit testing for both frontend and backend components
- Performance testing for graph visualization with large datasets

### Other Technical Considerations

- Security implementation for team and role-based access control
- Real-time collaboration architecture with conflict resolution
- Efficient TypeDB query patterns for graph visualization and navigation
- Document processing pipeline for knowledge extraction
- Integration with LLM services for AI assistance features
- Commenting and discussion system implementation

Please analyze these requirements and constraints to develop a comprehensive architecture that addresses the functional and non-functional requirements while providing a solid foundation for development.
