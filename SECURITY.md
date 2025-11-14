# Security Policy

## Reporting Security Issues

If you discover a security vulnerability, please email: security@yourcompany.com

**Do not** create public GitHub issues for security vulnerabilities.

## Security Measures

This project implements the following security controls:

- ✅ Pre-commit secret scanning with Gitleaks
- ✅ Dependency vulnerability scanning
- ✅ Environment variable protection
- ✅ Row-level security on database
- ✅ API key rotation policy
- ✅ Audit logging

## Developer Guidelines

All developers must:

1. Run daily security checks: `./scripts/security/daily-check.sh`
2. Never commit secrets or credentials
3. Review all AI-generated code before merging
4. Verify dependencies before installing
5. Follow the principle of least privilege

For detailed guidelines, see: `LLM-Security-Guidelines.md`

## Incident Response

If you suspect a security incident:

1. **Immediate**: Stop all potentially affected systems
2. **Notify**: security@yourcompany.com or #security-alerts on Slack
3. **Document**: Use incident response scripts in `scripts/security/`
4. **Follow**: Escalation procedures in security guidelines

## Security Updates

- Security guidelines are reviewed monthly
- All developers receive security training quarterly
- Incident retrospectives are conducted after any security event
