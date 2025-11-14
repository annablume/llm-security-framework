# GitHub Organization Security Configuration Checklist

**For**: AI-Assisted Development with Claude Code, Cursor  
**Version**: 2.0  
**Last Updated**: November 2025

---

## Organization-Level Settings

### 1. Enable GitHub Advanced Security

**Navigation**: Organization Settings > Code security and analysis

```
✓ Dependency graph (automatically enabled)
✓ Dependabot alerts
✓ Dependabot security updates
✓ Secret scanning
✓ Secret scanning push protection (CRITICAL)
✓ Code scanning (if using GitHub Actions)
```

**Cost**: Free for public repos, requires GitHub Enterprise for private repos

---

### 2. Organization Access Controls

**Navigation**: Organization Settings > Member privileges

```yaml
Base permissions: Read
Repository creation: Restrict to admins
Repository deletion: Require 2FA
Pages creation: Restrict to admins
Team creation: Restrict to admins
Two-factor authentication: Required for all members
```

---

### 3. Repository Security Settings

Apply to **ALL** repositories:

#### A. Branch Protection Rules

**Navigation**: Repository > Settings > Branches > Add rule

**For `main` branch**:

```yaml
Branch name pattern: main

Protect matching branches:
  ✓ Require a pull request before merging
    - Required approvals: 2
    - Dismiss stale pull request approvals when new commits are pushed
    - Require review from Code Owners
    - Require approval of the most recent reviewable push
  
  ✓ Require status checks to pass before merging
    - Require branches to be up to date before merging
    - Status checks: (add these)
      • security/secret-scan
      • security/dependency-check
      • ci/tests
      • ci/lint
  
  ✓ Require conversation resolution before merging
  ✓ Require signed commits (optional but recommended)
  ✓ Require linear history
  ✓ Require deployments to succeed before merging (if applicable)
  
  ✓ Lock branch (for production branches)
  ✓ Do not allow bypassing the above settings
  ✓ Restrict who can push to matching branches
    - Restrict pushes to: Security team, DevOps team
  
  □ Allow force pushes: DISABLED
  □ Allow deletions: DISABLED
```

**For `develop` branch** (slightly relaxed):

```yaml
Branch name pattern: develop

Protect matching branches:
  ✓ Require a pull request before merging
    - Required approvals: 1
    - Dismiss stale pull request approvals
  
  ✓ Require status checks to pass before merging
    - Same status checks as main
  
  □ Require signed commits
  □ Require linear history
  
  □ Allow force pushes: DISABLED
  □ Allow deletions: DISABLED
```

---

#### B. CODEOWNERS File

Create `.github/CODEOWNERS` in repository root:

```bash
# Global reviewers (require approval from at least one)
* @org/developers

# Security-sensitive files (require security team approval)
.env.example @org/security-team
.github/ @org/security-team @org/devops-team
netlify.toml @org/security-team @org/platform-team
supabase/ @org/security-team @org/backend-team

# Infrastructure as code
infrastructure/ @org/security-team @org/devops-team
terraform/ @org/security-team @org/devops-team
.github/workflows/ @org/security-team @org/devops-team
Dockerfile @org/security-team @org/devops-team
docker-compose*.yml @org/security-team @org/devops-team

# Database migrations
supabase/migrations/ @org/backend-team @org/database-admin
prisma/migrations/ @org/backend-team @org/database-admin
**/migrations/ @org/backend-team

# Authentication & Security
**/auth/ @org/security-team @org/backend-team
**/middleware/auth* @org/security-team
**/middleware/security* @org/security-team
**/api/auth/ @org/security-team @org/backend-team

# Dependency management
package.json @org/security-team
package-lock.json @org/security-team
yarn.lock @org/security-team
requirements.txt @org/security-team
Pipfile.lock @org/security-team
go.mod @org/security-team
go.sum @org/security-team

# CI/CD
.github/workflows/ @org/devops-team @org/security-team
.gitlab-ci.yml @org/devops-team @org/security-team
.circleci/ @org/devops-team @org/security-team

# Documentation (if contains architecture)
docs/architecture/ @org/security-team @org/engineering-leads
docs/infrastructure/ @org/security-team @org/devops-team
```

---

#### C. Required Workflows

Create `.github/workflows/security-scan.yml`:

```yaml
name: Security Scan

on:
  push:
    branches: [ main, develop, 'feature/**' ]
  pull_request:
    branches: [ main, develop ]
  schedule:
    # Run weekly on Monday at 9 AM UTC
    - cron: '0 9 * * 1'

permissions:
  contents: read
  security-events: write
  pull-requests: write

jobs:
  secret-scanning:
    name: Secret Scanning
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Full history for better detection

      - name: Gitleaks
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GITLEAKS_LICENSE: ${{ secrets.GITLEAKS_LICENSE }} # Only for Gitleaks Enterprise

      - name: TruffleHog
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base: ${{ github.event.repository.default_branch }}
          head: HEAD
          extra_args: --debug --only-verified

  dependency-scanning:
    name: Dependency Scanning
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: npm audit
        run: npm audit --audit-level=moderate
        continue-on-error: true

      - name: Snyk Security Scan
        uses: snyk/actions/node@master
        continue-on-error: true
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high --fail-on=upgradable

      - name: OWASP Dependency Check
        uses: dependency-check/Dependency-Check_Action@main
        with:
          project: 'project-name'
          path: '.'
          format: 'SARIF'
          args: >
            --enableRetired
            --enableExperimental

      - name: Upload OWASP results to GitHub
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: reports/dependency-check-report.sarif

  code-quality:
    name: Code Quality & Linting
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: ESLint
        run: npm run lint
        continue-on-error: true

      - name: TypeScript Check
        run: npx tsc --noEmit
        continue-on-error: true

  license-compliance:
    name: License Compliance
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Check licenses
        run: |
          npx license-checker --summary --production \
            --excludePackages "package1@version;package2@version" \
            --exclude "MIT,ISC,Apache-2.0,BSD-2-Clause,BSD-3-Clause" \
            --failOn "GPL;AGPL;LGPL;SSPL"

  sbom-generation:
    name: Generate SBOM
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Generate SBOM with Syft
        uses: anchore/sbom-action@v0
        with:
          format: cyclonedx-json
          output-file: sbom.json

      - name: Upload SBOM as artifact
        uses: actions/upload-artifact@v3
        with:
          name: sbom
          path: sbom.json
          retention-days: 90

  container-scanning:
    name: Container Scanning
    runs-on: ubuntu-latest
    if: github.event_name == 'push' || github.event_name == 'pull_request'
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build Docker image
        run: docker build -t myapp:${{ github.sha }} .

      - name: Scan with Trivy
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: myapp:${{ github.sha }}
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'

      - name: Upload Trivy results to GitHub Security
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'
```

---

### 4. Secret Scanning Configuration

**Navigation**: Repository > Settings > Code security and analysis > Secret scanning

#### A. Enable Push Protection

```yaml
✓ Push protection: Enabled
```

This blocks commits containing secrets from being pushed.

#### B. Custom Patterns (if needed)

Add custom secret patterns for your organization:

**Navigation**: Organization Settings > Code security and analysis > Secret scanning > Custom patterns

Example patterns:

```
Name: Internal API Key Pattern
Secret format: INTERNAL_API_[A-Z0-9]{32}
Test string: INTERNAL_API_ABCD1234EFGH5678IJKL9012MNOP3456

Name: Custom Service Token
Secret format: svc_[a-z0-9]{40}
Test string: svc_abcd1234efgh5678ijkl9012mnop3456qrst7890
```

---

### 5. Dependabot Configuration

Create `.github/dependabot.yml`:

```yaml
version: 2
updates:
  # Enable version updates for npm
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
    open-pull-requests-limit: 10
    reviewers:
      - "org/security-team"
    assignees:
      - "org/backend-team"
    commit-message:
      prefix: "deps"
      include: "scope"
    labels:
      - "dependencies"
      - "security"
    ignore:
      # Ignore major version updates for now
      - dependency-name: "*"
        update-types: ["version-update:semver-major"]

  # GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "org/devops-team"
    labels:
      - "dependencies"
      - "ci-cd"

  # Docker
  - package-ecosystem: "docker"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "org/devops-team"
    labels:
      - "dependencies"
      - "docker"

  # Python (if applicable)
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "org/backend-team"
    labels:
      - "dependencies"
      - "python"
```

---

### 6. Required Status Checks Setup

**Navigation**: Repository > Settings > Branches > Branch protection rule > Require status checks

Add these required checks before merging:

```
✓ security/secret-scan
✓ security/dependency-check
✓ security/code-quality
✓ ci/tests
✓ ci/build
✓ ci/lint
```

Configure these in your CI/CD workflows.

---

### 7. GitHub Actions Security

#### A. Action Permissions

**Navigation**: Repository > Settings > Actions > General > Workflow permissions

```yaml
Workflow permissions:
  ◉ Read repository contents and packages permissions
  
Permissions:
  □ Allow GitHub Actions to create and approve pull requests
```

For each workflow, explicitly declare minimal permissions:

```yaml
permissions:
  contents: read        # Clone repo
  pull-requests: write  # Comment on PRs
  security-events: write # Upload scan results
```

#### B. Action Restrictions

**Navigation**: Organization Settings > Actions > General > Policies

```yaml
Actions permissions:
  ◉ Allow select actions and reusable workflows
  
Allow actions created by GitHub: ✓
Allow actions by Marketplace verified creators: ✓
Allow specified actions and reusable workflows:
  actions/*,
  github/*,
  docker/*,
  snyk/actions/*,
  aquasecurity/trivy-action@*,
  anchore/sbom-action@*
```

---

### 8. Deploy Keys and Secrets Management

#### A. Deploy Keys

**Navigation**: Repository > Settings > Deploy keys

```
Rules:
• Use deploy keys instead of personal access tokens
• Create read-only deploy keys for CI/CD
• Rotate deploy keys every 90 days
• Never share deploy keys between repositories
```

#### B. Repository Secrets

**Navigation**: Repository > Settings > Secrets and variables > Actions

```yaml
Required Secrets:
  SNYK_TOKEN              # Snyk security scanning
  SLACK_WEBHOOK_URL       # Security notifications
  SENTRY_DSN              # Error tracking

Environment-Specific Secrets:
  Production:
    SUPABASE_SERVICE_KEY
    NETLIFY_AUTH_TOKEN
  
  Staging:
    STAGING_SUPABASE_KEY
    STAGING_NETLIFY_TOKEN

Never Store:
  ❌ Personal credentials
  ❌ Customer data
  ❌ Plaintext passwords
  ❌ SSH private keys (use deploy keys instead)
```

---

### 9. Security Policy

Create `SECURITY.md` in repository root:

```markdown
# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.x.x   | :white_check_mark: |
| 1.x.x   | :x:                |

## Reporting a Vulnerability

**DO NOT** create public issues for security vulnerabilities.

Instead, please email: security@yourcompany.com

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if available)

We will respond within 48 hours and provide a timeline for fixes.

## Security Measures

This repository implements:
- ✅ Automated secret scanning
- ✅ Dependency vulnerability scanning
- ✅ Pre-commit hooks for local checks
- ✅ Code review requirements
- ✅ Signed commits (recommended)
- ✅ Branch protection

## Security Best Practices

For detailed security guidelines, see: `LLM-Security-Guidelines.md`
```

---

### 10. Audit Logging

**Navigation**: Organization Settings > Audit log

```yaml
Configuration:
  ✓ Enable audit log streaming (Enterprise only)
  ✓ Export audit logs regularly
  ✓ Set up alerts for sensitive events:
    - Repository deletion
    - Secret scanning alert dismissed
    - Branch protection changes
    - Member privilege changes
    - New deploy keys
```

---

## Verification Checklist

Use this to verify configuration:

```bash
□ GitHub Advanced Security enabled
□ Secret scanning active with push protection
□ Dependabot alerts enabled
□ Dependabot security updates enabled
□ Branch protection on main/master
□ Branch protection on develop
□ CODEOWNERS file created
□ Required status checks configured
□ 2FA required for all org members
□ Action permissions restricted
□ Deploy keys used (not PATs)
□ Security workflows running
□ Dependabot configured
□ SECURITY.md published
□ Audit logging enabled
```

---

## Monthly Security Review Tasks

**First Monday of each month:**

```bash
□ Review open Dependabot PRs
□ Check secret scanning alerts
□ Review audit log for anomalies
□ Update CODEOWNERS if teams changed
□ Verify all team members have 2FA enabled
□ Review repository permissions
□ Check for stale branches
□ Update security documentation
□ Rotate deploy keys (quarterly)
□ Review GitHub Actions usage
```

---

## Emergency Procedures

### If Secret Scanning Alert Fired

1. **Immediate**: Revoke the exposed credential
2. **Within 1 hour**: Rotate affected keys
3. **Within 4 hours**: Review access logs
4. **Within 24 hours**: Complete incident report
5. **Document**: Add to incident log

### If Malicious Code Detected

1. **Immediate**: Revert suspicious commits
2. **Lock branch** temporarily
3. **Notify security team**
4. **Review PR approver logs**
5. **Update branch protection rules** if needed

---

## Additional Resources

- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [Secret Scanning Patterns](https://docs.github.com/en/code-security/secret-scanning/secret-scanning-patterns)
- [Dependabot Documentation](https://docs.github.com/en/code-security/dependabot)
- [Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)

---

**Document Version**: 2.0  
**Last Review**: 2025-11-14  
**Next Review**: 2025-12-14  
**Owner**: Security Team