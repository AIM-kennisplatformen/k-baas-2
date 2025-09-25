# Security

## Authentication & Authorization

**Dual Authentication Support:**
- **Username/Password:** JWT tokens with RS256 signing, 1-hour access tokens with refresh token rotation
- **OAuth Integration:** Support for Google, GitHub, Microsoft with secure token exchange
- **Session Management:** Stateless JWT authentication with secure token storage

**Authorization Patterns:**
- All protected endpoints use FastAPI `Depends()` for authentication validation
- Knowledge base access control through team membership verification
- Multi-database security ensuring users only access authorized knowledge bases

## Input Validation & API Security

**Request Validation:**
- All external inputs validated using Pydantic models generated from TypeDB schema
- Validation at API boundary before service layer processing
- Whitelist approach for allowed values and formats

**API Protection:**
- Rate limiting: 100 requests per minute per user, 20 requests per minute for AI endpoints
- CORS policy with explicitly allowed origins only
- Security headers: HSTS, CSP, X-Frame-Options, X-Content-Type-Options
- HTTPS enforcement with redirect from HTTP

## Data Protection

**Encryption:**
- TLS 1.3 minimum for all external communications
- Sensitive data fields encrypted at rest in TypeDB
- No secrets, API keys, or sensitive data in logs or error responses

**Secrets Management:**
- Development: Environment variables with `.env` file validation
- Production: External secret management service integration
- JWT signing keys rotated regularly
- OAuth client secrets stored securely

## Database Security

**Multi-Database Isolation:**
- Core database access restricted to system services only
- Knowledge base databases isolated per-KB with access control
- Database connection pooling with authentication per connection
- TypeDB queries use parameterized queries to prevent injection
