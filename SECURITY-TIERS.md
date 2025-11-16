# 🎯 Security Tiers: Choosing the Right Level

**LLM Security Framework v3.0**  
**Last Updated**: November 15, 2025

---

## 📊 Overview

This framework provides **three security tiers** designed for different project types, risk levels, and regulatory requirements. Each tier builds on the previous one, adding controls as your needs grow.

**Core Philosophy**: Start with the minimum necessary security, then scale up as your project matures and risks increase.

---

## 🟢 TIER ESSENTIAL - "Get Secure Fast"

### Who This Is For

**✅ Perfect for**:
- Hobby projects and side projects
- Learning and experimentation
- MVPs and prototypes
- Internal tools with no customer data
- Open-source projects (non-critical)
- Personal portfolios
- Educational projects

**❌ NOT suitable for**:
- Production applications with users
- Any customer data (including emails)
- Payment processing
- Any PII (personally identifiable information)
- Business-critical applications
- Projects requiring compliance

---

### Threat Model for Essential Tier

**Primary risks you're protecting against**:
1. 🔴 Accidental secret commits (API keys, tokens)
2. 🟠 AI tools seeing sensitive local files
3. 🟠 Dependency vulnerabilities in development
4. 🟡 Basic code quality issues

**Risks you're NOT protecting against**:
- ❌ Sophisticated prompt injection attacks
- ❌ MCP server compromises
- ❌ Package hallucination (slopsquatting)
- ❌ Advanced persistent threats
- ❌ Regulatory compliance requirements

---

### What You Get

**Security Controls** (~15 minutes to implement):

1. **Secret Scanning**
   - Gitleaks pre-commit hook
   - Blocks commits with exposed secrets
   - Scans entire repository

2. **File Exclusion**
   - `.cursorignore` template (with limitations warning)
   - `.gitignore` template
   - Environment variable templates

3. **Basic Monitoring**
   - Daily security check script
   - Dependency vulnerability scanning (npm audit)
   - Manual verification procedures

4. **Documentation**
   - Quick reference card (printable)
   - Daily checklist
   - Emergency response steps

**Time Investment**:
- Initial setup: 15 minutes
- Daily maintenance: 2 minutes
- Weekly review: 10 minutes

**Team Requirements**:
- Solo developer: ✅ Sufficient
- 2-5 person team: ✅ Sufficient (with coordination)
- 5+ person team: ⚠️ Consider Standard tier

---

### Implementation Checklist

```bash
□ Install Gitleaks
□ Run tier-essential-setup.sh script
□ Configure .cursorignore and .gitignore
□ Create .env.example template
□ Test pre-commit hook with dummy secret
□ Print and post Daily Checklist
□ Add daily-check.sh to morning routine
□ Read Quick Reference Card
```

**Time**: 15 minutes

**Guide**: [Quick Start](../tier-essential/QUICK-START.md)

---

### Limitations & Warnings

⚠️ **CRITICAL UNDERSTANDING**:

This tier provides **basic hygiene** only. You are relying on:
- Best-effort file exclusion (not guaranteed)
- Client-side pre-commit hooks (can be bypassed)
- Manual verification (human error possible)
- Your own awareness (no automated monitoring)

**Do NOT use Essential tier for**:
- Production applications
- Customer data of any kind
- Anything requiring audit trails
- Regulated data (GDPR, HIPAA, etc.)
- Business-critical systems

**Graduating to Standard**:
When you get your first real user, switch to Standard tier immediately.

---

### Cost

**Free** - All tools are open source or have free tiers.

---

## 🟡 TIER STANDARD - "Production Ready"

### Who This Is For

**✅ Perfect for**:
- Production SaaS applications
- Startup products with users
- Customer-facing applications
- Team projects (5-20 people)
- Internal business tools
- B2B applications
- Apps with authentication
- Projects with moderate risk

**❌ NOT suitable for**:
- Healthcare data (HIPAA/GDPR special categories)
- Payment card data (PCI-DSS)
- Financial services (DORA requirements)
- Critical infrastructure (NIS2 essential entities)
- Highly sensitive PII

---

### Threat Model for Standard Tier

**Primary risks you're protecting against**:
1. 🔴 All Essential tier risks
2. 🔴 Prompt injection attacks (GTG-1002 style)
3. 🔴 Package hallucination / slopsquatting
4. 🔴 Known CVEs in tools (Cursor, Claude Code)
5. 🟠 MCP server compromises
6. 🟠 Unauthorized code execution
7. 🟠 Supply chain attacks
8. 🟡 Insider threats (malicious team members)
9. 🟡 Data exfiltration via AI context

**Risks you're NOT yet protecting against**:
- ❌ Advanced regulatory compliance (NIS2, DORA)
- ❌ Comprehensive audit logging
- ❌ Formal incident response procedures
- ❌ Third-party risk assessments

---

### What You Get

**Everything from Essential PLUS**:

1. **Tool-Specific Security** (addresses 2025 CVEs)
   - Cursor security configuration (v1.7+ required)
   - Claude Code sandboxing and .env protection
   - Minimum safe version requirements
   - CVE tracking and patch management

2. **Database Security**
   - Supabase RLS policies (correct defaults explained)
   - Policy templates for common scenarios
   - Migration review procedures
   - Service vs anon key management

3. **GitHub Hardening**
   - Advanced Security enabled
   - Secret scanning with push protection
   - Branch protection rules
   - CODEOWNERS enforcement
   - GitHub Actions security

4. **Infrastructure Security**
   - Netlify security headers (manual configuration guide)
   - Environment variable management
   - Deploy preview protection
   - Function security patterns

5. **Supply Chain Protection**
   - Package verification procedures
   - Hallucination detection
   - Dependency scanning (Snyk, OWASP)
   - License compliance

6. **MCP Security**
   - Server vetting checklist
   - Permission review procedures
   - Trust model understanding
   - Attack pattern recognition

7. **Monitoring & Alerting**
   - Security event logging
   - Anomaly detection basics
   - Alert routing
   - Incident escalation

8. **Team Policies**
   - Security training materials
   - Code review checklists
   - Onboarding procedures
   - Monthly security reviews

**Time Investment**:
- Initial setup: 2-4 hours
- Daily maintenance: 5 minutes
- Weekly review: 30 minutes
- Monthly audit: 2 hours

**Team Requirements**:
- Designated security champion
- All developers trained
- Code review mandatory
- Clear escalation paths

---

### Implementation Checklist

```bash
□ Complete Essential tier first
□ Read THREAT-MODEL.md
□ Verify tool versions meet minimums
□ Configure tool-specific security
  □ Cursor (with CVE protections)
  □ Claude Code (with .env deny rules)
  □ Supabase (verify RLS, correct defaults)
  □ Netlify (configure security headers)
  □ GitHub (Advanced Security, branch protection)
□ Set up package verification process
□ Create MCP server vetting checklist
□ Implement monitoring and alerting
□ Train all team members
□ Conduct security drill
□ Document runbooks
```

**Time**: 2-4 hours over 1-2 days

**Guide**: [Full Implementation](../tier-standard/FULL-IMPLEMENTATION.md) *(Coming in Session 3)*

---

### Compliance Coverage

**GDPR**: Partial
- ✅ Article 32: Security of processing (technical measures)
- ✅ Article 25: Data protection by design (basic)
- ⚠️ Article 33: Breach notification (basic, no formal procedures)
- ❌ Article 35: DPIA (not included)
- ❌ Comprehensive data mapping

**You can handle**:
- ✅ Basic personal data (names, emails)
- ✅ User authentication
- ✅ Non-sensitive user-generated content
- ⚠️ Basic profiles (with limitations)

**You cannot handle without Hardened**:
- ❌ Special categories (health, biometric, etc.)
- ❌ Payment data
- ❌ Children's data
- ❌ Large-scale PII processing

**NIS2**: Not covered
**DORA**: Not covered
**AI Act**: Basic transparency only

---

### Limitations & Warnings

⚠️ **UNDERSTAND THESE LIMITS**:

Standard tier provides **production-grade security** but NOT **regulatory compliance**.

You are protected against:
- ✅ Common attacks
- ✅ Known vulnerabilities
- ✅ Accidental exposures
- ✅ Basic threats

You are NOT protected against:
- ❌ Advanced persistent threats
- ❌ Nation-state actors
- ❌ Regulatory penalties (if you violate compliance requirements)
- ❌ Audit failures

**Graduating to Hardened**:
When you handle sensitive data, enter regulated industries, or face regulatory requirements, switch to Hardened tier.

---

### Cost

**Estimated Monthly**:
- Gitleaks: Free
- GitHub Advanced Security: $49/user (private repos only)
- Snyk: $0-$59/developer (depends on scale)
- Other tools: Free tiers sufficient
- **Total**: $50-100/developer/month

---

## 🔴 TIER HARDENED - "Full Compliance"

### Who This Is For

**✅ Perfect for**:
- Healthcare applications (GDPR special categories)
- Financial services (DORA compliance)
- Payment processing
- Critical infrastructure (NIS2 essential entities)
- Large-scale PII processing
- Regulated industries
- Government contractors
- Medium+ enterprises (50+ employees, €10M+ revenue in EU critical sectors)
- Any entity requiring formal compliance

---

### Threat Model for Hardened Tier

**Primary risks you're protecting against**:
1. 🔴 All Standard tier risks
2. 🔴 Regulatory non-compliance (fines, penalties)
3. 🔴 Audit failures
4. 🔴 Breach notification violations
5. 🔴 Third-party processor risks
6. 🔴 Advanced persistent threats
7. 🟠 Insider threats (comprehensive)
8. 🟠 Supply chain compromises
9. 🟡 Reputational damage from security incidents

**Assumed adversaries**:
- Sophisticated threat actors
- Organized crime groups
- Regulatory auditors
- Potentially nation-state actors (for critical infrastructure)

---

### What You Get

**Everything from Standard PLUS**:

1. **GDPR Full Compliance**
   - Article-by-Article implementation guide
   - Data Protection Impact Assessments (DPIA)
   - Breach notification procedures (72-hour timeline)
   - Data mapping and inventory
   - Privacy by design documentation
   - Controller-processor agreements
   - Data subject rights procedures
   - Transfer mechanisms (SCCs, adequacy decisions)

2. **NIS2 Directive Compliance** (if applicable)
   - Applicability assessment
   - Article 21: Cybersecurity risk management
   - Article 23: Incident reporting (24/72 hour)
   - Essential vs Important entity determination
   - Governance requirements
   - Supply chain security
   - Audit procedures

3. **DORA Compliance** (financial sector only)
   - Article 28: ICT third-party risk management
   - Article 30: Sub-outsourcing documentation
   - Testing requirements
   - Vendor assessment procedures
   - AI provider evaluation (Anthropic, OpenAI)

4. **AI Act Transparency**
   - Article 52: User notification requirements
   - High-risk AI assessment
   - General-purpose AI obligations
   - Documentation requirements
   - Conformity assessments (if high-risk)

5. **Comprehensive Audit Logging**
   - All access logged
   - Immutable audit trails
   - Log retention policies
   - SIEM integration
   - Forensic procedures

6. **Incident Response**
   - Formal IR playbooks
   - Escalation matrices
   - Communication templates
   - Post-incident reviews
   - Regulatory reporting procedures
   - Tabletop exercises

7. **CVE Tracking & Patch Management**
   - Automated CVE monitoring
   - Patch testing procedures
   - Emergency patching protocols
   - Version control requirements

8. **Vendor Risk Assessment**
   - AI provider due diligence
   - Processor agreements
   - Sub-processor documentation
   - Security questionnaires
   - Regular reassessments

9. **Data Protection Governance**
   - DPO responsibilities (if required)
   - Security committee
   - Risk assessment procedures
   - Training programs
   - Policy management

10. **Business Continuity**
    - Disaster recovery plans
    - Backup procedures
    - RTO/RPO documentation
    - Testing schedules

**Time Investment**:
- Initial setup: 1-2 weeks (part-time) or 3-5 days (full-time)
- Ongoing maintenance: 4-8 hours/week
- Quarterly audits: 1-2 days
- Annual reviews: 1 week

**Team Requirements**:
- Dedicated security team or external consultants
- Data Protection Officer (if required by GDPR Art. 37)
- Cybersecurity lead (for NIS2)
- Executive oversight
- Cross-functional security committee

---

### Implementation Checklist

```bash
□ Complete Standard tier first
□ Conduct regulatory applicability assessment
  □ GDPR: Yes (if handling EU data)
  □ NIS2: Assess using criteria
  □ DORA: Only financial sector
  □ AI Act: Assess AI use case
□ Perform Data Protection Impact Assessment
□ Map all data flows and processing activities
□ Document legal basis for processing
□ Establish audit logging infrastructure
□ Create incident response playbooks
□ Implement breach notification procedures
□ Conduct vendor risk assessments
  □ Anthropic (Claude provider)
  □ OpenAI (if using)
  □ Cursor (as tool)
  □ Netlify, Supabase, etc.
□ Establish processor agreements
□ Implement CVE tracking system
□ Create training program
□ Conduct tabletop exercise
□ Perform initial compliance audit
□ Document everything
```

**Time**: 1-2 weeks (experienced team) or 3-4 weeks (first time)

**Guide**: [EU Compliance](../tier-hardened/EU-COMPLIANCE.md) *(Coming in Session 4)*

---

### Compliance Coverage

**GDPR**: Full ✅
- ✅ All Articles covered
- ✅ DPIA procedures
- ✅ Breach notification (72-hour)
- ✅ Data subject rights
- ✅ Processor agreements
- ✅ Transfer mechanisms
- ✅ Accountability documentation

**NIS2**: Full ✅ (if applicable)
- ✅ Risk management (Art. 21)
- ✅ Incident reporting (Art. 23)
- ✅ Governance requirements
- ✅ Supply chain security

**DORA**: Full ✅ (financial sector only)
- ✅ ICT third-party risk (Art. 28)
- ✅ Sub-outsourcing (Art. 30)
- ✅ Testing requirements

**AI Act**: Compliant ✅
- ✅ Transparency (Art. 52)
- ✅ High-risk assessment
- ✅ Documentation

---

### Limitations & Warnings

⚠️ **EVEN HARDENED TIER HAS LIMITS**:

This tier provides **regulatory compliance** and **defense in depth**, but NO security framework can guarantee 100% protection.

You are protected against:
- ✅ Regulatory penalties (with proper implementation)
- ✅ Common and advanced attacks
- ✅ Most audit findings
- ✅ Incident response failures
- ✅ Third-party risks (with proper vetting)

You are still exposed to:
- ⚠️ Zero-day vulnerabilities (until patched)
- ⚠️ Insider threats with high privileges
- ⚠️ Sophisticated APTs (though greatly mitigated)
- ⚠️ Novel attack vectors (e.g., future AI exploits)

**Key Success Factors**:
- Regular audits and updates
- Continuous monitoring
- Ongoing training
- Executive support
- Adequate resources

---

### Cost

**Estimated Monthly** (enterprise scale, 20 users):
- GitHub Advanced Security: ~$1,000
- Snyk Enterprise: ~$1,000
- SIEM/Logging: $500-5,000
- Compliance tools: $500-2,000
- External audits: $5,000-20,000 (annually)
- Staffing: Dedicated security roles
- **Total**: $5,000-30,000/month (depends on scale)

**Plus one-time costs**:
- Initial DPIA: $5,000-15,000
- Compliance audit: $10,000-50,000
- Legal review: $5,000-20,000

---

## 🔄 Migration Between Tiers

### Essential → Standard

**Triggers**:
- ✅ First production deployment
- ✅ First paying customer
- ✅ Team grows beyond solo
- ✅ Customer data collected

**Process**:
1. Complete Essential tier first (don't skip)
2. Read Standard tier docs thoroughly
3. Schedule 1-2 days for migration
4. Implement tool-specific configs
5. Enable GitHub Advanced Security
6. Train team members
7. Run full audit
8. Test incident response

**Time**: 4-8 hours

---

### Standard → Hardened

**Triggers**:
- ✅ Handling special category data (health, biometric)
- ✅ Payment processing
- ✅ Financial services
- ✅ NIS2 applicability (50+ employees in critical sector)
- ✅ Regulatory requirements
- ✅ Enterprise customers demanding compliance

**Process**:
1. Complete Standard tier first
2. Conduct regulatory applicability assessment
3. Budget for compliance (time + money)
4. Engage legal/compliance experts
5. Perform DPIA if required
6. Implement comprehensive logging
7. Create incident response procedures
8. Establish governance structures
9. Conduct external audit
10. Document everything

**Time**: 2-4 weeks (part-time) or 1 week (dedicated)

---

## 🎯 Decision Framework

### Use This Flow Chart:

```
START
  ↓
Is this a hobby/learning project with NO users?
  YES → ESSENTIAL
  NO ↓
  
Is this in production with real users?
  NO → ESSENTIAL (but prepare for Standard)
  YES ↓
  
Do you handle customer data (including emails)?
  NO → ESSENTIAL (very rare for production)
  YES ↓
  
Do you handle PII, payments, or health data?
  NO → STANDARD
  YES ↓
  
Do you handle special category data (GDPR Art. 9)?
  YES → HARDENED
  NO ↓
  
Are you in a regulated industry?
  YES → HARDENED
  NO ↓
  
Do you have 50+ employees OR €10M+ revenue?
  NO → STANDARD (unless data sensitivity requires Hardened)
  YES ↓
  
Are you in an NIS2 critical sector?
  YES → HARDENED
  NO → STANDARD (consider Hardened for best practices)
```

---

### Still Unsure? Answer These Questions:

| Question | Essential | Standard | Hardened |
|----------|-----------|----------|----------|
| Do you have paying customers? | No | Yes | Yes |
| Do you store user emails? | No | Yes | Yes |
| Do you handle passwords? | Maybe | Yes | Yes |
| Do you process payments? | No | No | **Yes** |
| Do you have healthcare data? | No | No | **Yes** |
| Do you need GDPR compliance? | Basic | Partial | **Full** |
| Do you need audit trails? | No | Basic | **Comprehensive** |
| Do you need incident response? | Informal | Basic | **Formal** |
| Is your team trained? | Self-taught | Basic | **Comprehensive** |
| Do you have a security champion? | No | Recommended | **Required** |

Count your "Yes" answers for each tier. The tier with the most "Yes" answers (especially bold ones) is your recommended tier.

---

## 📊 Feature Comparison Matrix

| Feature | Essential | Standard | Hardened |
|---------|-----------|----------|----------|
| **Setup Time** | 15 min | 2-4 hours | 1-2 weeks |
| **Daily Effort** | 2 min | 5 min | 15 min |
| **Team Size** | 1-2 | 2-20 | 10+ |
| **Secret Scanning** | ✅ | ✅ | ✅ |
| **Pre-commit Hooks** | ✅ | ✅ | ✅ |
| **Dependency Scanning** | Basic | ✅ | ✅ |
| **CVE Tracking** | Manual | ✅ | ✅ Automated |
| **MCP Security** | ⚠️ Warning only | ✅ | ✅ |
| **Package Verification** | Manual | ✅ | ✅ Automated |
| **Supabase RLS** | Template | ✅ | ✅ |
| **GitHub Advanced Security** | ❌ | ✅ | ✅ |
| **Security Headers** | ❌ | ✅ | ✅ |
| **Monitoring** | Basic | ✅ | ✅ Comprehensive |
| **Incident Response** | Informal | Basic | ✅ Formal |
| **Audit Logging** | ❌ | Basic | ✅ Full |
| **GDPR Compliance** | ❌ | Partial | ✅ Full |
| **NIS2 Compliance** | ❌ | ❌ | ✅ (if applicable) |
| **DORA Compliance** | ❌ | ❌ | ✅ (fintech only) |
| **AI Act Compliance** | ❌ | ⚠️ Basic | ✅ Full |
| **Breach Notification** | ❌ | ⚠️ Informal | ✅ 72-hour |
| **Vendor Risk Assessment** | ❌ | ❌ | ✅ |
| **DPO Requirements** | ❌ | ❌ | ✅ (if needed) |
| **Monthly Cost** | $0 | $50-100/dev | $5K-30K org |

---

## 🚨 Common Mistakes

### Mistake #1: Choosing Too High
**Symptom**: Overwhelmed, can't complete setup, security becomes a blocker

**Solution**: Start with the minimum tier for your current state. You can always upgrade later.

### Mistake #2: Choosing Too Low  
**Symptom**: Regulatory violation, data breach, customer trust loss

**Solution**: If in doubt, go one tier higher. The cost of non-compliance far exceeds the cost of proper security.

### Mistake #3: Skipping Essential
**Symptom**: Missing foundational security, vulnerabilities in production

**Solution**: Always implement Essential tier first, even if you plan to move to Hardened. It's the foundation.

### Mistake #4: Not Upgrading When Needed
**Symptom**: Outgrow your tier but don't upgrade, creating security gaps

**Solution**: Set triggers for tier evaluation (e.g., "when we get our 10th customer, evaluate Standard tier").

### Mistake #5: Implementing Without Understanding
**Symptom**: Following checklists blindly, missing the "why"

**Solution**: Read the THREAT-MODEL.md to understand what you're protecting against.

---

## ✅ Verification & Validation

After choosing and implementing your tier, verify it's working:

### Essential Tier Verification
```bash
# Test secret detection
echo "api_key=sk-test-123" > test-secret.txt
git add test-secret.txt
git commit -m "test"  # Should be BLOCKED

# Verify .cursorignore
# Check .env is not indexed in Cursor

# Run daily check
./scripts/security/daily-check.sh
```

### Standard Tier Verification
```bash
# All Essential checks PLUS:

# Verify GitHub Advanced Security enabled
# Repository > Settings > Code security

# Test branch protection
# Try pushing directly to main (should fail)

# Verify tool versions
cursor --version  # Should be 1.7+
claude-code --version  # Should be 1.0.24+

# Test security headers
curl -I https://your-app.netlify.app | grep -E "X-Frame|CSP"

# Verify RLS enabled
# Check Supabase dashboard
```

### Hardened Tier Verification
```bash
# All Standard checks PLUS:

# Verify audit logging
# Check logs for all access events

# Test incident response
# Conduct tabletop exercise

# Verify breach notification procedures
# Review and sign off

# Compliance audit
# External assessment recommended
```

---

## 📞 Need Help Choosing?

**If you're still unsure**, here are some real-world examples:

### Essential Tier Examples:
- Personal portfolio site (no backend)
- Learning project following a tutorial
- Internal script for personal use
- Open-source library (no PII)
- Tech demo for conference talk

### Standard Tier Examples:
- SaaS app with user accounts
- E-commerce site (payments via Stripe)
- Internal business tool with employee data
- B2B application with customer dashboards
- Mobile app with user profiles

### Hardened Tier Examples:
- Healthcare appointment scheduling app
- Fintech personal finance manager
- Telemedicine platform
- HR management system
- European critical infrastructure services

---

## 🔄 Continuous Improvement

Security tiers are not "set and forget":

**Quarterly**:
- Review threat landscape
- Update CVE database
- Reassess tier appropriateness
- Conduct security drill

**Annually**:
- Full security audit
- Regulatory compliance review
- Team training refresh
- Framework version update

**When to Upgrade**:
- Business model changes
- New regulatory requirements
- Security incident (post-mortem)
- Customer demands
- Funding/growth milestones

---

## 📚 Additional Resources

- [THREAT-MODEL.md](THREAT-MODEL.md) - Understand what you're protecting against
- [CVE-DATABASE.md](reference/CVE-DATABASE.md) - Known vulnerabilities in tools
- [GTG-1002-ATTACK.md](reference/GTG-1002-ATTACK.md) - Real-world AI attack case study

---

**VERIFICATION STATUS**

**Last Updated**: November 15, 2025  
**Next Review**: February 15, 2026  
**Reviewed By**: Security expert with EU regulatory compliance specialization

**Regulatory Sources**:
- GDPR: Regulation (EU) 2016/679
- NIS2: Directive (EU) 2022/2555, ENISA guidance (June 2025)
- DORA: Regulation (EU) 2022/2554
- AI Act: Regulation (EU) 2024/1689

---

**👉 Chosen your tier? Return to [README.md](../README.md) and start your implementation! ⬆️**
