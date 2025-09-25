# Frontend Testing and Build Strategies

## Testing Philosophy (BMAD-Aligned)

**Behavior-Driven Development (BDD) as Primary:**
- All user-observable behavior is driven by **Gherkin scenarios** automated with **Playwright**. These tests are located in the project root's `tests/features` directory and are the primary validation gate for features.

**Component and Unit Testing:**
- **Vitest** and **React Testing Library** are used for component-level and unit tests to cover internal frontend logic, rendering, and hooks that are not covered by the BDD scenarios.

## Test Organization

### BDD / E2E Tests (Playwright & Gherkin)
- **Location:** `tests/features/` (Project Root). This single, top-level directory contains all BDD tests for the entire application.
- **Scope:** Complete user workflows, including real-time collaboration and wiki-to-graph sync.
- **Features:** Gherkin `.feature` files describing user stories.
- **Steps:** Playwright step definitions located in `tests/steps/`.

### Component & Unit Tests (Vitest)
- **Location:** `frontend/src/` (Co-located with the components, e.g., `MyComponent.test.js`).
- **Scope:** Individual React components, custom hooks, and utility functions.
- **Mocking:** Mock dependencies like the backend API (`fetch`) and the `socket.io` client.

## CI/CD Pipeline (BMAD-Aligned)

**GitHub Actions Workflow:**
1.  **Install Dependencies:**
    - `uv` is used for backend Python dependencies.
    - `npm install` is run inside the `frontend/` directory for its dependencies.
    - The BDD test suite in `tests/` is run using `deno` or `bun` and has its own dependency management.
2.  **Lint & Format:** ESLint and Prettier are run for frontend code quality.
3.  **Run Tests (Sequential Execution):**
    -   Run BDD tests from the project root (e.g., `bun test:bdd`).
    -   Run frontend unit tests from the `frontend/` directory (e.g., `npm run test:unit`).
    -   Run frontend component tests from the `frontend/` directory (e.g., `npm run test:component`).
4.  **Build Docker Image:** A production-optimized Docker image is created for the frontend.
5.  **Deploy:** The image is pushed to a container registry and deployed to staging/production.

## Build and Deployment Process

**Development Environment:**
- **Vite** is used for its fast Hot Module Replacement (HMR).

**Production Build:**
- **Vite** creates an optimized production build.
- **Docker** containerizes the frontend, serving static files with a lightweight web server like Nginx.
