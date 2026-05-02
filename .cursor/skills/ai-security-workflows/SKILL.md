---
name: ai-security-workflows
description: >-
  Applies threat-aware review and hardening for CI/CD and automation workflows
  touched by humans or AI (GitHub Actions, bots, codegen PRs). Use when editing
  `.github/workflows`, `.github/actions`, reusable workflows, OIDC/deploy
  pipelines, MCP or agent-driven automation, secret scanning jobs, or when the
  user asks for workflow security or safe CI design for AI-assisted repos.
---

# AI security for workflows

## Principle

Treat workflow YAML and CI glue code like **privileged production code**: small mistakes become secret theft, repo takeover, or lateral movement. If an AI authored or edited the workflow, assume **mistakes and injection pressure** until proven otherwise.

## Before changing anything

- [ ] Confirm **who can merge** changes under `.github/`—branch protection **and** a `CODEOWNERS` entry like `/.github/ @security-team` so reviews cannot be bypassed by non-owners.
- [ ] Prefer **minimal `permissions`** per job (`contents: read` baseline; escalate only where required). Set permissions **at the job level**, not just the workflow level, so each job is independently least-privilege.
- [ ] Prefer **pinned action versions** (immutable commit SHA)—not `@main`, `@latest`, or floating major tags for security-sensitive steps. Pair SHA pins with Dependabot `ecosystem: github-actions` updates so pins don't rot.
- [ ] For `actions/checkout`, set `persist-credentials: false` on any checkout step that is followed by untrusted code execution—otherwise the implicit `GITHUB_TOKEN` credential in the `.git/config` can be read by a malicious script.

## Secrets and credentials

- [ ] No secrets in YAML, scripts committed to the repo, or echoed to logs—use **GitHub Secrets** / provider vaults / **OIDC** to cloud roles instead of long-lived PATs embed in CI.
- [ ] Narrow **environment secrets** with **deployment protection** where environments exist.
- [ ] After edits, mentally trace every `env:` and `${{ secrets.* }}` outlet (including subprocesses and upload steps).

## Untrusted input (critical for AI-heavy repos)

Fork PRs, issue bodies, discussion comments, and **PR descriptions** can feed tools or prompts.

- [ ] **`pull_request_target` and “run untrusted code” patterns**: treat as **high risk**; justify every use; never check out the fork's code with write tokens or in the same job that has secrets access.
- [ ] **`workflow_run` trigger**: equally dangerous—it fires in the context of the **target (base) branch**, not the fork, which means it inherits org secrets even when triggered by an untrusted fork PR. Never use it to check out or execute code from the triggering workflow's branch without explicit SHA verification.
- [ ] Do **not** pass raw PR/issue/markdown into steps that **network**, **install packages**, or **mutate the repo** without strict allowlists and static targets.
- [ ] For `workflow_dispatch` inputs, validate format and **reject** command-like values where they influence shell or file paths.
- [ ] **Artifacts and caches** are a lateral-movement surface: a compromised job can write a poisoned artifact that a later job executes, or cache-poison a shared key. Scope artifact retention, restrict `download-artifact` to named jobs only, and never execute downloaded artifacts without integrity checks.

## Third-party actions and supply chain

- [ ] Verify publisher and repo for each `uses:`; beware typosquats and recently-transferred repos.
- [ ] Review **post/pre** script behavior and **composite** action steps for exfil patterns (unexpected `curl`, base64 payloads, or env-dumping).
- [ ] **Dependabot PRs** get a restricted `secrets.GITHUB_TOKEN` scoped to the repo, but auto-merge rules on Dependabot PRs still run full CI—ensure no step escalates privileges based on actor == 'dependabot[bot]' checks that can be spoofed.
- [ ] **Self-hosted runners** are a high-value target: code executing on them persists across jobs and can access runner host credentials. Never run untrusted fork PRs on self-hosted runners without full ephemeral/disposable runner isolation.

## AI-generated workflow PRs

- [ ] Review diffs with **full-file context**, not only hunks (indentation and `if:` boundaries change semantics).
- [ ] Re-scan for **new network calls**, **new secret references**, **new `write` permissions**, and **new triggers** (`schedule`, `workflow_run`, `pull_request_target`).
- [ ] Run or simulate **secret scanning** (e.g. gitleaks) on the branch when workflows change.

## Reusable workflows (`workflow_call`)

- [ ] Treat a called workflow like an imported library—review it to the same standard as inline steps.
- [ ] Permissions are **not automatically inherited**: the caller's `permissions:` block does not propagate unless the called workflow declares its own. Verify each side independently.
- [ ] Secrets must be **explicitly passed** via `secrets: inherit` or named secrets; audit what the callee actually uses vs. what `inherit` silently exposes.
- [ ] Prefer calling workflows pinned to a specific SHA rather than a mutable ref so that a compromised upstream cannot hijack your pipeline.

## MCP, agents, and external runners

- [ ] If an agent or MCP server can open PRs or edit workflows: **scope tokens** to a single repo, least privilege, short-lived, and monitor audit logs.
- [ ] Do not give **org admin** or **deploy keys** to assistant integrations.
- [ ] For AI agents with CI write access (e.g., auto-fix bots): require a human-approved environment gate before any step that writes to protected branches or deploys.

## Environment protection rules

GitHub deployment environments provide an additional security boundary orthogonal to branch protection.

- [ ] Configure **required reviewers** on production environments so no automated job deploys without human sign-off.
- [ ] Use **wait timers** on sensitive environments to allow time for anomaly detection before deploy proceeds.
- [ ] Restrict environments to **specific branch patterns** (`main` only for production) so feature branches cannot trigger production deploys even if branch protection is misconfigured.
- [ ] Apply **environment secrets** (not repo-level secrets) for production credentials so non-production jobs cannot read them.

## If you suspect workflow compromise

- [ ] Immediately **rotate any secrets** referenced in the affected workflow—assume they are burned.
- [ ] Check the **audit log** (GitHub org audit log or repo audit log) for unexpected token usage, workflow triggers, and permission changes in the past 24–48 hours.
- [ ] Inspect **artifact and cache content** from recent runs for exfiltrated data or injected payloads.
- [ ] **Disable the workflow** (rename or remove) before investigating further—do not just revert; a compromised action may have already run.
- [ ] Follow `docs/incident-response-template.md` in this repo for structured documentation of timeline, impact, and remediation steps.

## Definition of done

- [ ] Jobs have **explicit `permissions`** where feasible.
- [ ] No **broad write** access without a named, reviewed reason.
- [ ] All third-party `uses:` are **pinned to an immutable SHA**.
- [ ] Any `actions/checkout` followed by untrusted code sets **`persist-credentials: false`**.
- [ ] Secrets and cloud access use **vault/OIDC** patterns appropriate to the platform.
- [ ] Untrusted code paths cannot **read org secrets** or **write** to protected refs.
- [ ] **Secret scanning** (e.g., Gitleaks) passed on the branch—see the `secret-scan` job in `.github/workflows/security-scan.yml`.
- [ ] Change is **documented** in PR/commit in neutral, reviewable terms (no vendor-branded fluff).

## Repo-specific tooling

This repository ships the following security infrastructure—use it, don't duplicate it:

| Tool | Location | What it does |
|------|----------|--------------|
| **Secret scan (CI)** | `.github/workflows/security-scan.yml` → `secret-scan` job | Gitleaks full-history scan on every push/PR to main/develop |
| **Dependency scan (CI)** | `.github/workflows/security-scan.yml` → `dependency-scan` job | `npm audit` at moderate severity threshold |
| **Pre-commit hook** | `templates/pre-commit.template` | 7 local checks: secret patterns, .env files, large files, debug code—install via `scripts/security-setup.sh` |
| **Pre-push hook** | `templates/pre-push.template` | Full Gitleaks scan before push |
| **AI context protection** | `.cursorignore` / `templates/.cursorignore.template` | Prevents secrets, build artifacts, and logs from loading into Cursor/Claude context windows |
| **CODEOWNERS** | `.github/CODEOWNERS` | Enforces review on all security-sensitive paths |
| **Incident response** | `docs/incident-response-template.md` | Structured timeline and RCA template for security events |

Also align significant workflow changes with `docs/LLM-Security-Guidelines.md` (sections 1–3 cover Cursor/Claude Code/GitHub Actions threat models) and `docs/GitHub-Security-Configuration.md` (branch protection, OIDC, Dependabot setup).
