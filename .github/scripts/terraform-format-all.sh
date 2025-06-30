#!/bin/bash
# Format all Terraform files in the repository
# Usage: ./scripts/terraform-format-all.sh

set -e

echo "🔧 Formatting all Terraform files in repository..."

# Find all directories containing Terraform files
TERRAFORM_DIRS=$(find . -name "*.tf" -type f | xargs -I {} dirname {} | sort -u | grep -v '^\.$' || true)

if [ -z "$TERRAFORM_DIRS" ]; then
    echo "ℹ️ No Terraform files found in repository"
    exit 0
fi

echo "📁 Found Terraform files in these directories:"
echo "$TERRAFORM_DIRS"
echo ""

# Format files using terraform fmt
echo "🎨 Running terraform fmt..."
terraform fmt -recursive .

echo "✅ All Terraform files formatted successfully!"

# Show what was changed (if anything)
if git status --porcelain | grep -E '\.(tf|tfvars)$' > /dev/null; then
    echo ""
    echo "📝 Files modified:"
    git status --porcelain | grep -E '\.(tf|tfvars)$'
    echo ""
    echo "💡 Review changes and commit them:"
    echo "git add ."
    echo "git commit -m 'terraform: format all files'"
else
    echo ""
    echo "✨ No formatting changes needed - all files were already properly formatted!"
fi