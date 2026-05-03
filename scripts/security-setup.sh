#!/bin/bash

# LLM Security Setup Script
# Version 2.0
# This script automates the setup of security controls for AI-assisted development
#
# Existing .github/workflows/security-scan.yml is not overwritten unless you set:
#   LLM_SECURITY_FRAMEWORK_OVERWRITE_WORKFLOW=1

set -e  # Exit on error

echo "🔒 LLM Security Setup Script v2.0"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo -e "${RED}❌ Error: Not in a git repository${NC}"
    echo "Run this script from your repository root"
    exit 1
fi

echo "📁 Repository: $(basename $(pwd))"
echo ""

# Function to print status
status() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}❌${NC} $1"
}

# 1. Install Gitleaks
echo "1️⃣  Installing Gitleaks (secret scanner)..."
if command -v gitleaks &> /dev/null; then
    status "Gitleaks already installed: $(gitleaks version)"
else
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install gitleaks
            status "Gitleaks installed via Homebrew"
        else
            error "Homebrew not found. Install from: https://brew.sh"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -sSfL https://raw.githubusercontent.com/gitleaks/gitleaks/master/scripts/install.sh | sh -s -- -b /usr/local/bin
        status "Gitleaks installed"
    else
        warning "Unsupported OS. Install Gitleaks manually: https://github.com/gitleaks/gitleaks"
    fi
fi
echo ""

# 2. Create .cursorignore
echo "2️⃣  Creating .cursorignore..."
if [ -f .cursorignore ]; then
    warning ".cursorignore already exists, backing up to .cursorignore.backup"
    cp .cursorignore .cursorignore.backup
fi

cat > .cursorignore << 'EOF'
# LLM Security - Sensitive Files
# Version 2.0

# Environment & Secrets
.env
.env.*
!.env.example
*.key
*.pem
*.crt
*.p12
*.pfx
secrets/
credentials/

# Cloud Provider Configs
.aws/
.gcloud/
.azure/

# Database & Service Configs
supabase/.env
netlify.toml
docker-compose.override.yml

# Package Manager (if contains tokens)
.npmrc
.yarnrc.yml
.pip/
poetry.toml

# Build Artifacts
dist/
build/
.next/
.nuxt/
out/
coverage/

# Logs (may contain sensitive data)
*.log
logs/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# IDE
.vscode/settings.json
.idea/

# Testing with real data
tests/fixtures/real-data/
cypress/fixtures/production/

# Documentation with architecture details
docs/infrastructure/
docs/architecture/sensitive/

# Git
.git/

# Dependencies
node_modules/
EOF

status ".cursorignore created"
echo ""

# 3. Create .gitignore additions
echo "3️⃣  Updating .gitignore..."
if [ ! -f .gitignore ]; then
    touch .gitignore
    status ".gitignore created"
fi

# Check if security section exists
if ! grep -q "# LLM Security" .gitignore; then
    cat >> .gitignore << 'EOF'

# LLM Security
.env*
!.env.example
*.key
*.pem
secrets/
credentials/
.cursorignore.backup
security-incidents/
EOF
    status "Security entries added to .gitignore"
else
    warning "Security entries already in .gitignore"
fi
echo ""

# 4. Create .env.example
echo "4️⃣  Creating .env.example template..."
if [ ! -f .env.example ]; then
    cat > .env.example << 'EOF'
# Environment Configuration Template
# Copy to .env and fill with actual values
# NEVER commit .env to git

# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_keep_secret

# Netlify (if using serverless functions)
# Set these in Netlify UI, not in code

# Other APIs
# API_KEY=your_api_key
EOF
    status ".env.example created"
else
    warning ".env.example already exists"
fi
echo ""

# 5. Setup Git Hooks
echo "5️⃣  Setting up Git hooks..."

# Pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# LLM Security Pre-Commit Hook

# Prompt the user; fail safely (return 1) when /dev/tty is unavailable.
# Git hook stdin is bound to git's pipes, so we must explicitly open the tty.
# In CI / non-interactive shells (e.g. some IDE source-control panels) /dev/tty
# cannot be opened — refuse the soft prompt and tell the user how to bypass.
confirm() {
    local prompt="$1"
    if ! { exec 3</dev/tty; } 2>/dev/null; then
        echo
        echo "  Non-interactive shell — cannot prompt for confirmation."
        echo "  To proceed anyway, re-run with: git commit --no-verify"
        return 1
    fi
    read -p "$prompt " -n 1 -r REPLY <&3
    exec 3<&-
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

echo "🔍 Running security checks..."

# Check for secrets with gitleaks
if command -v gitleaks &> /dev/null; then
    gitleaks protect --staged --verbose
    if [ $? -ne 0 ]; then
        echo "❌ COMMIT BLOCKED: Secrets detected"
        echo "Remove secrets and try again"
        exit 1
    fi
else
    echo "⚠️  Gitleaks not installed, skipping secret scan"
fi

# Check if .env is being committed
if git diff --cached --name-only | grep -E "^\.env$"; then
    echo "❌ COMMIT BLOCKED: .env file should not be committed"
    echo "Add .env to .gitignore"
    exit 1
fi

# Check for debug statements
if git diff --cached | grep -E "console\.log|debugger"; then
    echo "⚠️  Debug statements found. Remove before committing."
    if ! confirm "Continue anyway? (y/N)"; then
        exit 1
    fi
fi

echo "✅ Pre-commit checks passed"
EOF

chmod +x .git/hooks/pre-commit
status "Pre-commit hook installed"

# Pre-push hook
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
# LLM Security Pre-Push Hook

echo "🔍 Running pre-push security checks..."

# Get refs being pushed to build a safe diff range
while read local_ref local_sha remote_ref remote_sha
do
    if [ "$local_sha" = "0000000000000000000000000000000000000000" ]; then
        continue
    fi

    if [ "$remote_sha" = "0000000000000000000000000000000000000000" ]; then
        range="$local_sha"
    else
        range="$remote_sha..$local_sha"
    fi
done

# Full repository scan
if command -v gitleaks &> /dev/null; then
    gitleaks detect --source . --verbose
    if [ $? -ne 0 ]; then
        echo "❌ PUSH BLOCKED: Secrets found in repository"
        echo "Clean history before pushing"
        exit 1
    fi
else
    echo "⚠️  Gitleaks not installed, skipping full scan"
fi

# Check branch protection
protected_branches=("main" "master" "production")

push_blocked=false
blocked_branch=""

while IFS=' ' read -r local_ref local_sha remote_ref remote_sha; do
    if [[ "$local_sha" == "0000000000000000000000000000000000000000" ]]; then
        continue
    fi
    remote_branch="${remote_ref#refs/heads/}"
    if [[ " ${protected_branches[@]} " =~ " ${remote_branch} " ]]; then
        push_blocked=true
        blocked_branch="$remote_branch"
        break
    fi
done

if [[ "$push_blocked" == "true" ]]; then
    echo "❌ Direct push to protected branch '$blocked_branch' not allowed"
    echo "Create a pull request instead"
    exit 1
fi

# Check for unresolved TODO/FIXME comments in outgoing changes
if [ -n "$range" ]; then
    todo_count=$(git diff "$range" 2>/dev/null | grep -E "^\+.*TODO|^\+.*FIXME" | wc -l)
else
    todo_count=0
fi

if [ "$todo_count" -gt 0 ]; then
    echo "⚠️  Found $todo_count TODO/FIXME comments in outgoing changes"
    git diff "$range" | grep -n -E "^\+.*TODO|^\+.*FIXME" | head -5
fi

echo "✅ Pre-push checks passed"
EOF

chmod +x .git/hooks/pre-push
status "Pre-push hook installed"
echo ""

# 6. Create security scripts directory
echo "6️⃣  Creating security scripts..."
mkdir -p scripts/security

# Daily security check script
cat > scripts/security/daily-check.sh << 'EOF'
#!/bin/bash
# Daily Security Check
# Run this every morning before starting work

echo "🔍 Running daily security checks..."

# 1. Scan for secrets
echo "1. Checking for secrets..."
gitleaks detect --no-git --verbose --source .
if [ $? -ne 0 ]; then
    echo "❌ Secrets detected!"
    exit 1
fi

# 2. Check dependencies
echo "2. Checking dependencies..."
if [ -f package.json ]; then
    npm audit --audit-level=moderate
fi

# 3. Check environment
echo "3. Checking environment files..."
if [ -f .env ] && git ls-files --error-unmatch .env 2>/dev/null; then
    echo "❌ .env is tracked by Git!"
    exit 1
fi

# 4. Verify .cursorignore
echo "4. Checking .cursorignore..."
if [ ! -f .cursorignore ]; then
    echo "⚠️  .cursorignore not found"
fi

echo "✅ Daily security checks complete"
EOF

chmod +x scripts/security/daily-check.sh
status "Daily check script created: scripts/security/daily-check.sh"

# Secret leak response script
cat > scripts/security/secret-leak-response.sh << 'EOF'
#!/bin/bash
# Secret Leak Incident Response
# Run this immediately if a secret is detected in commits

echo "🚨 SECRET LEAK INCIDENT RESPONSE"
echo "================================"
echo ""

INCIDENT_DIR="./security-incidents/$(date +%Y%m%d-%H%M%S)-secret-leak"
mkdir -p "$INCIDENT_DIR"

echo "📝 Documenting incident..."

# Find the leak
echo "1. Locating secret in history..."
gitleaks detect --source . --verbose --report-path "$INCIDENT_DIR/leak-report.json"

# Check if pushed
echo "2. Checking if secret reached remote..."
git fetch --all --prune

# Scan remote refs directly so we can distinguish remote exposure
if gitleaks detect --source . --verbose --log-opts="--remotes" --report-path "$INCIDENT_DIR/remote-leak-report.json"; then
    echo "✓ No leaks detected in remote refs"
    echo "Action: Secret appears confined to local history"
    echo "Action: Amend or rebase to remove local leak before pushing"
else
    echo "⚠️  CRITICAL: Secret was pushed to remote"
    echo "Action required: Rotate credentials immediately"
    echo "See: $INCIDENT_DIR/response-steps.txt"
    
    cat > "$INCIDENT_DIR/response-steps.txt" << 'STEPS'
IMMEDIATE ACTIONS REQUIRED:

1. ROTATE ALL POTENTIALLY AFFECTED CREDENTIALS
   - Supabase: Project Settings > API > Generate new service key
   - Netlify: Site settings > Environment variables > Edit
   - GitHub: Settings > Secrets > Update

2. REVIEW ACCESS LOGS
   - Check Supabase Dashboard > Logs
   - Check Netlify Function Logs
   - Check GitHub Audit Log

3. NOTIFY SECURITY TEAM
   - Email: security@yourcompany.com
   - Include: What leaked, when, impact assessment

4. CLEAN GIT HISTORY (requires team coordination)
   - Use BFG Repo Cleaner
   - Force push after cleaning
   - All team members must re-clone

5. DOCUMENT INCIDENT
   - What was leaked?
   - How long was it exposed?
   - Was it accessed?
   - What actions were taken?

Time logged: $(date)
STEPS
fi

echo ""
echo "📂 Incident data saved to: $INCIDENT_DIR"
echo "Next: Follow steps in response-steps.txt if remote leak detected"
EOF

chmod +x scripts/security/secret-leak-response.sh
status "Incident response script created: scripts/security/secret-leak-response.sh"

echo ""

# 7. Create GitHub Actions workflow (if .github exists)
if [ -d .github/workflows ]; then
    echo "7️⃣  Creating GitHub Actions security workflow..."
    WORKFLOW_DEST=".github/workflows/security-scan.yml"
    if [ -f "$WORKFLOW_DEST" ] && [ "${LLM_SECURITY_FRAMEWORK_OVERWRITE_WORKFLOW:-}" != "1" ]; then
        warning "$WORKFLOW_DEST already exists — skipping (set LLM_SECURITY_FRAMEWORK_OVERWRITE_WORKFLOW=1 to replace)"
    else
    cat > .github/workflows/security-scan.yml << 'EOF'
# Maintainer note: Duplicate substantive changes here into the heredoc in
# scripts/security-setup.sh under "Creating GitHub Actions security workflow".

name: Security Scan

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

permissions:
  contents: read

env:
  FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: "true"

jobs:
  workflow-lint:
    name: workflow-lint
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - name: Harden runner
        uses: step-security/harden-runner@a5ad31d6a139d249332a2605b85202e8c0b78450  # v2.19.1
        with:
          egress-policy: block
          allowed-endpoints: >
            files.pythonhosted.org:443
            github.com:443
            pypi.org:443

      - name: Checkout repository
        uses: actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd  # v6
        with:
          persist-credentials: false

      - name: Install zizmor
        run: pip install -r .github/workflows/requirements.txt

      - name: Run zizmor
        run: zizmor --format sarif .github/workflows/ > zizmor.sarif
        continue-on-error: true

      - name: Fail on high/critical findings
        run: |
          HIGH=$(python3 -c "
          import json, sys
          s = json.load(open('zizmor.sarif'))
          findings = [
            r for run in s.get('runs', [])
            for r in run.get('results', [])
            if r.get('level') in ('error', 'warning')
          ]
          print(len(findings))
          for f in findings:
            msg = f.get('message', {}).get('text', '')
            locs = f.get('locations', [{}])
            loc = locs[0].get('physicalLocation', {}).get('artifactLocation', {}).get('uri', '')
            line = locs[0].get('physicalLocation', {}).get('region', {}).get('startLine', '?')
            print(f'  [{f[\"level\"].upper()}] {loc}:{line} — {msg}')
          ")
          COUNT=$(echo "$HIGH" | head -1)
          echo "$HIGH"
          if [ "$COUNT" -gt 0 ]; then
            echo "zizmor found $COUNT high/critical finding(s) — see above."
            exit 1
          fi

  secret-scan:
    name: secret-scan
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - name: Harden runner
        uses: step-security/harden-runner@a5ad31d6a139d249332a2605b85202e8c0b78450  # v2.19.1
        with:
          egress-policy: block
          allowed-endpoints: >
            api.github.com:443
            gitleaks.io:443
            github.com:443

      - name: Checkout repository
        uses: actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd  # v6
        with:
          fetch-depth: 0
          persist-credentials: false

      - name: Run gitleaks
        uses: gitleaks/gitleaks-action@ff98106e4c7b2bc287b24eaf42907196329070c7  # v2.3.9
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GITLEAKS_LICENSE: ${{ secrets.GITLEAKS_LICENSE }}

  dependency-scan:
    name: dependency-scan
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - name: Harden runner
        uses: step-security/harden-runner@a5ad31d6a139d249332a2605b85202e8c0b78450  # v2.19.1
        with:
          egress-policy: block
          allowed-endpoints: >
            github.com:443
            nodejs.org:443
            registry.npmjs.org:443

      - name: Checkout repository
        uses: actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd  # v6
        with:
          persist-credentials: false

      - name: Detect supported dependency manifests
        id: detect-manifests
        shell: bash
        run: |
          if [ -f package-lock.json ] || [ -f npm-shrinkwrap.json ]; then
            echo "npm=true" >> "$GITHUB_OUTPUT"
          else
            echo "npm=false" >> "$GITHUB_OUTPUT"
          fi

      - name: Set up Node.js
        if: steps.detect-manifests.outputs.npm == 'true'
        uses: actions/setup-node@48b55a011bda9f5d6aeb4c2d9c7362e8dae4041e  # v6
        with:
          node-version: "24"

      - name: Install dependencies
        if: steps.detect-manifests.outputs.npm == 'true'
        run: npm ci

      - name: Run npm audit
        if: steps.detect-manifests.outputs.npm == 'true'
        run: npm audit --audit-level=moderate

      - name: Skip when no supported manifests
        if: steps.detect-manifests.outputs.npm != 'true'
        run: echo "No npm lockfile found; dependency scan skipped."
EOF
    status "GitHub Actions workflow created or updated"

    # Write zizmor pin file (read by workflow-lint job)
    cat > .github/workflows/requirements.txt << 'EOF'
zizmor==1.24.1
EOF
    status "zizmor requirements.txt created: .github/workflows/requirements.txt"
    fi
else
    warning "No .github/workflows directory found, skipping GitHub Actions setup"
fi
echo ""

# 8. Create security documentation
echo "8️⃣  Creating security documentation..."
if [ -f SECURITY.md ]; then
    warning "SECURITY.md already exists — skipping boilerplate overwrite (merge manually if needed)"
else
cat > SECURITY.md << 'EOF'
# Security Policy

## Reporting Security Issues

If you discover a security vulnerability, please email: security@yourcompany.com

**Do not** create public GitHub issues for security vulnerabilities.

## Security Measures

This project implements the following security controls:

- ✅ Pre-commit secret scanning with Gitleaks
- ✅ Dependency vulnerability scanning
- ✅ Environment variable protection
- ✅ Row-level security on database
- ✅ API key rotation policy
- ✅ Audit logging

## Developer Guidelines

All developers must:

1. Run daily security checks: `./scripts/security/daily-check.sh`
2. Never commit secrets or credentials
3. Review all AI-generated code before merging
4. Verify dependencies before installing
5. Follow the principle of least privilege

For detailed guidelines, see: `docs/LLM-Security-Guidelines.md`

## Incident Response

If you suspect a security incident:

1. **Immediate**: Stop all potentially affected systems
2. **Notify**: security@yourcompany.com or #security-alerts on Slack
3. **Document**: Use incident response scripts in `scripts/security/`
4. **Follow**: Escalation procedures in security guidelines

## Security Updates

- Security guidelines are reviewed monthly
- All developers receive security training quarterly
- Incident retrospectives are conducted after any security event
EOF

status "SECURITY.md created"
fi
echo ""

# 9. Final scan
echo "9️⃣  Running initial security scan..."
if command -v gitleaks &> /dev/null; then
    gitleaks detect --source . --verbose
    if [ $? -eq 0 ]; then
        status "No secrets found in repository"
    else
        error "Secrets detected! Review and remediate before proceeding"
        echo "Run: ./scripts/security/secret-leak-response.sh"
    fi
else
    warning "Gitleaks not available, skipping scan"
fi
echo ""

# 10. Summary
echo "✅ Security Setup Complete!"
echo "=========================="
echo ""
echo "📋 What was installed:"
echo "  • Gitleaks (secret scanner)"
echo "  • .cursorignore (AI context protection)"
echo "  • .gitignore (security entries)"
echo "  • .env.example (template)"
echo "  • Pre-commit hooks (automatic scanning)"
echo "  • Pre-push hooks (branch protection)"
echo "  • Security scripts"
if [ -d .github/workflows ]; then
    echo "  • GitHub Actions workflows"
fi
echo "  • SECURITY.md"
echo ""
echo "📖 Next steps:"
echo "  1. Review docs/LLM-Security-Guidelines.md"
echo "  2. Copy .env.example to .env and fill with real values"
echo "  3. Run: ./scripts/security/daily-check.sh"
echo "  4. Configure Supabase RLS policies"
echo "  5. Set up Netlify environment variables"
echo "  6. Enable GitHub Advanced Security"
echo ""
echo "🔗 Important files:"
echo "  • Full guidelines: docs/LLM-Security-Guidelines.md"
echo "  • Quick reference: docs/Security-Quick-Reference.md"
echo "  • Daily checks: scripts/security/daily-check.sh"
echo "  • Incident response: scripts/security/secret-leak-response.sh"
echo ""
echo "💡 Remember: Run daily checks every morning!"
echo "   ./scripts/security/daily-check.sh"
echo ""
echo "🆘 Questions? Contact: security@yourcompany.com"