#!/bin/bash
# Generate actionable dashboard for jcaldwell-labs organization

set -euo pipefail

WORKSPACE_ROOT="/home/be-dev-agent/projects/jcaldwell-labs"
REPOS_DIR="$WORKSPACE_ROOT/repos"

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
echo "Action Dashboard - jcaldwell-labs Organization"
echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo "==================================================================="
echo ""

# Section 1: Open PRs requiring action
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. OPEN PRS REQUIRING REVIEW/MERGE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

HAS_PRS=false
for repo in "${REPOS[@]}"; do
    PRS=$(gh pr list --repo jcaldwell-labs/$repo --state open --json number,title,updatedAt,author,isDraft,url 2>/dev/null || echo "[]")

    if [ "$PRS" != "[]" ]; then
        HAS_PRS=true
        echo ""
        echo "📁 $repo"
        echo "$PRS" | jq -r '.[] | "  • PR #\(.number): \(.title)\n    Author: \(.author.login) | Draft: \(.isDraft) | Updated: \(.updatedAt | split("T")[0])\n    URL: \(.url)\n    ACTION: Review and merge or provide feedback"'
    fi
done

if [ "$HAS_PRS" = false ]; then
    echo "  ✓ No open PRs"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. LOCAL REPOSITORIES NEEDING ATTENTION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

HAS_LOCAL_ISSUES=false
for repo in "${REPOS[@]}"; do
    if [ -d "$REPOS_DIR/$repo" ]; then
        cd "$REPOS_DIR/$repo"

        ISSUES=""

        # Check for uncommitted changes
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            ISSUES="${ISSUES}\n    ⚠ Uncommitted changes"
        fi

        # Check if out of sync
        git fetch origin -q 2>/dev/null || true
        LOCAL=$(git rev-parse @ 2>/dev/null || echo "")
        REMOTE=$(git rev-parse @{u} 2>/dev/null || echo "")

        if [ -n "$REMOTE" ] && [ "$LOCAL" != "$REMOTE" ]; then
            BEHIND=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
            AHEAD=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")

            if [ "$BEHIND" -gt 0 ]; then
                ISSUES="${ISSUES}\n    ⚠ Behind remote by $BEHIND commits"
            fi
            if [ "$AHEAD" -gt 0 ]; then
                ISSUES="${ISSUES}\n    ⚠ Ahead of remote by $AHEAD commits (unpushed)"
            fi
        fi

        if [ -n "$ISSUES" ]; then
            HAS_LOCAL_ISSUES=true
            echo ""
            echo "📁 $repo"
            echo -e "$ISSUES"
            echo "    ACTION: Review changes and sync with remote"
        fi

        cd - > /dev/null
    fi
done

if [ "$HAS_LOCAL_ISSUES" = false ]; then
    echo "  ✓ All local repositories clean and in sync"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. SUGGESTED ACTIONS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "🖥️  MANUAL ACTIONS (local terminal):"
echo "  • Review and merge open PRs on GitHub"
echo "  • Resolve uncommitted changes in local repos"
echo "  • Push unpushed commits"
echo ""

echo "🤖 CLAUDE LOCAL ACTIONS (this session):"
echo "  • Code reviews for open PRs"
echo "  • Fix issues in local repositories"
echo "  • Write tests or documentation"
echo "  • Refactor code"
echo ""

echo "☁️  CLAUDE REMOTE ACTIONS (github.com/claude-code):"
echo "  • Create new features from scratch"
echo "  • Large refactoring projects"
echo "  • Multi-file changes across repositories"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4. QUICK COMMANDS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Check PR status:"
echo "  ./scripts/check-prs.sh"
echo ""
echo "Check repo health:"
echo "  ./scripts/repo-health.sh"
echo ""
echo "Clone missing repo:"
echo "  gh repo clone jcaldwell-labs/<repo-name> repos/<repo-name>"
echo ""
echo "Review specific PR locally:"
echo "  cd repos/<repo-name> && gh pr checkout <pr-number>"
echo ""

echo "==================================================================="
