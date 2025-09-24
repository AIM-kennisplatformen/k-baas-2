<!-- Powered by BMAD™ Core -->

# Gherkin Standards

Project standards and conventions for writing Gherkin feature files and scenarios.

## File Organization

### Directory Structure
```
features/
├── epic1/
│   ├── user-authentication.feature
│   └── user-profile.feature
├── epic2/
│   ├── data-management.feature
│   └── reporting.feature
├── shared/
│   └── common-workflows.feature
└── feature-registry.md
```

### Naming Conventions
- **Feature files**: `{epic-slug}/{story-slug}.feature`
- **Epic slug**: Lowercase, hyphenated, max 20 characters
- **Story slug**: Lowercase, hyphenated, max 30 characters
- **File names**: Descriptive of the main feature/capability

## Feature File Structure

### Standard Template
```gherkin
Feature: {Feature Title}
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
```

## Language Guidelines

### Business Language
- Use domain terminology understood by stakeholders
- Avoid technical implementation details
- Focus on user-observable behavior
- Write from user's perspective

### Step Construction

#### Given Steps (Setup/Context)
```gherkin
# Good - describes state/context
Given I am logged in as a "premium user"
Given the shopping cart contains 3 items
Given the system has the following users:

# Avoid - implementation details
Given the database has user record with ID 123
Given the authentication token is set in localStorage
```

#### When Steps (Actions)
```gherkin
# Good - user actions
When I click on "Add to Cart"
When I enter "john@example.com" in the email field
When I upload a profile picture

# Avoid - system actions
When the API endpoint is called
When the database is updated
```

#### Then Steps (Outcomes/Verification)
```gherkin
# Good - observable outcomes
Then I should see "Item added successfully"
Then I should be redirected to the dashboard
Then the email should be sent to the user

# Avoid - internal system verification
Then the database should contain the record
Then the API should return status 200
```

## Scenario Types and Tags

### Required Scenario Coverage

#### @happy-path
- Primary user journey succeeding as expected
- Valid inputs and normal conditions
- Core functionality working correctly

#### @unhappy-path
- Invalid inputs and validation failures
- System errors and graceful degradation
- Missing or malformed data handling

#### @edge-case
- Boundary conditions (min/max values)
- Empty/null inputs
- Concurrent operations
- Large data sets

#### @security
- Malicious input attempts (SQL injection, XSS)
- Authorization bypass attempts
- Input sanitization validation
- CSRF protection verification

### Additional Tags

#### Execution Tags
```gherkin
@smoke      # Critical path, run first
@regression # Full regression suite
@slow       # Long-running scenarios
@api        # API-level testing
@ui         # UI interaction testing
```

#### Functional Tags
```gherkin
@authentication
@authorization
@data-validation
@file-upload
@payment
@notification
```

## Data Handling

### Parameter Patterns
```gherkin
# String parameters
When I enter "john@example.com" in the email field

# Numeric parameters  
When I set the quantity to 5

# Multiple parameters
When I create a user with name "John Doe" and role "admin"
```

### Data Tables
```gherkin
# Simple data table
Given the following users exist:
  | name     | email           | role  |
  | John Doe | john@email.com  | admin |
  | Jane Doe | jane@email.com  | user  |

# Key-value data table
When I fill the registration form:
  | First Name | John        |
  | Last Name  | Doe         |
  | Email      | john@ex.com |
  | Password   | SecurePass1 |
```

### Doc Strings
```gherkin
When I submit the following JSON data:
  """
  {
    "name": "Test User",
    "email": "test@example.com",
    "preferences": {
      "notifications": true,
      "theme": "dark"
    }
  }
  """
```

## Security Scenario Standards

### Input Validation Testing
```gherkin
@security
Scenario Outline: Reject malicious input in user fields
  Given I am on the user registration page
  When I enter "<malicious_input>" in the "<field>" field
  And I submit the form
  Then I should see an error message containing "<error_type>"
  And the form should not be submitted

  Examples:
    | field     | malicious_input                | error_type        |
    | email     | <script>alert('xss')</script> | Invalid format    |
    | name      | '; DROP TABLE users; --       | Invalid characters|
    | comment   | javascript:alert('xss')       | Invalid content   |
```

### Authorization Testing
```gherkin
@security
Scenario: Prevent unauthorized access to admin features
  Given I am logged in as a "regular user"
  When I attempt to access the admin dashboard directly
  Then I should be redirected to the access denied page
  And I should see "Insufficient privileges" message
```

## Scenario Writing Best Practices

### Atomic Scenarios
- One behavior per scenario
- Independent scenarios (no dependencies)
- Each scenario should be able to run in isolation

### Descriptive Naming
```gherkin
# Good - describes the behavior being tested
Scenario: Display validation error when email format is invalid
Scenario: Redirect to login page when session expires
Scenario: Show success message after password reset

# Avoid - generic or unclear descriptions
Scenario: Test email validation
Scenario: Check session
Scenario: Password functionality
```

### Background Usage
```gherkin
# Use Background for common setup across ALL scenarios
Background:
  Given I am logged in as a "standard user"
  And I am on the dashboard page

# Don't use Background for setup needed by only some scenarios
```

### Scenario Outlines
```gherkin
# Use for testing multiple variations of the same behavior
Scenario Outline: Validate required fields in contact form
  Given I am on the contact form
  When I leave the "<field>" field empty
  And I submit the form
  Then I should see a validation error for "<field>"

  Examples:
    | field   |
    | name    |
    | email   |
    | message |
```

## Quality Standards

### Review Checklist
- [ ] Feature title clearly describes the capability
- [ ] User story format in feature description
- [ ] All four scenario types present (where applicable)
- [ ] Business language used (no technical implementation)
- [ ] Scenarios are atomic and independent
- [ ] Appropriate tags applied
- [ ] Security scenarios included for user inputs
- [ ] Data tables properly formatted
- [ ] Scenario names are descriptive

### Common Anti-Patterns to Avoid
- Testing implementation details instead of behavior
- Scenarios that depend on other scenarios
- Overly technical language
- Missing security scenarios for user inputs
- Generic scenario names
- Mixing multiple behaviors in one scenario

## Integration with Development

### Definition of Ready for Features
Before development begins:
- [ ] Feature file exists with comprehensive scenarios
- [ ] All acceptance criteria covered by scenarios
- [ ] Security scenarios included for user inputs
- [ ] Step definitions created (even if not implemented)
- [ ] Feature file reviewed and approved

### Execution Requirements
- All scenarios must pass before story can be marked "Review"
- Security scenarios are mandatory for user-facing features
- Feature files serve as living documentation
- Failed scenarios must be fixed, not disabled