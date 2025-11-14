#!/bin/bash
# Push to all configured remotes
# This script pushes the current branch to all remotes configured in git

set -e

current_branch=$(git branch --show-current)

echo "🚀 Pushing to all remotes..."
echo "Current branch: $current_branch"
echo ""

# Get all remotes
remotes=$(git remote)

for remote in $remotes; do
    echo "📤 Pushing to $remote..."
    git push --no-verify "$remote" "$current_branch" || {
        echo "⚠️  Failed to push to $remote"
        echo "Continue with other remotes? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            exit 1
        fi
    }
    echo "✅ Pushed to $remote"
    echo ""
done

echo "✅ All pushes complete!"

