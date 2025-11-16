# 🟢 Tier Essential - Quick Security Setup

**15 minutes to basic security for hobby projects and MVPs**

---

## 🎯 What Is Tier Essential?

Tier Essential provides **basic security hygiene** for projects that don't handle customer data, payments, or PII. It's perfect for:

- ✅ Hobby projects and side projects
- ✅ Learning and experimentation
- ✅ MVPs and prototypes
- ✅ Internal tools with no customer data
- ✅ Open-source projects (non-critical)
- ✅ Personal portfolios

**⚠️ NOT suitable for**: Production apps, customer data, payments, PII

---

## 🚀 Quick Start (15 minutes)

1. **Read this guide**: [QUICK-START.md](QUICK-START.md)
2. **Follow the checklist**: [DAILY-CHECKLIST.md](DAILY-CHECKLIST.md)
3. **Copy configs**: Use templates in `configs/` directory
4. **Understand limits**: Read [LIMITATIONS.md](LIMITATIONS.md)

---

## 📁 What's Included

### Documentation
- **[QUICK-START.md](QUICK-START.md)** - Step-by-step setup guide
- **[DAILY-CHECKLIST.md](DAILY-CHECKLIST.md)** - Daily security routine
- **[LIMITATIONS.md](LIMITATIONS.md)** - What this tier does NOT protect against

### Configuration Templates
- **[configs/](configs/)** - Copy-paste templates for:
  - `.cursorignore` - Protect files from AI tools
  - `.gitignore` - Prevent committing secrets
  - `.env.example` - Environment variable template
  - `pre-commit-hook.sh` - Automatic secret scanning

---

## ⚡ One-Command Setup

```bash
# Clone or download this framework
cd your-project

# Copy configs to your project root
cp tier-essential/configs/.cursorignore.template .cursorignore
cp tier-essential/configs/.gitignore.template .gitignore
cp tier-essential/configs/.env.example.template .env.example

# Install Gitleaks (secret scanner)
brew install gitleaks  # macOS
# OR
curl -sSfL https://raw.githubusercontent.com/gitleaks/gitleaks/master/scripts/install.sh | sh

# Install pre-commit hook
cp tier-essential/configs/pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Test it works
echo "api_key=sk-test-123" > test.txt
git add test.txt
git commit -m "test"  # Should be BLOCKED
rm test.txt
```

---

## 📋 Daily Routine

**Every morning** (2 minutes):
```bash
# Run daily security check
./scripts/security/daily-check.sh
```

**Before every commit** (automatic):
- Pre-commit hook scans for secrets automatically
- No action needed - it just works!

**Weekly** (10 minutes):
- Review any security alerts
- Check dependency updates
- Review your `.env` files

---

## 🔒 What You're Protected Against

✅ **Accidental secret commits** - Blocked by pre-commit hook  
✅ **Basic dependency vulnerabilities** - npm audit  
✅ **AI tools seeing sensitive files** - .cursorignore (best-effort)  
✅ **Common mistakes** - Templates and checklists  

---

## ⚠️ What You're NOT Protected Against

❌ Sophisticated prompt injection attacks  
❌ MCP server compromises  
❌ Package hallucination (slopsquatting)  
❌ Advanced persistent threats  
❌ Regulatory compliance requirements  

**👉 For production apps, upgrade to [Tier Standard](../../docs/tier-standard/)**

---

## 📚 Next Steps

1. ✅ Complete Quick Start guide
2. ✅ Set up daily checklist routine
3. ✅ Read limitations to understand risks
4. ✅ When you get real users → Upgrade to Tier Standard

---

## 🆘 Need Help?

- **Quick Start**: [QUICK-START.md](QUICK-START.md)
- **Daily Routine**: [DAILY-CHECKLIST.md](DAILY-CHECKLIST.md)
- **Understanding Limits**: [LIMITATIONS.md](LIMITATIONS.md)
- **General Security**: [Security Quick Reference](../../docs/Security-Quick-Reference.md)

---

**Ready? Start with [QUICK-START.md](QUICK-START.md) →**




