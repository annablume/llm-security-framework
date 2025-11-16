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

## 🚀 Quick Setup

Copy all templates at once:

```bash
# From your project root
cp tier-essential/configs/.cursorignore.template .cursorignore
cat tier-essential/configs/.gitignore.template >> .gitignore
cp tier-essential/configs/.env.example.template .env.example
cp tier-essential/configs/pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
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

## 🆘 Troubleshooting

See [QUICK-START.md](../QUICK-START.md#troubleshooting) for common issues.

---

**Next**: [QUICK-START.md](../QUICK-START.md)




