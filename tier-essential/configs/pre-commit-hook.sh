#!/bin/bash
# Pre-commit Git Hook - Security Checks
# Version: 2.0
# 
# This hook runs security checks before allowing a commit.
# Install: Copy to .git/hooks/pre-commit and make executable
# 
# Installation:
#   chmod +x pre-commit
#   cp pre-commit .git/hooks/pre-commit
# 
# Or use the setup script: ./scripts/security-setup.sh

set -e  # Exit on first error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Running pre-commit security checks...${NC}"
echo ""

# ============================================================================
# CHECK 1: SECRET SCANNING WITH GITLEAKS
# ============================================================================

echo "1️⃣  Scanning for secrets..."

if command -v gitleaks &> /dev/null; then
    # Scan staged files only
    gitleaks protect --staged --verbose
    
    if [ $? -ne 0 ]; then
        echo ""
        echo -e "${RED}❌ COMMIT BLOCKED: Secrets detected in staged files${NC}"
        echo ""
        echo "What to do:"
        echo "  1. Remove the secret from your code"
        echo "  2. Add it to .env and load from environment variables"
        echo "  3. Run: git reset HEAD <file> to unstage"
        echo "  4. Never commit secrets to Git"
        echo ""
        echo "To see details: gitleaks protect --staged --verbose"
        exit 1
    fi
    echo -e "${GREEN}✓ No secrets detected${NC}"
else
    echo -e "${YELLOW}⚠️  Gitleaks not installed, skipping secret scan${NC}"
    echo "   Install: brew install gitleaks (macOS) or visit https://github.com/gitleaks/gitleaks"
fi

echo ""

# ============================================================================
# CHECK 2: PREVENT .env FILE COMMITS
# ============================================================================

echo "2️⃣  Checking for .env files..."

if git diff --cached --name-only | grep -E "^\.env$"; then
    echo -e "${RED}❌ COMMIT BLOCKED: .env file should never be committed${NC}"
    echo ""
    echo "What to do:"
    echo "  1. git reset HEAD .env"
    echo "  2. Add .env to .gitignore"
    echo "  3. Use .env.example for templates"
    exit 1
fi

# Check for other environment files
if git diff --cached --name-only | grep -E "\.env\.(local|production|staging)$"; then
    echo -e "${RED}❌ COMMIT BLOCKED: Environment file detected${NC}"
    echo "Files like .env.local should not be committed"
    exit 1
fi

echo -e "${GREEN}✓ No .env files in commit${NC}"
echo ""

# ============================================================================
# CHECK 3: LARGE FILE CHECK
# ============================================================================

echo "3️⃣  Checking for large files..."

# Maximum file size in KB
MAX_SIZE=5120  # 5MB

large_files=$(git diff --cached --name-only | while read file; do
    if [ -f "$file" ]; then
        size=$(du -k "$file" | cut -f1)
        if [ $size -gt $MAX_SIZE ]; then
            echo "$file ($size KB)"
        fi
    fi
done)

if [ -n "$large_files" ]; then
    echo -e "${YELLOW}⚠️  Large files detected:${NC}"
    echo "$large_files"
    echo ""
    echo "Consider:"
    echo "  1. Using Git LFS for large files"
    echo "  2. Checking if this file should be ignored"
    echo "  3. Compressing the file"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✓ No large files${NC}"
fi

echo ""

# ============================================================================
# CHECK 4: DEBUG CODE DETECTION
# ============================================================================

echo "4️⃣  Checking for debug code..."

# Check for console.log, debugger, etc.
debug_patterns=(
    "console\.log"
    "console\.debug"
    "debugger"
    "console\.trace"
)

found_debug=0

for pattern in "${debug_patterns[@]}"; do
    if git diff --cached | grep -E "^\+.*$pattern" > /dev/null; then
        if [ $found_debug -eq 0 ]; then
            echo -e "${YELLOW}⚠️  Debug statements found:${NC}"
            found_debug=1
        fi
        git diff --cached | grep -n -E "^\+.*$pattern" | sed 's/^/  /'
    fi
done

if [ $found_debug -eq 1 ]; then
    echo ""
    echo "Consider removing debug statements before committing"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✓ No debug statements${NC}"
fi

echo ""

# ============================================================================
# CHECK 5: DEPENDENCY CHANGES
# ============================================================================

echo "5️⃣  Checking for dependency changes..."

if git diff --cached --name-only | grep -E "package\.json|package-lock\.json|yarn\.lock|requirements\.txt|Pipfile\.lock"; then
    echo -e "${YELLOW}⚠️  Dependencies changed${NC}"
    echo ""
    echo "Before committing dependency changes, verify:"
    echo "  □ Package legitimacy (check npm/PyPI)"
    echo "  □ No known vulnerabilities (npm audit / pip check)"
    echo "  □ Package reputation (downloads, GitHub stars)"
    echo "  □ License compatibility"
    echo ""
    read -p "Have you verified these packages? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✓ No dependency changes${NC}"
fi

echo ""

# ============================================================================
# CHECK 6: SENSITIVE PATTERNS
# ============================================================================

echo "6️⃣  Checking for sensitive patterns..."

# Patterns that might indicate secrets
sensitive_patterns=(
    "api[_-]?key"
    "api[_-]?secret"
    "password\s*="
    "passwd\s*="
    "secret[_-]?key"
    "access[_-]?token"
    "auth[_-]?token"
    "private[_-]?key"
)

found_sensitive=0

for pattern in "${sensitive_patterns[@]}"; do
    if git diff --cached | grep -iE "^\+.*$pattern" > /dev/null; then
        if [ $found_sensitive -eq 0 ]; then
            echo -e "${YELLOW}⚠️  Sensitive patterns found:${NC}"
            found_sensitive=1
        fi
        git diff --cached | grep -n -iE "^\+.*$pattern" | sed 's/^/  /'
    fi
done

if [ $found_sensitive -eq 1 ]; then
    echo ""
    echo -e "${RED}Potential secrets or credentials detected${NC}"
    echo "Review carefully - these should likely be in .env"
    echo ""
    read -p "Are these safe to commit? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✓ No sensitive patterns detected${NC}"
fi

echo ""

# ============================================================================
# CHECK 7: COMMIT MESSAGE QUALITY (optional)
# ============================================================================

# Uncomment to enforce commit message format
# 
# commit_msg=$(cat "$1" 2>/dev/null || echo "")
# 
# if [ -z "$commit_msg" ]; then
#     echo "Commit message is empty"
#     exit 1
# fi
# 
# # Enforce conventional commits format
# if ! echo "$commit_msg" | grep -qE "^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+"; then
#     echo "❌ Commit message must follow Conventional Commits format"
#     echo "   Format: type(scope): description"
#     echo "   Example: feat(auth): add login functionality"
#     exit 1
# fi

# ============================================================================
# SUMMARY
# ============================================================================

echo ""
echo -e "${GREEN}✅ All pre-commit checks passed!${NC}"
echo ""

# Optional: Show commit stats
echo "Commit summary:"
git diff --cached --shortstat

echo ""
echo "Committing..."

# Allow commit to proceed
exit 0

# ============================================================================
# NOTES
# ============================================================================
# 
# Bypassing this hook (use only in emergencies):
#   git commit --no-verify
# 
# Temporarily disabling:
#   chmod -x .git/hooks/pre-commit
# 
# Re-enabling:
#   chmod +x .git/hooks/pre-commit
# 
# Sharing hooks across team:
#   - Commit hook templates to scripts/ directory
#   - Document installation in README
#   - Use automation script for setup
# 
# Customization:
#   - Add project-specific checks
#   - Adjust file size limits
#   - Add linting/formatting checks
#   - Add unit test requirements
# 
# ============================================================================
