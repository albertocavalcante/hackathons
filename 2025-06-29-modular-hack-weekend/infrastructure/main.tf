# Lambda Cloud GPU Infrastructure
# Modular Hackathon - June 2025
#
# This is the main entry point for the Terraform configuration.
# All specific configurations are organized in separate files:
#
# - providers.tf: Terraform and provider configuration
# - variables.tf: Input variables and validation
# - data.tf: Data sources for external information
# - locals.tf: Local values and computed expressions
# - resources.tf: Infrastructure resources (instances, SSH keys)
# - outputs.tf: Output values for use after deployment
#
# Infrastructure Overview:
# - Lambda Cloud GPU instances for ML/AI workloads
# - Strategic SSH key management with reuse optimization
# - Terraform Cloud backend for remote state management
# - Support for multiple instance types and regions
#
# Usage:
#   make cloud-setup  # Initial setup with Terraform Cloud
#   make plan         # Create execution plan
#   make apply        # Deploy infrastructure
#   make ssh          # Connect to GPU instance
#   make destroy      # Clean up resources
#
# Cost Management:
#   - A10 GPU: $0.75/hour (default)
#   - RTX 6000: $0.50/hour
#   - A100: $1.10/hour
#   - Remember to destroy when not in use!
#
# For detailed configuration, see individual .tf files.