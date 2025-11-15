# 🔒 LLM Security Framework v3.0

**Comprehensive Security Guide for AI-Assisted Development**

**Stack**: Cursor, Claude Code, GitHub, Netlify, Supabase  
**Target**: Solo Developers → Startups (5-20) → Production Apps with PII/Payments  
**Compliance**: GDPR, NIS2, DORA, AI Act (EU Focus)  
**Last Updated**: November 15, 2025

---

## ⚠️ Framework v3.0 - What Changed?

**CRITICAL**: This is a complete rebuild based on 2025 security research and fact-checking.

**Major Corrections from v2.0:**
- ✅ Fixed dangerous `.cursorignore` misconceptions (it's best-effort, not a security boundary)
- ✅ Corrected Supabase RLS defaults (nuanced by table creation method)
- ✅ Added Claude Code .env protection requirements (not protected by default)
- ✅ Documented all 2025 CVEs (5 confirmed vulnerabilities with patch versions)
- ✅ Added GTG-1002 attack documentation (first AI-orchestrated cyber espionage)
- ✅ Clarified Netlify security headers (manual configuration required)
- ✅ Added package hallucination protections ("slopsquatting" attacks)
- ✅ Included MCP security risks (5 official threat categories)
- ✅ Mapped EU compliance requirements (GDPR/NIS2/DORA/AI Act)

**See**: [SECURITY-AUDIT-CRITICAL.md](SECURITY-AUDIT-CRITICAL.md) for complete gap analysis.

---

## 🎯 Choose Your Security Tier

### 🟢 **Tier Essential** (15 minutes)
**Perfect for**: Hobby projects, MVPs, learning, side projects, non-production code

**You get**:
- ✅ Basic secret scanning (Gitleaks)
- ✅ Pre-commit hooks
- ✅ .cursorignore and .gitignore templates
- ✅ Environment variable templates
- ✅ Daily security checklist

**You DON'T get**:
- ❌ Protection against MCP attacks
- ❌ Package hallucination verification
- ❌ Advanced monitoring
- ❌ Compliance documentation

**⚠️ NOT suitable for**: Production apps, customer data, payments, PII

**👉 START HERE**: [Quick Start Guide](docs/tier-essential/QUICK-START.md)

---

### 🟡 **Tier Standard** (2-4 hours)
**Perfect for**: Production SaaS, startups, customer-facing apps, team projects

**You get everything from Essential PLUS**:
- ✅ Tool-specific security (Cursor CVEs, Claude Code sandboxing, etc.)
- ✅ Supabase RLS policies (correct defaults)
- ✅ GitHub Advanced Security setup
- ✅ Netlify security headers (manual config)
- ✅ Package verification procedures
- ✅ MCP server vetting checklist
- ✅ Monitoring and alerting
- ✅ Team security policies

**You DON'T get**:
- ❌ Full EU compliance documentation
- ❌ Audit logging procedures
- ❌ Incident response templates
- ❌ Regulatory reporting procedures

**⚠️ NOT suitable for**: Healthcare data, financial services, critical infrastructure, strict regulatory requirements

**👉 START HERE**: [Full Implementation Guide](docs/tier-standard/FULL-IMPLEMENTATION.md)

---

### 🔴 **Tier Hardened** (1-2 weeks)
**Perfect for**: PII/payments, regulated industries, healthcare, fintech, critical infrastructure

**You get everything from Standard PLUS**:
- ✅ GDPR Article-by-Article compliance mapping
- ✅ NIS2 Directive implementation (for applicable entities)
- ✅ DORA requirements (financial sector)
- ✅ AI Act transparency obligations
- ✅ Comprehensive audit logging
- ✅ Incident response playbooks
- ✅ CVE tracking and patch management
- ✅ Vendor risk assessment (Anthropic/OpenAI as processors)
- ✅ Data protection impact assessments (DPIA)
- ✅ Breach notification procedures (72-hour timeline)

**This tier IS suitable for**: Everything, with full regulatory compliance

**👉 START HERE**: [EU Compliance Guide](docs/tier-hardened/EU-COMPLIANCE.md)

---

## 🔧 Already Have a Project?

**Don't start from scratch** - retrofit security into your existing codebase.

**Assessment takes 30 minutes**:
- 🔍 Scan for secrets in Git history
- 🔍 Check dependency vulnerabilities
- 🔍 Verify RLS policies
- 🔍 Audit environment variables
- 🔍 Score your current security posture

**👉 START HERE**: [Retrofitting Assessment](docs/retrofitting/ASSESSMENT.md)

---

## 📚 Core Documentation

### Foundation (Read These First)
- [**Security Tiers Explained**](docs/SECURITY-TIERS.md) - Understand Essential vs Standard vs Hardened
- [**Threat Model**](docs/THREAT-MODEL.md) - AI-specific attack surface and risks
- [**Security Audit Report**](SECURITY-AUDIT-CRITICAL.md) - What was wrong with v2.0

### Reference Materials
- [**CVE Database**](docs/reference/CVE-DATABASE.md) - All 2025 vulnerabilities with patches
- [**GTG-1002 Attack Analysis**](docs/reference/GTG-1002-ATTACK.md) - First AI-orchestrated attack
- [**MCP Security Guide**](docs/reference/MCP-SECURITY.md) - Model Context Protocol risks
- [**Package Hallucination**](docs/reference/PACKAGE-HALLUCINATION.md) - Slopsquatting defenses

---

## 🚨 Quick Links for Emergencies

### Secret Leaked in Git?
**→ [Secret Leak Response](docs/tier-standard/INCIDENT-RESPONSE.md#secret-leak)**  
**→ Script**: `scripts/security/secret-leak-response.sh`

### Suspicious AI Behavior?
**→ [Prompt Injection Defense](docs/tier-standard/CURSOR-SECURITY.md#prompt-injection)**  
**→ [GTG-1002 Attack Patterns](docs/reference/GTG-1002-ATTACK.md)**

### Compliance Breach?
**→ [GDPR Breach Response](docs/tier-hardened/GDPR-TECHNICAL-MEASURES.md#breach-notification)**  
**→ [NIS2 Incident Reporting](docs/tier-hardened/NIS2-REQUIREMENTS.md#incident-reporting)**

### CVE in Your Tools?
**→ [Check Versions](docs/reference/CVE-DATABASE.md#minimum-safe-versions)**  
**→ Cursor minimum: v1.7+**  
**→ Claude Code minimum: v1.0.24+**

---

## 📊 What's Inside This Framework?

```
llm-security-framework/
│
├── README.md ⭐ YOU ARE HERE
├── SECURITY-AUDIT-CRITICAL.md (v2.0 gap analysis)
├── IMPLEMENTATION-ROADMAP.md (6-session rebuild plan)
├── CHANGELOG.md
├── LICENSE
│
├── docs/
│   ├── SECURITY-TIERS.md ⭐ FOUNDATION
│   ├── THREAT-MODEL.md ⭐ FOUNDATION
│   │
│   ├── tier-essential/ 📁 (15-min security)
│   │   ├── QUICK-START.md
│   │   ├── DAILY-CHECKLIST.md
│   │   └── configs/ (copy-paste templates)
│   │
│   ├── tier-standard/ 📁 (Production ready)
│   │   ├── FULL-IMPLEMENTATION.md
│   │   ├── CURSOR-SECURITY.md (with CVE warnings)
│   │   ├── CLAUDE-CODE-SECURITY.md (with .env protection)
│   │   ├── SUPABASE-SECURITY.md (correct RLS defaults)
│   │   ├── NETLIFY-SECURITY.md (manual headers)
│   │   ├── GITHUB-SECURITY.md
│   │   ├── PACKAGE-VERIFICATION.md
│   │   └── MONITORING.md
│   │
│   ├── tier-hardened/ 📁 (Full compliance)
│   │   ├── EU-COMPLIANCE.md
│   │   ├── GDPR-TECHNICAL-MEASURES.md
│   │   ├── NIS2-REQUIREMENTS.md
│   │   ├── DORA-CHECKLIST.md
│   │   ├── AI-ACT-TRANSPARENCY.md
│   │   ├── AUDIT-LOGGING.md
│   │   └── INCIDENT-RESPONSE.md
│   │
│   ├── retrofitting/ 📁
│   │   ├── ASSESSMENT.md
│   │   ├── REMEDIATION-PLAN.md
│   │   └── SECRET-CLEANUP.md
│   │
│   └── reference/
│       ├── CVE-DATABASE.md (2025 vulnerabilities)
│       ├── GTG-1002-ATTACK.md
│       ├── MCP-SECURITY.md
│       └── PACKAGE-HALLUCINATION.md
│
├── templates/ (all configs fact-checked)
├── scripts/ (automation with 2025 fixes)
└── examples/ (real-world scenarios)
```

---

## 🎓 Who Is This For?

### ✅ Perfect For:
- **Solo indie developers** building SaaS with AI assistance
- **Startup teams (5-20 people)** using Cursor/Claude Code
- **Product teams** adopting AI coding tools
- **Security teams** implementing AI tool governance
- **Compliance officers** ensuring regulatory adherence

### ❌ Not Designed For:
- Large enterprises (100+ devs) - you need more sophisticated tooling
- Non-European compliance (HIPAA, SOC2, etc.) - we focus on EU
- Custom/proprietary AI tools - we cover Cursor, Claude Code, standard tools
- Air-gapped/offline environments - assumes cloud-based development

---

## ⚖️ EU Regulatory Compliance

This framework helps you comply with:

### GDPR (General Data Protection Regulation)
**Applies to**: ALL businesses handling EU resident data

**We cover**:
- Article 25: Data protection by design and by default
- Article 32: Security of processing (appropriate technical measures)
- Article 33: Breach notification (72-hour requirement)
- Article 35: Data Protection Impact Assessment

**👉 Guide**: [GDPR Technical Measures](docs/tier-hardened/GDPR-TECHNICAL-MEASURES.md)

---

### NIS2 (Network and Information Security Directive)
**Applies to**: Medium+ enterprises (50+ employees OR €10M+ revenue) in 18 critical sectors

**Transposition deadline**: October 17, 2024 (14/27 member states compliant as of Nov 2025)

**We cover**:
- Article 21: Cybersecurity risk management measures
- Article 23: Incident reporting (24/72 hour timeline)
- Applicability assessment
- Technical implementation guidance

**👉 Guide**: [NIS2 Requirements](docs/tier-hardened/NIS2-REQUIREMENTS.md)

**Source**: Directive (EU) 2022/2555, ENISA Technical Guidance (June 2025)

---

### DORA (Digital Operational Resilience Act)
**Applies to**: Financial sector entities ONLY

**Effective**: January 2025

**We cover**:
- Article 28: ICT third-party risk management
- Article 30: Sub-outsourcing (AI providers as sub-processors)
- Testing requirements

**👉 Guide**: [DORA Checklist](docs/tier-hardened/DORA-CHECKLIST.md)

---

### AI Act (Artificial Intelligence Act)
**Applies to**: Users of general-purpose AI systems

**Phased implementation**: Starting 2025

**We cover**:
- Article 52: Transparency obligations (users must know they're interacting with AI)
- High-risk AI system assessment
- General-purpose AI requirements

**👉 Guide**: [AI Act Transparency](docs/tier-hardened/AI-ACT-TRANSPARENCY.md)

---

## 🔍 Framework Verification Status

**Last Fact-Checked**: November 15, 2025

**Primary Sources**:
- ✅ EU Official Journal (GDPR, NIS2, DORA, AI Act)
- ✅ ENISA Technical Guidance (NIS2, June 2025)
- ✅ National Vulnerability Database (CVE verification)
- ✅ GitHub Security Advisories (Cursor, Claude Code)
- ✅ Anthropic Official Documentation (Claude Code, GTG-1002)
- ✅ Cursor Official Documentation
- ✅ Supabase Official Documentation
- ✅ Netlify Official Documentation

**Next Review**: February 15, 2026 (quarterly updates)

**CVE Verification**:
- All CVE-2025-XXXXX numbers verified via NVD, NSFOCUS, Tenable
- Patch versions verified via GitHub Security Advisories
- Disclosure dates confirmed via security research firms

**Compliance Verification**:
- NIS2 status verified via ENISA.europa.eu (November 2025)
- GDPR Article citations verified via EUR-Lex
- DORA requirements verified via EU Official Journal
- AI Act provisions verified via EU Commission documentation

---

## 🚀 Getting Started (5 Minutes)

### Step 1: Determine Your Tier (2 min)

Answer these questions:

1. **Do you handle customer data?**
   - No → Essential
   - Yes → Continue...

2. **Is it in production with real users?**
   - No → Essential
   - Yes → Continue...

3. **Do you handle PII, payments, or health data?**
   - No → Standard
   - Yes → Hardened

4. **Are you in a regulated industry (finance, healthcare)?**
   - No → Standard
   - Yes → Hardened

5. **Do you have 50+ employees OR €10M+ revenue in EU critical sectors?**
   - No → Standard (unless you handle sensitive data)
   - Yes → Hardened (NIS2 likely applies)

**👉 Still unsure?** Read [SECURITY-TIERS.md](docs/SECURITY-TIERS.md)

---

### Step 2: Follow Your Tier's Quick Start (3 min)

**Essential**: [Quick Start](docs/tier-essential/QUICK-START.md) - 15 minutes to basic security

**Standard**: [Full Implementation](docs/tier-standard/FULL-IMPLEMENTATION.md) - 2-4 hours to production-ready

**Hardened**: [EU Compliance](docs/tier-hardened/EU-COMPLIANCE.md) - 1-2 weeks to full compliance

---

### Step 3: Set Up Daily Habits

**Every morning before coding**:
```bash
./scripts/security/daily-check.sh
```

**Before every commit**:
```bash
# Automatic via pre-commit hook (installed in setup)
git commit -m "your message"
```

**Weekly** (Mondays):
- Review Dependabot PRs
- Check secret scanning alerts
- Review open security issues

**Monthly**:
- Rotate credentials (90-day policy)
- Review access logs
- Update threat model
- Team security training

---

## 🆘 Support & Questions

### Internal Resources
- **Security Team**: security@yourcompany.com
- **Slack**: #security-alerts (incidents), #security-general (questions)

### External Resources
- **Anthropic Security**: https://docs.anthropic.com/security
- **Cursor Security**: https://github.com/cursor/cursor/security
- **Supabase Security**: https://supabase.com/docs/guides/platform/security
- **Netlify Security**: https://docs.netlify.com/security/
- **ENISA NIS2 Guidance**: https://www.enisa.europa.eu/publications/nis2-technical-implementation-guidance

### Contributing
Found a gap? Security issue? Want to improve something?

1. **Security vulnerabilities**: Email security@yourcompany.com (don't create public issues)
2. **Improvements**: Create GitHub issue or PR
3. **Questions**: Use GitHub Discussions

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.0 | 2025-11-15 | Complete rebuild with 2025 fact-checking, EU compliance, CVE documentation |
| 2.0 | 2025-11-14 | Production-ready expansion (contained critical inaccuracies - see audit) |
| 1.0 | 2025-11 | Initial German version |

---

## 📜 License

Apache 2.0 - See [LICENSE](LICENSE)

---

## ⚡ One-Line Summary

**Fact-checked, tiered security framework for AI-assisted development with Cursor and Claude Code, covering hobby projects through full EU regulatory compliance.**

---

**👉 Ready? Pick your tier above and get started! ⬆️**
