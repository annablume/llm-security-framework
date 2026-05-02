# Templates directory

Optional reference files used when **manually** hardening a repository.

## Hooks

- **`pre-commit.template`** and **`pre-push.template`** — **extended** examples with extra checks, logging, and stricter UX than what [`scripts/security-setup.sh`](../scripts/security-setup.sh) installs by default.

**Important:** Running `scripts/security-setup.sh` writes **minimal** hooks directly into `.git/hooks/` (embedded in the installer). Those minimal hooks **do not** match every check in these template files copy-paste-fashion. Prefer the installer for baseline consistency; adopt the verbose templates **only when** your team consciously wants additional controls and you reconcile behavior with downstream documentation.

See also [CONTRIBUTING.md](../CONTRIBUTING.md) (maintainer section) for parity expectations.

## GitHub Actions workflow templates

- **`.github/workflows/security-scan.yml`** — Advanced scanning add-on: TruffleHog (deep secret + entropy scan), Trivy (filesystem vulnerability scan with SARIF upload), and SBOM generation. Complements the base `security-scan.yml`, does not replace it.
- **`.github/workflows/dependency-check.yml`** — Deep dependency scanning: Snyk (requires `SNYK_TOKEN` secret) and OWASP Dependency-Check (NVD CVE feed, no extra secret needed).

**Before using either template:**
1. Pin every action to a SHA — they ship with `@tag` refs as placeholders. Use `ratchet pin` or resolve SHAs manually.
2. Run with `egress-policy: audit` first, then switch to `block` once you have verified the allowed-endpoints list.

## Other files

- **`.cursorignore.template`** — stricter Cursor ignore preset (may exclude all of `.cursor/`).
- **`pre-commit.template`** / **`pre-push.template`** cross-reference [`scripts/security-setup.sh`](../scripts/security-setup.sh) for the minimal installs.
