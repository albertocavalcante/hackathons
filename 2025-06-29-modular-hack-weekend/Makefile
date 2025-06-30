# Makefile for Lambda Labs GPU Infrastructure Provisioning
# Modular Hackathon - June 2025

.PHONY: help init plan apply destroy clean status ssh outputs validate format

# Default target
help: ## Show this help message
	@echo "Lambda Labs GPU Infrastructure Makefile"
	@echo "======================================="
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Environment Variables:"
	@echo "  LAMBDALABS_API_KEY - Lambda Labs API key (required)"
	@echo "  TF_VAR_lambda_api_key - Alternative to LAMBDALABS_API_KEY"
	@echo "  TF_CLOUD_TOKEN - Terraform Cloud API token (required for cloud backend)"
	@echo "  TF_CLOUD_ORGANIZATION - Automatically set to 'alberto'"
	@echo "  TF_WORKSPACE - Automatically set to 'modular-hackathon-jun-2025'"
	@echo ""
	@echo "Setup Requirements:"
	@echo "  1. Login to Terraform Cloud: terraform login"
	@echo "  2. Set environment variables for Lambda Labs API"
	@echo ""
	@echo "Example usage:"
	@echo "  make cloud-login     # Login to Terraform Cloud"
	@echo "  make cloud-status    # Check authentication status"
	@echo "  make cloud-setup     # Initial Terraform Cloud setup"
	@echo "  make init plan apply"
	@echo "  make watch-status    # Monitor provisioning progress"
	@echo "  make ssh"
	@echo "  make destroy"
	@echo ""
	@echo "Troubleshooting:"
	@echo "  make cloud-fix-auth  # Reset authentication if having issues"

# Terraform configuration
TERRAFORM := terraform
PLAN_FILE := hackathon.tfplan
TERRAFORM_DIR := infrastructure

# Environment variables for Terraform Cloud configuration
export TF_CLOUD_ORGANIZATION := alberto
export TF_WORKSPACE := modular-hackathon-jun-2025

# Ensure clean terraform environment by unsetting conflicting variables
export TF_CLI_CONFIG_FILE :=

cloud-setup: ## Setup Terraform Cloud authentication and workspace
	@echo "🌥️  Setting up Terraform Cloud..."
	@echo "Checking authentication..."
	@if [ ! -f ~/.terraform.d/credentials.tfrc.json ] && [ -z "$$TF_TOKEN_app_terraform_io" ]; then \
		echo "❌ Terraform Cloud credentials not found!"; \
		echo "Please run 'make cloud-login' first"; \
		exit 1; \
	fi
	@echo "✅ Terraform Cloud credentials found"
	@echo "Cleaning up any local state files..."
	@rm -rf $(TERRAFORM_DIR)/.terraform $(TERRAFORM_DIR)/terraform.tfstate $(TERRAFORM_DIR)/terraform.tfstate.backup $(TERRAFORM_DIR)/.terraform.lock.hcl
	@echo "Initializing workspace: modular-hackathon-jun-2025"
	cd $(TERRAFORM_DIR) && $(TERRAFORM) init
	@echo ""
	@echo "🎉 Terraform Cloud setup complete!"
	@echo "Next step: Configure environment variables in workspace"
	@echo "Run 'make cloud-workspace' for instructions"

cloud-login: ## Login to Terraform Cloud
	@echo "🔐 Logging into Terraform Cloud..."
	$(TERRAFORM) login

cloud-fix-auth: ## Fix authentication issues by resetting credentials
	@echo "🔧 Fixing Terraform Cloud authentication..."
	@echo "Removing existing credentials..."
	@rm -rf ~/.terraform.d/credentials.tfrc.json
	@echo "Please re-authenticate:"
	$(TERRAFORM) login

cloud-status: ## Check Terraform Cloud authentication status
	@echo "🔍 Checking Terraform Cloud authentication..."
	@if [ -f ~/.terraform.d/credentials.tfrc.json ]; then \
		echo "✅ Terraform Cloud credentials file found at ~/.terraform.d/credentials.tfrc.json"; \
		echo "File contents:"; \
		cat ~/.terraform.d/credentials.tfrc.json; \
		echo ""; \
		echo "File permissions: $$(ls -la ~/.terraform.d/credentials.tfrc.json)"; \
	else \
		echo "❌ Terraform Cloud credentials not found"; \
		echo "Run 'make cloud-login' to authenticate"; \
	fi

init: ## Initialize Terraform (use cloud-setup for first time)
	@echo "🔧 Initializing Terraform..."
	cd $(TERRAFORM_DIR) && $(TERRAFORM) init

validate: ## Validate Terraform configuration
	@echo "✅ Validating Terraform configuration..."
	cd $(TERRAFORM_DIR) && $(TERRAFORM) validate

format: ## Format Terraform files
	@echo "📝 Formatting Terraform files..."
	cd $(TERRAFORM_DIR) && $(TERRAFORM) fmt

plan: init validate ## Create Terraform execution plan
	@echo "📋 Creating Terraform execution plan..."
	@if [ ! -f $(TERRAFORM_DIR)/terraform.tfvars ]; then \
		echo "⚠️  Warning: terraform.tfvars not found. Using default values."; \
		echo "💡 Copy $(TERRAFORM_DIR)/terraform.tfvars.example to $(TERRAFORM_DIR)/terraform.tfvars and customize if needed."; \
	fi
	cd $(TERRAFORM_DIR) && $(TERRAFORM) plan -out=$(PLAN_FILE)
	@echo "✅ Plan saved to $(PLAN_FILE)"

apply: ## Apply Terraform plan (requires plan file)
	@if [ ! -f $(TERRAFORM_DIR)/$(PLAN_FILE) ]; then \
		echo "❌ Plan file $(TERRAFORM_DIR)/$(PLAN_FILE) not found. Run 'make plan' first."; \
		exit 1; \
	fi
	@echo "🚀 Applying Terraform plan..."
	@echo "⏱️  Note: GPU instance provisioning can take 3-5 minutes (booting process)"
	cd $(TERRAFORM_DIR) && $(TERRAFORM) apply $(PLAN_FILE)
	@echo "✅ Infrastructure provisioned successfully!"
	@echo ""
	@echo "🔑 To connect to your GPU instance:"
	@echo "   make ssh"
	@echo ""
	@echo "📊 To see outputs:"
	@echo "   make outputs"
	@echo ""
	@echo "📋 To monitor instance status:"
	@echo "   make status"

destroy: ## Destroy Terraform-managed infrastructure
	@echo "⚠️  WARNING: This will destroy all provisioned infrastructure!"
	@echo "Press Ctrl+C to cancel, or Enter to continue..."
	@read dummy
	@echo "🔥 Destroying infrastructure..."
	cd $(TERRAFORM_DIR) && $(TERRAFORM) destroy
	@$(MAKE) clean

status: ## Show Terraform state and instance status
	@echo "📊 Terraform state:"
	cd $(TERRAFORM_DIR) && $(TERRAFORM) show
	@echo ""
	@echo "🔍 Instance status check:"
	@if cd $(TERRAFORM_DIR) && $(TERRAFORM) output instance_id >/dev/null 2>&1; then \
		echo "Instance ID: $$(cd $(TERRAFORM_DIR) && $(TERRAFORM) output -raw instance_id)"; \
		echo "Instance IP: $$(cd $(TERRAFORM_DIR) && $(TERRAFORM) output -raw instance_ip 2>/dev/null || echo 'Not yet available')"; \
		echo "Instance Type: $$(cd $(TERRAFORM_DIR) && $(TERRAFORM) output -raw instance_type)"; \
		echo "Status: Instance is provisioned ✅"; \
	else \
		echo "Status: Instance not yet fully provisioned ⏳"; \
	fi

watch-status: ## Watch instance status (updates every 10 seconds)
	@echo "👀 Watching instance status (Ctrl+C to stop)..."
	@while true; do \
		clear; \
		echo "🕐 $$(date)"; \
		echo ""; \
		$(MAKE) --no-print-directory status || true; \
		echo ""; \
		echo "⏱️  Refreshing in 10 seconds..."; \
		sleep 10; \
	done

outputs: ## Show Terraform outputs
	@echo "📋 Infrastructure outputs:"
	cd $(TERRAFORM_DIR) && $(TERRAFORM) output

ssh: ## SSH into the GPU instance
	@echo "🔌 Connecting to GPU instance..."
	@INSTANCE_IP=$$(cd $(TERRAFORM_DIR) && $(TERRAFORM) output -raw instance_ip 2>/dev/null); \
	if [ -z "$$INSTANCE_IP" ]; then \
		echo "❌ No instance IP found. Make sure infrastructure is deployed."; \
		exit 1; \
	fi; \
	echo "🌐 Connecting to $$INSTANCE_IP..."; \
	ssh -i ~/.sshkeys/hackathons/modular-jun-2025/lambda_gpu_key ubuntu@$$INSTANCE_IP

setup-commands: ## Show setup commands for the GPU instance
	@echo "🛠️  Setup commands for GPU instance:"
	@cd $(TERRAFORM_DIR) && $(TERRAFORM) output -raw setup_commands

clean: ## Clean up temporary files
	@echo "🧹 Cleaning up temporary files..."
	@rm -f $(TERRAFORM_DIR)/$(PLAN_FILE)
	@rm -f $(TERRAFORM_DIR)/terraform.tfstate.backup
	@rm -rf $(TERRAFORM_DIR)/.terraform.lock.hcl
	@echo "✅ Cleanup complete (Note: State is managed in Terraform Cloud)"

# Advanced targets
refresh: ## Refresh Terraform state
	@echo "🔄 Refreshing Terraform state..."
	cd $(TERRAFORM_DIR) && $(TERRAFORM) refresh

graph: ## Generate Terraform dependency graph
	@echo "📈 Generating dependency graph..."
	cd $(TERRAFORM_DIR) && $(TERRAFORM) graph | dot -Tpng > terraform-graph.png
	@echo "✅ Graph saved to $(TERRAFORM_DIR)/terraform-graph.png"

cost-estimate: ## Show estimated costs
	@echo "💰 Estimated Infrastructure Costs:"
	@echo "   RTX 6000 (gpu_1x_rtx6000): $0.50/hour"
	@echo "   A10 (gpu_1x_a10): $0.75/hour"
	@echo "   V100 (gpu_1x_v100): $0.55/hour"
	@echo "   A100 (gpu_1x_a100): $1.10/hour"
	@echo ""
	@echo "⚠️  Remember to destroy resources when not in use!"

# Development targets
dev-setup: init plan ## Quick development setup
	@echo "🚀 Development environment setup complete"
	@echo "Run 'make apply' to provision infrastructure"

full-cycle: init plan apply outputs ## Full provisioning cycle
	@echo "🎉 Full infrastructure provisioning complete!"

# Safety checks
check-env: ## Check required environment variables
	@echo "🔍 Checking environment variables..."
	@if [ -z "$$LAMBDALABS_API_KEY" ] && [ -z "$$TF_VAR_lambda_api_key" ]; then \
		echo "❌ Lambda Labs API key not found!"; \
		echo "Set LAMBDALABS_API_KEY or TF_VAR_lambda_api_key environment variable"; \
		exit 1; \
	fi
	@echo "✅ Environment variables OK"

cloud-workspace: ## Show Terraform Cloud workspace information
	@echo "🌥️  Terraform Cloud Workspace Information:"
	@echo "Organization: alberto"
	@echo "Workspace: modular-hackathon-jun-2025"
	@echo "URL: https://app.terraform.io/app/alberto/workspaces/modular-hackathon-jun-2025"
	@echo ""
	@echo "📋 Required Environment Variables in Terraform Cloud:"
	@echo "  LAMBDALABS_API_KEY = $$LAMBDALABS_API_KEY"
	@echo ""
	@echo "🔧 To set environment variables:"
	@echo "  1. Go to: https://app.terraform.io/app/alberto/workspaces/modular-hackathon-jun-2025/variables"
	@echo "  2. Add Environment Variable: LAMBDALABS_API_KEY"
	@echo "  3. Set value to: $$LAMBDALABS_API_KEY"
	@echo "  4. Mark as 'Sensitive' to hide the value"
	@echo ""
	@echo "Benefits of using Terraform Cloud:"
	@echo "  ✅ Remote state management (no local .tfstate files)"
	@echo "  ✅ State locking to prevent conflicts"
	@echo "  ✅ Execution history and logs"
	@echo "  ✅ Team collaboration features"
	@echo "  ✅ No timeout issues on long-running operations"

# Emergency stop
emergency-stop: ## Emergency stop - destroy everything immediately
	@echo "🚨 EMERGENCY STOP - Destroying all resources immediately!"
	$(TERRAFORM) destroy -auto-approve
	@$(MAKE) clean