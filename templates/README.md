# Templates directory

Optional reference files used when **manually** hardening a repository.

## Hooks

- **`pre-commit.template`** and **`pre-push.template`** — **extended** examples with extra checks, logging, and stricter UX than what [`scripts/security-setup.sh`](../scripts/security-setup.sh) installs by default.

**Important:** Running `scripts/security-setup.sh` writes **minimal** hooks directly into `.git/hooks/` (embedded in the installer). Those minimal hooks **do not** match every check in these template files copy-paste-fashion. Prefer the installer for baseline consistency; adopt the verbose templates **only when** your team consciously wants additional controls and you reconcile behavior with downstream documentation.

See also [CONTRIBUTING.md](../CONTRIBUTING.md) (maintainer section) for parity expectations.

## Other files

- **`.cursorignore.template`** — stricter Cursor ignore preset (may exclude all of `.cursor/`).
- **`pre-commit.template`** / **`pre-push.template`** cross-reference [`scripts/security-setup.sh`](../scripts/security-setup.sh) for the minimal installs.
