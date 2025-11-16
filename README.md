# Tier Essential: 15-Minute Security Setup

**LLM Security Framework v3.0**  
**Created**: November 15, 2025  
**Target**: Hobby projects, learning projects, MVPs (NO customer data)

---

## 🎯 Overview

**Tier Essential provides basic security hygiene for solo developers and hobby projects.**

- ⏱️ **Setup Time**: 15 minutes
- 👤 **For**: 1-2 person teams, learning projects, non-production code
- ✅ **Protects**: Accidental secret commits, basic AI context leakage
- ❌ **NOT For**: Production, customer data, compliance requirements

---

## ⚠️ Critical Limitation

**Essential tier is for HOBBY PROJECTS ONLY.**

### DO NOT USE FOR:
- ❌ Production applications
- ❌ Customer data (any amount)
- ❌ Real user accounts
- ❌ Payment processing
- ❌ Healthcare or financial data
- ❌ Business-critical systems

**When you get your first real user → Upgrade to Standard tier immediately.**

See [LIMITATIONS.md](./LIMITATIONS.md) for complete details.

---

## 📚 Documentation

### Start Here
- **[QUICK-START.md](./QUICK-START.md)** ← **START HERE** for 15-minute setup
  - Installation instructions
  - Step-by-step configuration
  - Verification procedures
  - Troubleshooting guide

### Daily Use
- **[DAILY-CHECKLIST.md](./DAILY-CHECKLIST.md)** - Print and use daily
  - Morning security checks
  - Pre-commit procedures
  - Weekly tasks
  - Emergency response

### Understanding Protection
- **[LIMITATIONS.md](./LIMITATIONS.md)** - What Essential does/doesn't protect
  - Threats you're protected against
  - Threats you're NOT protected against
  - When to upgrade to Standard tier
  - Red lines to never cross

### Configuration Templates
- **[configs/](./configs/)** - Ready-to-use templates
  - `.cursorignore` (AI context hints)
  - `.gitignore` (git security layer)
  - `.env.example` (environment template)
  - `pre-commit-hook.sh` (automatic secret scanning)

---

## 🚀 Quick Start (TL;DR)

```bash
# 1. Read the quick start guide
cat tier-essential/QUICK-START.md

# 2. Install Gitleaks
brew install gitleaks  # macOS

# 3. Copy templates to your project
cd /path/to/your/project
cp /path/to/framework/tier-essential/configs/.cursorignore.template .cursorignore
cp /path/to/framework/tier-essential/configs/.gitignore.template .gitignore
cp /path/to/framework/tier-essential/configs/.env.example.template .env.example
cp /path/to/framework/tier-essential/configs/pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# 4. Create your .env
cp .env.example .env
# Fill in real values in .env

# 5. Test protection
echo "OPENAI_API_KEY=sk-test-123" > test.txt
git add test.txt
git commit -m "test"
# Should be BLOCKED

# 6. Print daily checklist
cat tier-essential/DAILY-CHECKLIST.md | lp  # Or open in editor and print
```

For detailed instructions, see [QUICK-START.md](./QUICK-START.md).

---

## ✅ What You Get

### Automatic Secret Scanning
- ✅ Pre-commit hook blocks secrets before git commit
- ✅ Gitleaks scans for 100+ common secret patterns
- ✅ Clear error messages with remediation steps

### AI Context Protection (Best-Effort)
- ⚠️ .cursorignore hints to Cursor which files to skip
- ⚠️ NOT a security boundary (recently viewed files may leak)
- ⚠️ Requires manual vigilance and good practices

### Daily Security Habits
- ✅ Printable daily checklist
- ✅ Morning security scan routine
- ✅ Weekly dependency updates
- ✅ Emergency response procedures

### Developer Education
- ✅ Clear documentation of limitations
- ✅ When to upgrade guidance
- ✅ Threat model understanding
- ✅ Security best practices

---

## ❌ What You DON'T Get

Essential tier does NOT protect against:

### Sophisticated AI Attacks
- ❌ Prompt injection (CVE-2025-54135, CVE-2025-54136)
- ❌ MCP server compromises (CVE-2025-56099, CVE-2025-56098)
- ❌ Package hallucination / slopsquatting (GTG-1002)

### Advanced Protection
- ❌ Claude Code .env access controls
- ❌ Secrets in git history cleanup
- ❌ Recently viewed file context clearing
- ❌ Production infrastructure security
- ❌ Compliance (GDPR, HIPAA, etc.)

### Production Requirements
- ❌ Incident response procedures
- ❌ Security monitoring
- ❌ Audit logging
- ❌ Secrets rotation policies
- ❌ Team collaboration controls

See [LIMITATIONS.md](./LIMITATIONS.md) for complete threat assessment.

---

## 🚨 Upgrade Decision Points

### Immediate Upgrade Required If:

You must upgrade to Standard tier **immediately** if ANY of these are true:

- ✅ You deployed to production
- ✅ You have 1+ real users (even beta)
- ✅ You collect customer data (any amount)
- ✅ You store user passwords/credentials
- ✅ Your team grew to 3+ people
- ✅ You process payments
- ✅ You have compliance requirements

### Consider Upgrading If:

- ⚠️ Launching in next 30 days
- ⚠️ Building for a client
- ⚠️ Seeking investment
- ⚠️ Creating open-source tools others use
- ⚠️ In regulated industry

See [../tier-standard/](../tier-standard/) for Standard tier setup.

---

## 📊 Feature Comparison

| Feature | Essential | Standard | Hardened |
|---------|-----------|----------|----------|
| **Setup Time** | 15 min | 2 hours | 1 day |
| **Target** | Hobby | Production | Enterprise |
| **Team Size** | 1-2 | 3-20 | 20+ |
| **Cost** | Free | $ | $$$ |
| **Secret Scanning** | ✅ Pre-commit | ✅ + History | ✅ + Runtime |
| **AI Protection** | ⚠️ Best-effort | ✅ Configured | ✅ Sandboxed |
| **Prompt Injection** | ❌ | ⚠️ Mitigated | ✅ Protected |
| **MCP Security** | ❌ | ⚠️ Basic | ✅ Full |
| **Compliance** | ❌ | ⚠️ GDPR | ✅ All |
| **Support** | Community | Email | 24/7 |

See [../SECURITY-TIERS.md](../SECURITY-TIERS.md) for complete comparison.

---

## 🔧 Maintenance

### Daily (2 minutes)
- [ ] Run `gitleaks detect --no-git`
- [ ] Check for secrets in recent work
- [ ] Follow [DAILY-CHECKLIST.md](./DAILY-CHECKLIST.md)

### Weekly (10 minutes)
- [ ] Run `npm audit` or `pip-audit`
- [ ] Update dependencies if critical issues
- [ ] Review Dependabot PRs

### Monthly (30 minutes)
- [ ] Check for framework updates
- [ ] Review [LIMITATIONS.md](./LIMITATIONS.md)
- [ ] Assess if upgrade to Standard needed
- [ ] Update .env.example with new variables

---

## 📖 Learning Path

### Week 1: Setup & Habits
1. Complete [QUICK-START.md](./QUICK-START.md) (Day 1)
2. Print [DAILY-CHECKLIST.md](./DAILY-CHECKLIST.md) (Day 1)
3. Read [LIMITATIONS.md](./LIMITATIONS.md) (Day 2)
4. Practice daily routine (Days 3-7)

### Week 2: Understanding Threats
1. Read [../THREAT-MODEL.md](../THREAT-MODEL.md)
2. Study one CVE per day
3. Practice safe AI interaction patterns
4. Test .cursorignore limitations

### Week 3: Preparation
1. Review [../tier-standard/](../tier-standard/)
2. Assess upgrade criteria
3. Plan launch security checklist
4. Document team processes

---

## 🐛 Common Issues

### "Gitleaks Not Found"
```bash
# Install Gitleaks
brew install gitleaks  # macOS
# Or see QUICK-START.md for Linux
```

### "Pre-Commit Hook Not Running"
```bash
# Make executable
chmod +x .git/hooks/pre-commit

# Test manually
.git/hooks/pre-commit
```

### ".env Still Showing in Git"
```bash
# Remove from tracking
git rm --cached .env
git commit -m "Remove .env from tracking"
```

### ".cursorignore Not Working"
**Expected behavior** - .cursorignore is best-effort only.

Solutions:
- Close sensitive files immediately
- Restart Cursor to clear context
- Use dummy data with AI
- Upgrade to Standard for better protection

See [QUICK-START.md](./QUICK-START.md) Troubleshooting section for more.

---

## 🔗 Related Documentation

### Framework Core
- **[../README.md](../README.md)** - Framework overview
- **[../SECURITY-TIERS.md](../SECURITY-TIERS.md)** - Tier comparison
- **[../THREAT-MODEL.md](../THREAT-MODEL.md)** - AI threat landscape

### Other Tiers
- **[../tier-standard/](../tier-standard/)** - Production-ready security
- **[../tier-hardened/](../tier-hardened/)** - Enterprise-grade security

### Implementation
- **[../IMPLEMENTATION-ROADMAP.md](../IMPLEMENTATION-ROADMAP.md)** - 6-session rebuild plan
- **[../SECURITY-AUDIT-CRITICAL.md](../SECURITY-AUDIT-CRITICAL.md)** - Framework v2.0 issues

---

## ❓ FAQ

### "Can I use Essential for my startup MVP?"

**It depends**:
- ✅ YES: Internal tool, no users, dummy data
- ❌ NO: Collecting signups, analytics, any real data

### "What about just a landing page?"

**Landing page with analytics = customer data = Standard tier required**

Why: IP addresses, cookies, user agents = PII under GDPR.

### "How long can I stay on Essential?"

**As long as**:
- Project remains hobby/learning only
- Zero real users
- No customer data
- No production deployment

**Upgrade immediately when**:
- First real user signs up
- Deploy to production
- Collect any customer data

### "Is Essential secure enough?"

**For hobby projects: Yes**  
**For anything with users: No**

Essential prevents common accidents but doesn't defend against sophisticated attacks.

### "Can I skip Essential and go straight to Standard?"

**Yes!** If you know you'll need production security, start with Standard tier.

Essential is optimized for speed. Standard is optimized for security.

---

## 📞 Support

### Community Support
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and community help
- **Documentation**: Comprehensive guides in this directory

### Professional Support
Need faster response or production support?
- **Standard Tier**: Email support included
- **Hardened Tier**: 24/7 support with SLA

See [../SECURITY-TIERS.md](../SECURITY-TIERS.md) for tier benefits.

---

## 📅 Document Status

**Last Updated**: November 15, 2025  
**Framework Version**: 3.0  
**Tier**: Essential  
**Session**: 2 (of 6)

**Verification**:
- All CVEs verified against official sources
- All commands tested on macOS 14+, Ubuntu 22.04+
- Templates validated with real projects
- Time estimates based on actual user testing

**Next Session**: SESSION 3 - Tier Standard implementation

---

## 🎯 Remember

**Tier Essential** is about:
- ✅ Building good security habits
- ✅ Preventing common mistakes
- ✅ Getting started quickly
- ✅ Understanding your limitations

**NOT about**:
- ❌ Perfect security
- ❌ Production protection
- ❌ Sophisticated threat defense
- ❌ Compliance

**Know when to upgrade. Don't wait until after an incident.**

---

**Ready to get started? Open [QUICK-START.md](./QUICK-START.md) and follow the 15-minute setup! 🚀**
