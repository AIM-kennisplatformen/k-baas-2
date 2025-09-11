# Technical Assumptions

## V0.7 Technology Stack

### Frontend
- **Framework**: React 19
- **Styling**: Tailwind 4
- **UI Components**: Shadcn/ui
- **Text Editor**: Lexical
- **Graph Visualization**: React Flow
- **State Management**: Jotai
- **Testing**: CodeceptJS for BDD-style E2E testing
- **Language**: JavaScript (not TypeScript)

### Backend
- **Framework**: FastAPI
- **Language**: Python 3.14
- **Database**: TypeDB 3.3 (connection code will be provided)
- **Package Manager**: uv
- **WebSockets**: python-socketio

## Architecture & Integration

- **Application Architecture**: Modern web application with a clear separation between frontend and backend components
- **API Design**: RESTful API with JSON payloads for most operations, with Socket.io for real-time collaboration features
- **Authentication**: JWT-based authentication with secure token handling
- **State Management**: Client-side state management with Jotai, synchronized via Socket.io for collaborative features
- **Real-time Updates**: Socket.io connections for propagating changes between users in real-time
- **AI Integration**: Integration with both external LLM services and self-hosted LLMs running in our own infrastructure

## Data Management

- **Knowledge Graph Storage**: TypeDB for storing and querying the knowledge graph structure
- **Media Storage**: Separate blob storage for media files with reference links in TypeDB
- **Schema Management**: Schemas defined using Pydantic, with TypeDB schema files generated from those definitions
- **Search Functionality**: Full-text search capabilities for wiki content and entity properties

## Development & Deployment

- **Repository & Service Architecture**: Single repository structure containing both frontend and backend components
- **Project Organization**: Standard directory structure without monorepo management tools
- **Build System**: Modern build pipeline with optimization for production deployment
- **Containerization**: Docker-based containerization for consistent deployment
- **Environment Configuration**: Environment variable-based configuration for different deployment scenarios
- **CI/CD**: GitHub Actions for automated testing and deployment

## Testing requirements

- **Unit Testing**: Comprehensive unit tests for both frontend and backend components
- **Integration Testing**: API-level integration tests to verify component interactions
- **E2E Testing**: CodeceptJS for BDD-style end-to-end testing of critical user flows
- **Performance Testing**: Load testing to verify performance under expected user loads
- **Accessibility Testing**: Automated and manual testing for accessibility compliance

## Security Considerations

- **Authentication**: Secure, industry-standard authentication mechanisms
- **Authorization**: Team and role-based access control for all operations
- **Data Protection**: HTTPS/TLS for all data in transit
- **Input Validation**: Thorough validation of all user inputs to prevent injection attacks
- **API Security**: Rate limiting and appropriate security headers

## Browser & Device Support

- **Browsers**: Latest two versions of Chrome, Firefox, Safari, and Edge
- **Minimum Resolution**: 1400×900 pixels
- **Responsive Design**: Optimized for desktop with limited functionality on mobile devices
- **JavaScript Required**: Application requires JavaScript to function
