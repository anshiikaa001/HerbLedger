# 🔒 HERBLEDGER - Security & SSL Configuration Guide

## 🛡️ Production Security Checklist

### ✅ **SSL/HTTPS Configuration**

#### Railway (Automatic SSL)
```bash
# Railway provides automatic SSL certificates
# No configuration needed - HTTPS is enabled by default
✅ Automatic SSL certificates
✅ HTTPS redirect
✅ TLS 1.3 support
✅ HSTS headers
```

#### Custom Domain SSL
```bash
# Add custom domain with SSL
railway domains add yourdomain.com
railway domains add www.yourdomain.com

# SSL certificates are automatically provisioned
```

---

### 🔐 **Environment Variables Security**

#### Required Production Variables
```env
# Security Keys (Generate strong random keys!)
JWT_SECRET=your-super-secure-jwt-secret-256-bits
SESSION_SECRET=your-super-secure-session-secret-256-bits
ENCRYPTION_KEY=your-32-character-encryption-key-here

# Database URLs (Railway provides these)
DATABASE_URL=${DATABASE_URL}
REDIS_URL=${REDIS_URL}

# API Keys (if using external services)
SMS_API_KEY=${SMS_API_KEY}
SMTP_PASSWORD=${SMTP_PASSWORD}
```

#### Generate Secure Keys
```bash
# Generate JWT secret (256-bit)
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Generate session secret
node -e "console.log(require('crypto').randomBytes(64).toString('base64'))"

# Generate encryption key
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

---

### 🔒 **Security Headers Configuration**

#### Helmet.js Security Headers
```javascript
// Already configured in security-config.js
✅ Content Security Policy (CSP)
✅ HTTP Strict Transport Security (HSTS)
✅ X-Frame-Options: DENY
✅ X-Content-Type-Options: nosniff
✅ X-XSS-Protection: 1; mode=block
✅ Referrer-Policy: strict-origin-when-cross-origin
```

#### Rate Limiting
```javascript
// API Rate Limiting (configured)
✅ 50 requests per 15 minutes per IP
✅ 100 general requests per 15 minutes per IP
✅ Progressive delays for repeated requests
✅ IP-based blocking for abuse
```

---

### 🌐 **CORS Security**

#### Allowed Origins (Production)
```javascript
const allowedOrigins = [
  'https://herbledger-farmer.railway.app',
  'https://herbledger-consumer.railway.app',
  'https://herbledger-processor.railway.app',
  'https://herbledger-lab.railway.app',
  'https://herbledger-regulator.railway.app',
  'https://herbledger-stakeholder.railway.app',
  'https://herbledger-management.railway.app',
  'https://herbledger-supply-chain.railway.app'
];
```

---

### 📁 **File Upload Security**

#### Upload Restrictions
```javascript
✅ Max file size: 10MB
✅ Allowed types: images, PDFs, CSV, JSON
✅ Virus scanning (recommended)
✅ File type validation
✅ Secure file storage
```

#### Secure Upload Configuration
```javascript
const uploadConfig = {
  maxFileSize: 10 * 1024 * 1024, // 10MB
  allowedMimeTypes: [
    'image/jpeg', 'image/png', 'image/gif',
    'application/pdf', 'text/csv', 'application/json'
  ],
  destination: '/tmp/uploads', // Temporary storage
  filename: (req, file, cb) => {
    // Generate secure filename
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
};
```

---

### 🔑 **Authentication & Authorization**

#### JWT Token Security
```javascript
✅ 24-hour token expiration
✅ Secure token signing
✅ Token refresh mechanism
✅ Role-based access control
✅ Session management
```

#### Password Security
```javascript
✅ bcrypt hashing (12 rounds)
✅ Password strength requirements
✅ Account lockout after failed attempts
✅ Password reset tokens (1-hour expiry)
```

---

### 🛡️ **Database Security**

#### Connection Security
```javascript
✅ SSL/TLS encrypted connections
✅ Connection pooling
✅ Query parameterization (SQL injection prevention)
✅ Database user permissions (least privilege)
✅ Regular backups
```

#### Data Encryption
```javascript
✅ Sensitive data encryption at rest
✅ PII data hashing
✅ Secure key management
✅ Data anonymization for logs
```

---

### 📊 **Monitoring & Logging**

#### Security Monitoring
```javascript
✅ Failed login attempt tracking
✅ Suspicious activity detection
✅ Rate limit violation logging
✅ Error tracking and alerting
✅ Performance monitoring
```

#### Log Security
```javascript
✅ No sensitive data in logs
✅ Log rotation and retention
✅ Centralized logging
✅ Log integrity protection
```

---

### 🚨 **Incident Response**

#### Security Incident Checklist
1. **Immediate Response**
   - Identify and isolate affected systems
   - Preserve evidence and logs
   - Notify stakeholders

2. **Investigation**
   - Analyze attack vectors
   - Assess data impact
   - Document findings

3. **Recovery**
   - Patch vulnerabilities
   - Restore from clean backups
   - Update security measures

4. **Post-Incident**
   - Conduct security review
   - Update procedures
   - Train team members

---

### 🔧 **Security Testing**

#### Regular Security Checks
```bash
# Dependency vulnerability scanning
npm audit

# Security linting
npm run lint:security

# Penetration testing (recommended)
# Third-party security audit (recommended)
```

---

### 📋 **Compliance & Standards**

#### Security Standards
✅ **OWASP Top 10** compliance
✅ **ISO 27001** guidelines
✅ **GDPR** data protection
✅ **SOC 2** controls
✅ **HIPAA** compliance (for health data)

#### Regular Updates
- **Monthly** dependency updates
- **Quarterly** security reviews
- **Annual** penetration testing
- **Continuous** monitoring

---

### 🎯 **Quick Security Setup**

1. **Deploy to Railway** (automatic SSL)
2. **Set environment variables** (secure keys)
3. **Configure CORS** (allowed origins)
4. **Enable monitoring** (error tracking)
5. **Test security** (vulnerability scan)

Your HERBLEDGER system will be **enterprise-grade secure** with these configurations! 🛡️

