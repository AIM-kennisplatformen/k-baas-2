# Starter Template or Existing Project

**Decision**: No starter template will be used for this project. The application will be built from scratch following the specified directory structure and technology stack.

**Rationale**: Given the specific requirements for TypeDB integration, real-time collaboration, and the unique combination of wiki + knowledge graph functionality, a custom implementation provides better control over architecture decisions and avoids potential constraints from existing templates.

**Manual Setup Required**: All tooling and configuration will be established manually, including:
- FastAPI application structure with proper dependency injection
- TypeDB schema generation from Pydantic models
- Socket.io integration for real-time collaboration
- Custom authentication and authorization patterns
- Specialized document processing pipeline
