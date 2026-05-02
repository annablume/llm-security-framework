# Changelog

All notable changes to the LLM Security Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [2.1.0] - 2026-05-02

### Security

- Switched `step-security/harden-runner` to `block` mode with verified egress allowlist across all CI workflows and the installer heredoc in `security-setup.sh`
- Added `GITLEAKS_LICENSE` secret wiring and `api.github.com:443` / `gitleaks.io:443` to the secret-scan job egress allowlist (required by gitleaks-action v2)

### Fixed

- Pre-push hook: was checking local branch name (`git symbolic-ref HEAD`) instead of reading the push target from stdin — any push from a local `main` branch falsely blocked even when targeting a non-protected remote ref; now reads `remote_ref` from stdin and skips deletion pushes (all-zero SHA)
- Pre-push hook example in `docs/LLM-Security-Guidelines.md` updated to match the corrected stdin approach
- `pkill` target corrected from `claude-code` to `claude` (the actual process name)
- Fabricated `claude-code` CLI flags (`--audit-log`, `--read-only`, `--allowed-paths`, `review-session`) replaced with real in-session slash commands (`/permissions`, `/status`, `/help`) and `settings.json` knobs
- Wrong incident-response path in `.cursor/skills/ai-security-workflows/SKILL.md` (`docs/` → `examples/`)
- Version numbers and year updated across `SECURITY.md`, `CONTRIBUTING.md`, and the guidelines header (2025 → 2026)

### Changed

- **Cursor security** (Section 1): Added Privacy Mode / ZDR, `.cursorindexingignore`, `.cursorignore` terminal/MCP caveats, Rules security, MCP server risks; removed stale settings keys
- **Claude Code security** (Section 2): Complete rewrite — removed invented flags, documented real permission model (`deny`/`ask`/`allow`), permission modes (`plan`, `default`, `acceptEdits`, `bypassPermissions`), sandbox, `denyTools`, `CLAUDE.md` trust model, and managed settings
- **Supabase RLS** (Section 4): Updated policies to use `(select auth.uid())` wrapping for performance, `TO authenticated`, `raw_app_meta_data` for role claims, null guard, security definer functions; added `examples/supabase-rls-policies.sql` with 10 real policy sections
- **Netlify headers** (Section 5): Removed deprecated `X-XSS-Protection`, removed `'unsafe-inline'`/`'unsafe-eval'` CSP defaults, added function-header caveat, documented Secrets Controller; updated `examples/netlify.toml.example`
- **README.md**: Fixed stale paths, added sections for CI workflows, `templates/`, `examples/`, editor skills, hygiene files; added maintainer revalidation table and v2.1 version history
- **Template files**: Filled previously empty `templates/.github/workflows/security-scan.yml` (TruffleHog, Trivy, SBOM jobs) and `templates/.github/workflows/dependency-check.yml` (Snyk, OWASP Dependency-Check); added `templates/README.md`

### Maintainer notes

- `security-scan.yml` and the heredoc emitted by `security-setup.sh` must stay identical for new installs — see header comment in the workflow file
- After edits to `.github/PULL_REQUEST_TEMPLATE.md` or `.github/ISSUE_TEMPLATE/`, smoke-test on github.com and record the date in the README maintainer table

---

## [2.0.0] - 2025-11-14

### 🎉 Initial Release

The first production-ready release of the LLM Security Framework - a comprehensive security framework for AI-assisted development workflows.

### ✨ Added

#### Core Documentation
- **Complete Security Manual** (50KB, 2,035 lines)
  - 17 comprehensive security sections
  - Tool-specific configurations for Cursor, Claude Code, GitHub, Netlify, Supabase
  - Risk classification system (Critical/High/Medium/Low)
  - 200+ actionable security controls
  - Compliance guidelines (GDPR, SOC2, ISO27001)

- **Security Quick Reference** (5KB)
  - Daily security checklist
  - Pre-flight checks for AI interactions
  - Emergency response procedures
  - Critical "never do" list
  - Quick command reference

- **GitHub Security Configuration Guide** (16KB)
  - Organization-level security settings
  - Branch protection configurations
  - Secret scanning setup
  - Dependabot configuration
  - Monthly maintenance checklists

- **Repository Structure Guide** (9KB)
  - Complete file organization
  - Setup instructions
  - Badge examples
  - Marketing checklist

#### Automation & Scripts
- **One-Command Setup Script** (`security-setup.sh`)
  - Installs Gitleaks secret scanner
  - Creates `.cursorignore` for AI context protection
  - Configures `.gitignore` with security entries
  - Sets up Git pre-commit hooks
  - Sets up Git pre-push hooks
  - Creates security utility scripts
  - Generates a baseline GitHub Actions workflow when `.github/workflows` exists
  - Runs initial security scan

#### GitHub Templates & Workflows
- **Security Scan Workflow** (`security-scan.yml`)
  - Baseline automated checks: Gitleaks secret scan + npm audit dependency scan
  - Extended checks (TruffleHog, Snyk, OWASP, SBOM, Trivy) are available as template/documentation guidance and require manual setup

- **CODEOWNERS Template**
  - 100+ security-sensitive path patterns
  - Team-based code ownership rules
  - Authentication/authorization oversight
  - Infrastructure change controls
  - Dependency management oversight

- **Pull Request Template**
  - Comprehensive security checklist (20+ items)
  - Code quality verification
  - Testing requirements
  - Documentation guidelines
  - Deployment notes

- **Git Hooks Templates**
  - Pre-commit hook: Local secret scanning, debug code detection, sensitive pattern matching
  - Pre-push hook: Full repository scan, test execution, build verification

- **Cursor AI Protection** (`.cursorignore.template`)
  - Prevents secrets from loading into AI context
  - Protects 15+ categories of sensitive files
  - Cloud provider configuration protection
  - Build artifact exclusion

#### Configuration Examples
- **Netlify Configuration** (`netlify.toml.example`, 493 lines)
  - Production-ready security headers (CSP, HSTS, X-Frame-Options)
  - Context-specific environment handling
  - CORS configuration
  - Caching strategies
  - Serverless function security
  - Rate limiting examples

- **Supabase RLS Policies** (`supabase-rls-policies.sql`, 616 lines)
  - 12 comprehensive Row Level Security patterns
  - User-owned resources
  - Role-based access control (RBAC)
  - Team/organization access
  - Time-based access
  - Multi-tenant isolation
  - Hierarchical permissions
  - Testing examples
  - Performance optimization tips

- **Incident Response Template** (`incident-response-template.md`, 542 lines)
  - Complete incident report structure
  - Timeline tracking
  - Impact assessment framework
  - Root cause analysis (Five Whys)
  - Action item tracking
  - Evidence collection procedures
  - Post-incident review template

#### Repository Governance
- **README.md** - Master documentation and quick start guide
- **SECURITY.md** - Security policy and vulnerability reporting procedures
- **CONTRIBUTING.md** - Comprehensive contribution guidelines
- **Code of Conduct** - Community standards (embedded in CONTRIBUTING.md)

### 🔒 Security Features

#### Prevention
- Pre-commit secret scanning with Gitleaks
- Pre-push comprehensive validation
- GitHub push protection for secrets
- Dependency vulnerability scanning
- Automated code analysis
- License compliance checks

#### Detection
- Weekly automated security scans
- Real-time secret scanning
- Dependabot vulnerability alerts
- Audit logging guidelines
- Anomaly detection patterns

#### Response
- Pre-defined incident response procedures
- 30-minute response timelines for critical issues
- Communication templates
- Forensics procedures
- Rollback strategies

#### Recovery
- Backup strategies documented
- Disaster recovery procedures
- Business continuity guidelines
- Secret rotation workflows

### 📊 Statistics

- **17 files** totaling 235KB
- **5,977 total lines** of production-ready code and documentation
- **200+ security controls** documented
- **12 RLS policy patterns** with examples
- **100+ file patterns** in CODEOWNERS template
- **20+ security checklist items** in PR template
- **15+ categories** of files protected from AI context
- **6 automated security jobs** in GitHub Actions

### 🎯 Platform Support

- **AI Assistants**: Cursor, Claude Code, GitHub Copilot
- **Cloud Platforms**: Netlify, Vercel
- **Databases**: Supabase, PostgreSQL with RLS
- **Version Control**: GitHub (with GitLab/Bitbucket adaptability)
- **CI/CD**: GitHub Actions (adaptable to other platforms)
- **Languages**: JavaScript/TypeScript, Python, Shell/Bash

### 📚 Documentation Coverage

#### Cursor IDE Security
- Context window protection
- Composer/Agent mode safety
- Workspace-level settings
- File exclusion patterns

#### Claude Code CLI Security
- API key management
- Command execution validation
- Workspace isolation
- Audit logging

#### GitHub Organization Hardening
- Branch protection rules
- Secret scanning configuration
- Dependabot setup
- Actions security
- Access controls

#### Supabase Security
- Row Level Security (RLS) enforcement
- API key separation (anon vs service role)
- Database migration review process
- Edge function security

#### Netlify Security
- Environment variable management
- Build hook protection
- Serverless function security
- Deploy preview isolation
- Security headers configuration

### 🌟 Key Innovations

- **First comprehensive framework** specifically for AI-assisted development security
- **Addresses AI-specific risks** (context window exposure, prompt injection, AI-generated vulnerabilities)
- **Production-ready configurations** that work out of the box
- **Automated setup** reducing implementation time from days to minutes
- **Real-world examples** based on actual security patterns and incidents
- **Multi-tool coverage** across the entire development workflow

### 🔧 Technical Improvements

- Gitleaks integration for secret detection
- Baseline GitHub Actions security workflow with stable check names
- Automated baseline dependency scanning (npm audit)
- Expanded workflow examples for SBOM/container/deep scanning in docs/templates (manual enablement)
- Pre-commit and pre-push validation
- Comprehensive logging and monitoring guidelines

### 📖 Breaking Changes

N/A - Initial release

### ⚠️ Known Issues

None at release. Report issues at: https://github.com/yourusername/llm-security-framework/issues

### 🙏 Acknowledgments

This framework builds upon security best practices from:
- OWASP Security Guidelines
- GitHub Security Best Practices
- Anthropic AI Security Documentation
- Supabase Security Guidelines
- Netlify Security Documentation

### 📝 Migration Guide

N/A - Initial release. For setup instructions, see [README.md](README.md) and run `./scripts/security-setup.sh`.

---

## How to Update This Changelog

### For Maintainers

When releasing a new version:

1. **Move items from [Unreleased] to new version section**
2. **Update the version number and date**
3. **Categorize changes**:
   - `Added` - New features
   - `Changed` - Changes in existing functionality
   - `Deprecated` - Soon-to-be removed features
   - `Removed` - Removed features
   - `Fixed` - Bug fixes
   - `Security` - Security improvements/fixes

4. **Follow format**:
```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- Feature description

### Fixed
- Bug fix description

### Security
- Security improvement description
```

5. **Update version links at bottom**
6. **Commit with**: `docs(changelog): release version X.Y.Z`

### For Contributors

When submitting PRs, add your changes to the `[Unreleased]` section:

```markdown
## [Unreleased]

### Added
- Your new feature description (#PR_NUMBER)
```

### Version Number Guidelines

Following [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes, major rewrites
  - Example: Removing support for a tool, changing file structure
  
- **MINOR** (0.X.0): New features, backwards compatible
  - Example: Adding AWS support, new templates
  
- **PATCH** (0.0.X): Bug fixes, backwards compatible
  - Example: Fixing typos, correcting scripts

---

## Version History

| Version | Release Date | Highlights |
|---------|--------------|------------|
| [2.1.0](#210---2026-05-02) | 2026-05-02 | Security hardening, doc accuracy pass, hook bug fix |
| [2.0.0](#200---2025-11-14) | 2025-11-14 | Initial production release |

---

## Links

- [Repository](https://github.com/yourusername/llm-security-framework)
- [Issues](https://github.com/yourusername/llm-security-framework/issues)
- [Pull Requests](https://github.com/yourusername/llm-security-framework/pulls)
- [Discussions](https://github.com/yourusername/llm-security-framework/discussions)
- [Security Policy](SECURITY.md)
- [Contributing Guide](CONTRIBUTING.md)

---

**[2.1.0]**: https://github.com/annablume/llm-security-framework/compare/v2.0.0...v2.1.0
**[2.0.0]**: https://github.com/annablume/llm-security-framework/releases/tag/v2.0.0
**[Unreleased]**: https://github.com/annablume/llm-security-framework/compare/v2.1.0...HEAD