<!-- Powered by BMAD™ Core -->

# test-design

Create comprehensive test scenarios with appropriate test level recommendations for story implementation.

## Inputs

```yaml
required:
  - story_issue_number: GitHub issue number for the story (e.g., 42)
  - story_title: '{title}' # If missing, derive from issue title
  - story_slug: '{slug}' # If missing, derive from title (lowercase, hyphenated)

optional:
  - github_repo: from `.bmad-core/core-config.yaml` key `github.repo`
  - acceptance_criteria: From story issue body (use `gh issue view {issue_number} --json body`)
```

## Purpose

Design a complete test strategy that identifies what to test, at which level (unit/integration/e2e), and why. This ensures efficient test coverage without redundancy while maintaining appropriate test boundaries.

## Dependencies

```yaml
data:
  - test-levels-framework.md # Unit/Integration/E2E decision criteria
  - test-priorities-matrix.md # P0/P1/P2/P3 classification system
  - gherkin-standards.md # Gherkin scenario writing standards and conventions
  - cucumber-integration.md # Cucumber + Playwright setup and patterns
```

## Process

### 1. Analyze Story Requirements

Break down each acceptance criterion into testable scenarios. For each AC:

- Identify the core functionality to test
- Determine data variations needed
- Consider error conditions
- Note edge cases

### 2. Apply Test Level Framework

**Reference:** Load `test-levels-framework.md` for detailed criteria

Quick rules:

- **Unit**: Pure logic, algorithms, calculations
- **Integration**: Component interactions, DB operations
- **E2E**: Critical user journeys, compliance

### 3. Apply Gherkin/BDD Override Rules

**CRITICAL FIRST CHECK:** Load `test-priorities-matrix.md` for Gherkin override rules

**Mandatory Gherkin Requirements:**
- ALL user-facing stories require comprehensive Gherkin scenarios regardless of priority
- Feature files must exist before development begins
- All scenarios (happy/unhappy/edge/security) must pass before story completion

### 4. Assign Traditional Test Priorities

**Reference:** Load `test-priorities-matrix.md` for classification

Quick priority assignment for non-Gherkin tests:

- **P0**: Revenue-critical, security, compliance
- **P1**: Core user journeys, frequently used
- **P2**: Secondary features, admin functions
- **P3**: Nice-to-have, rarely used

**Note:** Gherkin scenarios override traditional priority classification for user-facing functionality

### 5. Design Test Scenarios

For each identified test need, create:

```yaml
test_scenario:
  id: '{epic}.{story}-{LEVEL}-{SEQ}'
  requirement: 'AC reference'
  priority: P0|P1|P2|P3|GHERKIN-MANDATORY
  level: unit|integration|e2e|gherkin
  description: 'What is being tested'
  justification: 'Why this level was chosen'
  mitigates_risks: ['RISK-001'] # If risk profile exists
  gherkin_coverage: true|false # Indicates if covered by Gherkin scenarios
```

### 6. Validate Coverage

Ensure:

- Every AC with user-observable consequences has Gherkin scenarios
- Every AC has appropriate test coverage (prioritizing Gherkin for user-facing functionality)
- Traditional E2E/integration tests don't duplicate Gherkin scenario coverage
- Security issues have both Gherkin scenarios AND API-level tests
- Critical paths have multiple levels where needed
- Risk mitigations are addressed

## Outputs

### Output 1: Test Design Document

**Save to:** `qa.qaLocation/assessments/{epic}.{story}-test-design-{YYYYMMDD}.md`

```markdown
# Test Design: Story {epic}.{story}

Date: {date}
Designer: Quinn (Test Architect)

## Test Strategy Overview

- Total test scenarios: X
- Gherkin scenarios: G (mandatory for user-facing ACs)
- Unit tests: Y (A%)
- Integration tests: Z (B%) (reduced where Gherkin provides coverage)
- E2E tests: W (C%) (reduced where Gherkin provides coverage)
- Priority distribution: P0: X, P1: Y, P2: Z
- User-facing ACs: {count} (all require Gherkin scenarios)

## Test Scenarios by Acceptance Criteria

### AC1: {description}

#### Scenarios

| ID           | Level       | Priority | Test                      | Justification            |
| ------------ | ----------- | -------- | ------------------------- | ------------------------ |
| 1.3-UNIT-001 | Unit        | P0       | Validate input format     | Pure validation logic    |
| 1.3-INT-001  | Integration | P0       | Service processes request | Multi-component flow     |
| 1.3-E2E-001  | E2E         | P1       | User completes journey    | Critical path validation |

[Continue for all ACs...]

## Risk Coverage

[Map test scenarios to identified risks if risk profile exists]

## Recommended Execution Order

1. **ALL Gherkin scenarios first** (mandatory gate for user-facing stories)
2. P0 Unit tests (fail fast)
3. P0 Integration/API tests (especially for security)
4. P0 E2E tests (only where not covered by Gherkin)
5. P1 tests in order
6. P2+ as time permits
```

### Output 2: Gate YAML Block

Generate for inclusion in quality gate:

```yaml
test_design:
  scenarios_total: X
  gherkin_required: true|false # Based on user-facing ACs
  gherkin_scenarios: G
  by_level:
    unit: Y
    integration: Z (reduced where Gherkin covers)
    e2e: W (reduced where Gherkin covers)
    gherkin: G
  by_priority:
    p0: A
    p1: B
    p2: C
    gherkin_mandatory: G
  coverage_gaps: [] # List any ACs without tests
  gherkin_gaps: [] # List any user-facing ACs without Gherkin scenarios
  security_api_tests: [] # Security scenarios requiring additional API tests
```

### Output 3: Issue Comment

Add comment to story issue:

```bash
gh issue comment {story_issue_number} --body "## Test Design Complete

**Test Design Matrix**: qa.qaLocation/assessments/{epic}.{story}-test-design-{YYYYMMDD}.md
**Total Test Scenarios**: {total}
**Gherkin Scenarios**: {gherkin_count} (mandatory for user-facing ACs)
**Traditional E2E/Integration**: Reduced where Gherkin provides coverage
**Security API Tests**: {security_api_count} (additional to Gherkin for security)
**Coverage Gaps**: {gap_count}

{summary of test strategy emphasizing Gherkin-first approach}"
```

## Quality Checklist

Before finalizing, verify:

- [ ] Every AC with user-observable consequences has Gherkin scenarios
- [ ] Traditional E2E/integration tests don't duplicate Gherkin coverage
- [ ] Security issues have both Gherkin scenarios AND API-level tests
- [ ] Test levels are appropriate (not over-testing)
- [ ] Priorities align with business risk
- [ ] Test IDs follow naming convention
- [ ] Scenarios are atomic and independent
- [ ] Security scenarios included in Gherkin for user inputs

## Key Principles

- **Gherkin First**: ALL user-facing functionality requires Gherkin scenarios (overrides priority)
- **Efficient coverage**: Gherkin scenarios can replace traditional E2E/integration for user-facing ACs
- **Security Exception**: Security issues require both Gherkin scenarios AND API-level tests
- **Shift left**: Prefer unit tests for business logic, Gherkin for user interactions
- **Risk-based**: Focus on what could go wrong
- **Maintainability**: Consider long-term test maintenance
- **Fast feedback**: Gherkin scenarios run first, followed by quick traditional tests
