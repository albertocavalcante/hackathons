# GitHub Actions Workflows Documentation

This file provides guidance for working with the GitHub Actions workflows in this monorepo.

## Available Workflows

### terraform-validation.yml
**Trigger**: Pull requests affecting Terraform files  
**Purpose**: Format checking, validation, security scanning, and linting  
**Required for**: All Terraform changes  

### terraform-apply.yml  
**Trigger**: Push to main branch affecting infrastructure  
**Purpose**: Deploy infrastructure changes to production  
**Configuration**: Uses `auto_approve: true` for post-merge deployments  

### terraform-destroy.yml
**Trigger**: Manual workflow dispatch  
**Purpose**: Emergency infrastructure cleanup  
**Usage**: Destroy all resources when needed  

## Configuration

All workflows use environment variables for Terraform Cloud integration:
- `TERRAFORM_CLOUD_TOKENS`: Authentication token for app.terraform.io
- `TF_CLOUD_ORGANIZATION`: "alberto" 
- `TF_WORKSPACE`: "modular-hackathon-jun-2025"

## Security

Workflows include comprehensive security scanning:
- TFLint for Terraform best practices
- Secret detection and validation
- Configuration security analysis
- Provider and resource validation

## Usage Notes

- Validation runs automatically on PRs
- Apply runs automatically on main branch pushes
- Always review plan output before merging
- Use destroy workflow for emergency cleanup only
