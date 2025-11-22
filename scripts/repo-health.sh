#!/bin/bash
# Check health of all jcaldwell-labs repositories

set -euo pipefail

REPOS=(
    "fintrack"
    "terminal-stars"
    "adventure-engine-v2"
    "boxes-live"
    "smartterm-prototype"
    "atari-style"
    "my-context"
    "tario"
    ".github"
)

WORKSPACE_ROOT="/home/be-dev-agent/projects/jcaldwell-labs"
REPOS_DIR="$WORKSPACE_ROOT/repos"

echo "==================================================================="
echo "Repository Health Check - jcaldwell-labs Organization"
echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo "==================================================================="
echo ""

for repo in "${REPOS[@]}"; do
    echo "Repository: $repo"
    echo "-------------------------------------------------------------------"

    # Check if cloned locally
    if [ -d "$REPOS_DIR/$repo" ]; then
        echo "  ✓ Cloned locally: $REPOS_DIR/$repo"

        cd "$REPOS_DIR/$repo"

        # Check git status
        if git diff-index --quiet HEAD -- 2>/dev/null; then
            echo "  ✓ Working directory clean"
        else
            echo "  ⚠ Uncommitted changes detected"
            git status --short | sed 's/^/    /'
        fi

        # Check if branch is up to date with remote
        git fetch origin -q 2>/dev/null || true
        LOCAL=$(git rev-parse @ 2>/dev/null || echo "")
        REMOTE=$(git rev-parse @{u} 2>/dev/null || echo "")

        if [ "$LOCAL" = "$REMOTE" ]; then
            echo "  ✓ Up to date with remote"
        elif [ -z "$REMOTE" ]; then
            echo "  ⚠ No upstream branch set"
        else
            echo "  ⚠ Out of sync with remote"
        fi

        cd - > /dev/null
    else
        echo "  ✗ NOT cloned locally"
        echo "    Clone with: gh repo clone jcaldwell-labs/$repo $REPOS_DIR/$repo"
    fi

    # Check remote status
    REMOTE_INFO=$(gh repo view jcaldwell-labs/$repo --json name,updatedAt,primaryLanguage,stargazerCount,forkCount 2>/dev/null || echo "{}")

    if [ "$REMOTE_INFO" != "{}" ]; then
        echo "  Remote Info:"
        echo "    Language: $(echo "$REMOTE_INFO" | jq -r '.primaryLanguage.name // "N/A"')"
        echo "    Updated: $(echo "$REMOTE_INFO" | jq -r '.updatedAt')"
        echo "    Stars: $(echo "$REMOTE_INFO" | jq -r '.stargazerCount')"
    fi

    echo ""
done

echo "==================================================================="
echo "Health check complete"
echo "==================================================================="
