---
name: ai-security-workflows
description: >-
  Actively audits GitHub Actions workflows and CI/CD config for security issues.
  Use when editing .github/workflows/, .github/actions/, reviewing a PR that
  touches CI, or when asked to check workflow security.
argument-hint: [workflow-file-or-glob]
allowed-tools: Read Grep Glob Bash(git diff*) Bash(git log*) Bash(git show*)
context: fork
---

You are performing a security audit of GitHub Actions workflows in an AI-assisted development repository.
The threat model here is elevated: AI tools (Cursor, Claude Code) author or edit these files, so assume
injection pressure and mistakes until proven otherwise.

## What to audit

$ARGUMENTS is the target. If empty, audit all files matching `.github/workflows/*.yml` and `.github/actions/**`.

Recent workflow changes for context:
!`git diff HEAD~5 -- .github/ 2>/dev/null | head -200 || echo "no recent changes"`

Existing workflows:
!`ls .github/workflows/ 2>/dev/null || echo "no workflows dir"`

## Run these checks on every workflow file in scope

For each file, report findings under a `### filename` heading using this format:
- **[CRITICAL / HIGH / MEDIUM / LOW]** — Finding. _Specific line or pattern._

### 1. Permissions
- Top-level `permissions:` should default to `read-all` or be absent (defaults vary).
- Each `job` should declare its own `permissions:` block (least privilege).
- Flag any `write-all`, `contents: write`, `packages: write`, `id-token: write` without a documented reason in a comment.

### 2. Action pinning
- Every `uses: owner/action@ref` must be pinned to an **immutable commit SHA**, not `@main`, `@master`, `@latest`, or a floating tag like `@v2`.
- Exception: actions in this org's own workflows may use tags if Dependabot monitors them.
- Check Dependabot config: `.github/dependabot.yml` should include `ecosystem: github-actions`.

### 3. Secrets and credentials
- No `echo ${{ secrets.* }}` or `run: ... $SECRET` patterns that would print to logs.
- No hardcoded tokens, keys, or passwords in YAML.
- Trace every `env:` block — does it expose a secret to untrusted subprocesses?
- Flag long-lived PAT usage; prefer OIDC (`id-token: write` + cloud provider trust policy).

### 4. Dangerous triggers
- `pull_request_target`: flag every use. Verify the job does NOT check out untrusted code with write tokens.
- `workflow_run`: flag every use. This trigger fires in the **base branch context** (has secrets) even when triggered by a fork. Never execute code from the triggering branch without SHA verification.
- `workflow_dispatch` inputs: check that they are validated and not interpolated directly into `run:` steps or file paths.

### 5. Untrusted input injection
- Any `${{ github.event.pull_request.* }}`, `${{ github.event.issue.* }}`, `${{ github.event.comment.* }}` used directly in `run:` steps is a shell injection vector. Flag it.
- Check for `${{ github.head_ref }}` used in branch names or cache keys — can be poisoned.

### 6. Checkout and credentials
- `actions/checkout` steps followed by untrusted code execution must set `persist-credentials: false`.
- Default checkout on `pull_request_target` leaves write credentials accessible — flag if not explicitly disabled.

### 7. Third-party action supply chain
- For each `uses:` not from `actions/`, `github/`, or this org: note the publisher and flag if recently transferred or typosquat-adjacent.
- Composite actions: check if they have `post:` or `pre:` scripts with network calls.

### 8. Self-hosted runners
- `runs-on: self-hosted` on any job triggered by fork PRs or external events = HIGH risk. Flag it.

### 9. Reusable workflows (workflow_call)
- If this workflow is a caller: verify the called workflow's `permissions:` is independently scoped.
- If this workflow is a callee: verify `secrets: inherit` does not silently expose more than needed.

### 10. Artifacts and caches
- `download-artifact` followed by execution of downloaded content without integrity check = injection risk.
- Cache keys using untrusted input (PR branch name, issue title) = poisoning risk.

### 11. CODEOWNERS and branch protection
- Check `.github/CODEOWNERS` — does `/.github/` or `/.github/workflows/` have a named owner?
- If not, flag: workflow changes can be merged without security review.

## After individual file checks

Cross-reference against the repo's security infrastructure:
- The `secret-scan` job in `.github/workflows/security-scan.yml` must be a required status check — confirm in branch protection settings (cannot verify programmatically, note it as a manual check).
- Pre-commit/pre-push hooks are in `templates/` — remind the user to run `scripts/security-setup.sh` if hooks are not installed.

## Output format

1. **Summary table** — one row per file: filename | findings count by severity | overall risk rating (CRITICAL/HIGH/MEDIUM/LOW/PASS)
2. **Per-file findings** — detailed list as described above
3. **Manual checks required** — things that need human verification (branch protection settings, environment rules, secret rotation status)
4. **Recommended fixes** — concrete YAML snippets for the top issues found

Be specific. Quote the offending line. Do not pad the report with findings that do not apply.
