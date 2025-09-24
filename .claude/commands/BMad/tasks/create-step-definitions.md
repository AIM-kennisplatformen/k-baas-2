<!-- Powered by BMAD™ Core -->

# create-step-definitions

Create Cucumber step definitions for Gherkin feature files using Playwright for browser interactions, providing the implementation scaffolding that connects scenarios to actual test code.

## Inputs

```yaml
required:
  - story_issue_number: GitHub issue number for the story (e.g., 42)
  - feature_file_path: Path to the Gherkin feature file (e.g., features/epic1/user-auth.feature)

optional:
  - tech_stack: from `.bmad-core/core-config.yaml` key `techStack`
  - test_framework: Cucumber implementation (cucumber-js with Playwright)
  - step_definition_language: JavaScript, TypeScript (with Playwright)
```

## Purpose

Generate comprehensive step definition files that provide the implementation scaffolding for Gherkin scenarios using Playwright for browser automation. Step definitions bridge the gap between business-readable scenarios and executable test code, following project conventions and Playwright best practices.

## Dependencies

```yaml
data:
  - cucumber-integration.md # Step definition patterns and Playwright setup
  - technical-preferences.md # Project tech stack and testing preferences
  - gherkin-standards.md # For understanding scenario patterns
```

## Process

### 1. Analyze Feature File

- Read the Gherkin feature file from the provided path
- Extract all unique step patterns (Given, When, Then statements)
- Identify parameter patterns and data tables
- Group similar steps for reusable step definitions

### 2. Apply Tech Stack Standards

**Reference:** Load `technical-preferences.md` and `cucumber-integration.md`

Determine:
- Programming language for step definitions (JavaScript/TypeScript)
- Playwright configuration and browser setup
- File organization and naming conventions
- Import/require patterns for Playwright and Cucumber

### 3. Generate Step Definition Templates with Playwright

For each unique step pattern, create:

#### Basic Step Definition Structure with Playwright
```javascript
// Example for JavaScript/TypeScript with Playwright
const { Given, When, Then } = require('@cucumber/cucumber');
const { expect } = require('@playwright/test');

Given('I am a {string}', async function(userRole) {
  // TODO: Implement user role setup with Playwright
  // Reference: AC{number} - {acceptance_criteria_text}
  // Example: await this.page.goto('/login');
  // await this.loginAsRole(userRole);
  throw new Error('Step definition pending implementation');
});

When('I navigate to {string}', async function(url) {
  // TODO: Implement navigation with Playwright
  // Reference: AC{number} - {acceptance_criteria_text}
  // await this.page.goto(url);
  throw new Error('Step definition pending implementation');
});

When('I click on {string}', async function(elementText) {
  // TODO: Implement click action with Playwright
  // await this.page.click(`text=${elementText}`);
  throw new Error('Step definition pending implementation');
});

Then('I should see {string}', async function(expectedText) {
  // TODO: Implement assertion with Playwright
  // Reference: AC{number} - {acceptance_criteria_text}
  // await expect(this.page.locator(`text=${expectedText}`)).toBeVisible();
  throw new Error('Step definition pending implementation');
});
```

#### Form Interaction Steps with Playwright
```javascript
When('I enter {string} in the {string} field', async function(value, fieldName) {
  // TODO: Implement form field interaction with Playwright
  // await this.page.fill(`[data-testid="${fieldName}"]`, value);
  // or await this.page.fill(`input[name="${fieldName}"]`, value);
  throw new Error('Step definition pending implementation');
});

When('I select {string} from the {string} dropdown', async function(option, dropdownName) {
  // TODO: Implement dropdown selection with Playwright
  // await this.page.selectOption(`select[name="${dropdownName}"]`, option);
  throw new Error('Step definition pending implementation');
});

When('I upload {string} to the {string} file input', async function(fileName, inputName) {
  // TODO: Implement file upload with Playwright
  // await this.page.setInputFiles(`input[name="${inputName}"]`, fileName);
  throw new Error('Step definition pending implementation');
});
```

#### Security Test Steps with Playwright
```javascript
When('I attempt to inject {string} into {string}', async function(maliciousInput, fieldName) {
  // TODO: Implement security test with Playwright
  // await this.page.fill(`[data-testid="${fieldName}"]`, maliciousInput);
  // Store the malicious input for verification
  this.maliciousInput = maliciousInput;
  throw new Error('Security step definition pending implementation');
});

Then('the system should reject the input with {string}', async function(errorType) {
  // TODO: Assert security protection with Playwright
  // await expect(this.page.locator('.error-message')).toContainText(errorType);
  // Verify malicious input was sanitized/rejected
  throw new Error('Security assertion pending implementation');
});

Then('I should be redirected to the login page', async function() {
  // TODO: Assert unauthorized access redirect with Playwright
  // await expect(this.page).toHaveURL(/.*\/login/);
  throw new Error('Security redirect assertion pending implementation');
});
```

#### Data Table Handling with Playwright
```javascript
Given('I have the following user data:', async function(dataTable) {
  // TODO: Process data table input with Playwright
  // const users = dataTable.hashes();
  // for (const user of users) {
  //   await this.createUser(user);
  // }
  throw new Error('Data table step definition pending implementation');
});

When('I fill the form with:', async function(dataTable) {
  // TODO: Fill form using data table with Playwright
  // const formData = dataTable.rowsHash();
  // for (const [field, value] of Object.entries(formData)) {
  //   await this.page.fill(`[data-testid="${field}"]`, value);
  // }
  throw new Error('Form data table step pending implementation');
});
```

### 4. Organize Step Definitions by Domain

Group step definitions into logical files:
- `tests/steps/common-steps.js` - Shared navigation, authentication steps
- `tests/steps/{feature-domain}-steps.js` - Feature-specific interactions
- `tests/steps/security-steps.js` - Security testing with malicious inputs
- `tests/steps/form-steps.js` - Form interactions and validations

### 5. Add Playwright Setup and Hooks

Include necessary setup for Playwright integration:

```javascript
// hooks.js - Playwright setup for Cucumber
const { Before, After } = require('@cucumber/cucumber');
const { chromium } = require('@playwright/test');

Before(async function() {
  // TODO: Setup Playwright browser and page
  // this.browser = await chromium.launch();
  // this.context = await this.browser.newContext();
  // this.page = await this.context.newPage();
});

After(async function() {
  // TODO: Cleanup Playwright resources
  // await this.page.close();
  // await this.context.close();
  // await this.browser.close();
});
```

## Outputs

### Output 1: Step Definition Files

**Save to:** `tests/steps/{domain}-steps.js` (JavaScript/TypeScript with Playwright)

```javascript
// Complete step definition file with:
// - Playwright imports and setup
// - All unique steps from feature file
// - Async/await patterns for Playwright
// - Proper locator strategies
// - TODO implementation guidance
// - Security step definitions with browser automation
```

### Output 2: Playwright Hooks Setup

**Save to:** `tests/support/hooks.js`

```javascript
// Playwright browser lifecycle management
// Setup and teardown for each scenario
// Browser context and page management
// Screenshot capture on failures
```

### Output 3: Step Definition Registry

**Update:** `tests/steps/step-registry.md`

```markdown
## Story {epic_num}.{story_num}: {story_title}

- **Feature File:** `{feature_file_path}`
- **Step Definition Files:**
  - `tests/steps/{domain}-steps.js` (Playwright-based)
  - `tests/steps/security-steps.js` (Playwright security tests)
- **Playwright Setup:** `tests/support/hooks.js`
- **Step Definitions Created:** {total_count}
  - Given steps: {given_count}
  - When steps: {when_count}
  - Then steps: {then_count}
- **Implementation Status:** Templates created (pending Playwright implementation)
- **Security Steps:** {security_count} Playwright security test steps
```

### Output 4: Issue Comment

Add comment to story issue:

```bash
gh issue comment {story_issue_number} --body "## Cucumber Step Definitions with Playwright Created

**Step Definition Files:**
- \`tests/steps/{domain}-steps.js\` (Playwright-based)
- \`tests/steps/security-steps.js\` (Playwright security tests)
- \`tests/support/hooks.js\` (Playwright setup)

**Step Definitions Generated:** {total}
- Given steps: {given_count} (async with Playwright)
- When steps: {when_count} (browser interactions)
- Then steps: {then_count} (assertions with Playwright)
- Security steps: {security_count} (malicious input testing)

**Implementation Status:** 🟡 Templates created (pending Playwright implementation)

**Technology Stack:** Cucumber.js + Playwright for browser automation

**Next Steps:**
1. Implement step definitions using Playwright API
2. Configure browser setup in hooks
3. Run feature scenarios to verify Playwright automation
4. Begin story development only after step definitions are working

**Developer Notes:** All step definitions use async/await patterns for Playwright. Security scenarios include browser-based attack simulation."
```

## Quality Checklist

Before finalizing, verify:

- [ ] All unique steps from feature file have Playwright-based definitions
- [ ] Step definitions use async/await patterns for Playwright
- [ ] Proper Playwright locator strategies included
- [ ] Browser lifecycle hooks created
- [ ] Security steps include browser-based attack simulation
- [ ] TODO comments provide Playwright-specific implementation guidance
- [ ] Step definitions organized logically by domain
- [ ] Playwright imports and setup correctly configured

## Key Principles

- **Playwright Integration**: All browser interactions use Playwright API
- **Async Patterns**: Step definitions use async/await for Playwright operations
- **Locator Strategies**: Use data-testid attributes and semantic selectors
- **Security Testing**: Browser-based malicious input and attack simulation
- **Browser Lifecycle**: Proper setup/teardown of browser contexts
- **Implementation Guidance**: Clear TODO comments with Playwright examples