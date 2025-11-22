#!/bin/bash
# Check for open PRs across all jcaldwell-labs repositories

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

echo "==================================================================="
echo "Open Pull Requests - jcaldwell-labs Organization"
echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo "==================================================================="
echo ""

TOTAL_PRS=0

for repo in "${REPOS[@]}"; do
    echo "Repository: $repo"
    echo "-------------------------------------------------------------------"

    PRS=$(gh pr list --repo jcaldwell-labs/$repo --state open --json number,title,updatedAt,author,isDraft 2>/dev/null || echo "[]")

    if [ "$PRS" = "[]" ]; then
        echo "  ✓ No open PRs"
    else
        COUNT=$(echo "$PRS" | jq '. | length')
        TOTAL_PRS=$((TOTAL_PRS + COUNT))

        echo "$PRS" | jq -r '.[] | "  PR #\(.number): \(.title)\n    Author: \(.author.login)\n    Updated: \(.updatedAt)\n    Draft: \(.isDraft)"'
    fi
    echo ""
done

echo "==================================================================="
echo "Total Open PRs: $TOTAL_PRS"
echo "==================================================================="
