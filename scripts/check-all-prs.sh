#!/bin/bash
# Check all PRs across jcaldwell-labs repositories
# Usage: ./scripts/check-all-prs.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         jcaldwell-labs Pull Request Status Dashboard          ║${NC}"
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo ""

# List of all jcaldwell-labs repositories
REPOS=(
    "fintrack"
    "boxes-live"
    "terminal-stars"
    "my-context"
    "tario"
    "adventure-engine-v2"
    "smartterm-prototype"
    "atari-style"
    ".github"
)

total_open=0
total_merged=0
total_closed=0

echo -e "${BLUE}Repository Status:${NC}"
echo ""

for repo in "${REPOS[@]}"; do
    echo -e "${YELLOW}━━━ $repo ━━━${NC}"

    # Get PR list with status
    pr_data=$(gh pr list --repo "jcaldwell-labs/$repo" --json number,title,state,url,headRefName,statusCheckRollup --limit 10 2>/dev/null || echo "[]")

    if [ "$pr_data" = "[]" ]; then
        echo -e "  ${GREEN}✓${NC} No open pull requests"
        echo ""
        continue
    fi

    # Count PRs
    open_count=$(echo "$pr_data" | jq '[.[] | select(.state == "OPEN")] | length')

    if [ "$open_count" -eq 0 ]; then
        echo -e "  ${GREEN}✓${NC} No open pull requests"
        echo ""
        continue
    fi

    total_open=$((total_open + open_count))

    # Show each open PR
    echo "$pr_data" | jq -r '.[] | select(.state == "OPEN") |
        "  PR #\(.number): \(.title)\n" +
        "    Branch: \(.headRefName)\n" +
        "    URL: \(.url)\n" +
        "    Checks: \(if .statusCheckRollup then
                      (if (.statusCheckRollup | map(select(.conclusion == "SUCCESS")) | length) == (.statusCheckRollup | length) then "✓ All passing"
                       elif (.statusCheckRollup | map(select(.conclusion == "FAILURE")) | length) > 0 then "✗ Some failing"
                       elif (.statusCheckRollup | map(select(.conclusion == "PENDING" or .status == "PENDING" or .status == "IN_PROGRESS")) | length) > 0 then "⏳ In progress"
                       else "? Unknown" end)
                    else "No checks" end)\n"'

    echo ""
done

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Summary:${NC}"
echo -e "  Total Open PRs: ${YELLOW}$total_open${NC}"
echo ""

# Show recent merged PRs across all repos
echo -e "${BLUE}Recent Merged PRs (last 7 days):${NC}"
echo ""

for repo in "${REPOS[@]}"; do
    recent_merged=$(gh pr list --repo "jcaldwell-labs/$repo" --state merged --limit 5 --json number,title,mergedAt --jq '[.[] | select(.mergedAt | fromdateiso8601 > (now - 604800))] | length' 2>/dev/null || echo "0")

    if [ "$recent_merged" -gt 0 ]; then
        echo -e "  ${GREEN}$repo${NC}: $recent_merged merged PR(s)"
        gh pr list --repo "jcaldwell-labs/$repo" --state merged --limit 5 --json number,title,mergedAt --jq '.[] | select(.mergedAt | fromdateiso8601 > (now - 604800)) | "    PR #\(.number): \(.title)"' 2>/dev/null
        echo ""
    fi
done

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Quick Actions:${NC}"
echo "  View specific PR:    gh pr view <number> --repo jcaldwell-labs/<repo>"
echo "  Check CI status:     gh pr checks <number> --repo jcaldwell-labs/<repo>"
echo "  Review PR:           gh pr review <number> --repo jcaldwell-labs/<repo>"
echo "  Merge PR:            gh pr merge <number> --repo jcaldwell-labs/<repo>"
echo ""
