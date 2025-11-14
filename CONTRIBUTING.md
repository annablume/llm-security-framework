# Contributing to LLM Security Framework

First off, thank you for considering contributing to the LLM Security Framework! 🎉

This project aims to help developers secure their AI-assisted development workflows. Your contributions make this possible.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Style Guidelines](#style-guidelines)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

---

## 📜 Code of Conduct

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of:
- Age, body size, disability, ethnicity
- Gender identity and expression
- Level of experience
- Nationality, personal appearance, race
- Religion, sexual identity and orientation

### Our Standards

**Positive behavior includes:**
- ✅ Using welcoming and inclusive language
- ✅ Being respectful of differing viewpoints
- ✅ Gracefully accepting constructive criticism
- ✅ Focusing on what's best for the community
- ✅ Showing empathy towards others

**Unacceptable behavior includes:**
- ❌ Trolling, insulting/derogatory comments, personal attacks
- ❌ Public or private harassment
- ❌ Publishing others' private information
- ❌ Other unprofessional conduct

### Enforcement

Instances of abusive behavior may be reported to security@yourcompany.com. All complaints will be reviewed and investigated promptly and fairly.

---

## 🤝 How Can I Contribute?

There are many ways to contribute to this project:

### 1. 🐛 **Report Bugs**

Found a bug? Please create an issue with:
- Clear, descriptive title
- Steps to reproduce
- Expected vs actual behavior
- Environment details (OS, tools, versions)
- Screenshots if applicable

**Template:**
```markdown
**Bug Description**: [Brief description]

**Steps to Reproduce**:
1. 
2. 
3. 

**Expected Behavior**: 
**Actual Behavior**: 
**Environment**: 
- OS: 
- Tool versions: 

**Screenshots**: [If applicable]
```

### 2. 💡 **Suggest Features**

Have an idea? We'd love to hear it! Create an issue with:
- Clear problem statement
- Proposed solution
- Alternative solutions considered
- Impact on existing functionality

**Template:**
```markdown
**Problem**: [What problem does this solve?]

**Proposed Solution**: [Your idea]

**Alternatives Considered**: [Other approaches]

**Additional Context**: [Any other details]
```

### 3. 📝 **Improve Documentation**

Documentation is crucial! You can help by:
- Fixing typos or grammar
- Adding examples
- Clarifying confusing sections
- Translating to other languages
- Adding diagrams or screenshots

### 4. 🔒 **Report Security Vulnerabilities**

**DO NOT create public issues for security vulnerabilities.**

See [SECURITY.md](SECURITY.md) for reporting procedures.

### 5. 💻 **Contribute Code**

Ready to code? Great! See the [Development Workflow](#development-workflow) section below.

### 6. 🎨 **Design Contributions**

Help improve visual elements:
- Logo design
- Architecture diagrams
- Infographics
- UI/UX improvements

### 7. 🧪 **Testing**

Help test:
- New features
- Different environments
- Edge cases
- Performance benchmarks

### 8. 💬 **Help Others**

Join discussions:
- Answer questions in Issues
- Participate in Discussions
- Help review PRs
- Share your experience

---

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:

```bash
# Required
- Git
- Text editor (VS Code, Cursor recommended)
- GitHub account

# For testing scripts
- Bash shell (Linux/macOS) or WSL (Windows)
- Node.js 18+ (if testing npm-related features)
- Python 3.8+ (if testing Python-related features)

# Recommended
- Gitleaks (for secret scanning)
- Docker (for testing containerized workflows)
```

### Fork & Clone

1. **Fork the repository** on GitHub
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/llm-security-framework.git
   cd llm-security-framework
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/original-owner/llm-security-framework.git
   ```

4. **Verify remotes**:
   ```bash
   git remote -v
   # origin    https://github.com/YOUR-USERNAME/llm-security-framework.git (fetch)
   # origin    https://github.com/YOUR-USERNAME/llm-security-framework.git (push)
   # upstream  https://github.com/original-owner/llm-security-framework.git (fetch)
   # upstream  https://github.com/original-owner/llm-security-framework.git (push)
   ```

### Setup Development Environment

```bash
# Create a branch for your work
git checkout -b feature/your-feature-name

# If testing scripts, make them executable
chmod +x scripts/*.sh

# Install pre-commit hooks (optional but recommended)
cp templates/pre-commit.template .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Test that everything works
./scripts/security-setup.sh --dry-run  # If available
```

---

## 🔄 Development Workflow

### 1. **Keep Your Fork Updated**

```bash
# Fetch upstream changes
git fetch upstream

# Merge upstream changes into your main branch
git checkout main
git merge upstream/main

# Push updates to your fork
git push origin main
```

### 2. **Create a Feature Branch**

```bash
# Branch naming conventions:
# feature/     - New features
# fix/         - Bug fixes
# docs/        - Documentation changes
# refactor/    - Code refactoring
# test/        - Test additions/changes
# chore/       - Maintenance tasks

git checkout -b feature/add-azure-support
```

### 3. **Make Your Changes**

Follow these guidelines:

**For Documentation**:
- Use clear, concise language
- Add examples where helpful
- Update table of contents if needed
- Check spelling and grammar
- Test all code examples

**For Scripts**:
- Add comments for complex logic
- Include error handling
- Test on multiple platforms if possible
- Update documentation

**For Templates**:
- Provide clear examples
- Add comments explaining customization
- Ensure they work out of the box

**For Configurations**:
- Use secure defaults
- Comment all options
- Include links to official documentation

### 4. **Test Your Changes**

```bash
# For shell scripts
shellcheck script.sh  # Static analysis

# For markdown
markdownlint *.md  # Linting

# For YAML
yamllint file.yml  # Syntax check

# Manual testing
# - Test scripts run without errors
# - Verify examples work as documented
# - Check links aren't broken
```

### 5. **Commit Your Changes**

See [Commit Guidelines](#commit-guidelines) below.

### 6. **Push to Your Fork**

```bash
git push origin feature/add-azure-support
```

### 7. **Open a Pull Request**

Go to your fork on GitHub and click "New Pull Request".

---

## 📏 Style Guidelines

### Markdown

```markdown
# Use ATX-style headers (# ## ###)

# Use descriptive link text
✅ See our [security guidelines](docs/LLM-Security-Guidelines.md)
❌ Click [here](docs/LLM-Security-Guidelines.md)

# Use fenced code blocks with language
✅ ```bash
   command here
   ```
❌ ```
   command here
   ```

# Use lists consistently
- Unordered lists with hyphens
1. Numbered lists with numbers

# Add blank lines between sections
```

### Shell Scripts

```bash
#!/bin/bash
# Description of what this script does
# Version: X.X
# Author: (optional)

set -e  # Exit on error
set -u  # Exit on undefined variable

# Constants in UPPER_CASE
CONST_VAR="value"

# Functions with descriptive names
function do_something() {
    local var="value"  # Local variables
    # Function logic
}

# Main script logic
main() {
    # Clear flow
    do_something
}

# Run main
main "$@"
```

### YAML

```yaml
# Use 2-space indentation
name: Workflow Name

# Add comments for complex sections
on:
  push:  # Trigger on push
    branches: [ main ]

# Group related items
jobs:
  job1:
    runs-on: ubuntu-latest
    steps:
      - name: Descriptive step name
        run: command
```

### Configuration Files

```toml
# Add section headers with clear descriptions
[section]
  # Explain what each option does
  option = "value"  # Inline comment for specific values
  
  # Use examples
  # Example: option = "production"
```

---

## 💬 Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, no logic change)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks
- **security**: Security improvements

### Examples

```bash
# Feature
feat(scripts): add Azure DevOps integration

# Bug fix
fix(setup): resolve permission issue on macOS

# Documentation
docs(readme): add installation troubleshooting section

# Security
security(hooks): strengthen secret detection patterns

# Multiple changes
feat(config): add Netlify edge functions support

- Add configuration examples
- Update documentation
- Add tests

Closes #123
```

### Best Practices

```bash
✅ GOOD
feat(auth): implement OAuth2 flow
fix(scan): handle unicode in secret detection
docs(guide): add Cursor setup instructions

❌ BAD
fixed stuff
update
WIP
asdf
```

---

## 🔍 Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Self-review completed
- [ ] Tests pass (if applicable)
- [ ] No security vulnerabilities introduced
- [ ] Commits follow commit guidelines
- [ ] Branch is up to date with main

### PR Title

Use the same format as commit messages:
```
feat(scripts): add GCP security scanning support
```

### PR Description

Use the [PR template](.github/PULL_REQUEST_TEMPLATE.md):

1. **Description**: What does this PR do?
2. **Type of Change**: Feature, fix, docs, etc.
3. **Related Issues**: Link to issues
4. **Changes Made**: Detailed list
5. **Testing**: How you tested
6. **Security Checklist**: Complete all items
7. **Screenshots**: If applicable

### Review Process

1. **Automated Checks**: CI/CD runs automatically
   - Secret scanning
   - Linting
   - Link checking
   - (Add more as project grows)

2. **Maintainer Review**: A maintainer will review your PR
   - Provide feedback
   - Request changes if needed
   - Approve when ready

3. **Address Feedback**: Make requested changes
   ```bash
   # Make changes
   git add .
   git commit -m "fix: address review comments"
   git push origin feature/your-feature
   ```

4. **Merge**: Once approved, a maintainer will merge

### After Merge

```bash
# Switch to main branch
git checkout main

# Pull latest changes
git pull upstream main

# Delete your feature branch (optional)
git branch -d feature/your-feature
git push origin --delete feature/your-feature
```

---

## 🏷️ Issue Labels

We use labels to organize issues:

| Label | Description |
|-------|-------------|
| `bug` | Something isn't working |
| `documentation` | Improvements or additions to docs |
| `enhancement` | New feature or request |
| `good first issue` | Good for newcomers |
| `help wanted` | Extra attention needed |
| `question` | Further information requested |
| `security` | Security-related issues |
| `wontfix` | This will not be worked on |
| `duplicate` | This issue already exists |
| `priority: high` | High priority |
| `priority: low` | Low priority |

---

## 🎓 Learning Resources

New to contributing? Check these out:

### Git & GitHub
- [GitHub's Git Handbook](https://guides.github.com/introduction/git-handbook/)
- [First Contributions Guide](https://github.com/firstcontributions/first-contributions)
- [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)

### Markdown
- [Markdown Guide](https://www.markdownguide.org/)
- [GitHub Flavored Markdown](https://github.github.com/gfm/)

### Security
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Security Best Practices](https://docs.github.com/en/code-security)

---

## 💡 Tips for Success

### For New Contributors

1. **Start Small**: Begin with documentation or simple fixes
2. **Ask Questions**: Use Discussions for questions
3. **Read Existing Code**: Learn the project structure
4. **Be Patient**: Reviews take time
5. **Have Fun**: Enjoy the learning process!

### For All Contributors

1. **Communicate**: Comment on issues before starting work
2. **Stay Focused**: One feature/fix per PR
3. **Write Tests**: If applicable
4. **Document Changes**: Update docs with code
5. **Be Respectful**: Everyone's learning

---

## 🌍 Community

### Where to Get Help

- **GitHub Discussions**: Ask questions, share ideas
- **Issues**: Report bugs, request features
- **Email**: security@yourcompany.com (for security issues)
- **Social Media**: 
  - Twitter: [@yourusername](https://twitter.com/yourusername)
  - LinkedIn: [Your Profile](https://linkedin.com/in/yourprofile)

### Recognition

Contributors are recognized in:
- GitHub Contributors page
- Release notes
- Project README (for significant contributions)
- Security Hall of Fame (for security improvements)

---

## 📅 Release Process

(For maintainers)

### Versioning

We use [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes (backwards compatible)

### Release Checklist

- [ ] Update CHANGELOG.md
- [ ] Update version numbers
- [ ] Tag release: `git tag v2.1.0`
- [ ] Push tag: `git push origin v2.1.0`
- [ ] Create GitHub release with notes
- [ ] Announce on social media

---

## ❓ FAQ

### How do I claim an issue?

Comment on the issue saying you'd like to work on it. A maintainer will assign it to you.

### How long should I wait for a review?

Typically 2-7 days. If no response after a week, politely ping by commenting on the PR.

### Can I work on multiple issues?

Yes, but we recommend focusing on one at a time, especially when starting out.

### What if I can't finish an issue?

That's okay! Let us know in the issue comments so someone else can help or take over.

### Can I contribute if I'm a beginner?

Absolutely! Look for issues labeled `good first issue`.

### Do I need to sign a CLA?

No, we don't require a Contributor License Agreement.

---

## 📞 Contact

**Project Maintainer**: Anna
- Email: security.aloha@proton.me
- GitHub: https://github.com/annablume


**Security Team**: security.aloha@proton.me

---

## 🙏 Thank You!

Every contribution, no matter how small, makes a difference. Thank you for helping make AI-assisted development more secure for everyone!

**Happy Contributing! 🚀**

---

*This contributing guide is inspired by and borrows from:*
- *[Open Source Guides](https://opensource.guide/)*
- *[Contributor Covenant](https://www.contributor-covenant.org/)*
- *[GitHub's Contributing Template](https://github.com/github/.github/blob/main/CONTRIBUTING.md)*

---

**Last Updated**: November 2025  
**Version**: 2.0
