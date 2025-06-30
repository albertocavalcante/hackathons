# Terraform Provider Configuration
# Lambda Cloud Infrastructure - Modular Hackathon June 2025

terraform {
  cloud {
    # Organization and workspace configured via environment variables:
    # TF_CLOUD_ORGANIZATION = "alberto"
    # TF_WORKSPACE = "modular-hackathon-jun-2025"
    # This allows flexible workspace selection in different environments
  }

  required_providers {
    lambdalabs = {
      source  = "elct9620/lambdalabs"
      version = "~> 0.8.0"
    }
  }

  required_version = ">= 1.1"
  
  # Environment variables used:
  # TF_CLOUD_ORGANIZATION - Terraform Cloud organization name
  # TF_WORKSPACE - Terraform Cloud workspace name
  # LAMBDALABS_API_KEY - Lambda Cloud provider authentication
}

# Configure the Lambda Labs provider
provider "lambdalabs" {
  # API key can be set via LAMBDALABS_API_KEY environment variable
  # or passed as a variable
  api_key = var.lambda_api_key
}