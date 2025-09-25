# Starter Template or Existing Project

**Decision**: No starter template will be used for the frontend. The React application will be built from scratch using the specified technology stack.

**Rationale**: The unique requirements for the split-view interface (wiki editor + graph visualization), real-time collaboration, and the specific combination of Lexical editor with React Flow graph manipulation require a custom implementation. Using a starter template would likely introduce constraints that conflict with the specialized UI/UX requirements.

**Manual Setup Required**: All frontend tooling and configuration will be established manually, including:
- React 19 application structure with JavaScript (not TypeScript)
- Tailwind 4 configuration with custom design system
- Shadcn/ui component integration and customization
- Lexical editor setup with custom plugins for entity linking
- React Flow configuration for knowledge graph visualization
- Jotai state management architecture
- Socket.io client integration for real-time features
