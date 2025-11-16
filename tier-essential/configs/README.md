# 📁 Tier Essential - Configuration Templates

**Copy-paste templates for quick setup**

---

## 📋 Available Templates

### 1. `.cursorignore.template`
Prevents AI tools from seeing sensitive files (best-effort).

**Usage**:
```bash
cp .cursorignore.template ../.cursorignore
```

**⚠️ Important**: See [LIMITATIONS.md](../LIMITATIONS.md#8-cursorignore-limitations)

---

### 2. `.gitignore.template`
Security entries for `.gitignore` to prevent committing secrets.

**Usage**:
```bash
# Append to your existing .gitignore
cat .gitignore.template >> ../.gitignore
```

---

### 3. `.env.example.template`
Template for environment variables.

**Usage**:
```bash
cp .env.example.template ../.env.example
cp .env.example.template ../.env
# Then edit .env with your actual values
```

**⚠️ Important**: 
- ✅ Commit `.env.example` (template)
- ❌ Never commit `.env` (actual secrets)

---

### 4. `pre-commit-hook.sh`
Pre-commit hook that scans for secrets before commits.

**Usage**:
```bash
cp pre-commit-hook.sh ../../.git/hooks/pre-commit
chmod +x ../../.git/hooks/pre-commit
```

**What it does**:
- Scans staged files for secrets
- Blocks .env file commits
- Checks for debug code
- Validates file sizes

---

### 5. `daily-check.sh`
Daily security check script to run every morning.

**Usage**:
```bash
cp daily-check.sh ../../scripts/security/daily-check.sh
chmod +x ../../scripts/security/daily-check.sh
```

**What it does**:
- Scans for secrets in your codebase
- Checks for dependency vulnerabilities
- Verifies .env files aren't tracked
- Checks for .cursorignore file

**Run daily**: `./scripts/security/daily-check.sh`

---

## 🚀 Quick Setup

Copy all templates at once:

```bash
# From your project root
cp tier-essential/configs/.cursorignore.template .cursorignore
cat tier-essential/configs/.gitignore.template >> .gitignore
cp tier-essential/configs/.env.example.template .env.example
cp tier-essential/configs/pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
mkdir -p scripts/security
cp tier-essential/configs/daily-check.sh scripts/security/
chmod +x scripts/security/daily-check.sh
```

---

## 📝 Customization

All templates can be customized for your project:

- **`.cursorignore`**: Add project-specific paths
- **`.gitignore`**: Add project-specific patterns
- **`.env.example`**: Add your API keys and configs
- **`pre-commit-hook.sh`**: Add custom checks

---

## ✅ Verification

After copying templates:

```bash
# Verify files exist
ls -la .cursorignore .gitignore .env.example .git/hooks/pre-commit

# Test pre-commit hook
echo "api_key=test" > test.txt
git add test.txt
git commit -m "test"  # Should be BLOCKED
rm test.txt
```

---

## 🔍 Handling Template Files in Secret Scanning

### The Challenge

Template files like `.env.example.template` contain example values that look like real secrets:
- Example JWTs: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
- Example API keys: `sk-proj-xxxxxxxxxxxx`
- Example UUIDs: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`

These trigger false positives in secret scanning tools.

### The Solution

The framework's pre-push hook automatically excludes:
```bash
tier-essential/configs/   # All framework templates
examples/                 # Documentation examples
*.template               # Any .template files
*.example               # Any .example files
```

### For Your Projects

When you copy templates to your projects, the example values are safe because:

1. **Templates are documentation** - They show the format, not real secrets
2. **Real files are protected** - Your actual `.env` is in `.gitignore`
3. **Scanning still works** - Real code is still scanned

### Creating Your Own Templates

If you create custom template files:

```bash
# Add your template directory to the exclusion list
# Edit .git/hooks/pre-push and add:
# | grep -v "your-templates-directory/"
```

### Why This Approach

We chose directory-based exclusion over `.gitleaksignore` because:
- ✅ More reliable across gitleaks versions
- ✅ Explicit and visible in the hook
- ✅ Easy to customize per project
- ✅ No dependency on gitleaks config format

---

## 🆘 Troubleshooting

See [QUICK-START.md](../QUICK-START.md#troubleshooting) for common issues.

---

**Next**: [QUICK-START.md](../QUICK-START.md)




