# Initial Architect Prompt

Based on our discussions and requirements analysis for the Knowledge Graph Wiki Tool, I've compiled the following technical guidance to inform your architecture analysis and decisions to kick off Architecture Creation Mode:

## Technical Infrastructure

- **Repository & Service Architecture Decision:** Single repository structure containing both frontend and backend applications without monorepo management tools.
- **Starter Project/Template:** None specified; the project will be built from scratch following the defined structure.
- **Hosting/Cloud Provider:** To be determined, but the application will be containerized for deployment flexibility.
- **Frontend Platform:** React 19 with JavaScript, Tailwind 4, Shadcn/ui, Lexical for text editing, and React Flow for graph visualization.
- **Backend Platform:** Python 3.14 with FastAPI, python-socketio for WebSockets, and Pydantic for schema definition.
- **Database Requirements:** TypeDB 3.3 with connection code to be provided.

## Technical Constraints

- Must use the specified technology stack (React, FastAPI, TypeDB, etc.)
- Must support real-time collaboration via Socket.io
- Must integrate with both external and self-hosted LLMs
- Must generate TypeDB schema files from Pydantic definitions
- Must support document processing for various formats (PDF, DOCX, EPUB, Markdown, images, audio)
- Must implement grid-snapping and auto-layout for graph visualization

## Deployment Considerations

- Containerized deployment using Docker
- CI/CD through GitHub Actions
- Environment configuration via environment variables
- Support for different deployment environments (development, staging, production)

## Local Development & Testing Requirements

- Local development environment using Docker Compose
- E2E testing with CodeceptJS
- Unit testing for both frontend and backend components
- Performance testing for graph visualization with large datasets

## Other Technical Considerations

- Security implementation for team and role-based access control
- Real-time collaboration architecture with conflict resolution
- Efficient TypeDB query patterns for graph visualization and navigation
- Document processing pipeline for knowledge extraction
- Integration with LLM services for AI assistance features
- Commenting and discussion system implementation

Please analyze these requirements and constraints to develop a comprehensive architecture that addresses the functional and non-functional requirements while providing a solid foundation for development.
