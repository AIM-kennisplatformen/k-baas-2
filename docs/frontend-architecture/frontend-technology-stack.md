# Frontend Technology Stack

This section defines the exact frontend technologies and versions. All choices are aligned with the backend architecture and optimized for the split-view knowledge graph interface.

## Core Framework & Language

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| **Language** | JavaScript | ES2023 | Primary development language | Specified in PRD, faster development without TypeScript overhead, team preference |
| **Framework** | React | 19 | UI framework | Latest stable version, improved concurrent features, server components support |
| **Build Tool** | Vite | 7.1 | Development and build tooling | Fast HMR, optimized builds, excellent React 19 support |

## UI Framework & Styling

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| **CSS Framework** | Tailwind CSS | 4.1 | Utility-first styling | Latest version with improved performance, design system foundation |
| **Component Library** | Shadcn/ui | 3.3 | Base UI components | Accessible, customizable, Tailwind-native, excellent DX |
| **Icons** | Lucide React | 0.544 | Icon system | Consistent with Shadcn/ui, customizable, lightweight |

## Specialized Libraries

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| **Text Editor** | Lexical | 0.35 | Rich text wiki editing | Extensible, performant, excellent React integration, entity linking support |
| **Graph Visualization** | React Flow | 12.8 | Knowledge graph interface | Mature graph editing library, direct manipulation, customizable nodes/edges |
| **State Management** | Jotai | 2.10 | Atomic state management | Bottom-up state, minimal re-renders, perfect for real-time collaboration |

## Real-time & API Integration

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| **WebSocket Client** | Socket.io Client | 4.8 | Real-time collaboration | Matches backend Socket.io implementation, reliable real-time features |
| **HTTP Client** | Fetch API | Native | API communication | Modern native browser API, direct integration with Jotai atoms |

## Development & Testing

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| **Testing Framework** | Vitest | 3.2 | Unit testing | Fast, Vite-native, excellent React testing utilities |
| **Component Testing** | React Testing Library | 16.3 | Component testing | User-centric testing approach, accessibility focus |
| **E2E Testing** | Playwright | 1.54 | End-to-end testing | Cross-browser testing, visual regression, real user scenarios |
| **Code Quality** | ESLint | 9.36 | JavaScript linting | Code quality enforcement, React-specific rules |
| **Formatting** | Prettier | 3.6 | Code formatting | Consistent code style, automatic formatting |

## Key Technology Integrations

**React 19 + Jotai Integration:**
- Concurrent features for responsive UI during real-time updates
- Atomic state subscriptions for granular component updates
- Direct fetch integration without additional query libraries

**Lexical + Entity Linking:**
- Custom plugins for wiki-link syntax detection ([[Entity Name]])
- Real-time entity suggestion as user types
- Automatic graph synchronization when wiki links are created

**React Flow + Direct Manipulation:**
- Custom node components for concept visualization
- Grid snapping and auto-layout algorithms
- Drag-and-drop relationship creation between concepts

**Socket.io + Optimistic Updates:**
- Client-side optimistic state updates for immediate feedback
- Conflict resolution when multiple users edit the same content
- Presence indicators showing other users' cursor positions

**Tailwind + Design System:**
- Custom design tokens for knowledge graph visualization
- Dark/light mode support with CSS custom properties
- Responsive breakpoints optimized for desktop-first design

## Browser Compatibility

**Target Browsers:**
- All major desktop browsers less than 1 year old: Chromium-based, Gecko-based, Safari
- Minimum resolution: 1400×900 pixels

**Required Features:**
- ES2023 JavaScript support
- CSS Grid and Flexbox
- WebSocket API
- Local Storage API
- Canvas API (for React Flow)

**Application Requirements:**
- JavaScript required for all functionality
- No fallback for non-JavaScript environments
- Modern browser features assumed available
