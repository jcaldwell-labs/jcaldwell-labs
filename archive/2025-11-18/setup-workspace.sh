#!/bin/bash
# jcaldwell-labs Workspace Setup Script
# Run this script to set up clean clones of all repositories

set -e  # Exit on error

WORKSPACE_DIR="$HOME/projects/jcaldwell-labs"
REPOS_DIR="$WORKSPACE_DIR/repos"

echo "========================================="
echo "jcaldwell-labs Workspace Setup"
echo "========================================="
echo ""

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p "$REPOS_DIR"
cd "$REPOS_DIR"

# Clone repositories
echo ""
echo "📦 Cloning repositories..."
echo ""

repos=(
    "fintrack"
    "adventure-engine-v2"
    "smartterm-prototype"
    "boxes-live"
)

for repo in "${repos[@]}"; do
    if [ -d "$repo" ]; then
        echo "⏭️  Skipping $repo (already exists)"
    else
        echo "🔄 Cloning $repo..."
        git clone "git@github.com:jcaldwell-labs/$repo.git" || {
            echo "❌ Failed to clone $repo"
            exit 1
        }
        echo "✅ Cloned $repo"
    fi
done

echo ""
echo "========================================="
echo "✅ Workspace setup complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. cd ~/projects/jcaldwell-labs/repos"
echo "2. Review each repository"
echo "3. Check out PR branches"
echo "4. Run tests and fixes"
echo ""
echo "Repositories cloned:"
for repo in "${repos[@]}"; do
    if [ -d "$repo" ]; then
        echo "  ✓ $repo"
    fi
done
echo ""
