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
