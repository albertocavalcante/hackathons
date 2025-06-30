# Development Setup Guide

## 🚀 Quick Start

### 1. Pre-commit Hooks Setup (MANDATORY)

**Install pre-commit hooks to prevent CI failures:**

```bash
# Install pre-commit
pip install pre-commit

# Install hooks for this repository
pre-commit install

# Run hooks on all files (initial setup)
pre-commit run --all-files
```

### 2. Required Tools

```bash
# Terraform (required for infrastructure)
brew install terraform  # macOS
# or download from https://terraform.io

# TFLint (Terraform linting)
brew install tflint  # macOS
# or curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# actionlint (GitHub Actions validation)
brew install actionlint  # macOS
# or go install github.com/rhysberg/actionlint/cmd/actionlint@latest
```

### 3. Pre-commit Hook Details

The following checks run automatically on every commit:

#### Terraform Security & Quality

- ✅ **`terraform fmt`** - Canonical formatting
- ✅ **`terraform validate`** - Syntax validation  
- ✅ **`tflint`** - Best practices and security analysis
- ✅ **`checkov`** - Infrastructure as Code security scanning

#### GitHub Actions & Bazel

- ✅ **`actionlint`** - Workflow validation (from official rhysd/actionlint repo)
- ✅ **`buildifier`** - Bazel BUILD, WORKSPACE, and .bzl file formatting
- ✅ **`buildifier-lint`** - Bazel code quality and best practices

#### Multi-Layer Secret Detection (2025 Enhanced)

- 🔒 **TruffleHog OSS** - Deep scanning with 800+ secret types & live verification
- 🔒 **Gitleaks** - Fast entropy-based detection with custom configuration
- 🔒 **detect-secrets** - Baseline-aware scanning for additional coverage

#### Code Quality & Formatting  

- ✅ **Typo detection** across all text files with `typos`
- ✅ **YAML/JSON formatting** with Prettier
- ✅ **Markdown linting** with configurable rules
- ✅ **Python Black** formatting (if Python files exist)
- ✅ **EditorConfig compliance** enforcement
- ✅ **Trailing whitespace & newline** auto-fixing
- ✅ **Commit message conventions** with Commitizen (optional)

#### Security Best Practices (2025)

- 🔐 **Commit hash pinning** - All hooks pinned to specific commits for security
- 🔐 **Trusted sources only** - Using official repositories and verified maintainers
- 🔐 **Defense in depth** - Multiple complementary security tools
- 🔐 **Configuration management** - Custom rules for project-specific patterns

## 🔧 Manual Commands

### Run Pre-commit Manually

```bash
# Run all hooks on all files
pre-commit run --all-files

# Run specific hook
pre-commit run terraform_fmt
pre-commit run terraform_validate
pre-commit run actionlint

# Run on specific files
pre-commit run --files path/to/file.tf
pre-commit run --files .github/workflows/terraform-plan.yml
```

### Terraform Commands

```bash
# Navigate to infrastructure directory
cd 2025-06-29-modular-hack-weekend/infrastructure

# Format all Terraform files
terraform fmt -recursive

# Validate configuration
terraform validate

# Run TFLint
tflint
```

### GitHub Actions Validation

```bash
# Validate all workflows
actionlint .github/workflows/*.yml

# Validate specific workflow
actionlint .github/workflows/terraform-plan.yml
```

## 🚨 Claude Code Agent Guidelines

When using Claude Code, the agent MUST:

1. **Run pre-commit before any file changes**:

  ```bash
  pre-commit run --all-files
  ```

2. **Fix all pre-commit failures before proceeding**

3. **Use specific commands for Terraform**:

  ```bash
  terraform fmt -recursive
  terraform validate
  ```

4. **Validate GitHub Actions after changes**:

  ```bash
  actionlint .github/workflows/*.yml
  ```

## 🛠️ Troubleshooting

### Pre-commit Hook Failures

**If pre-commit fails:**

1. Read the error message carefully
2. Fix the issues (often auto-fixed by hooks)
3. Add the fixed files: `git add .`
4. Commit again

**Common fixes:**

- **Terraform formatting**: Auto-fixed by `terraform_fmt` hook
- **Trailing whitespace**: Auto-fixed by `trailing-whitespace` hook
- **Missing newlines**: Auto-fixed by `end-of-file-fixer` hook

### Skip Hooks (Emergency Only)

```bash
# Skip pre-commit hooks (NOT RECOMMENDED)
git commit --no-verify -m "Emergency commit"

# Skip specific hook
SKIP=terraform_validate git commit -m "Skip validation"
```

### Update Pre-commit Hooks

```bash
# Update to latest versions
pre-commit autoupdate

# Re-install after updates
pre-commit install
```

## 📋 Environment Variables

For local development, ensure these are set:

```bash
# Terraform Cloud
export TF_CLOUD_ORGANIZATION="alberto"
export TF_WORKSPACE="modular-hackathon-jun-2025"

# Lambda Cloud (for Terraform provider)
export LAMBDALABS_API_KEY="your-lambda-cloud-api-key"
```

## ✅ Verification

To verify your setup is working:

```bash
# 1. Check pre-commit installation
pre-commit --version

# 2. Run all hooks
pre-commit run --all-files

# 3. Check required tools
terraform version
tflint --version
actionlint --version

# 4. Verify specific components
cd 2025-06-29-modular-hack-weekend/infrastructure
terraform validate
tflint
```

If all commands pass without errors, your development environment is ready! 🎉
