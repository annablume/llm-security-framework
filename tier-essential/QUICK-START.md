# 🚀 Tier Essential - Quick Start Guide

**15 minutes to basic security**

---

## Prerequisites

- Git repository initialized
- Terminal/command line access
- 15 minutes of time

---

## Step 1: Install Gitleaks (2 minutes)

Gitleaks scans your code for secrets before you commit.

### macOS
```bash
brew install gitleaks
```

### Linux
```bash
curl -sSfL https://raw.githubusercontent.com/gitleaks/gitleaks/master/scripts/install.sh | sh
```

### Verify Installation
```bash
gitleaks version
```

---

## Step 2: Copy Configuration Templates (3 minutes)

### Copy .cursorignore
```bash
cp tier-essential/configs/.cursorignore.template .cursorignore
```

**What this does**: Prevents AI tools (Cursor, Claude Code) from seeing sensitive files.  
**⚠️ Important**: This is best-effort, not a security boundary. See [LIMITATIONS.md](LIMITATIONS.md).

### Copy .gitignore additions
```bash
# Add security entries to your existing .gitignore
cat tier-essential/configs/.gitignore.template >> .gitignore
```

**What this does**: Prevents committing secrets and sensitive files to Git.

### Copy .env.example
```bash
cp tier-essential/configs/.env.example.template .env.example
```

**What this does**: Template for environment variables. Copy to `.env` and fill with real values.

---

## Step 3: Install Pre-Commit Hook (2 minutes)

This automatically scans for secrets before every commit.

```bash
# Copy hook to git hooks directory
cp tier-essential/configs/pre-commit-hook.sh .git/hooks/pre-commit

# Make it executable
chmod +x .git/hooks/pre-commit
```

**What this does**: Blocks commits that contain secrets.

---

## Step 4: Test It Works (3 minutes)

### Test Secret Detection

```bash
# Create a test file with a fake secret
# Replace YOUR_ACTUAL_KEY with a realistic API key format to test detection
# Example formats that trigger: sk_live_..., api_key=..., etc.
echo "api_key=YOUR_ACTUAL_KEY_REPLACE_WITH_REALISTIC_FORMAT" > test-secret.txt

# Try to commit it
git add test-secret.txt
git commit -m "test secret detection"
```

**Expected result**: Commit should be **BLOCKED** with an error message showing the detected secret pattern.

```bash
# Clean up
rm test-secret.txt
git reset HEAD test-secret.txt 2>/dev/null || true
```

### Test .env Protection

```bash
# Create a test .env file
echo "SECRET_KEY=test123" > .env

# Try to commit it
git add .env
git commit -m "test .env protection"
```

**Expected result**: Commit should be **BLOCKED**.

```bash
# Clean up
rm .env
git reset HEAD .env 2>/dev/null || true
```

---

## Step 5: Set Up Daily Check (2 minutes)

Copy the daily check script to your project:

```bash
# Create scripts directory if it doesn't exist
mkdir -p scripts/security

# Copy daily check script
cp tier-essential/configs/daily-check.sh scripts/security/

# Make it executable
chmod +x scripts/security/daily-check.sh

# Test it
./scripts/security/daily-check.sh
```

**Add to your morning routine**: Run this every day before coding.

---

## Step 6: Create Your .env File (3 minutes)

```bash
# Copy template
cp .env.example .env

# Edit with your actual values (use your editor)
# NEVER commit .env to git (it's in .gitignore)
```

**Important**: 
- ✅ Commit `.env.example` (template)
- ❌ Never commit `.env` (actual secrets)

---

## ✅ Verification Checklist

After setup, verify everything works:

```bash
□ Gitleaks installed and working
□ .cursorignore file exists
□ .gitignore has security entries
□ .env.example exists (template)
□ .env exists locally (not in git)
□ Pre-commit hook blocks secret commits
□ Daily check script runs successfully
```

---

## 🎯 You're Done!

**What you now have**:
- ✅ Automatic secret scanning before commits
- ✅ Protected files from AI tools (best-effort)
- ✅ Daily security check routine
- ✅ Environment variable templates

**Next steps**:
1. Read [DAILY-CHECKLIST.md](DAILY-CHECKLIST.md) - Your daily routine
2. Read [LIMITATIONS.md](LIMITATIONS.md) - Understand what this tier doesn't protect
3. When you get real users → Upgrade to [Tier Standard](../../docs/tier-standard/)

---

## 🆘 Troubleshooting

### Pre-commit hook not running?
```bash
# Check if hook exists and is executable
ls -la .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### Gitleaks not found?
```bash
# Verify installation
which gitleaks
gitleaks version

# If not found, reinstall (see Step 1)
```

### Want to bypass hook temporarily?
```bash
# Only use in emergencies!
git commit --no-verify -m "your message"
```

---

**👉 Next: [DAILY-CHECKLIST.md](DAILY-CHECKLIST.md)**




