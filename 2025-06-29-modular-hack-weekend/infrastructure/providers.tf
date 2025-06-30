# Terraform Provider Configuration
# Lambda Cloud Infrastructure - Modular Hackathon June 2025

terraform {
  cloud {
    organization = "alberto"
    workspaces {
      name = "modular-hackathon-jun-2025"
    }
  }

  required_providers {
    lambdalabs = {
      source  = "elct9620/lambdalabs"
      version = "~> 0.8.0"
    }
  }

  required_version = ">= 1.1"
}

# Configure the Lambda Labs provider
provider "lambdalabs" {
  # API key can be set via LAMBDALABS_API_KEY environment variable
  # or passed as a variable
  api_key = var.lambda_api_key
}