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
git fetch --all
LEAK_COMMIT=$(git log --all -p | grep -m 1 "KEYWORD" | head -1 | awk '{print $2}')

if [ ! -z "$LEAK_COMMIT" ]; then
    if git branch -r --contains $LEAK_COMMIT 2>/dev/null; then
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
    else
        echo "✓ Secret only in local history"
        echo "Action: Amend or rebase to remove"
    fi
fi

echo ""
echo "📂 Incident data saved to: $INCIDENT_DIR"
echo "Next: Follow steps in response-steps.txt"
