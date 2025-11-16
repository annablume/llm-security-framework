# ✅ Tier Essential - Daily Security Checklist

**2 minutes every morning before coding**

---

## 🌅 Morning Routine

### 1. Run Daily Security Check (30 seconds)

```bash
./scripts/security/daily-check.sh
```

**What it checks**:
- ✅ No secrets in your code
- ✅ No dependency vulnerabilities
- ✅ .env file not tracked by Git
- ✅ .cursorignore exists

**If it finds issues**: Fix them before continuing.

---

### 2. Review Yesterday's Commits (30 seconds)

```bash
# Check what you committed yesterday
git log --since="yesterday" --oneline

# Verify no secrets slipped through
git log --since="yesterday" -p | grep -iE "api[_-]?key|secret|password|token"
```

**If you find secrets**: See [Emergency Response](#emergency-response) below.

---

### 3. Check for Dependency Updates (1 minute)

```bash
# Check for vulnerabilities
npm audit

# Review any high/critical issues
npm audit --audit-level=high
```

**If vulnerabilities found**: Review and update dependencies.

---

## 📝 Before Every Commit

**Automatic** - Pre-commit hook handles this:
- ✅ Scans for secrets
- ✅ Blocks .env files
- ✅ Checks for debug code
- ✅ Validates file sizes

**You don't need to do anything** - it just works!

---

## 🔍 Weekly Review (10 minutes, every Monday)

### 1. Review Security Alerts
- Check GitHub Security tab (if using GitHub)
- Review any Dependabot alerts
- Check for secret scanning alerts

### 2. Audit Environment Variables
```bash
# List all .env files
find . -name ".env*" -type f

# Verify none are tracked
git ls-files | grep -E "\.env$|\.env\."
```

### 3. Review Dependencies
```bash
# Check what's installed
npm list --depth=0

# Check for updates
npm outdated
```

### 4. Clean Up
```bash
# Remove any test files
rm -f test*.txt test*.js

# Check for large files
find . -type f -size +1M -not -path "*/node_modules/*"
```

---

## 🚨 Emergency Response

### If You Committed a Secret

**Immediate actions** (within 30 minutes):

1. **Revoke the secret immediately**
   - Generate new API keys
   - Rotate passwords
   - Update tokens

2. **Check if it was pushed**
   ```bash
   git log --all -p | grep "your-secret"
   git branch -r --contains HEAD
   ```

3. **If pushed to remote**:
   - Secret is exposed
   - Rotate immediately
   - Consider using BFG Repo Cleaner to remove from history
   - Notify team members

4. **If only local**:
   ```bash
   # Amend the commit
   git commit --amend
   # Or reset if not pushed
   git reset HEAD~1
   ```

5. **Document the incident**
   - What leaked?
   - When?
   - What actions taken?

---

## 📋 Pre-Commit Checklist

Before committing, mentally check:

```bash
□ No secrets in code (api_key, password, token, etc.)
□ No .env files being committed
□ No debug code (console.log, debugger)
□ Dependencies verified (if adding new packages)
□ Large files not included (use Git LFS if needed)
```

**Most of this is automatic** - pre-commit hook catches it!

---

## 🎯 Monthly Review (30 minutes, first Monday)

### 1. Security Audit
```bash
# Full repository scan
gitleaks detect --source . --verbose

# Check all dependencies
npm audit

# Review all .env files
find . -name ".env*" -type f
```

### 2. Update Tools
```bash
# Update Gitleaks
brew upgrade gitleaks  # macOS
# OR reinstall (Linux)

# Update npm
npm install -g npm@latest
```

### 3. Review Configuration
- Check `.cursorignore` still covers your needs
- Review `.gitignore` entries
- Update `.env.example` if needed

### 4. Documentation Review
- Review security practices
- Update team (if applicable)
- Check for new security best practices

---

## ✅ Success Indicators

**You're doing it right if**:
- ✅ Daily check passes every morning
- ✅ No secrets in Git history
- ✅ Pre-commit hook blocks bad commits
- ✅ Dependencies are up to date
- ✅ No .env files tracked

**Red flags**:
- ❌ Daily check finds secrets
- ❌ Pre-commit hook not working
- ❌ Multiple dependency vulnerabilities
- ❌ .env files in Git

---

## 📞 Need Help?

- **Secret leaked?** See [Emergency Response](#emergency-response) above
- **Pre-commit hook not working?** See [QUICK-START.md](QUICK-START.md#troubleshooting)
- **Want more security?** Upgrade to [Tier Standard](../../docs/tier-standard/)
- **General questions?** See [Security Quick Reference](../../docs/Security-Quick-Reference.md)

---

**Print this checklist and keep it visible!**

---

**Last Updated**: November 15, 2025  
**Next Review**: When upgrading to Tier Standard




