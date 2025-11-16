# LLM-Assisted Development Security Guidelines
**Version 2.0 - Production Ready**  
**Stack**: Claude Code, Cursor, GitHub, Netlify, Supabase  
**Last Updated**: November 2025

---

## 🎯 Executive Summary

This document provides security controls for AI-assisted development workflows. **Primary threat vectors**: secret leakage, supply chain attacks, prompt injection, unauthorized code execution, and data exposure through LLM context windows.

**Critical Principle**: Treat AI coding assistants as **untrusted external developers** with read access to your entire codebase.

---

## 📊 Risk Classification System

| Level | Impact | Response Time | Examples |
|-------|--------|---------------|----------|
| 🔴 **CRITICAL** | Production compromise, data breach | Immediate | API keys in commits, RCE vulnerabilities, SQL injection |
| 🟠 **HIGH** | Potential exploitation, service degradation | < 24h | Outdated dependencies, exposed endpoints, weak auth |
| 🟡 **MEDIUM** | Security weakness, compliance issue | < 1 week | Missing RLS policies, unvalidated inputs, logging gaps |
| 🟢 **LOW** | Best practice deviation | < 1 month | Code quality issues, documentation gaps |

---

## 1. Cursor IDE Security Configuration

### 🔴 CRITICAL: Context Window Protection

**Threat**: Cursor loads entire workspace into context, potentially exposing secrets to Claude.

#### Mandatory `.cursorignore` Configuration

```bash
# .cursorignore - Place in repository root

# Environment & Secrets
.env
.env.*
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
netlify.toml  # If contains secrets
docker-compose.override.yml

# Package Manager
.npmrc  # If contains tokens
.yarnrc.yml  # If contains tokens
.pip/
poetry.toml  # If contains credentials

# Build Artifacts (may contain embedded secrets)
dist/
build/
.next/
.nuxt/
out/

# Logs (may contain sensitive data)
*.log
logs/
npm-debug.log*

# IDE & System
.vscode/settings.json  # May contain paths/tokens
.idea/
*.swp

# Testing fixtures with real data
tests/fixtures/real-data/
cypress/fixtures/production/

# Documentation with architectural details
docs/infrastructure/
docs/architecture/sensitive/
```

#### Pre-Interaction Checklist

Before asking Cursor/Claude for help:

```bash
# 1. Verify no secrets in context
grep -r "api_key\|secret\|password\|token" --include=\*.{js,ts,py,yml,yaml} .

# 2. Check environment files
find . -name ".env*" -type f

# 3. Validate .cursorignore is working
# Open Cursor > Press Cmd/Ctrl+Shift+P > "Cursor: Show Indexed Files"
# Verify sensitive files are NOT listed
```

### 🟠 HIGH: Cursor Composer & Agent Mode

**Risk**: Composer can execute terminal commands and modify files automatically.

**Controls**:
- **Never use Composer in production environments**
- Review every file change in diff view before accepting
- Disable auto-apply for:
  - Database migrations
  - Configuration files
  - Deployment scripts
  - Package installations

```json
// .cursor/settings.json
{
  "cursor.composer.autoApply": false,
  "cursor.composer.confirmBeforeExecute": true,
  "cursor.review.showDiff": true
}
```

### 🟡 MEDIUM: Workspace-Level Settings

```json
// .vscode/settings.json (Cursor-compatible)
{
  "cursor.maxContextTokens": 20000,  // Limit context size
  "cursor.ignorePatterns": [
    "**/.env*",
    "**/secrets/**",
    "**/credentials/**"
  ],
  "cursor.disableIndexing": [
    "node_modules/",
    ".git/",
    "dist/",
    "build/"
  ]
}
```

---

## 2. Claude Code CLI Security

### 🔴 CRITICAL: API Key Management

**Never** store Claude API keys in:
- Repository files
- Environment files committed to Git
- Claude Code config files in workspace

#### Secure Configuration

```bash
# Store in OS-level credential manager

# macOS Keychain
security add-generic-password -a ${USER} -s claude-api-key -w "sk-ant-..."

# Linux Secret Service
secret-tool store --label='Claude API Key' application claude key api-key

# Windows Credential Manager
cmdkey /generic:claude-api-key /user:api /pass:"sk-ant-..."
```

```bash
# ~/.config/claude-code/config.yaml
# DO NOT commit this file to any repository
api_key: ${CLAUDE_API_KEY}  # Load from environment
workspace_exclusions:
  - .env*
  - secrets/
  - *.key
  - credentials/
```

### 🟠 HIGH: Command Execution Validation

Claude Code can run terminal commands. **Every command must be reviewed**.

#### Safe Practices

```bash
# BAD - Direct execution without review
claude-code --execute-all

# GOOD - Step-by-step with confirmation
claude-code --interactive --confirm-commands

# BEST - Audit log enabled
claude-code --interactive --log-commands ~/.claude-code/audit.log
```

### 🟡 MEDIUM: Workspace Isolation

```bash
# Create isolated workspace profiles for different security zones

# Development (relaxed)
claude-code --profile dev --workspace ./dev-project

# Production (restricted)
claude-code --profile prod --workspace ./prod-project \
  --disable-file-writes \
  --read-only-mode \
  --log-level debug
```

---

## 3. GitHub Organization Hardening

### 🔴 CRITICAL: Branch Protection

Required for **ALL** repositories:

```yaml
# .github/branch-protection-policy.yml
branches:
  main:
    protection:
      required_pull_request_reviews:
        required_approving_review_count: 2
        dismiss_stale_reviews: true
        require_code_owner_reviews: true
      required_status_checks:
        strict: true
        contexts:
          - "security/secret-scan"
          - "security/dependency-check"
          - "ci/tests"
      enforce_admins: true
      required_linear_history: true
      allow_force_pushes: false
      allow_deletions: false
      restrictions:
        users: []
        teams: ["security-team"]
```

### 🔴 CRITICAL: Secret Scanning

#### Enable GitHub Advanced Security

```bash
# Organization-level settings
Settings > Code security and analysis > 
  ✓ Dependency graph
  ✓ Dependabot alerts
  ✓ Dependabot security updates
  ✓ Secret scanning
  ✓ Push protection (CRITICAL)
```

#### Pre-commit Hooks (Client-side)

```bash
# Install gitleaks
brew install gitleaks  # macOS
# or
curl -sSfL https://raw.githubusercontent.com/gitleaks/gitleaks/master/scripts/install.sh | sh

# .git/hooks/pre-commit
#!/bin/bash
echo "🔍 Scanning for secrets..."
gitleaks detect --source . --verbose --no-git

if [ $? -eq 1 ]; then
    echo "❌ SECRET DETECTED! Commit blocked."
    echo "Run: gitleaks detect --verbose --no-git --report-path leaks.json"
    exit 1
fi

echo "✅ No secrets detected"
```

#### GitHub Actions Secret Scanning

```yaml
# .github/workflows/security-scan.yml
name: Security Scan

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  secret-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Full history for better detection

      - name: Gitleaks Scan
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: TruffleHog Scan
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base: main
          head: HEAD

  dependency-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Snyk
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high
```

### 🟠 HIGH: CODEOWNERS Enforcement

```bash
# .github/CODEOWNERS
# Security-sensitive files require security team approval

# Secrets & Configuration
.env.example                    @org/security-team
netlify.toml                    @org/security-team @org/platform-team
supabase/config.toml            @org/security-team @org/backend-team

# Infrastructure
infrastructure/*                @org/security-team @org/devops-team
.github/workflows/*             @org/security-team
Dockerfile                      @org/security-team

# Database
supabase/migrations/*           @org/backend-team @org/database-admin
prisma/migrations/*             @org/backend-team

# Authentication & Authorization
**/auth/**                      @org/security-team @org/backend-team
**/middleware/auth*             @org/security-team

# Package Management
package.json                    @org/security-team
package-lock.json               @org/security-team
yarn.lock                       @org/security-team
requirements.txt                @org/security-team
```

### 🟡 MEDIUM: GitHub Actions Security

```yaml
# .github/workflows/secure-template.yml
name: Secure Workflow Template

on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string

permissions:
  contents: read  # NEVER use 'write' unless absolutely necessary
  pull-requests: read

jobs:
  secure-job:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}  # Use environments for secrets
    
    steps:
      - uses: actions/checkout@v4
        with:
          persist-credentials: false  # Don't persist GitHub token
      
      # Pin actions to commit SHA (not tags)
      - uses: actions/setup-node@1a4442cacd436585916779262731d5b162bc6ec7  # v3.8.2
      
      # Never log secrets
      - name: Deploy
        env:
          API_KEY: ${{ secrets.API_KEY }}
        run: |
          # Secrets won't appear in logs
          echo "::add-mask::$API_KEY"
          npm run deploy
```

---

## 4. Supabase Security Configuration

### 🔴 CRITICAL: Row Level Security (RLS)

**Never disable RLS in production**. AI assistants often suggest disabling RLS for "simplicity".

#### Mandatory RLS Policy Review

```sql
-- supabase/migrations/YYYYMMDD_enable_rls_all_tables.sql

-- Audit all tables without RLS
SELECT schemaname, tablename 
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename NOT IN (
    SELECT tablename 
    FROM pg_policies
  );

-- Enable RLS on all public tables
DO $$
DECLARE
    tbl RECORD;
BEGIN
    FOR tbl IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
    LOOP
        EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY;', tbl.tablename);
    END LOOP;
END $$;
```

#### Example Secure RLS Policies

```sql
-- User can only read their own data
CREATE POLICY "Users can view own data"
ON public.users
FOR SELECT
USING (auth.uid() = id);

-- User can only update their own data
CREATE POLICY "Users can update own data"
ON public.users
FOR UPDATE
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Service role bypass (for backend operations only)
CREATE POLICY "Service role has full access"
ON public.users
FOR ALL
USING (auth.jwt()->>'role' = 'service_role');
```

### 🔴 CRITICAL: API Key Management

```bash
# .env.local (NEVER commit)
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGc...  # Safe for client-side
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...      # NEVER expose to client

# .env.example (safe to commit)
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_keep_secret
```

**Service Role Key Rules**:
- **ONLY use server-side** (API routes, Edge Functions)
- **NEVER** send to client
- **NEVER** log or expose in errors
- Rotate every 90 days

#### Client vs Server Key Usage

```typescript
// ✅ CORRECT - Client-side (Next.js page)
import { createClientComponentClient } from '@supabase/auth-helpers-nextjs'

export default function ClientComponent() {
  const supabase = createClientComponentClient() // Uses anon key
  // RLS enforced, user can only access their data
}

// ✅ CORRECT - Server-side (API route)
import { createServerComponentClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'

export async function GET(request: Request) {
  const supabase = createServerComponentClient({ cookies })
  // Still uses anon key, but with user's JWT
}

// ✅ CORRECT - Service role (admin operations)
import { createClient } from '@supabase/supabase-js'

const supabaseAdmin = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!,  // Bypasses RLS
  { auth: { persistSession: false } }
)
// ONLY use in trusted server environments

// ❌ WRONG - Service key on client
const supabase = createClient(url, process.env.SUPABASE_SERVICE_ROLE_KEY)
// CRITICAL: Exposes service key to browser!
```

### 🟠 HIGH: Database Migration Review Process

**Never apply AI-generated migrations without review**.

```bash
# Workflow for AI-generated migrations

# 1. AI generates migration
supabase migration new add_user_profiles

# 2. Review SQL in detail
code supabase/migrations/XXXXXX_add_user_profiles.sql

# 3. Check for:
#    - Missing RLS policies
#    - Overly permissive policies
#    - Missing indexes (performance)
#    - Data type mismatches
#    - Foreign key constraints

# 4. Test locally first
supabase db reset  # Apply all migrations
supabase db diff   # Verify changes

# 5. Deploy to staging
supabase db push --db-url $STAGING_DATABASE_URL

# 6. Run integration tests on staging

# 7. Only then deploy to production
supabase db push --db-url $PRODUCTION_DATABASE_URL
```

### 🟡 MEDIUM: Edge Function Security

```typescript
// supabase/functions/secure-function/index.ts

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  // ✅ Validate request method
  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 })
  }

  // ✅ Verify JWT token
  const authHeader = req.headers.get('Authorization')
  if (!authHeader) {
    return new Response('Unauthorized', { status: 401 })
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_ANON_KEY') ?? '',
    { global: { headers: { Authorization: authHeader } } }
  )

  // ✅ Verify user session
  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    return new Response('Invalid token', { status: 401 })
  }

  // ✅ Input validation
  const body = await req.json()
  if (!body.data || typeof body.data !== 'string') {
    return new Response('Invalid input', { status: 400 })
  }

  // ✅ Rate limiting (use Supabase RLS or external service)
  
  // Process request...
  
  // ✅ Never log sensitive data
  console.log(`Request from user ${user.id}`)  // OK
  console.log(`Data: ${body.data}`)            // ❌ Could contain PII

  return new Response(JSON.stringify({ success: true }), {
    headers: { 'Content-Type': 'application/json' }
  })
})
```

---

## 5. Netlify Security Configuration

### 🔴 CRITICAL: Environment Variables

```toml
# netlify.toml - Safe for repository
[build]
  command = "npm run build"
  publish = "dist"

[build.environment]
  NODE_VERSION = "20"
  # ❌ DO NOT put secrets here

# ✅ Set secrets via Netlify UI or CLI
# Settings > Environment Variables > Add variable
# Scopes: All deploys, Production, Deploy previews, Branch deploys

# Or via CLI:
# netlify env:set SUPABASE_SERVICE_KEY "xxx" --scope production
```

#### Context-Specific Variables

```toml
# netlify.toml

# Production context
[context.production.environment]
  NEXT_PUBLIC_API_URL = "https://api.example.com"
  NODE_ENV = "production"

# Deploy preview context (PRs)
[context.deploy-preview.environment]
  NEXT_PUBLIC_API_URL = "https://staging-api.example.com"
  NODE_ENV = "development"

# Branch deploys
[context.branch-deploy.environment]
  NEXT_PUBLIC_API_URL = "https://dev-api.example.com"
```

### 🟠 HIGH: Build Hooks Protection

```bash
# Netlify build hooks are sensitive URLs that trigger deployments
# Treat them like API keys

# ✅ Store in GitHub Secrets
# Settings > Secrets > Actions > New repository secret
# Name: NETLIFY_BUILD_HOOK_URL
# Value: https://api.netlify.com/build_hooks/xxxxx

# Use in GitHub Actions:
# .github/workflows/deploy.yml
- name: Trigger Netlify Deploy
  run: curl -X POST -d {} ${{ secrets.NETLIFY_BUILD_HOOK_URL }}
```

### 🟡 MEDIUM: Serverless Function Security

```typescript
// netlify/functions/api.ts

import { Handler, HandlerEvent, HandlerContext } from '@netlify/functions'

export const handler: Handler = async (
  event: HandlerEvent,
  context: HandlerContext
) => {
  // ✅ CORS configuration
  const headers = {
    'Access-Control-Allow-Origin': process.env.ALLOWED_ORIGIN || 'https://yourdomain.com',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
  }

  // Handle preflight
  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 204, headers, body: '' }
  }

  // ✅ Method validation
  if (event.httpMethod !== 'POST') {
    return {
      statusCode: 405,
      headers,
      body: JSON.stringify({ error: 'Method not allowed' })
    }
  }

  // ✅ Rate limiting via Netlify Edge
  const ip = event.headers['x-nf-client-connection-ip']
  // Implement rate limit check

  // ✅ Input validation
  try {
    const body = JSON.parse(event.body || '{}')
    
    if (!body.action || typeof body.action !== 'string') {
      return {
        statusCode: 400,
        headers,
        body: JSON.stringify({ error: 'Invalid input' })
      }
    }

    // Process request
    
    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({ success: true })
    }
  } catch (error) {
    // ✅ Never expose internal errors
    console.error('Function error:', error)
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ error: 'Internal server error' })
    }
  }
}
```

### 🟡 MEDIUM: Deploy Contexts & Preview Security

```toml
# netlify.toml

# Restrict deploy previews
[context.deploy-preview]
  environment = { ROBOTS_NOINDEX = "true" }

# Add authentication to deploy previews
[[plugins]]
  package = "@netlify/plugin-password-protection"
  
  [plugins.inputs]
    password = "staging-password-from-env"

# Security headers for all deploys
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
    X-XSS-Protection = "1; mode=block"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Permissions-Policy = "geolocation=(), microphone=(), camera=()"
    Content-Security-Policy = "default-src 'self'; script-src 'self' 'unsafe-inline' https://cdn.example.com"
```

---

## 6. Prompt Hygiene & Injection Prevention

### 🔴 CRITICAL: Data Sanitization Before AI Queries

**Never paste** into Claude/Cursor:
- Real user data (emails, names, addresses)
- API responses with sensitive data
- Database query results with PII
- Authentication tokens
- Session IDs
- Error messages with stack traces containing paths

#### Data Anonymization Script

```typescript
// scripts/sanitize-for-ai.ts

interface SanitizeOptions {
  preserveStructure: boolean
  maskEmails: boolean
  maskIds: boolean
}

export function sanitizeForAI(data: any, options: SanitizeOptions = {
  preserveStructure: true,
  maskEmails: true,
  maskIds: true
}): any {
  if (typeof data === 'string') {
    let sanitized = data
    
    // Email obfuscation
    if (options.maskEmails) {
      sanitized = sanitized.replace(
        /[\w.-]+@[\w.-]+\.\w+/g,
        'user@example.com'
      )
    }
    
    // UUID obfuscation
    if (options.maskIds) {
      sanitized = sanitized.replace(
        /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/gi,
        'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      )
    }
    
    // API keys
    sanitized = sanitized.replace(
      /sk-[a-zA-Z0-9]{48}/g,
      'sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    )
    
    // Phone numbers
    sanitized = sanitized.replace(
      /\+?[1-9]\d{1,14}/g,
      '+1234567890'
    )
    
    return sanitized
  }
  
  if (Array.isArray(data)) {
    return data.map(item => sanitizeForAI(item, options))
  }
  
  if (typeof data === 'object' && data !== null) {
    const sanitized: any = {}
    for (const [key, value] of Object.entries(data)) {
      sanitized[key] = sanitizeForAI(value, options)
    }
    return sanitized
  }
  
  return data
}

// Usage example
const apiResponse = await fetch('/api/users')
const data = await apiResponse.json()

// ✅ Sanitize before copying to Cursor
const sanitizedData = sanitizeForAI(data)
console.log(sanitizedData)
// Now safe to copy and paste into AI chat
```

### 🟠 HIGH: Prompt Injection Detection

Signs you may be experiencing prompt injection:

1. **AI suggests code that**:
   - Disables security features
   - Adds backdoors or unusual network calls
   - Modifies authentication logic unexpectedly
   - Includes obfuscated code
   - References unusual external domains

2. **AI behavior changes**:
   - Suddenly refuses to follow your instructions
   - Starts asking unusual questions
   - Provides evasive or inconsistent answers

#### Response Protocol

```bash
# IMMEDIATE ACTIONS if you suspect prompt injection:

# 1. Stop all AI interactions
# Close Cursor, exit Claude Code session

# 2. Clear AI context
# Cursor: Restart Cursor IDE
# Claude Code: Start fresh terminal session

# 3. Review recent changes
git diff HEAD~5 HEAD > recent-changes.diff
# Manually review every line

# 4. Check for suspicious code
grep -r "eval\|exec\|Function\|setTimeout.*http" --include=\*.{js,ts} .
grep -r "base64\|atob\|btoa" --include=\*.{js,ts} . | grep -v node_modules

# 5. Verify no secrets were exposed
git log --all -p | grep -E "api[_-]key|secret|password|token" 

# 6. If secrets found
# Immediately rotate all keys
# Check access logs for unauthorized usage
# Deploy emergency patch

# 7. File incident report
# Document what happened for team review
```

### 🟡 MEDIUM: Safe Query Patterns

```bash
# ❌ BAD - Pasting real user data
"Here's the API response with user data:
{
  email: 'john.doe@company.com',
  ssn: '123-45-6789',
  credit_card: '4532-1234-5678-9010'
}
Can you help process this?"

# ✅ GOOD - Using dummy data
"Here's the expected API response structure:
{
  email: 'user@example.com',
  ssn: 'XXX-XX-XXXX',
  credit_card: '****-****-****-****'
}
Can you help me write a validator for this?"

# ❌ BAD - Exposing architecture
"Our production database is at postgres://user:password@db.internal.company.com:5432/prod"

# ✅ GOOD - Generic example
"I need to connect to a PostgreSQL database. Here's my connection pattern:
postgres://user:password@hostname:5432/database"
```

---

## 7. Supply Chain Security

### 🔴 CRITICAL: Dependency Verification

**AI models frequently suggest packages**. Many are:
- Outdated with known vulnerabilities
- Typosquatting attacks
- Malicious packages
- Unmaintained projects

#### Pre-Installation Checklist

```bash
# Before running 'npm install <package>' suggested by AI:

# 1. Verify package exists and is legitimate
npm info <package>

# 2. Check weekly downloads (low numbers = suspicious)
# Visit: https://www.npmjs.com/package/<package>
# Look for: >10k weekly downloads, recent updates, GitHub link

# 3. Check for known vulnerabilities
npm audit

# 4. Review package on Snyk
# https://snyk.io/advisor/npm-package/<package>

# 5. Check GitHub repository
# - Stars (>100 preferred)
# - Recent commits
# - Open issues response time
# - Maintainer reputation

# 6. Review dependencies
npm view <package> dependencies
# Flag if package has excessive dependencies

# 7. Check package size
npm view <package> dist.unpackedSize
# Suspiciously large packages may contain malicious code
```

#### Automated Dependency Scanning

```yaml
# .github/workflows/dependency-security.yml
name: Dependency Security

on:
  pull_request:
    paths:
      - 'package.json'
      - 'package-lock.json'
      - 'yarn.lock'
      - 'requirements.txt'
      - 'Pipfile.lock'

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Snyk Security Scan
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          command: test
          args: --severity-threshold=high --fail-on=upgradable

      - name: OWASP Dependency Check
        uses: dependency-check/Dependency-Check_Action@main
        with:
          project: 'my-project'
          path: '.'
          format: 'ALL'

      - name: Upload Dependency Check Results
        uses: actions/upload-artifact@v3
        with:
          name: dependency-check-report
          path: reports/

  license-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Check Licenses
        run: |
          npx license-checker --summary --production \
            --exclude "MIT,ISC,Apache-2.0,BSD-2-Clause,BSD-3-Clause"
          
          if [ $? -ne 0 ]; then
            echo "❌ Incompatible licenses detected"
            exit 1
          fi
```

### 🟠 HIGH: Package Lock Enforcement

```json
// .npmrc - Repository root
package-lock=true
save-exact=true
engine-strict=true

// Prevent auto-updating packages
save-prefix=""
```

```yaml
# .github/workflows/lockfile-verification.yml
name: Verify Lockfiles

on:
  pull_request:
    paths:
      - 'package.json'
      - 'package-lock.json'

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      - name: Verify lockfile integrity
        run: |
          npm ci
          npm run build
          
          # Ensure lockfile is up-to-date
          if ! git diff --exit-code package-lock.json; then
            echo "❌ package-lock.json is out of sync with package.json"
            exit 1
          fi
```

### 🟡 MEDIUM: Software Bill of Materials (SBOM)

```bash
# Generate SBOM for compliance and security audits

# Using Syft
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
syft packages dir:. -o json > sbom.json

# Upload to artifact registry
# Review SBOM regularly for unexpected dependencies
```

---

## 8. Token & Credential Management

### 🔴 CRITICAL: Short-Lived Tokens

```typescript
// Token rotation strategy

interface TokenConfig {
  accessTokenTTL: number  // 15 minutes
  refreshTokenTTL: number  // 7 days
  rotateOnUse: boolean
}

// Supabase JWT configuration
const config: TokenConfig = {
  accessTokenTTL: 900,      // 15 minutes
  refreshTokenTTL: 604800,  // 7 days
  rotateOnUse: true         // Rotate refresh token on each use
}

// Implement token refresh
async function refreshSession() {
  const { data, error } = await supabase.auth.refreshSession()
  if (error) {
    // Redirect to login
    window.location.href = '/login'
  }
  return data.session
}

// Auto-refresh before expiry
setInterval(async () => {
  const { data: { session } } = await supabase.auth.getSession()
  if (session) {
    const expiresAt = session.expires_at * 1000
    const now = Date.now()
    const timeUntilExpiry = expiresAt - now
    
    // Refresh 5 minutes before expiry
    if (timeUntilExpiry < 5 * 60 * 1000) {
      await refreshSession()
    }
  }
}, 60000) // Check every minute
```

### 🟠 HIGH: API Key Rotation

```bash
# Automated key rotation workflow

# 1. Generate new key
NEW_KEY=$(openssl rand -hex 32)

# 2. Deploy new key alongside old (dual-key period)
netlify env:set API_KEY_PRIMARY "$NEW_KEY" --scope production
# Keep OLD key as API_KEY_SECONDARY for 24h

# 3. Update clients gradually

# 4. Monitor usage
# Check logs for usage of OLD key

# 5. After 24h, revoke old key
netlify env:unset API_KEY_SECONDARY --scope production

# 6. Promote new key
# NEW key becomes PRIMARY
```

#### Secrets Management with HashiCorp Vault

```typescript
// Integration with Vault for production secrets
import vault from 'node-vault'

const vaultClient = vault({
  endpoint: process.env.VAULT_ADDR,
  token: process.env.VAULT_TOKEN  // Short-lived, rotated token
})

async function getSecret(path: string) {
  try {
    const result = await vaultClient.read(path)
    return result.data.data
  } catch (error) {
    console.error('Failed to read secret from Vault')
    throw error
  }
}

// Usage
const dbCredentials = await getSecret('secret/data/production/database')
```

### 🟡 MEDIUM: Least Privilege Access

```sql
-- Database user permissions (Supabase/PostgreSQL)

-- ❌ BAD - Overprivileged user
GRANT ALL PRIVILEGES ON DATABASE myapp TO app_user;

-- ✅ GOOD - Minimal required permissions
-- Read-only user for analytics
CREATE ROLE analytics_reader;
GRANT CONNECT ON DATABASE myapp TO analytics_reader;
GRANT USAGE ON SCHEMA public TO analytics_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analytics_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO analytics_reader;

-- Application user with specific permissions
CREATE ROLE app_user;
GRANT CONNECT ON DATABASE myapp TO app_user;
GRANT USAGE ON SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE users, posts, comments TO app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_user;
```

---

## 9. Monitoring & Logging

### 🟠 HIGH: API Usage Monitoring

```typescript
// middleware/api-monitoring.ts

import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  const start = Date.now()
  
  // Log request
  console.log({
    timestamp: new Date().toISOString(),
    method: request.method,
    path: request.nextUrl.pathname,
    ip: request.headers.get('x-forwarded-for'),
    userAgent: request.headers.get('user-agent'),
  })

  // Continue request
  const response = NextResponse.next()

  // Log response
  const duration = Date.now() - start
  console.log({
    timestamp: new Date().toISOString(),
    path: request.nextUrl.pathname,
    status: response.status,
    duration: `${duration}ms`,
  })

  return response
}

export const config = {
  matcher: '/api/:path*',
}
```

### 🟠 HIGH: Anomaly Detection

```yaml
# Set up alerts for suspicious patterns

# Datadog/New Relic/CloudWatch alert examples:
alerts:
  - name: "Unusual API Key Usage"
    condition: "api_requests > 1000 in 5 minutes from single IP"
    severity: high
    notification: security-team
    
  - name: "Failed Authentication Spike"
    condition: "auth_failures > 50 in 1 minute"
    severity: critical
    notification: security-team, devops
    
  - name: "Unexpected Geographic Access"
    condition: "api_request.country NOT IN [US, EU] AND user.role = admin"
    severity: high
    notification: security-team
    
  - name: "Secret Scan Failure"
    condition: "github_action.secret_scan.status = failed"
    severity: critical
    notification: security-team, developer
    
  - name: "Dependency Vulnerability"
    condition: "snyk.severity = critical"
    severity: critical
    notification: security-team, engineering-lead
```

### 🟡 MEDIUM: Audit Logging

```typescript
// utils/audit-log.ts

interface AuditEvent {
  timestamp: Date
  actor: string  // User ID or system
  action: string  // CRUD operation
  resource: string  // What was accessed
  resourceId: string
  outcome: 'success' | 'failure'
  metadata?: Record<string, any>
  ip?: string
  userAgent?: string
}

export async function logAuditEvent(event: AuditEvent) {
  // Store in secure, append-only log
  await supabase
    .from('audit_logs')
    .insert({
      ...event,
      timestamp: event.timestamp.toISOString(),
    })
  
  // Also send to external SIEM if compliance required
  if (process.env.SIEM_ENABLED === 'true') {
    await sendToSIEM(event)
  }
}

// Usage example
await logAuditEvent({
  timestamp: new Date(),
  actor: user.id,
  action: 'UPDATE',
  resource: 'user_profile',
  resourceId: profileId,
  outcome: 'success',
  metadata: { fields: ['email', 'name'] },
  ip: request.ip,
  userAgent: request.headers['user-agent']
})
```

---

## 10. Incident Response Procedures

### 🔴 CRITICAL: Secret Leak Response

**Timeline**: Act within **30 minutes** of detection.

```bash
#!/bin/bash
# incident-response-secret-leak.sh

echo "🚨 SECRET LEAK DETECTED - INCIDENT RESPONSE ACTIVATED"
echo "Timestamp: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# STEP 1: IMMEDIATE CONTAINMENT (0-5 minutes)
echo "STEP 1: Revoking compromised credentials..."

# Rotate all potentially affected keys
# Supabase
# Navigate to: https://app.supabase.com/project/_/settings/api
# Click "Reveal" on service_role key > "Generate new key"

# Netlify
netlify env:unset SUPABASE_SERVICE_ROLE_KEY --scope production
# Generate new key and set
netlify env:set SUPABASE_SERVICE_ROLE_KEY "new-key" --scope production

# GitHub
# Settings > Secrets and variables > Actions > Update secret

# STEP 2: ASSESS IMPACT (5-15 minutes)
echo "STEP 2: Assessing impact..."

# Check when secret was exposed
LEAK_COMMIT=$(git log --all -p | grep -m 1 "leaked-secret" | grep "commit" | cut -d' ' -f2)
LEAK_DATE=$(git show -s --format=%ci $LEAK_COMMIT)
echo "Secret first appeared in commit: $LEAK_COMMIT"
echo "Date: $LEAK_DATE"

# Check if pushed to remote
if git branch -r --contains $LEAK_COMMIT; then
  echo "⚠️  CRITICAL: Secret was pushed to remote repository"
  PUSHED_TO_REMOTE=true
else
  echo "✓ Secret only exists locally"
  PUSHED_TO_REMOTE=false
fi

# STEP 3: REVIEW ACCESS LOGS (15-30 minutes)
echo "STEP 3: Checking for unauthorized access..."

# Supabase: Check API logs
# Dashboard > Logs > Filter by date range

# Netlify: Check function logs
netlify functions:log --since="${LEAK_DATE}"

# GitHub: Check audit log
# Settings > Logs > Export audit log

# STEP 4: CONTAINMENT ACTIONS
if [ "$PUSHED_TO_REMOTE" = true ]; then
  echo "STEP 4: Remote containment required..."
  
  # BFG Repo-Cleaner to remove secret from history
  # WARNING: This rewrites history
  # Coordinate with team before running
  
  # Download BFG
  # wget https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar
  
  # Create file with secret to remove
  echo "leaked-secret-value" > secrets.txt
  
  # Run BFG
  # java -jar bfg-1.14.0.jar --replace-text secrets.txt /path/to/repo
  
  echo "⚠️  Run: cd /path/to/repo && git reflog expire --expire=now --all && git gc --prune=now --aggressive"
  echo "⚠️  Then: git push --force --all"
  echo "⚠️  Notify all team members to re-clone repository"
fi

# STEP 5: NOTIFICATION (within 30 minutes)
echo "STEP 5: Notifying stakeholders..."

# Send to security team
curl -X POST $SLACK_WEBHOOK_URL -H 'Content-Type: application/json' \
  -d '{
    "text": "🚨 Security Incident: Secret Leak Detected",
    "attachments": [{
      "color": "danger",
      "fields": [
        {"title": "Incident Type", "value": "Secret Exposure", "short": true},
        {"title": "Severity", "value": "CRITICAL", "short": true},
        {"title": "Commit", "value": "'"$LEAK_COMMIT"'", "short": true},
        {"title": "Status", "value": "Containment in progress", "short": true}
      ]
    }]
  }'

# Create incident ticket
# gh issue create --title "SECURITY: Secret Leak - $LEAK_DATE" \
#   --body "Secret detected in commit $LEAK_COMMIT. Credentials rotated. Investigating unauthorized access." \
#   --label "security,incident,critical"

echo "✓ Incident response steps completed"
echo "Next: Complete incident report and schedule retrospective"
```

### 🟠 HIGH: Suspected Prompt Injection Response

```bash
#!/bin/bash
# incident-response-prompt-injection.sh

echo "⚠️  PROMPT INJECTION SUSPECTED"

# STEP 1: ISOLATE (Immediate)
echo "STEP 1: Isolating AI interactions..."
# 1. Close all Cursor/Claude Code sessions
# 2. Kill any running AI processes
pkill -f "cursor"
pkill -f "claude-code"

# STEP 2: PRESERVE EVIDENCE
echo "STEP 2: Preserving evidence..."
INCIDENT_DIR="./security-incidents/$(date +%Y%m%d-%H%M%S)-prompt-injection"
mkdir -p "$INCIDENT_DIR"

# Save recent changes
git diff HEAD~10 HEAD > "$INCIDENT_DIR/recent-changes.diff"
git log --oneline -20 > "$INCIDENT_DIR/recent-commits.log"

# Save Cursor chat history
cp -r ~/.cursor/conversations "$INCIDENT_DIR/cursor-history" 2>/dev/null

# Save environment
env | grep -v "SECRET\|KEY\|TOKEN\|PASSWORD" > "$INCIDENT_DIR/environment.txt"

# STEP 3: CODE REVIEW
echo "STEP 3: Reviewing for malicious code..."

# Check for suspicious patterns
grep -r "eval\|exec\|Function" --include=\*.{js,ts} . > "$INCIDENT_DIR/eval-usage.txt"
grep -r "http\|https" --include=\*.{js,ts} . | grep -v "node_modules\|localhost" > "$INCIDENT_DIR/external-urls.txt"
grep -r "atob\|btoa\|fromCharCode" --include=\*.{js,ts} . > "$INCIDENT_DIR/encoding.txt"

# STEP 4: ROLLBACK SUSPICIOUS CHANGES
echo "STEP 4: Preparing rollback..."
# Review files in $INCIDENT_DIR/recent-changes.diff
# Manually revert any suspicious modifications

# STEP 5: VERIFY INTEGRITY
echo "STEP 5: Running security scans..."
npm audit
gitleaks detect --source . --verbose --no-git --report-path "$INCIDENT_DIR/gitleaks-report.json"

echo "✓ Evidence preserved in: $INCIDENT_DIR"
echo "Next: Manual code review required"
echo "Team notification: [Send to security team]"
```

### 🟡 MEDIUM: Incident Documentation Template

```markdown
# Security Incident Report

**Incident ID**: INC-YYYY-MM-DD-XXX
**Date**: [Date]
**Severity**: Critical / High / Medium / Low
**Status**: Open / Investigating / Contained / Resolved

## Executive Summary
[Brief description of what happened]

## Timeline
- **[Time]**: Initial detection
- **[Time]**: Containment actions started
- **[Time]**: Root cause identified
- **[Time]**: Resolution deployed
- **[Time]**: Incident closed

## Technical Details

### What Happened
[Detailed technical description]

### Root Cause
[Why this happened]

### Affected Systems
- [ ] Production environment
- [ ] Staging environment
- [ ] Development environment
- [ ] CI/CD pipeline
- [ ] User data
- [ ] API keys
- [ ] Database

### Impact Assessment
- **Users Affected**: [Number]
- **Data Exposed**: [Type and volume]
- **Duration**: [How long was exposure active]
- **Financial Impact**: [If applicable]

## Response Actions

### Immediate Actions Taken
1. [Action 1]
2. [Action 2]

### Containment Measures
1. [Measure 1]
2. [Measure 2]

### Remediation Steps
1. [Step 1]
2. [Step 2]

## Lessons Learned

### What Went Well
- [Success 1]
- [Success 2]

### What Could Be Improved
- [Improvement 1]
- [Improvement 2]

### Action Items
- [ ] [Action item 1] - Owner: [Name] - Due: [Date]
- [ ] [Action item 2] - Owner: [Name] - Due: [Date]

## Prevention

### New Controls Implemented
1. [Control 1]
2. [Control 2]

### Process Changes
1. [Change 1]
2. [Change 2]

## Sign-off
- **Incident Commander**: [Name] - [Date]
- **Security Team Lead**: [Name] - [Date]
- **Engineering Lead**: [Name] - [Date]
```

---

## 11. Code Review Checklist for AI-Generated Code

### 🔴 CRITICAL REVIEW POINTS

Before merging any AI-generated code, verify:

#### Security
```bash
# ✓ No hardcoded secrets
grep -r "api_key\|apiKey\|secret\|password\|token" --include=\*.{js,ts,py} .

# ✓ No eval() or dangerous functions
grep -r "eval\|exec\|Function" --include=\*.{js,ts,py} .

# ✓ No SQL injection vulnerabilities
grep -r "raw\|query.*\+" --include=\*.{js,ts,py} .

# ✓ Proper input validation
# Check all user inputs are validated/sanitized

# ✓ Authentication/authorization checks
# Verify protected routes have auth middleware

# ✓ XSS prevention
# Ensure user content is properly escaped
```

#### Dependencies
```bash
# ✓ All new packages vetted
git diff main package.json | grep "+"

# ✓ No typosquatting
# Verify package names are spelled correctly

# ✓ No outdated packages
npm audit

# ✓ License compatibility
npx license-checker --summary
```

#### Database Changes
```sql
-- ✓ RLS policies present
SELECT tablename FROM pg_tables WHERE schemaname = 'public'
  AND tablename NOT IN (SELECT tablename FROM pg_policies);

-- ✓ Proper indexes
-- Verify query performance won't degrade

-- ✓ Migration is reversible
-- Check DOWN migration exists

-- ✓ No destructive operations without backup
-- DROP, TRUNCATE should be reviewed 3x
```

#### Performance
```bash
# ✓ No N+1 queries
# Review database calls in loops

# ✓ Proper pagination
# Check list endpoints use LIMIT/OFFSET

# ✓ Appropriate caching
# Verify cache headers for static assets

# ✓ No unnecessary re-renders (React)
# Check for missing dependencies in useEffect
```

---

## 12. Pre-Commit & Pre-Push Checklists

### Daily Developer Checklist

```bash
#!/bin/bash
# daily-security-check.sh

echo "🔍 Running daily security checks..."

# 1. Check for uncommitted secrets
echo "Checking for secrets..."
gitleaks detect --no-git --verbose --source .
if [ $? -ne 0 ]; then
  echo "❌ Secrets detected! Do not commit."
  exit 1
fi

# 2. Audit dependencies
echo "Checking dependencies..."
npm audit --audit-level=moderate
if [ $? -ne 0 ]; then
  echo "⚠️  Vulnerabilities found. Review and fix."
fi

# 3. Check environment files
echo "Checking environment configuration..."
if [ -f .env ] && git ls-files --error-unmatch .env 2>/dev/null; then
  echo "❌ .env is tracked by Git! Remove immediately."
  exit 1
fi

# 4. Verify .cursorignore
echo "Checking .cursorignore..."
if [ ! -f .cursorignore ]; then
  echo "⚠️  .cursorignore not found. Creating default..."
  cat > .cursorignore << 'EOF'
.env*
*.key
*.pem
secrets/
credentials/
EOF
fi

# 5. Check for large files (potential data leaks)
echo "Checking for large files..."
find . -type f -size +5M -not -path "*/node_modules/*" -not -path "*/.git/*"

echo "✅ Security checks complete"
```

### Pre-Commit Hook (Mandatory)

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "🔒 Running pre-commit security checks..."

# 1. Secret scanning
gitleaks protect --staged --verbose
if [ $? -ne 0 ]; then
  echo "❌ COMMIT BLOCKED: Secrets detected"
  exit 1
fi

# 2. Check for direct dependency additions
if git diff --cached package.json | grep "^\+.*\"" | grep -v "version"; then
  echo "⚠️  Dependencies changed. Have you:"
  echo "   - Verified package legitimacy?"
  echo "   - Checked for vulnerabilities?"
  echo "   - Reviewed package reputation?"
  read -p "Continue? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# 3. Check for debugging code
if git diff --cached | grep -E "console\.log|debugger|TODO|FIXME"; then
  echo "⚠️  Found debugging statements. Remove before committing."
  read -p "Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# 4. Verify no large files
if git diff --cached --name-only | xargs -I {} du -h {} | grep -E "^[0-9]+M"; then
  echo "❌ Large files detected. Consider using Git LFS."
  exit 1
fi

echo "✅ Pre-commit checks passed"
```

### Pre-Push Hook

```bash
#!/bin/bash
# .git/hooks/pre-push

echo "🔒 Running pre-push security checks..."

# 1. Full repository secret scan
gitleaks detect --source . --verbose
if [ $? -ne 0 ]; then
  echo "❌ PUSH BLOCKED: Secrets in repository history"
  exit 1
fi

# 2. Branch protection check
current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
protected_branches=("main" "master" "production")

if [[ " ${protected_branches[@]} " =~ " ${current_branch} " ]]; then
  echo "❌ Direct push to protected branch '$current_branch' not allowed"
  echo "Create a pull request instead"
  exit 1
fi

# 3. Run tests
echo "Running tests..."
npm test
if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Fix before pushing."
  exit 1
fi

echo "✅ Pre-push checks passed"
```

---

## 13. Team Training & Awareness

### Monthly Security Review

**Schedule**: First Friday of every month

**Agenda**:
1. Review security incidents from previous month
2. Update threat model based on new AI features
3. Review access logs for anomalies
4. Audit API key usage and rotate if needed
5. Check for deprecated dependencies
6. Team knowledge sharing on new attack vectors

### Onboarding Security Checklist

**For new developers**:

- [ ] Read this security guideline document
- [ ] Complete secure coding training
- [ ] Configure local development environment:
  - [ ] Install gitleaks
  - [ ] Set up pre-commit hooks
  - [ ] Configure .cursorignore
  - [ ] Verify no secrets in shell history
- [ ] Review past security incidents
- [ ] Shadow experienced developer on code review
- [ ] Practice incident response scenario
- [ ] Understand escalation procedures

### Red Flags Training

Teach team to recognize:

**Suspicious AI Suggestions**:
- Code that disables security features
- Unusual network requests
- Base64-encoded strings without clear purpose
- Obfuscated code
- Requests to install unknown packages
- Suggestions to "temporarily disable" security controls

**Social Engineering via AI**:
- Prompts that seem to redirect the AI's behavior
- Requests to "ignore previous instructions"
- Attempts to extract sensitive information
- Unusual formatting or commands embedded in code comments

---

## 14. Compliance & Audit Requirements

### Audit Trail Requirements

**Must log and retain for 12 months**:
- All API key usage with timestamps
- Authentication attempts (success and failure)
- Database schema changes
- Environment variable modifications
- Access to production systems
- Secret rotation events
- Security scan results
- Incident response activations

### Compliance Checklist (GDPR/SOC2/ISO27001)

- [ ] Data minimization in AI context (no unnecessary PII)
- [ ] Audit logging enabled on all systems
- [ ] Encryption at rest and in transit
- [ ] Access controls with least privilege
- [ ] Regular security assessments
- [ ] Incident response procedures documented and tested
- [ ] Data breach notification procedures
- [ ] Vendor security assessments (Anthropic, Netlify, Supabase)
- [ ] Regular penetration testing
- [ ] Security awareness training for all team members

---

## 15. Tool-Specific Quick Reference

### Cursor Quick Security Commands

```bash
# Check what Cursor can see
Cmd/Ctrl + Shift + P > "Cursor: Show Indexed Files"

# Reload .cursorignore
Cmd/Ctrl + Shift + P > "Cursor: Reload Window"

# Clear chat history
Cmd/Ctrl + Shift + P > "Cursor: Clear Chat History"

# Disable network features temporarily
Cmd/Ctrl + Shift + P > "Cursor: Disable Web Search"
```

### Claude Code Security Commands

```bash
# Audit mode (logs all commands)
claude-code --audit-log ~/.claude-code/audit.log

# Read-only mode (for production debugging)
claude-code --read-only

# Restrict file access
claude-code --allowed-paths ./src,./tests

# Review session
claude-code review-session --session-id <id>
```

### GitHub Security Commands

```bash
# Enable secret scanning
gh repo edit --enable-secret-scanning

# Enable push protection
gh repo edit --enable-secret-scanning-push-protection

# View security alerts
gh api repos/:owner/:repo/security-advisories

# Close alert
gh api -X PATCH repos/:owner/:repo/secret-scanning/alerts/:number \
  -f state=resolved -f resolution=false_positive
```

### Supabase Security Commands

```sql
-- List all policies
SELECT schemaname, tablename, policyname, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public';

-- Find tables without RLS
SELECT tablename 
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename NOT IN (SELECT tablename FROM pg_policies);

-- Audit user permissions
SELECT grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_schema='public';
```

---

## 16. Emergency Contacts & Escalation

### Incident Severity Levels

| Severity | Description | Response Time | Escalation |
|----------|-------------|---------------|------------|
| **P0 - Critical** | Production down, active data breach, secrets leaked | Immediate | Security Lead + CTO |
| **P1 - High** | Major vulnerability, service degraded | < 1 hour | Security Lead |
| **P2 - Medium** | Potential exploit, non-critical issue | < 24 hours | Team Lead |
| **P3 - Low** | Best practice violation | < 1 week | Engineer |

### Contact Information

```yaml
security_team:
  email: security@yourcompany.com
  slack: "#security-alerts"
  pagerduty: https://yourcompany.pagerduty.com
  
escalation_chain:
  - name: Security Lead
    role: First responder
    contact: security-lead@yourcompany.com
    
  - name: CTO
    role: Critical incidents
    contact: cto@yourcompany.com
    
  - name: Legal
    role: Breach notification
    contact: legal@yourcompany.com

external_contacts:
  anthropic_security: security@anthropic.com
  netlify_support: support@netlify.com
  supabase_support: support@supabase.io
  github_support: https://support.github.com
```

---

## 17. Version History & Updates

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2025-11-XX | Initial German version | Team |
| 2.0 | 2025-11-14 | Production-ready English version with comprehensive controls | Security Team |

### Change Management

This document should be reviewed and updated:
- **Monthly**: For minor updates and refinements
- **Quarterly**: For major revisions based on new threats
- **Ad-hoc**: After any security incident
- **Annually**: Complete security posture review

**Document Owner**: Security Team  
**Next Review Date**: 2025-12-14

---

## 🎯 Summary: Top 10 Critical Controls

1. **🔴 Never commit secrets** - Use .env, pre-commit hooks, secret scanning
2. **🔴 Enable GitHub push protection** - Block secrets before they reach remote
3. **🔴 Enforce RLS on all Supabase tables** - Never bypass in production
4. **🔴 Verify all AI-suggested dependencies** - Check reputation before installing
5. **🔴 Review every AI code change** - Never auto-accept without understanding
6. **🔴 Separate service role from anon keys** - Never expose service keys client-side
7. **🔴 Implement pre-commit secret scanning** - Gitleaks in local hooks
8. **🔴 Sanitize data before AI queries** - Never paste real user data
9. **🔴 Maintain audit logs** - Track all sensitive operations
10. **🔴 Have incident response plan** - Know what to do when things go wrong

---

## 📚 Additional Resources

- **OWASP Top 10**: https://owasp.org/www-project-top-ten/
- **OWASP AI Security**: https://owasp.org/www-project-ai-security-and-privacy-guide/
- **Anthropic Security Best Practices**: https://docs.anthropic.com/security
- **Supabase Security**: https://supabase.com/docs/guides/platform/security
- **GitHub Security**: https://docs.github.com/en/code-security
- **Netlify Security**: https://docs.netlify.com/security/

---

**Remember**: AI coding assistants are powerful tools, but they're only as secure as the controls you implement around them. Stay vigilant, question everything, and always verify.

*This document is a living guide. Contribute improvements via pull request.*