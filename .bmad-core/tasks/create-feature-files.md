<!-- Powered by BMAD™ Core -->

# create-feature-files

Create comprehensive Gherkin feature files from story acceptance criteria with scenarios covering happy path, unhappy paths, edge cases, and malicious user input.

## Inputs

```yaml
required:
  - story_issue_number: GitHub issue number for the story (e.g., 42)
  - story_title: '{title}' # If missing, derive from issue title
  - story_slug: '{slug}' # If missing, derive from title (lowercase, hyphenated)

optional:
  - github_repo: from `.bmad-core/core-config.yaml` key `github.repo`
  - acceptance_criteria: From story issue body (use `gh issue view {issue_number} --json body`)
  - epic_number: For feature file organization
```

## Purpose

Generate comprehensive Gherkin feature files that translate acceptance criteria into executable scenarios. This ensures every user-observable behavior is captured with appropriate test coverage including edge cases and security considerations, following TDD principles where features are defined before implementation.

## Dependencies

```yaml
data:
  - gherkin-standards.md # Project Gherkin syntax and conventions
  - cucumber-integration.md # Step definition patterns and execution setup
```

## Process

### 1. Analyze Story and Acceptance Criteria

- Load story issue using `gh issue view {story_issue_number} --json body,title`
- Parse acceptance criteria from issue body
- Identify which acceptance criteria have user-observable consequences
- For infrastructure/refactoring stories, determine if feature files are needed

### 2. Apply Gherkin Standards

**Reference:** Load `gherkin-standards.md` for project conventions

Key principles:
- Use Business-readable language (not technical implementation details)
- Follow Given-When-Then structure consistently
- Create atomic scenarios (one behavior per scenario)
- Use Scenario Outline for data variations

### 3. Generate Comprehensive Scenarios

For each acceptance criterion with user-observable consequences, create:

#### Happy Path Scenarios
- Primary user journey succeeding as expected
- Valid inputs and expected outputs
- Normal operating conditions

#### Unhappy Path Scenarios
- Invalid inputs and validation failures
- System errors and graceful degradation
- Missing or malformed data handling
- Network/service failures

#### Edge Case Scenarios
- Boundary conditions (min/max values)
- Empty/null inputs
- Concurrent operations
- Large data sets or unusual data patterns

#### Malicious Input Scenarios
- SQL injection attempts
- XSS attack vectors
- CSRF protection validation
- Authorization bypass attempts
- Input sanitization validation

### 4. Structure Feature Files

```gherkin
Feature: {Feature Title from Story}
  As a {role}
  I want {capability}
  So that {benefit}

  Background:
    Given {common setup conditions}

  @happy-path @smoke
  Scenario: {Happy path description}
    Given {preconditions}
    When {user action}
    Then {expected outcome}

  @unhappy-path
  Scenario: {Error condition description}
    Given {preconditions}
    When {invalid action}
    Then {error handling expected}

  @edge-case
  Scenario: {Boundary condition description}
    Given {edge condition setup}
    When {boundary action}
    Then {boundary behavior expected}

  @security
  Scenario: {Security test description}
    Given {security test setup}
    When {malicious input attempted}
    Then {security response expected}

  @data-driven
  Scenario Outline: {Parameterized test description}
    Given {setup with <parameter>}
    When {action with <input>}
    Then {expected <result>}

    Examples:
      | parameter | input | result |
      | value1    | data1 | output1|
      | value2    | data2 | output2|
```

### 5. Validate Scenario Coverage

Ensure:
- Every AC with user-observable consequences has scenarios
- All four scenario types are represented where applicable
- No duplicate scenario coverage
- Business language (not technical implementation)
- Scenarios are independent and atomic

## Outputs

### Output 1: Feature Files

**Save to:** `tests/features/{epic_slug}/{story_slug}.feature`

```gherkin
# Complete feature file with comprehensive scenarios
# Following project gherkin-standards.md conventions
# Tagged appropriately for test execution
```

### Output 2: Feature File Registry

**Update:** `tests/features/feature-registry.md`

```markdown
## Story {epic_num}.{story_num}: {story_title}

- **Feature File:** `tests/features/{epic_slug}/{story_slug}.feature`
- **Scenarios Created:** {total_count}
  - Happy Path: {happy_count}
  - Unhappy Path: {unhappy_count}
  - Edge Cases: {edge_count}
  - Security: {security_count}
- **Coverage:** {ac_covered}/{total_acs} Acceptance Criteria
- **Status:** Created (awaiting step definitions)
```

### Output 3: Issue Comment

Add comment to story issue:

```bash
gh issue comment {story_issue_number} --body "## Gherkin Feature Files Created

**Feature File:** \`tests/features/{epic_slug}/{story_slug}.feature\`
**Total Scenarios:** {total}
**Coverage Types:**
- ✅ Happy Path: {happy_count} scenarios
- ❌ Unhappy Path: {unhappy_count} scenarios  
- 🔍 Edge Cases: {edge_count} scenarios
- 🔒 Security: {security_count} scenarios

**Next Steps:** 
1. Create step definitions using \`*step-defs {story}\`
2. Begin development only after step definitions are complete

**AC Coverage:** {covered_acs}/{total_acs} acceptance criteria with user-observable consequences"
```

## Quality Checklist

Before finalizing, verify:

- [ ] All user-observable ACs have feature scenarios
- [ ] Happy, unhappy, edge, and security scenarios created where applicable
- [ ] Gherkin syntax follows project standards
- [ ] Business language used (not technical implementation)
- [ ] Scenarios are atomic and independent
- [ ] Appropriate tags applied for test execution
- [ ] Feature file follows naming conventions

## Key Principles

- **User-Observable Focus**: Only create features for behaviors users can observe
- **Comprehensive Coverage**: Four scenario types ensure thorough testing
- **Business Language**: Features should be readable by non-technical stakeholders
- **TDD Compliance**: Features define behavior before implementation
- **Security First**: Include malicious input scenarios for all user inputs