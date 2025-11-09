# TFLint Configuration for Hackathons Monorepo
# Comprehensive linting rules for all Terraform code

config {
  # Enable all rules by default
  disabled_by_default = false

  # Force source formatting
  format = "compact"

  # Enable colored output
  force = false
}

# Core TFLint rules
rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}

# AWS provider rules (if we add AWS resources later)
plugin "aws" {
  enabled = false
  version = "0.44.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Google Cloud provider rules (if we add GCP resources later)
plugin "google" {
  enabled = false
  version = "0.34.0"
  source  = "github.com/terraform-linters/tflint-ruleset-google"
}

# Azure provider rules (if we add Azure resources later)
plugin "azurerm" {
  enabled = false
  version = "0.30.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# Custom rules for hackathon projects
rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

# Security-focused rules
rule "terraform_module_version" {
  enabled = true
}

# Performance and best practices
rule "terraform_unused_required_providers" {
  enabled = true
}
