# Makefile for Hackathons Mono Repository
# Development setup and quality assurance

.PHONY: help setup install-hooks run-hooks validate-all format-all lint-all clean

# Default target
help: ## Show this help message
	@echo "Hackathons Mono Repository - Development Tools"
	@echo "=============================================="
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Setup workflow:"
	@echo "  1. make setup          # Install all development tools"
	@echo "  2. make install-hooks  # Install pre-commit hooks"
	@echo "  3. make validate-all   # Verify everything works"
	@echo ""
	@echo "Daily usage:"
	@echo "  make run-hooks         # Run all quality checks"
	@echo "  make format-all        # Format all code"

setup: ## Install development dependencies (Python, pre-commit, etc.)
	@echo "🔧 Setting up development environment..."
	@echo "Installing pre-commit..."
	pip install pre-commit
	@echo "Installing detect-secrets..."
	pip install detect-secrets
	@echo "✅ Development tools installed"
	@echo "Next: run 'make install-hooks'"

install-hooks: ## Install pre-commit hooks
	@echo "🪝 Installing pre-commit hooks..."
	pre-commit install
	@echo "✅ Pre-commit hooks installed"
	@echo "Next: run 'make validate-all' to verify setup"

run-hooks: ## Run pre-commit hooks on all files
	@echo "🏃 Running pre-commit hooks on all files..."
	pre-commit run --all-files

validate-all: ## Validate all code (Terraform, GitHub Actions, etc.)
	@echo "✅ Running comprehensive validation..."
	@echo ""
	@echo "1. Pre-commit hooks..."
	pre-commit run --all-files
	@echo ""
	@echo "2. Terraform validation..."
	@$(MAKE) terraform-validate
	@echo ""
	@echo "3. GitHub Actions validation..."
	@$(MAKE) actions-validate
	@echo ""
	@echo "✅ All validation passed!"

format-all: ## Format all code files
	@echo "📝 Formatting all code files..."
	@echo "Terraform files..."
	terraform fmt -recursive .
	@echo "Running prettier on YAML files..."
	@if command -v prettier >/dev/null 2>&1; then \
		prettier --write "**/*.{yml,yaml}" --ignore-path .gitignore; \
	else \
		echo "⚠️  prettier not installed, skipping YAML formatting"; \
	fi
	@echo "✅ Code formatting complete"

lint-all: ## Run all linting tools
	@echo "🔍 Running all linting tools..."
	@echo "TFLint..."
	@$(MAKE) terraform-lint
	@echo "actionlint..."
	@$(MAKE) actions-validate
	@echo "✅ All linting complete"

# Terraform-specific targets
terraform-validate: ## Validate all Terraform configurations
	@echo "🔍 Validating Terraform configurations..."
	@for dir in $$(find . -name "*.tf" -type f -exec dirname {} \; | sort -u); do \
		if [ -f "$$dir/providers.tf" ] || [ -f "$$dir/main.tf" ]; then \
			echo "Validating $$dir..."; \
			cd "$$dir" && terraform validate; \
			cd - > /dev/null; \
		fi; \
	done

terraform-format: ## Format all Terraform files
	@echo "📝 Formatting Terraform files..."
	terraform fmt -recursive .

terraform-lint: ## Run TFLint on all Terraform directories
	@echo "🔍 Running TFLint..."
	@for dir in $$(find . -name "*.tf" -type f -exec dirname {} \; | sort -u); do \
		if [ -f "$$dir/providers.tf" ] || [ -f "$$dir/main.tf" ]; then \
			echo "Linting $$dir..."; \
			cd "$$dir" && tflint; \
			cd - > /dev/null; \
		fi; \
	done

# GitHub Actions targets
actions-validate: ## Validate all GitHub Actions workflows
	@echo "🔍 Validating GitHub Actions workflows..."
	@if command -v actionlint >/dev/null 2>&1; then \
		actionlint .github/workflows/*.yml; \
	else \
		echo "❌ actionlint not installed. Install with: brew install actionlint"; \
		exit 1; \
	fi

# Security targets
security-scan: ## Run security scans
	@echo "🔒 Running security scans..."
	@if command -v detect-secrets >/dev/null 2>&1; then \
		detect-secrets scan --baseline .secrets.baseline; \
	else \
		echo "❌ detect-secrets not installed. Install with: pip install detect-secrets"; \
		exit 1; \
	fi

# Project-specific targets
modular-hackathon: ## Work on Modular hackathon project
	@echo "🚀 Switching to Modular hackathon project..."
	cd 2025-06-29-modular-hack-weekend && make help

# Maintenance targets
update-hooks: ## Update pre-commit hooks to latest versions
	@echo "⬆️  Updating pre-commit hooks..."
	pre-commit autoupdate
	@echo "✅ Hooks updated"

clean: ## Clean up temporary files and caches
	@echo "🧹 Cleaning up temporary files..."
	find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
	find . -name "*.tfplan" -type f -delete 2>/dev/null || true
	find . -name ".terraform.lock.hcl" -type f -delete 2>/dev/null || true
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	find . -name "*.pyc" -type f -delete 2>/dev/null || true
	@echo "✅ Cleanup complete"

# Development workflow
dev-setup: setup install-hooks validate-all ## Complete development setup
	@echo "🎉 Development environment setup complete!"
	@echo ""
	@echo "Quick commands:"
	@echo "  make run-hooks     # Run quality checks"
	@echo "  make format-all    # Format all code"
	@echo "  make validate-all  # Validate everything"
	@echo ""
	@echo "Project-specific:"
	@echo "  make modular-hackathon  # Switch to Modular project"

# CI simulation
ci-simulation: ## Simulate CI pipeline locally
	@echo "🔄 Simulating CI pipeline..."
	@echo "1. Code formatting..."
	@$(MAKE) format-all
	@echo "2. Pre-commit hooks..."
	@$(MAKE) run-hooks
	@echo "3. Comprehensive validation..."
	@$(MAKE) validate-all
	@echo "4. Security scanning..."
	@$(MAKE) security-scan
	@echo "✅ CI simulation complete - ready for commit!"

# Check tool availability
check-tools: ## Check if required tools are installed
	@echo "🔍 Checking required tools..."
	@echo "Python: $$(python3 --version 2>/dev/null || echo '❌ Not installed')"
	@echo "pip: $$(pip --version 2>/dev/null || echo '❌ Not installed')"
	@echo "pre-commit: $$(pre-commit --version 2>/dev/null || echo '❌ Not installed')"
	@echo "Terraform: $$(terraform version 2>/dev/null | head -1 || echo '❌ Not installed')"
	@echo "TFLint: $$(tflint --version 2>/dev/null || echo '❌ Not installed')"
	@echo "actionlint: $$(actionlint --version 2>/dev/null || echo '❌ Not installed')"
	@echo "detect-secrets: $$(detect-secrets --version 2>/dev/null || echo '❌ Not installed')"
