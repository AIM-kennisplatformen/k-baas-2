# Testing Strategy

## Testing Philosophy

**Approach:** Test-Driven Development (TDD) for all user-observable behavior using Cucumber/Gherkin scenarios with Playwright automation. Appropriate test selection (E2E/Integration/API/Unit) based on feature complexity and requirements coverage.

**Coverage Goals:** 90% coverage for user-observable behavior through BDD scenarios, 85% code coverage for internal business logic

## Test Organization

### Behavior-Driven Development (Primary)
- **Framework:** Cucumber/Gherkin scenarios with Playwright automation
- **Scope:** All user-observable behavior and acceptance criteria
- **Location:** `backend/tests/bdd/` with feature files and step definitions
- **Coverage:** Complete user workflows, multi-user collaboration, knowledge base operations

### Integration Tests
- **Database Testing:** TestContainers with TypeDB for isolated test databases
- **API Testing:** FastAPI TestClient for endpoint testing
- **Multi-Database Testing:** Verify core DB and KB DB interactions
- **OAuth Testing:** Mock OAuth providers with realistic token flows

### Unit Tests
- **Framework:** pytest 8.4 with pytest-asyncio 1.2 for async support
- **Scope:** Internal business logic, utilities, and helper functions not covered by BDD
- **Mocking:** Mock TypeDB connections, external LLM APIs, OAuth providers
- **Location:** `backend/tests/unit/` mirroring source structure

## Test Data Management

**Multi-Database Test Strategy:**
- Separate test instances for core database and knowledge base databases
- Factory pattern for creating test users, teams, and knowledge bases
- Automated cleanup of test databases after test completion
- Realistic test data reflecting domain-specific schemas
