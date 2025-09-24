<!-- Powered by BMAD™ Core -->

# Create API Security Tests Task

## Purpose

Create comprehensive API-level security tests that complement Gherkin scenarios by testing security aspects at the API layer. These tests focus on authentication, authorization, input validation, and other security concerns that may not be fully covered by user-facing Gherkin scenarios.

## Prerequisites

- Story has acceptance criteria with API endpoints or backend functionality
- Understanding of the API surface area and security requirements
- Access to API documentation or specifications

## Inputs

```yaml
required:
  - story_issue_number: GitHub issue number for the story (e.g., 42)
  - api_endpoints: List of API endpoints involved in the story
  
optional:
  - auth_requirements: Authentication/authorization requirements
  - data_validation_rules: Input validation requirements
  - security_headers: Required security headers
```

## API Security Test Categories

### 1. Authentication Tests

- Valid token acceptance
- Invalid token rejection
- Expired token handling
- Missing token scenarios
- Token format validation

### 2. Authorization Tests

- Role-based access control
- Resource-level permissions
- Cross-tenant data access prevention
- Privilege escalation attempts
- Admin vs user access boundaries

### 3. Input Validation Tests

- SQL injection prevention
- XSS payload rejection
- Command injection blocking
- Path traversal prevention
- JSON/XML bombing protection
- Oversized payload handling

### 4. Security Headers Tests

- CORS header validation
- Content-Type enforcement
- X-Frame-Options presence
- CSP header configuration
- HSTS header validation

### 5. Rate Limiting Tests

- Request rate limiting
- Burst protection
- Per-user limits
- API key rate limits
- DDoS protection

### 6. Data Protection Tests

- Sensitive data masking
- PII handling compliance
- Data encryption verification
- Secure data transmission
- Data retention policies

## Test Implementation Structure

```typescript
// tests/security/api/{story_slug}-security.test.ts
import { describe, it, expect, beforeEach } from '@cucumber/cucumber';
import { request } from 'supertest';
import { app } from '../../../src/app';

describe('API Security Tests - {Story Title}', () => {
  let validToken: string;
  let invalidToken: string;
  
  beforeEach(async () => {
    // Setup test tokens and test data
  });

  describe('Authentication Security', () => {
    it('should reject requests without authentication token', async () => {
      const response = await request(app)
        .get('/api/endpoint')
        .expect(401);
      
      expect(response.body.error).toBe('Authentication required');
    });

    it('should reject requests with invalid tokens', async () => {
      const response = await request(app)
        .get('/api/endpoint')
        .set('Authorization', `Bearer ${invalidToken}`)
        .expect(401);
    });
  });

  describe('Input Validation Security', () => {
    it('should reject SQL injection attempts', async () => {
      const maliciousPayload = "'; DROP TABLE users; --";
      
      const response = await request(app)
        .post('/api/endpoint')
        .set('Authorization', `Bearer ${validToken}`)
        .send({ input: maliciousPayload })
        .expect(400);
    });

    it('should reject XSS payloads', async () => {
      const xssPayload = '<script>alert("xss")</script>';
      
      const response = await request(app)
        .post('/api/endpoint')
        .set('Authorization', `Bearer ${validToken}`)
        .send({ content: xssPayload })
        .expect(400);
    });
  });

  describe('Authorization Security', () => {
    it('should prevent unauthorized access to protected resources', async () => {
      const response = await request(app)
        .get('/api/admin/endpoint')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(403);
    });
  });
});
```

## Security Test Checklist

### Authentication Tests
- [ ] Valid authentication tokens accepted
- [ ] Invalid authentication tokens rejected
- [ ] Expired tokens handled correctly
- [ ] Missing authentication returns 401
- [ ] Token format validation working

### Authorization Tests
- [ ] Role-based access controls enforced
- [ ] Resource-level permissions verified
- [ ] Cross-user data access prevented
- [ ] Admin endpoints protected from regular users
- [ ] API key permissions respected

### Input Validation Tests
- [ ] SQL injection payloads blocked
- [ ] XSS payloads sanitized or rejected
- [ ] Command injection attempts blocked
- [ ] Path traversal attacks prevented
- [ ] Oversized payloads rejected
- [ ] Invalid JSON/XML handled gracefully

### Security Headers Tests
- [ ] Required security headers present
- [ ] CORS configured correctly
- [ ] Content-Type validation enforced
- [ ] XSS protection headers set
- [ ] CSRF protection implemented

### Rate Limiting Tests
- [ ] Request rate limits enforced
- [ ] Burst protection working
- [ ] Per-user limits applied
- [ ] Rate limit headers returned
- [ ] Proper error messages for rate limits

### Data Protection Tests
- [ ] Sensitive data not leaked in responses
- [ ] PII handling compliant
- [ ] Data encryption verified
- [ ] Secure data transmission
- [ ] Proper error message sanitization

## Output Requirements

### 1. Security Test Files

Create test files in the appropriate directory:
- **API Security Tests**: `tests/security/api/{story_slug}-security.test.ts`
- **Integration Security Tests**: `tests/security/integration/{story_slug}-security.test.ts`

### 2. Test Documentation

Document security test approach in:
- Test strategy and coverage
- Security assumptions and limitations
- Test data requirements
- Known security exceptions or waivers

### 3. Update Story Issue

Add comment to story issue documenting security test creation:

```bash
gh issue comment {story_issue_number} --body "## API Security Tests Created

**Security Test Coverage:**
- Authentication: {auth_test_count} tests
- Authorization: {authz_test_count} tests  
- Input Validation: {validation_test_count} tests
- Security Headers: {headers_test_count} tests
- Rate Limiting: {rate_limit_test_count} tests
- Data Protection: {data_protection_test_count} tests

**Test Files Created:**
- \`tests/security/api/{story_slug}-security.test.ts\`
- \`tests/security/integration/{story_slug}-security.test.ts\`

**Security Test Status:** ✅ Created - Ready for implementation

**Next Steps:**
1. Implement security test step definitions
2. Execute security test suite
3. Verify all security tests pass before deployment"
```

## Integration with Gherkin Scenarios

### Complementary Coverage

- **Gherkin Scenarios**: Focus on user-facing security (login forms, access controls in UI)
- **API Security Tests**: Focus on backend security (API authentication, input validation, headers)

### Test Execution Order

1. Execute Gherkin scenarios (user-facing security)
2. Execute API security tests (backend security)
3. Execute integration security tests (end-to-end security flows)

### Security Gap Analysis

- Identify security aspects covered by Gherkin vs API tests
- Ensure no security requirements fall through gaps
- Document security test coverage matrix

## Key Principles

- **Defense in Depth**: Test security at multiple layers
- **Fail Secure**: Default to secure state on failures
- **Comprehensive Coverage**: Test both positive and negative security cases
- **Realistic Attacks**: Use real-world attack patterns
- **Automated Execution**: Include in CI/CD pipeline
- **Clear Documentation**: Document security assumptions and limitations

## Completion Criteria

- All identified API endpoints have appropriate security tests
- Security test coverage aligns with story acceptance criteria
- Tests execute successfully in CI/CD pipeline
- Security test results documented in story issue
- No security gaps between Gherkin and API security test coverage