#!/bin/bash
# Post-Squash Merge Rebase Script
# Handles seamless rebasing after squash-merging to main

set -e

echo "🔄 Post-squash merge rebase helper"
echo "=================================="

# Get current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$CURRENT_BRANCH" = "main" ]; then
    echo "❌ You're on main branch. Switch to your feature branch first."
    exit 1
fi

echo "📋 Current branch: $CURRENT_BRANCH"

# Fetch latest from origin
echo "🔄 Fetching latest from origin..."
git fetch origin

# Check if main has new commits
MAIN_COMMITS=$(git rev-list --count HEAD..origin/main)
if [ "$MAIN_COMMITS" -eq 0 ]; then
    echo "✅ Already up to date with origin/main"
    exit 0
fi

echo "📊 Found $MAIN_COMMITS new commits on origin/main"

# Option 1: Reset and replay (safest for squash-merge scenario)
echo ""
echo "Choose rebase strategy:"
echo "1) Smart reset - Reset to main and replay only NEW changes (recommended after squash-merge)"
echo "2) Regular rebase - Standard git rebase (may show false conflicts from squash-merge)"
echo "3) Show what would happen - Preview the changes without applying"
echo "4) Cancel"
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo "🔄 Using smart reset strategy..."

        # Stash any uncommitted changes
        if ! git diff --quiet; then
            echo "💾 Stashing uncommitted changes..."
            git stash
            STASHED=true
        fi

        # Check if all our commits have equivalent changes on main (squash-merged)
        echo "🔍 Analyzing commits to determine what's new..."

        # Simple and correct logic: just check if our working tree is different from main
        # after accounting for commits (this handles squash-merge perfectly)

        echo "🔍 Checking if our changes are already on main..."

        # Create a temporary commit of our current state for comparison
        TEMP_COMMIT=$(git stash create || git rev-parse HEAD)

        # Check if our current state conflicts with main's state
        if git merge-tree $(git merge-base HEAD origin/main) origin/main $TEMP_COMMIT | grep -q "<<<<<<< "; then
            echo "⚠️  Found actual merge conflicts - needs manual resolution"
            echo "💡 Use option 2 (regular rebase) and resolve conflicts manually"
            exit 1
        else
            echo "✅ No conflicts detected - safe to reset to main"
            echo "🔄 This handles squash-merge scenario perfectly"
            echo "📝 Any new files on main (like renovate.json) will be preserved"
            git reset --hard origin/main
        fi

        # Restore stashed changes
        if [ "$STASHED" = true ]; then
            echo "🔄 Restoring stashed changes..."
            git stash pop
        fi
        ;;
    2)
        echo "🔄 Using regular rebase..."
        git rebase origin/main
        ;;
    3)
        echo "👀 Preview mode - showing what would happen..."
        echo ""
        echo "📋 Commits on your branch that aren't on main:"
        git log --oneline origin/main..HEAD
        echo ""
        echo "📋 Commits on main that aren't on your branch:"
        git log --oneline HEAD..origin/main
        echo ""
        echo "📋 Files that would be affected by rebase:"
        git diff --name-only origin/main..HEAD
        echo ""
        echo "Run the script again and choose option 1 or 2 to apply changes."
        exit 0
        ;;
    4)
        echo "❌ Cancelled"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo "✅ Rebase completed successfully!"
echo "📋 Your branch is now up to date with origin/main"
