# GitHub Actions CI/CD for Terraform

This directory contains GitHub Actions workflows for automated Terraform infrastructure management with Terraform Cloud integration.

**🏠 [← Hackathons Repository](../README.md)** • **[🤖 Claude Guidance](../CLAUDE.md)** • **[🚀 Modular Hackathon](../2025-06-29-modular-hack-weekend/README.md)**

## 🏗️ Workflow Overview

### 1. `terraform-validation.yml`
- **Trigger**: PRs/pushes affecting any Terraform files
- **Purpose**: Comprehensive validation across entire repository
- **Checks**: Format, lint, security, naming conventions
- **Scope**: **ALL** Terraform files in the repository

### 2. `terraform-plan.yml`
- **Trigger**: Pull requests affecting infrastructure files
- **Purpose**: Generate and review Terraform plans
- **Output**: Plan details commented on PR
- **Validation**: Format, TFLint, validation before planning

### 3. `terraform-apply.yml`  
- **Trigger**: Push to main branch (after PR merge)
- **Purpose**: Apply approved infrastructure changes
- **Protection**: Requires `production` environment approval
- **Validation**: Format, TFLint, validation before applying

### 4. `terraform-destroy.yml`
- **Trigger**: Manual workflow dispatch
- **Purpose**: Destroy all infrastructure resources
- **Safety**: Requires typing "DESTROY" to confirm
- **Validation**: Format, TFLint, validation before destroying

## ⚙️ Setup Requirements

### 1. GitHub Secrets
Configure these secrets in your repository settings:

```bash
# Repository Settings > Secrets and variables > Actions
TF_API_TOKEN=your-terraform-cloud-token
LAMBDALABS_API_KEY=your-lambda-cloud-api-key
```

### 2. GitHub Environment
Create a `production` environment with protection rules:

1. Go to **Settings** > **Environments** > **New environment**
2. Name: `production`  
3. **Protection rules**:
   - ✅ Required reviewers (add yourself/team)
   - ✅ Wait timer: 0 minutes
   - ⚠️ **Deployment branches**: Only `main` branch

### 3. Branch Protection Rules
Protect the `main` branch:

1. Go to **Settings** > **Branches** > **Add rule**
2. Branch name pattern: `main`
3. **Protection settings**:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require linear history
   - ✅ Include administrators

## 🔄 Workflow Process

### Standard Development Flow

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/add-gpu-instance
   # Make infrastructure changes
   git push origin feature/add-gpu-instance
   ```

2. **Open Pull Request**
   - GitHub Actions automatically runs `terraform plan`
   - Plan output commented on PR
   - Review plan for costs and changes

3. **Review and Approve**
   - Team reviews infrastructure changes
   - Approve PR when plan looks correct
   - Merge to `main` branch

4. **Automatic Deployment**
   - Merge triggers `terraform apply` workflow
   - Manual approval required in `production` environment
   - Infrastructure deployed after approval

### Emergency Cleanup

```bash
# Via GitHub UI:
# Actions > Terraform Destroy > Run workflow
# Input: "DESTROY"
```

## 💰 Cost Management Features

- **Plan Comments**: Include cost estimates
- **Automatic Destruction**: Manual workflow for cleanup
- **Resource Tracking**: Output important resource details
- **Usage Reminders**: Comments include cost reminders

## 🔒 Security Features

- **Environment Protection**: Manual approval for production
- **Secret Management**: Terraform Cloud token and API keys secured
- **Branch Protection**: Prevents direct pushes to main
- **Plan Review**: All changes reviewed before application
- **TFLint Security Rules**: Automated security scanning
- **Sensitive Data Detection**: Scans for hardcoded secrets
- **Repository-wide Validation**: All Terraform files checked

## 📊 Monitoring

### View Workflow Status
- **Actions Tab**: See all workflow runs
- **Pull Requests**: Plan output in comments
- **Environments**: Track production deployments

### Terraform Cloud Integration
- **Remote State**: All state managed in Terraform Cloud
- **Execution History**: View runs in Terraform Cloud console
- **Team Collaboration**: Shared workspace access

## 🚨 Troubleshooting

### Common Issues

1. **Terraform Cloud Authentication**
   ```bash
   # Check TF_API_TOKEN secret is set correctly
   # Verify Terraform Cloud organization/workspace names
   ```

2. **Lambda Cloud API Issues**
   ```bash
   # Verify LAMBDALABS_API_KEY secret
   # Check Lambda Cloud account status
   ```

3. **GitHub Environment Issues**
   ```bash
   # Ensure 'production' environment exists
   # Verify environment protection rules
   # Check reviewer assignments
   ```

### Emergency Procedures

1. **Failed Apply**: Check Terraform Cloud console for detailed logs
2. **Stuck Resources**: Use manual `terraform destroy` workflow
3. **Cost Overrun**: Immediately run destroy workflow
4. **Authentication Issues**: Rotate secrets and update GitHub

## 🎯 Best Practices

- **Always Review Plans**: Never merge without reviewing Terraform plan
- **Cost Awareness**: Monitor GPU instance costs ($0.50-1.10/hour)
- **Resource Cleanup**: Destroy resources when not in use
- **Branch Hygiene**: Use descriptive branch names and PR titles
- **Documentation**: Update this README for workflow changes
- **Format Before Commit**: Run `terraform fmt -recursive .` before committing
- **Lint Locally**: Run `tflint` in your directories before pushing
- **No Hardcoded Secrets**: Use variables and environment variables

## 🛠️ Local Development Scripts

Convenience scripts for local development:

```bash
# Format all Terraform files
./.github/scripts/terraform-format-all.sh

# Validate all Terraform configurations
./.github/scripts/terraform-validate-all.sh
```

## 📚 Additional Resources

- [Terraform Cloud Documentation](https://developer.hashicorp.com/terraform/cloud-docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Lambda Cloud Documentation](https://lambdalabs.com/service/gpu-cloud)
- [Terraform GitHub Actions](https://github.com/hashicorp/setup-terraform)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)
- [TFLint Rules](https://github.com/terraform-linters/tflint/tree/master/docs/rules)