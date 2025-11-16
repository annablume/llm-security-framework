# ⚠️ Tier Essential - Limitations & Warnings

**Critical understanding of what this tier does NOT protect against**

---

## 🎯 What Tier Essential Provides

Tier Essential provides **basic security hygiene**:

✅ Pre-commit secret scanning  
✅ Basic dependency vulnerability checking  
✅ File exclusion templates (best-effort)  
✅ Daily security checklist  
✅ Environment variable templates  

---

## ❌ What Tier Essential Does NOT Protect Against

### 🔴 CRITICAL GAPS

#### 1. Production-Grade Security
**You are NOT protected against**:
- ❌ Sophisticated prompt injection attacks (GTG-1002 style)
- ❌ Advanced persistent threats (APTs)
- ❌ Nation-state actors
- ❌ Organized crime groups
- ❌ Insider threats (malicious team members)

**Impact**: If you're handling customer data, you need Tier Standard minimum.

---

#### 2. MCP Server Security
**You are NOT protected against**:
- ❌ Malicious MCP servers
- ❌ MCP server compromises
- ❌ Unauthorized MCP access
- ❌ MCP permission abuse

**What you get**: Warning only - no verification or vetting procedures.

**Impact**: Using MCP servers? You need Tier Standard.

---

#### 3. Package Hallucination (Slopsquatting)
**You are NOT protected against**:
- ❌ AI suggesting fake packages
- ❌ Typosquatting attacks
- ❌ Malicious npm packages
- ❌ Supply chain attacks

**What you get**: Manual verification only - no automated checks.

**Impact**: Installing packages from AI suggestions? You need Tier Standard.

---

#### 4. Tool-Specific CVEs
**You are NOT protected against**:
- ❌ Known vulnerabilities in Cursor (CVE-2025-XXXXX)
- ❌ Known vulnerabilities in Claude Code
- ❌ Outdated tool versions
- ❌ Unpatched security issues

**What you get**: No CVE tracking, no version requirements.

**Impact**: Using Cursor or Claude Code? You need Tier Standard.

---

#### 5. Regulatory Compliance
**You are NOT compliant with**:
- ❌ GDPR (General Data Protection Regulation)
- ❌ NIS2 (Network and Information Security Directive)
- ❌ DORA (Digital Operational Resilience Act)
- ❌ AI Act (Artificial Intelligence Act)
- ❌ HIPAA (US healthcare)
- ❌ PCI-DSS (payment cards)

**Impact**: Handling EU data, payments, or healthcare data? You need Tier Hardened.

---

#### 6. Advanced Monitoring
**You do NOT have**:
- ❌ Automated security monitoring
- ❌ Real-time alerting
- ❌ SIEM integration
- ❌ Anomaly detection
- ❌ Audit logging

**What you get**: Manual checks only.

**Impact**: Need to detect attacks in real-time? You need Tier Standard.

---

#### 7. Incident Response
**You do NOT have**:
- ❌ Formal incident response procedures
- ❌ Escalation matrices
- ❌ Communication templates
- ❌ Regulatory reporting procedures
- ❌ Post-incident reviews

**What you get**: Basic emergency steps only.

**Impact**: Need formal IR? You need Tier Standard minimum.

---

#### 8. .cursorignore Limitations
**⚠️ CRITICAL UNDERSTANDING**:

`.cursorignore` is **best-effort**, NOT a security boundary:

- ⚠️ Cursor may still index files despite `.cursorignore`
- ⚠️ AI tools can access files through other means
- ⚠️ No guarantee of exclusion
- ⚠️ Can be bypassed

**What you get**: Reduces likelihood, but doesn't guarantee protection.

**Impact**: If secrets MUST be protected from AI, use Tier Standard with proper sandboxing.

---

## 🟡 MEDIUM GAPS

### 9. Branch Protection
**You do NOT have**:
- ❌ GitHub branch protection rules
- ❌ Required code reviews
- ❌ Required status checks
- ❌ Protection against force pushes

**Impact**: Team projects? You need Tier Standard.

---

### 10. Comprehensive Dependency Scanning
**You do NOT have**:
- ❌ Automated dependency scanning (Snyk, OWASP)
- ❌ License compliance checks
- ❌ SBOM generation
- ❌ Container scanning

**What you get**: Basic `npm audit` only.

**Impact**: Need comprehensive supply chain security? You need Tier Standard.

---

### 11. Database Security
**You do NOT have**:
- ❌ Supabase RLS policy templates
- ❌ Database migration review procedures
- ❌ Service vs anon key management
- ❌ Database security best practices

**Impact**: Using Supabase? You need Tier Standard.

---

### 12. Infrastructure Security
**You do NOT have**:
- ❌ Netlify security headers configuration
- ❌ Environment variable management procedures
- ❌ Deploy preview protection
- ❌ Function security patterns

**Impact**: Deploying to Netlify? You need Tier Standard.

---

## 🟢 LOW GAPS (Acceptable for Essential Tier)

### 13. Advanced Features
These are intentionally excluded from Essential tier:
- ❌ Comprehensive audit logging
- ❌ Vendor risk assessments
- ❌ Data Protection Impact Assessments (DPIA)
- ❌ Formal security training programs
- ❌ Executive security reporting

**Impact**: Acceptable for hobby projects, not for production.

---

## 📊 Risk Assessment

### When Essential Tier Is Acceptable

**✅ Safe to use Essential tier if**:
- No customer data
- No production users
- No payments
- No PII
- No regulatory requirements
- Solo developer or very small team
- Learning/experimentation project

### When Essential Tier Is NOT Acceptable

**❌ DO NOT use Essential tier if**:
- ✅ You have real users
- ✅ You handle customer data (even emails)
- ✅ You process payments
- ✅ You handle PII
- ✅ You're in a regulated industry
- ✅ You need compliance
- ✅ You have a team (5+ people)

**👉 Upgrade to Tier Standard immediately**

---

## 🚨 Common Misconceptions

### Misconception #1: "Essential tier is enough for production"
**Reality**: Essential tier is explicitly NOT for production. It's for hobby projects only.

### Misconception #2: ".cursorignore protects my secrets"
**Reality**: `.cursorignore` is best-effort only. It reduces likelihood but doesn't guarantee protection.

### Misconception #3: "Pre-commit hooks prevent all secret leaks"
**Reality**: Hooks can be bypassed with `--no-verify`. You need server-side protection (Tier Standard).

### Misconception #4: "I can handle customer data with Essential tier"
**Reality**: No. Customer data requires Tier Standard minimum, often Tier Hardened.

### Misconception #5: "Essential tier protects against all attacks"
**Reality**: Essential tier protects against basic mistakes only, not sophisticated attacks.

---

## 🔄 When to Upgrade

### Essential → Standard

**Upgrade immediately if**:
- ✅ First production deployment
- ✅ First paying customer
- ✅ First user signup
- ✅ Team grows beyond solo
- ✅ Customer data collected

**Process**: See [SECURITY-TIERS.md](../../SECURITY-TIERS.md#essential--standard)

---

## ✅ What You CAN Do with Essential Tier

**Safe use cases**:
- ✅ Personal portfolio sites
- ✅ Learning projects
- ✅ Internal scripts (no customer data)
- ✅ Open-source libraries (non-critical)
- ✅ Tech demos
- ✅ Conference talks
- ✅ Tutorials and examples

**All of these**: No customer data, no production users, no compliance needs.

---

## 📚 Understanding Your Risk

**Essential tier assumes**:
- Low-value targets (hobby projects)
- No sensitive data
- No regulatory requirements
- Basic threat model (accidental mistakes)

**If your threat model includes**:
- Customer data → Need Tier Standard
- Payments → Need Tier Hardened
- Healthcare data → Need Tier Hardened
- Regulatory compliance → Need Tier Hardened
- Advanced threats → Need Tier Standard minimum

---

## 🆘 If You're Unsure

**When in doubt, go one tier higher.**

The cost of a security incident far exceeds the cost of proper security.

**Questions to ask**:
1. Do I have real users? → Tier Standard
2. Do I handle customer data? → Tier Standard
3. Do I process payments? → Tier Hardened
4. Am I in a regulated industry? → Tier Hardened
5. Do I need compliance? → Tier Hardened

---

## 📞 Need More Security?

- **Tier Standard**: [Full Implementation Guide](../../docs/tier-standard/)
- **Tier Hardened**: [EU Compliance Guide](../../docs/tier-hardened/)
- **Threat Model**: [THREAT-MODEL.md](../../THREAT-MODEL.md)

---

**Last Updated**: November 15, 2025  
**Framework Version**: 3.0




