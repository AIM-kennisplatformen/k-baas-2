<!-- Powered by BMAD™ Core -->

# Cucumber Integration

Technical setup and integration patterns for Cucumber with Playwright browser automation.

## Technology Stack

### Core Dependencies
```json
{
  "devDependencies": {
    "@cucumber/cucumber": "^10.0.0",
    "@playwright/test": "^1.40.0",
    "playwright": "^1.40.0",
    "cucumber-html-reporter": "^7.1.0",
    "multiple-cucumber-html-reporter": "^3.5.0"
  }
}
```

### Project Structure
```
tests/
├── features/
│   ├── epic1/
│   │   └── user-auth.feature
│   └── epic2/
│       └── data-mgmt.feature
├── steps/
│   ├── common-steps.js
│   ├── auth-steps.js
│   ├── security-steps.js
│   └── form-steps.js
├── support/
│   ├── hooks.js
│   ├── world.js
│   └── config.js
├── reports/
├── screenshots/
└── cucumber.config.js
```

## Configuration Setup

### Cucumber Configuration
**File:** `cucumber.config.js`

```javascript
const config = {
  // Feature file patterns
  features: [
    'tests/features/**/*.feature'
  ],
  
  // Step definition patterns
  steps: [
    'tests/steps/**/*.js'
  ],
  
  // Support files
  support: [
    'tests/support/**/*.js'
  ],
  
  // Formatters and reporters
  formatters: [
    'progress-bar',
    'json:tests/reports/cucumber-report.json',
    'html:tests/reports/cucumber-report.html'
  ],
  
  // Parallel execution
  parallel: 2,
  
  // Retry failed scenarios
  retry: 1,
  
  // Tags for selective execution
  tags: process.env.CUCUMBER_TAGS || '@smoke',
  
  // World parameters for sharing data between steps
  worldParameters: {
    baseUrl: process.env.BASE_URL || 'http://localhost:3000',
    headless: process.env.HEADLESS !== 'false',
    browser: process.env.BROWSER || 'chromium',
    timeout: parseInt(process.env.TIMEOUT) || 30000
  }
};

module.exports = config;
```

### Playwright Browser Setup
**File:** `tests/support/hooks.js`

```javascript
const { Before, After, BeforeAll, AfterAll, Status } = require('@cucumber/cucumber');
const { chromium, firefox, webkit } = require('@playwright/test');

// Global browser instance
let browser;

BeforeAll(async function() {
  // Launch browser once for all scenarios
  const browserType = this.parameters.browser || 'chromium';
  const headless = this.parameters.headless !== false;
  
  switch(browserType) {
    case 'firefox':
      browser = await firefox.launch({ headless });
      break;
    case 'webkit':
      browser = await webkit.launch({ headless });
      break;
    default:
      browser = await chromium.launch({ headless });
  }
});

Before(async function() {
  // Create new context and page for each scenario
  this.context = await browser.newContext({
    // Browser context options
    viewport: { width: 1280, height: 720 },
    ignoreHTTPSErrors: true,
    
    // Record video for failed scenarios
    recordVideo: {
      dir: 'tests/reports/videos/',
      size: { width: 1280, height: 720 }
    },
    
    // Take screenshots on failure
    recordHar: {
      path: `tests/reports/har/${this.pickle.name}.har`
    }
  });
  
  this.page = await this.context.newPage();
  
  // Set default timeout
  this.page.setDefaultTimeout(this.parameters.timeout || 30000);
  
  // Navigate to base URL if provided
  const baseUrl = this.parameters.baseUrl;
  if (baseUrl) {
    await this.page.goto(baseUrl);
  }
});

After(async function(scenario) {
  // Take screenshot on failure
  if (scenario.result.status === Status.FAILED) {
    const screenshot = await this.page.screenshot({
      path: `tests/screenshots/${scenario.pickle.name}-failed.png`,
      fullPage: true
    });
    
    // Attach screenshot to report
    this.attach(screenshot, 'image/png');
  }
  
  // Cleanup page and context
  await this.page.close();
  await this.context.close();
});

AfterAll(async function() {
  // Close browser after all scenarios
  if (browser) {
    await browser.close();
  }
});
```

### Custom World Class
**File:** `tests/support/world.js`

```javascript
const { setWorldConstructor } = require('@cucumber/cucumber');

class CustomWorld {
  constructor(options) {
    this.parameters = options.parameters;
    this.attach = options.attach;
    this.log = options.log;
    
    // Store test data between steps
    this.testData = {};
    
    // Store UI elements for reuse
    this.elements = {};
    
    // Store security test data
    this.securityTestData = {};
  }
  
  // Helper method for storing form data
  setFormData(key, value) {
    if (!this.testData.formData) {
      this.testData.formData = {};
    }
    this.testData.formData[key] = value;
  }
  
  // Helper method for getting form data
  getFormData(key) {
    return this.testData.formData?.[key];
  }
  
  // Helper method for storing security test inputs
  setSecurityInput(inputType, value) {
    this.securityTestData[inputType] = value;
  }
  
  // Helper method for getting security test inputs
  getSecurityInput(inputType) {
    return this.securityTestData[inputType];
  }
  
  // Helper method for waiting with custom timeout
  async waitFor(condition, timeout = 5000) {
    await this.page.waitForFunction(condition, { timeout });
  }
  
  // Helper method for taking screenshots
  async takeScreenshot(name) {
    const screenshot = await this.page.screenshot({
      path: `tests/screenshots/${name}.png`,
      fullPage: true
    });
    this.attach(screenshot, 'image/png');
  }
}

setWorldConstructor(CustomWorld);
```

## Step Definition Patterns

### Common Playwright Patterns
**File:** `tests/steps/common-steps.js`

```javascript
const { Given, When, Then } = require('@cucumber/cucumber');
const { expect } = require('@playwright/test');

// Navigation steps
Given('I am on the {string} page', async function(pageName) {
  const urls = {
    'home': '/',
    'login': '/login',
    'dashboard': '/dashboard',
    'profile': '/profile'
  };
  
  const url = urls[pageName.toLowerCase()] || `/${pageName}`;
  await this.page.goto(url);
});

When('I navigate to {string}', async function(url) {
  await this.page.goto(url);
});

When('I click on {string}', async function(elementText) {
  await this.page.click(`text=${elementText}`);
});

When('I click the {string} button', async function(buttonText) {
  await this.page.click(`button:has-text("${buttonText}")`);
});

// Form interaction steps
When('I enter {string} in the {string} field', async function(value, fieldName) {
  // Try different selector strategies
  const selectors = [
    `[data-testid="${fieldName}"]`,
    `input[name="${fieldName}"]`,
    `input[placeholder*="${fieldName}"]`,
    `label:has-text("${fieldName}") >> input`
  ];
  
  for (const selector of selectors) {
    try {
      await this.page.fill(selector, value);
      return;
    } catch (error) {
      // Try next selector
    }
  }
  
  throw new Error(`Could not find field: ${fieldName}`);
});

When('I select {string} from the {string} dropdown', async function(option, dropdownName) {
  await this.page.selectOption(`[data-testid="${dropdownName}"]`, option);
});

// Assertion steps
Then('I should see {string}', async function(expectedText) {
  await expect(this.page.locator(`text=${expectedText}`)).toBeVisible();
});

Then('I should not see {string}', async function(unexpectedText) {
  await expect(this.page.locator(`text=${unexpectedText}`)).not.toBeVisible();
});

Then('I should be on the {string} page', async function(expectedPage) {
  const currentUrl = this.page.url();
  expect(currentUrl).toContain(expectedPage);
});
```

### Security Step Patterns
**File:** `tests/steps/security-steps.js`

```javascript
const { When, Then } = require('@cucumber/cucumber');
const { expect } = require('@playwright/test');

// Malicious input testing
When('I attempt to inject {string} into the {string} field', async function(maliciousInput, fieldName) {
  this.setSecurityInput('injectionAttempt', maliciousInput);
  this.setSecurityInput('targetField', fieldName);
  
  await this.page.fill(`[data-testid="${fieldName}"]`, maliciousInput);
});

When('I submit the form with malicious data', async function() {
  await this.page.click('button[type="submit"]');
});

Then('the system should reject the input', async function() {
  // Check for validation error
  const errorMessage = await this.page.locator('.error, .validation-error, [data-testid="error"]');
  await expect(errorMessage).toBeVisible();
});

Then('the system should sanitize the input', async function() {
  const maliciousInput = this.getSecurityInput('injectionAttempt');
  
  // Verify malicious input is not executed/displayed
  await expect(this.page.locator(`text=${maliciousInput}`)).not.toBeVisible();
});

// Authorization testing
When('I attempt to access {string} without authorization', async function(restrictedUrl) {
  await this.page.goto(restrictedUrl);
});

Then('I should be redirected to the login page', async function() {
  await expect(this.page).toHaveURL(/.*\/login/);
});

Then('I should see an access denied message', async function() {
  await expect(this.page.locator('text=Access Denied')).toBeVisible();
});
```

## Test Execution

### NPM Scripts
**File:** `package.json`

```json
{
  "scripts": {
    "test:cucumber": "cucumber-js",
    "test:smoke": "cucumber-js --tags @smoke",
    "test:security": "cucumber-js --tags @security",
    "test:regression": "cucumber-js --tags '@smoke or @regression'",
    "test:parallel": "cucumber-js --parallel 4",
    "test:headed": "HEADLESS=false cucumber-js",
    "test:chrome": "BROWSER=chromium cucumber-js",
    "test:firefox": "BROWSER=firefox cucumber-js",
    "test:report": "node generate-reports.js"
  }
}
```

### CI/CD Integration
**File:** `.github/workflows/cucumber-tests.yml`

```yaml
name: Cucumber Tests

on: [push, pull_request]

jobs:
  cucumber-tests:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        browser: [chromium, firefox, webkit]
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          
      - name: Install dependencies
        run: npm install
        
      - name: Install Playwright browsers
        run: npx playwright install
        
      - name: Run Cucumber tests
        run: |
          BROWSER=${{ matrix.browser }} npm run test:cucumber
        env:
          HEADLESS: true
          BASE_URL: http://localhost:3000
          
      - name: Upload test results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: cucumber-reports-${{ matrix.browser }}
          path: tests/reports/
          
      - name: Upload screenshots
        uses: actions/upload-artifact@v3
        if: failure()
        with:
          name: screenshots-${{ matrix.browser }}
          path: tests/screenshots/
```

## Reporting

### HTML Report Generation
**File:** `generate-reports.js`

```javascript
const reporter = require('cucumber-html-reporter');
const multipleReporter = require('multiple-cucumber-html-reporter');

// Generate single HTML report
const options = {
  theme: 'bootstrap',
  jsonFile: 'tests/reports/cucumber-report.json',
  output: 'tests/reports/cucumber-report.html',
  reportSuiteAsScenarios: true,
  scenarioTimestamp: true,
  launchReport: false,
  metadata: {
    'App Version': process.env.APP_VERSION || '1.0.0',
    'Test Environment': process.env.NODE_ENV || 'test',
    'Browser': process.env.BROWSER || 'chromium',
    'Platform': process.platform,
    'Executed': new Date().toISOString()
  }
};

reporter.generate(options);

// Generate multi-browser report
multipleReporter.generate({
  reportName: 'Cucumber Test Report',
  jsonDir: 'tests/reports/',
  reportPath: 'tests/reports/multi-browser/',
  metadata: {
    device: 'Local test machine',
    platform: {
      name: process.platform,
      version: process.version
    }
  },
  customData: {
    title: 'Run Info',
    data: [
      { label: 'Project', value: 'BDD with Cucumber + Playwright' },
      { label: 'Release', value: process.env.APP_VERSION || '1.0.0' },
      { label: 'Cycle', value: 'Regression' }
    ]
  }
});
```

## Best Practices

### Performance Optimization
- Use `@smoke` tags for critical path scenarios
- Run security tests in dedicated suites
- Implement parallel execution for faster feedback
- Use browser context pooling for better performance

### Debugging
- Set `HEADLESS=false` for visual debugging
- Use `page.pause()` for interactive debugging
- Capture screenshots and videos on failures
- Store HAR files for network analysis

### Maintenance
- Keep step definitions DRY (Don't Repeat Yourself)
- Use Page Object Model for complex UI interactions
- Implement custom world class for shared state
- Regular cleanup of screenshots and reports

### Integration Points
- Feature files are created by QA Agent
- Step definitions are implemented by Dev Agent
- All scenarios must pass before story completion
- Reports are generated automatically in CI/CD