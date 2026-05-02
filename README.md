# 🔒 LLM Security Framework - Complete Package

**Version 2.1 | Production Ready**  
**Created**: November 14, 2025 | **Updated**: May 2026

---

## 📦 What's Included

This package contains everything you need to secure your AI-assisted development workflow with Claude Code, Cursor, GitHub, Netlify, and Supabase.

### 1. **docs/LLM-Security-Guidelines.md** (50KB) ⭐ PRIMARY DOCUMENT
**Purpose**: Comprehensive security framework  
**Audience**: All developers, security team  
**Use case**: Complete reference guide

**Contents**:
- 17 major security sections
- Tool-specific configurations (Cursor, Claude Code, Supabase, Netlify, GitHub)
- Incident response procedures
- Code examples and scripts
- Compliance requirements
- Risk classification system
- 200+ security controls

**When to use**: 
- First read for all team members
- Reference during development
- Security audits
- Onboarding new developers

---

### 2. **docs/Security-Quick-Reference.md** (5KB) ⭐ DAILY USE
**Purpose**: One-page cheat sheet  
**Audience**: All developers  
**Use case**: Keep at your desk, check daily

**Contents**:
- Pre-flight checklist for AI interactions
- Critical "never do" list
- Emergency response steps
- Quick security commands
- Secret leak procedures
- Risk level reference
- Emergency contacts template

**When to use**:
- Every morning before starting work
- Before committing code
- Before asking AI for help
- During incidents

**💡 TIP**: Print this and keep it visible at your desk!

---

### 3. **security-setup.sh** → **scripts/security-setup.sh** ⭐ ONE-TIME SETUP
**Purpose**: Automated security configuration  
**Audience**: DevOps, team leads, developers  
**Use case**: Initial repository setup

The root `security-setup.sh` is a thin wrapper — run it from the repo root for convenience. The actual script lives in `scripts/security-setup.sh`.

**What it does**:
- ✅ Installs Gitleaks (secret scanner)
- ✅ Creates .cursorignore
- ✅ Configures .gitignore
- ✅ Sets up Git pre-commit hooks
- ✅ Sets up Git pre-push hooks
- ✅ Creates security scripts
- ✅ Creates a baseline GitHub Actions workflow (only when `.github/workflows` already exists)
- ✅ Generates SECURITY.md
- ✅ Runs initial security scan

**Scope note**:
- The setup script automates local guardrails and baseline CI scaffolding.
- Advanced CI jobs (for example TruffleHog, Snyk, OWASP Dependency Check, SBOM, Trivy) are documented templates/examples and require manual enablement plus credentials.

**How to use**:
```bash
# 1. Navigate to your repository root
cd /path/to/your/repo

# 2. Copy this script to your repo
cp security-setup.sh /path/to/your/repo/

# 3. Make it executable
chmod +x security-setup.sh

# 4. Run it
./security-setup.sh

# 5. Follow the post-setup instructions
```

**Time**: ~5 minutes  
**Prerequisites**: Git repository, macOS/Linux, npm installed

---

### 4. **docs/GitHub-Security-Configuration.md** (16KB) ⭐ GITHUB SETUP
**Purpose**: Complete GitHub organization hardening guide  
**Audience**: DevOps, organization admins, security team  
**Use case**: GitHub configuration and maintenance

**Contents**:
- Organization-level security settings
- Branch protection rules (copy-paste ready)
- CODEOWNERS file template
- GitHub Actions security workflows
- Secret scanning configuration
- Dependabot configuration
- Audit logging setup
- Monthly security review checklist

**When to use**:
- Setting up new GitHub organization
- Hardening existing repositories
- Monthly security reviews
- After security incidents

### 5. **.github/workflows/security-scan.yml** ⭐ LIVE CI SECURITY

**Purpose**: Hardened GitHub Actions workflow that runs on every push and PR  
**Jobs**:
- `workflow-lint` — runs [zizmor](https://github.com/woodruffw/zizmor) to catch workflow security issues
- `secret-scan` — runs gitleaks with a verified egress allowlist (harden-runner block mode)
- `dependency-scan` — runs `npm audit` when a lockfile is present

The runner uses `step-security/harden-runner` in **block mode** — all outbound traffic not in the allowlist is rejected.

---

### 6. **templates/** — Hook and workflow templates

Pre-commit and pre-push hook templates, a `.cursorignore` template, a `CODEOWNERS` template, and advanced CI workflow templates (TruffleHog, Snyk, OWASP, SBOM, Trivy). These require manual enablement and credentials — see `templates/README.md`.

---

### 7. **examples/** — Ready-to-copy configs

| File | Purpose |
|------|---------|
| `examples/netlify.toml.example` | Netlify security headers and redirect rules |
| `examples/supabase-rls-policies.sql` | Row-level security policy starters |
| `examples/incident-response-template.md` | Incident response runbook template |

---

### 8. **Editor skills**

| Path | Editor |
|------|--------|
| `.claude/skills/ai-security-workflows/SKILL.md` | Claude Code |
| `.cursor/skills/ai-security-workflows/SKILL.md` | Cursor |

Copy to `~/.claude/skills/` or `~/.cursor/skills/` to reuse the skill in other repositories.

---

### 9. **Repo hygiene files**

`CHANGELOG.md` · `CONTRIBUTING.md` · `SECURITY.md` · `LICENSE`

---

## 🚀 Quick Start Guide

### For New Projects

**Step 1**: Read the basics (15 minutes)
```
□ Read Security-Quick-Reference.md
□ Skim LLM-Security-Guidelines.md sections 1-6
```

**Step 2**: Run automated setup (5 minutes)
```bash
cd your-project
./security-setup.sh
```

**Step 3**: Configure GitHub (30 minutes)
```
□ Follow GitHub-Security-Configuration.md
□ Enable GitHub Advanced Security
□ Set up branch protection
□ Create CODEOWNERS file
```

**Step 4**: Team onboarding (ongoing)
```
□ Share Security-Quick-Reference.md with team
□ Schedule security training
□ Add to onboarding checklist
```

---

### For Existing Projects

**Phase 1: Assessment** (1 hour)
```bash
# Run security scan
gitleaks detect --source . --verbose

# Check for exposed secrets
git log --all -p | grep -i "api_key\|secret\|password"

# Audit dependencies
npm audit
```

**Phase 2: Remediation** (2-4 hours)
```bash
# Run setup script
./security-setup.sh

# Clean history if secrets found
# (Follow LLM-Security-Guidelines.md Section 10)

# Rotate all potentially compromised keys
```

**Phase 3: Hardening** (2-3 hours)
```
□ Configure GitHub per GitHub-Security-Configuration.md
□ Set up Supabase RLS (LLM-Security-Guidelines.md Section 4)
□ Configure Netlify security (LLM-Security-Guidelines.md Section 5)
□ Train team on Security-Quick-Reference.md
```

---

## 📚 Document Hierarchy

```
Usage Frequency:
├── Daily
│   └── Security-Quick-Reference.md
│
├── Weekly
│   └── LLM-Security-Guidelines.md (Sections 1-7, 11-13)
│
├── One-time Setup
│   ├── security-setup.sh
│   └── GitHub-Security-Configuration.md
│
└── Reference/Incident Response
    └── LLM-Security-Guidelines.md (Sections 8-10, 14-17)
```

---

## 🎯 Role-Based Reading Guide

### **Developers** (Individual Contributors)
**Must Read**:
- ✅ Security-Quick-Reference.md (entire document)
- ✅ LLM-Security-Guidelines.md (Sections 1, 2, 6, 11)

**Should Read**:
- 📖 LLM-Security-Guidelines.md (Sections 3, 4, 5, 7, 12)

**Reference**:
- 📚 LLM-Security-Guidelines.md (Sections 8, 9, 10)

---

### **Team Leads / Engineering Managers**
**Must Read**:
- ✅ All documents in entirety
- ✅ LLM-Security-Guidelines.md (Sections 13, 14, 15)

**Action Items**:
- ✅ Run security-setup.sh on all repositories
- ✅ Configure GitHub per GitHub-Security-Configuration.md
- ✅ Schedule monthly security reviews
- ✅ Assign security champions

---

### **Security Team**
**Must Read**:
- ✅ LLM-Security-Guidelines.md (complete)
- ✅ GitHub-Security-Configuration.md (complete)

**Ownership**:
- ✅ Incident response (Section 10)
- ✅ Audit logging (Section 9)
- ✅ Compliance (Section 14)
- ✅ Monthly reviews (Section 13)

---

### **DevOps / Platform Engineers**
**Must Read**:
- ✅ security-setup.sh (understand what it does)
- ✅ GitHub-Security-Configuration.md (complete)
- ✅ LLM-Security-Guidelines.md (Sections 3, 5, 8, 12)

**Action Items**:
- ✅ Implement CI/CD security scans
- ✅ Configure organization-level GitHub settings
- ✅ Set up monitoring and alerting
- ✅ Maintain secret rotation schedule

---

## ⚠️ Critical Implementation Priorities

### 🔴 **CRITICAL** (Do within 24 hours)
1. Run `security-setup.sh` on all repositories
2. Enable GitHub secret scanning with push protection
3. Scan all repositories for existing secrets
4. Rotate any exposed credentials
5. Enable Supabase RLS on all tables

### 🟠 **HIGH** (Do within 1 week)
1. Configure branch protection rules
2. Create CODEOWNERS file
3. Set up GitHub Actions security workflows
4. Configure Dependabot
5. Train all developers on Security-Quick-Reference.md

### 🟡 **MEDIUM** (Do within 1 month)
1. Complete team security training
2. Implement audit logging
3. Set up monitoring and alerting
4. Document incident response procedures
5. Schedule monthly security reviews

---

## 🆘 Emergency Quick Links

### 🚨 Secret Leaked in Git
**→ LLM-Security-Guidelines.md, Section 10**  
**→ security-setup.sh creates:** `scripts/security/secret-leak-response.sh`

### ⚠️ Suspected Prompt Injection
**→ LLM-Security-Guidelines.md, Section 10**  
**→ Security-Quick-Reference.md, "SUSPICIOUS AI BEHAVIOR"**

### 🔍 How Do I...?
| Question | Answer Location |
|----------|----------------|
| Configure Cursor safely? | LLM-Security-Guidelines.md, Section 1 |
| Use Claude Code securely? | LLM-Security-Guidelines.md, Section 2 |
| Set up Supabase RLS? | LLM-Security-Guidelines.md, Section 4 |
| Configure Netlify security? | LLM-Security-Guidelines.md, Section 5 |
| Verify a package before installing? | LLM-Security-Guidelines.md, Section 7 |
| Respond to an incident? | LLM-Security-Guidelines.md, Section 10 |
| Review AI-generated code? | LLM-Security-Guidelines.md, Section 11 |

---

## 📊 Metrics & Success Criteria

Track these metrics monthly:

```yaml
Prevention Metrics:
  - Secrets detected by pre-commit hooks: (target: <5/month)
  - Commits blocked by push protection: (tracked automatically)
  - Vulnerabilities in dependencies: (target: 0 critical)
  - Time to patch critical CVEs: (target: <48 hours)

Detection Metrics:
  - Mean time to detect security issue: (target: <1 hour)
  - False positive rate: (target: <10%)
  - Secret scanning alerts: (target: 0 open)
  
Response Metrics:
  - Mean time to respond to incidents: (target: <30 minutes)
  - Mean time to remediate: (target: <4 hours)
  - Incident retrospectives completed: (target: 100%)

Training Metrics:
  - Developers trained: (target: 100%)
  - Security awareness test pass rate: (target: >90%)
```

---

## 🔄 Maintenance Schedule

### Daily
- Individual developers run: `./scripts/security/daily-check.sh`

### Weekly
- Review Dependabot PRs
- Check secret scanning alerts
- Review open security issues

### Monthly
- Security team review meeting
- Update threat model
- Rotate credentials
- Review access logs
- Update documentation

### Quarterly
- Full security audit
- Penetration testing
- Team training refresh
- Tool updates

### Annually
- Complete security posture review
- Update compliance documentation
- Third-party security assessment

---

## 🛠️ Customization Guide

### Adapting for Your Organization

**Replace these placeholders throughout documents**:

```
@org/security-team → your-actual-security-team
@org/backend-team → your-actual-backend-team
@org/devops-team → your-actual-devops-team
security@yourcompany.com → your-actual-security-email
#security-alerts → your-actual-slack-channel
```

**Adjust risk levels** based on your:
- Industry regulations (healthcare, finance, etc.)
- Data sensitivity
- Threat model
- Compliance requirements

**Add sections for**:
- Your specific cloud providers
- Internal tools not covered
- Company-specific policies
- Industry-specific requirements

---

## Maintainer notes

### Vendor documentation validation

Re-check upstream guidance on a cadence your team commits to (for example quarterly). Update **Last reviewed** after each pass.

| Area | What to re-check | Last reviewed |
|------|------------------|---------------|
| GitHub Actions / platform | Runner Node defaults, pinned action versions, org security UI paths | 2026-05-03 |
| Editor rules / MCP | Ignore-file docs, in-repo rules as a trust boundary, MCP credentials and egress | 2026-05-03 |
| Anthropic CLI | Install and credential storage docs for coding agents | 2026-05-03 |
| Gitleaks | Install commands and `protect` / `detect` usage | 2026-05-03 |
| Netlify | `examples/netlify.toml.example` vs current platform security docs | 2026-05-03 |
| Supabase | RLS and dashboard security wording in docs | 2026-05-02 |

### CI and installer parity

After changing [`.github/workflows/security-scan.yml`](.github/workflows/security-scan.yml), apply the same YAML to the embedded block in [`scripts/security-setup.sh`](scripts/security-setup.sh) (see the workflow file header comment).

### Editor skills: AI security for workflows

Bundled for both editors:
- Claude Code: [`.claude/skills/ai-security-workflows/SKILL.md`](.claude/skills/ai-security-workflows/SKILL.md) → copy to `~/.claude/skills/ai-security-workflows/`
- Cursor: [`.cursor/skills/ai-security-workflows/SKILL.md`](.cursor/skills/ai-security-workflows/SKILL.md) → copy to `~/.cursor/skills/ai-security-workflows/`

### Hooks vs `templates/`

[`scripts/security-setup.sh`](scripts/security-setup.sh) installs **minimal** hooks. [`templates/README.md`](templates/README.md) explains how that differs from the longer `pre-commit` / `pre-push` template files.

### GitHub template smoke check

Whenever `.github/PULL_REQUEST_TEMPLATE.md` or `.github/ISSUE_TEMPLATE/` changes, open a test issue or PR on GitHub and confirm the sections render as expected. Record the verification date under **Unreleased** in [`CHANGELOG.md`](CHANGELOG.md) or refresh the **Last reviewed** row above.

---

## 📝 Version History

| Version | Date | Major Changes |
|---------|------|---------------|
| 1.0 | 2025-11 | Initial German version (user-created) |
| 2.0 | 2025-11-14 | Production-ready English expansion with:<br>• 17 comprehensive sections<br>• Tool-specific configs<br>• Incident response procedures<br>• Setup automation<br>• GitHub hardening guide |
| 2.1 | 2026-05 | CI hardening:<br>• harden-runner switched to block mode with verified egress allowlist<br>• gitleaks-action wired with license secret<br>• Claude Code skill added alongside Cursor skill |

---

## 🤝 Contributing

This is a living document. To improve:

1. **Found a security gap?** 
   - Email: security@yourcompany.com
   - Don't create public issues for vulnerabilities

2. **Have a suggestion?**
   - Create an issue or PR
   - Include rationale and examples

3. **After an incident**:
   - Update relevant sections
   - Add lessons learned
   - Update response procedures

---

## 📞 Support & Questions

### Internal
- **Security Team**: security@yourcompany.com
- **Slack**: #security-alerts (incidents), #security-general (questions)
- **Wiki**: [Link to internal security wiki]

### External Resources
- **Anthropic Security**: https://docs.anthropic.com/security
- **Supabase Security**: https://supabase.com/docs/guides/platform/security
- **GitHub Security**: https://docs.github.com/en/code-security
- **Netlify Security**: https://docs.netlify.com/security/
- **OWASP**: https://owasp.org/www-project-top-ten/

---

## ✅ Implementation Checklist

Use this to track your security framework implementation:

### Setup Phase
```
□ Read all documents
□ Run security-setup.sh on all repositories
□ Configure GitHub organization settings
□ Enable GitHub Advanced Security
□ Set up branch protection rules
□ Create CODEOWNERS files
□ Configure Dependabot
□ Set up CI/CD security scans
```

### Training Phase
```
□ Train all developers on Security-Quick-Reference
□ Conduct security awareness session
□ Distribute documentation to team
□ Assign security champions
□ Create onboarding checklist
```

### Operational Phase
```
□ Daily security checks running
□ Weekly Dependabot review process
□ Monthly security review meetings
□ Incident response tested
□ Metrics tracking implemented
□ Audit logging enabled
```

### Verification Phase
```
□ All repositories scanned
□ No secrets in Git history
□ All keys rotated
□ RLS enabled on all Supabase tables
□ Team trained and certified
□ Documentation customized for org
```

---

## 🎓 Training Resources

Included in this package:
- ✅ Security-Quick-Reference.md (printable cheat sheet)
- ✅ LLM-Security-Guidelines.md (comprehensive manual)
- ✅ GitHub-Security-Configuration.md (hands-on guide)
- ✅ security-setup.sh (automated implementation)

Recommended external training:
- OWASP Top 10 course
- GitHub Security certification
- Supabase security best practices
- AI security fundamentals

---

## 🏁 Next Steps

**Right Now** (5 minutes):
1. Read Security-Quick-Reference.md
2. Print it and put it at your desk
3. Check if Gitleaks is installed: `gitleaks version`

**Today** (1 hour):
1. Run security-setup.sh on your main repository
2. Fix any secrets it finds
3. Share Security-Quick-Reference.md with your team

**This Week** (3-4 hours):
1. Read LLM-Security-Guidelines.md sections 1-7
2. Configure GitHub per GitHub-Security-Configuration.md
3. Schedule team security training session

**This Month**:
1. Complete full security framework implementation
2. Train all team members
3. Schedule first monthly security review

---

**Remember**: Security is not a one-time setup—it's a continuous practice. Start small, be consistent, and improve iteratively.

---

*Package created: November 14, 2025*  
*Framework version: 2.0*  
*Maintained by: Security Team*
