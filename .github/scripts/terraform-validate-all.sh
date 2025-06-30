#!/bin/bash
# Validate all Terraform configurations in the repository
# Usage: ./scripts/terraform-validate-all.sh

echo "🔍 Validating all Terraform configurations..."

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed or not in PATH"
    exit 1
fi

# Check if tflint is installed
if ! command -v tflint &> /dev/null; then
    echo "⚠️ TFLint is not installed. Install with:"
    echo "curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash"
    echo "Continuing without TFLint..."
    TFLINT_AVAILABLE=false
else
    TFLINT_AVAILABLE=true
    echo "📋 Initializing TFLint..."
    tflint --init
fi

# Find all directories containing Terraform files
TERRAFORM_DIRS=$(find . -name "*.tf" -type f | xargs -I {} dirname {} | sort -u | grep -v '^\.$' || true)

if [ -z "$TERRAFORM_DIRS" ]; then
    echo "ℹ️ No Terraform files found in repository"
    exit 0
fi

echo "📁 Found Terraform directories:"
echo "$TERRAFORM_DIRS"
echo ""

# Global format check
echo "🎨 Checking Terraform format..."
terraform fmt -check -recursive .
echo "✅ Format check passed"
echo ""

# Validate each directory
VALIDATION_FAILED=false
TFLINT_FAILED=false

while IFS= read -r dir; do
    if [ -n "$dir" ] && [ -d "$dir" ]; then
        echo "📁 Processing directory: $dir"

        # Validate Terraform configuration
        echo "  🔍 Running terraform validate..."
        if (
            cd "$dir"
            terraform init -backend=false -input=false >/dev/null 2>&1
            terraform validate
        ); then
            echo "  ✅ Validation successful"
        else
            echo "  ❌ Validation failed for $dir"
            VALIDATION_FAILED=true
        fi

        # Run TFLint if available (from repository root to use .tflint.hcl config)
        if [ "$TFLINT_AVAILABLE" = true ]; then
            echo "  📋 Running TFLint..."
            if tflint "$dir" --format=compact; then
                echo "  ✅ TFLint passed"
            else
                echo "  ❌ TFLint failed"
                TFLINT_FAILED=true
            fi
        fi

        echo ""
    fi
done <<< "$TERRAFORM_DIRS"

# Summary
echo "📊 Validation Summary:"
echo "===================="

if [ "$VALIDATION_FAILED" = true ]; then
    echo "❌ Terraform validation failed for one or more directories"
    exit 1
else
    echo "✅ All Terraform configurations are valid"
fi

if [ "$TFLINT_AVAILABLE" = true ]; then
    if [ "$TFLINT_FAILED" = true ]; then
        echo "❌ TFLint found issues in one or more directories"
        exit 1
    else
        echo "✅ TFLint passed for all directories"
    fi
fi

echo ""
echo "🎉 All validations completed successfully!"
