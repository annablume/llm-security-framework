# LLM Security Quick Reference Card

## 🚨 BEFORE EVERY AI INTERACTION

### Cursor/Claude Code Pre-Flight Check
```bash
□ No .env files in workspace?
□ .cursorignore configured?
□ No real user data in context?
□ No secrets in recent files?
```

### Data Sanitization
```bash
□ Replace real emails with user@example.com
□ Replace UUIDs with xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
□ Replace API keys with ****
□ Use dummy data only
```

---

## 🔴 CRITICAL - NEVER DO THIS

❌ Commit secrets to Git  
❌ Share service role keys with AI  
❌ Paste real user data into AI chat  
❌ Disable RLS in Supabase  
❌ Auto-accept AI code without review  
❌ Install packages without verification  
❌ Push directly to main/production  
❌ Ignore pre-commit hook warnings  

---

## ✅ ALWAYS DO THIS

✓ Use .env for secrets  
✓ Run `gitleaks detect` before commit  
✓ Review every line of AI-generated code  
✓ Check package reputation before installing  
✓ Enable RLS on all tables  
✓ Use anon key for client, service key for server only  
✓ Create PRs for all changes  
✓ Test in staging first  

---

## 🔍 DAILY SECURITY COMMANDS

```bash
# Check for secrets
gitleaks detect --source . --verbose --no-git

# Audit dependencies
npm audit --audit-level=moderate

# Verify .env not tracked
git ls-files --error-unmatch .env 2>/dev/null

# Check Supabase RLS
psql -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public' 
AND tablename NOT IN (SELECT tablename FROM pg_policies);"
```

---

## 🚨 IF SECRET LEAKED - DO THIS NOW

**Within 30 minutes:**

1. **Revoke immediately**
   - Supabase: Generate new service key
   - Netlify: Update environment variables
   - GitHub: Rotate secrets

2. **Assess impact**
   ```bash
   git log --all -p | grep "api_key\|secret"
   ```

3. **Check access logs**
   - Supabase Dashboard > Logs
   - Netlify Functions > Logs
   - GitHub > Settings > Audit log

4. **Notify security team**
   - Email: security@yourcompany.com
   - Slack: #security-alerts

5. **Document incident**
   - What leaked?
   - When?
   - What's the impact?
   - What actions taken?

---

## 📋 BEFORE COMMITTING

```bash
# Run this checklist
gitleaks detect --staged --verbose     # Secrets?
npm audit                              # Vulnerabilities?
git diff --staged | grep console.log   # Debug code?
git diff package.json                  # New deps verified?
```

> ⚠️ **Gitleaks catches known patterns only** (AWS, Slack, Stripe, GitHub, etc.). Custom internal tokens, opaque JWTs, and project-specific keys can slip through. Treat **all** credentials as `.env`-only regardless of what gitleaks reports.

> ⚠️ **Local hooks can be bypassed** with `git commit --no-verify`. For real enforcement, enable GitHub push protection on the repo.

---

## 🔐 KEY MANAGEMENT RULES

| Key Type | Client-Side | Server-Side | Expires |
|----------|-------------|-------------|---------|
| Supabase Anon | ✅ Yes | ✅ Yes | Never |
| Supabase Service | ❌ NEVER | ✅ Yes | 90 days |
| Netlify Deploy Hook | ❌ No | ✅ Yes | Manual |
| GitHub Token | ❌ No | ✅ Yes | 90 days |

---

## 🚩 SUSPICIOUS AI BEHAVIOR

**Stop immediately if AI suggests:**
- Disabling security features
- Installing unknown packages
- Adding unusual network calls
- Bypassing authentication
- Removing input validation
- Obfuscated code
- eval() or exec() usage

**Response:**
1. Close AI session
2. Review recent changes
3. Clear AI context/memory
4. Report to security team

---

## 📊 RISK LEVELS

| Symbol | Level | Example |
|--------|-------|---------|
| 🔴 | CRITICAL | Secret in code, RCE, SQL injection |
| 🟠 | HIGH | Outdated deps, exposed endpoint |
| 🟡 | MEDIUM | Missing RLS, weak validation |
| 🟢 | LOW | Code quality, documentation |

**Response times:**
- 🔴 Immediate
- 🟠 < 24 hours
- 🟡 < 1 week
- 🟢 < 1 month

---

## 📞 EMERGENCY CONTACTS

**Security Team**: security@yourcompany.com  
**Slack**: #security-alerts  
**On-call**: [PagerDuty/Phone]

**P0 (Critical)**: Immediate response + CTO escalation  
**P1 (High)**: < 1 hour response  
**P2 (Medium)**: < 24 hours  
**P3 (Low)**: < 1 week  

---

## 🛠️ QUICK FIXES

**Secret in commit?**

**STOP.** Do not start by rewriting history.

1. **Rotate the secret first** (Supabase / Netlify / GitHub / wherever it's used). Once a secret has been pushed, assume it is compromised — it lives on in forks, CI logs, GitHub PR caches, and archive.org. History rewriting does NOT unexpose it.
2. **Check access logs** for unauthorized use of the old credential.
3. **Then — and only then — clean history.** This step is destructive and breaks every clone of the repo. Coordinate with your team in writing before running it.

History cleanup (run only after steps 1–2 and team coordination):

```bash
# Replace placeholders. secrets.txt = list of leaked strings, one per line.
java -jar bfg.jar --replace-text secrets.txt repo.git
cd repo && git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

The force-push that follows is intentionally NOT in a code block. Type it manually so you cannot paste it by accident:

> git push ‑‑force ‑‑all

Every teammate must re-clone after the force-push. Anyone with an open PR will need to rebase. If you are the only contributor and unsure, stop and ask for help instead.

**Cursor seeing sensitive files?**
```bash
# Update .cursorignore
echo ".env*" >> .cursorignore
echo "secrets/" >> .cursorignore
# Restart Cursor
```

**New dependency from AI?**
```bash
npm info <package>                    # Check existence
npm view <package> dist.unpackedSize  # Check size
npm audit                             # Check vulnerabilities
# Visit: snyk.io/advisor/npm-package/<package>
```

---

## 💡 REMEMBER

> **Treat AI assistants like untrusted external developers**  
> **Zero trust = Zero breach**  
> **When in doubt, ask security team**

---

**Print this card and keep it visible at your desk**

*Last updated: 2025-11-14 | Version 2.0*