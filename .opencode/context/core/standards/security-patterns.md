<!-- Context: standards/security | Priority: critical | Version: 1.0 -->
# Security Patterns

Security requirements for all code implementations.

## Philosophy

**Defense in Depth**: Multiple layers of security  
**Zero Trust**: Validate everything, trust nothing  
**Fail Secure**: Failures should be safe, not open

## Golden Rules

1. **Never trust user input**
2. **Always validate at boundaries**
3. **Never expose sensitive data**
4. **Fail securely (deny by default)**
5. **Log security events**

## Critical Security Checklist

### Input Validation

- [ ] Validate all user input
- [ ] Use allowlists (not denylists)
- [ ] Validate type, format, range
- [ ] Reject invalid input early

### Authentication

- [ ] Verify authentication on protected routes
- [ ] Use secure session management
- [ ] Implement proper password policies
- [ ] Support MFA where appropriate

### Authorization

- [ ] Check permissions before actions
- [ ] Principle of least privilege
- [ ] Verify resource ownership
- [ ] Don't rely on client-side checks

### Data Protection

- [ ] Encrypt sensitive data at rest
- [ ] Use HTTPS for all communications
- [ ] Hash passwords (bcrypt, Argon2)
- [ ] Never log sensitive data

### Injection Prevention

- [ ] Use parameterized queries
- [ ] Escape output for context
- [ ] Validate file uploads
- [ ] Sanitize file paths

## Patterns

### Input Validation

```javascript
// ✅ Validate with schema
const userSchema = z.object({
  email: z.string().email(),
  age: z.number().min(13).max(120),
  name: z.string().min(1).max(100)
});

function createUser(data) {
  const result = userSchema.safeParse(data);
  if (!result.success) {
    return { success: false, errors: result.error.errors };
  }
  // Continue with validated data...
}

// ❌ No validation
function createUser(data) {
  return db.users.create(data); // Dangerous!
}
```

### SQL Injection Prevention

```javascript
// ✅ Parameterized queries
const user = await db.query(
  'SELECT * FROM users WHERE id = $1',
  [userId]
);

// ❌ String concatenation
const user = await db.query(
  `SELECT * FROM users WHERE id = ${userId}`
);
```

### XSS Prevention

```javascript
// ✅ Escape output
function renderUserInput(input) {
  const escaped = input
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
  return escaped;
}

// Or use a library
import { escapeHtml } from 'escape-html';
const safe = escapeHtml(userInput);
```

### Authentication Check

```javascript
// ✅ Verify auth
async function getUserProfile(req) {
  const session = await verifySession(req);
  if (!session.isValid) {
    return { success: false, error: 'Unauthorized', status: 401 };
  }
  
  const user = await getUser(session.userId);
  return { success: true, user };
}

// ❌ No auth check
async function getUserProfile(req) {
  const userId = req.params.id;
  return await getUser(userId); // Anyone can access any user!
}
```

### Authorization Check

```javascript
// ✅ Check ownership
async function deleteDocument(req) {
  const session = await verifySession(req);
  if (!session.isValid) {
    return { success: false, error: 'Unauthorized', status: 401 };
  }
  
  const doc = await getDocument(req.params.id);
  if (doc.ownerId !== session.userId) {
    return { success: false, error: 'Forbidden', status: 403 };
  }
  
  await db.documents.delete(doc.id);
  return { success: true };
}
```

### Secure Error Handling

```javascript
// ✅ Don't leak internals
function handleError(error) {
  console.error('Detailed error:', error); // Log full error
  
  return { 
    success: false, 
    error: 'An error occurred' // Generic message to user
  };
}

// ❌ Exposing internals
function handleError(error) {
  return { 
    success: false, 
    error: error.message, // Might expose SQL, paths, etc.
    stack: error.stack     // Never expose stack traces!
  };
}
```

### Password Handling

```javascript
// ✅ Proper password hashing
import bcrypt from 'bcrypt';

const SALT_ROUNDS = 12;

async function hashPassword(password) {
  const hash = await bcrypt.hash(password, SALT_ROUNDS);
  return hash;
}

async function verifyPassword(password, hash) {
  const valid = await bcrypt.compare(password, hash);
  return valid;
}

// ❌ Never do this
function hashPassword(password) {
  return md5(password); // MD5 is broken!
}
```

### Secrets Management

```javascript
// ✅ Environment variables
const API_KEY = process.env.API_KEY;
const DB_PASSWORD = process.env.DB_PASSWORD;

// ❌ Hardcoded secrets
const API_KEY = 'sk-1234567890abcdef';
const DB_PASSWORD = 'password123';
```

## Security Headers

Always include security headers:

```javascript
// Express example
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  next();
});
```

## File Upload Security

```javascript
// ✅ Validate uploads
function validateUpload(file) {
  // Check file type
  const allowedTypes = ['image/jpeg', 'image/png', 'application/pdf'];
  if (!allowedTypes.includes(file.mimetype)) {
    return { success: false, error: 'Invalid file type' };
  }
  
  // Check file size (max 5MB)
  const maxSize = 5 * 1024 * 1024;
  if (file.size > maxSize) {
    return { success: false, error: 'File too large' };
  }
  
  // Sanitize filename
  const safeName = file.originalname.replace(/[^a-zA-Z0-9.-]/g, '_');
  
  return { success: true, filename: safeName };
}
```

## Security Logging

Log security-relevant events:

```javascript
function logSecurityEvent(event, details) {
  logger.warn({
    type: 'security',
    event,
    timestamp: new Date().toISOString(),
    details: sanitizeForLogging(details)
  });
}

// Usage
logSecurityEvent('failed_login', { username, ip: req.ip });
logSecurityEvent('unauthorized_access', { userId, resource, ip: req.ip });
```

## Common Vulnerabilities to Avoid

| Vulnerability | Prevention |
|--------------|------------|
| SQL Injection | Parameterized queries |
| XSS | Escape output, CSP headers |
| CSRF | CSRF tokens, SameSite cookies |
| Insecure Direct Object Reference | Verify ownership |
| Sensitive Data Exposure | Encryption, secure logging |
| Broken Authentication | Strong sessions, MFA |
| Security Misconfiguration | Secure defaults, minimal exposure |

## Security Review Checklist

Before marking code complete:

- [ ] All user input validated
- [ ] Authentication checked on protected routes
- [ ] Authorization verified for actions
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Sensitive data not logged
- [ ] Errors don't leak internals
- [ ] Secrets in environment variables
- [ ] Security headers included
- [ ] File uploads validated
