#!/bin/bash
#
# daily-health-check.sh - Organization-wide health monitoring
#
# Usage: ./scripts/daily-health-check.sh [--json] [--verbose]
#
# Checks:
#   - Open PRs across all repos
#   - Open issues
#   - CI/CD status (recent workflow runs)
#   - Security alerts
#   - Repository activity
#
# Output:
#   - Summary report to stdout
#   - Optional JSON output for automation
#

set -euo pipefail

# Configuration
ORG="jcaldwell-labs"
REPOS=(
    "jcaldwell-labs"
    "fintrack"
    "terminal-stars"
    "boxes-live"
    "atari-style"
    ".github"
    "my-context"
    "tario"
    "adventure-engine-v2"
    "smartterm-prototype"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
JSON_OUTPUT=false
VERBOSE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            JSON_OUTPUT=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Counters
total_open_prs=0
total_open_issues=0
total_failed_checks=0
repos_with_activity=0

# Arrays for JSON output
declare -a pr_list=()
declare -a issue_list=()
declare -a failed_checks=()

print_header() {
    if [ "$JSON_OUTPUT" = false ]; then
        echo ""
        echo -e "${BLUE}========================================${NC}"
        echo -e "${BLUE}  JCaldwell Labs Daily Health Check${NC}"
        echo -e "${BLUE}  $(date '+%Y-%m-%d %H:%M:%S')${NC}"
        echo -e "${BLUE}========================================${NC}"
        echo ""
    fi
}

check_open_prs() {
    local repo=$1
    local prs

    prs=$(gh pr list --repo "$ORG/$repo" --state open --json number,title,author,createdAt 2>/dev/null || echo "[]")
    local count=$(echo "$prs" | jq 'length')

    if [ "$count" -gt 0 ]; then
        total_open_prs=$((total_open_prs + count))
        if [ "$JSON_OUTPUT" = false ] && [ "$VERBOSE" = true ]; then
            echo -e "  ${YELLOW}PRs:${NC} $count open"
            echo "$prs" | jq -r '.[] | "    #\(.number): \(.title) (@\(.author.login))"'
        fi
        # Add to PR list for JSON
        pr_list+=("$(echo "$prs" | jq --arg repo "$repo" '[.[] | {repo: $repo, number, title, author: .author.login}]')")
    fi

    echo "$count"
}

check_open_issues() {
    local repo=$1
    local issues

    issues=$(gh issue list --repo "$ORG/$repo" --state open --json number,title,createdAt 2>/dev/null || echo "[]")
    local count=$(echo "$issues" | jq 'length')

    if [ "$count" -gt 0 ]; then
        total_open_issues=$((total_open_issues + count))
        if [ "$JSON_OUTPUT" = false ] && [ "$VERBOSE" = true ]; then
            echo -e "  ${YELLOW}Issues:${NC} $count open"
        fi
    fi

    echo "$count"
}

check_ci_status() {
    local repo=$1
    local runs

    # Get recent workflow runs
    runs=$(gh run list --repo "$ORG/$repo" --limit 5 --json status,conclusion,name,createdAt 2>/dev/null || echo "[]")

    # Check for failures in recent runs
    local failed=$(echo "$runs" | jq '[.[] | select(.conclusion == "failure")] | length')

    if [ "$failed" -gt 0 ]; then
        total_failed_checks=$((total_failed_checks + failed))
        if [ "$JSON_OUTPUT" = false ] && [ "$VERBOSE" = true ]; then
            echo -e "  ${RED}CI:${NC} $failed recent failures"
        fi
        failed_checks+=("$repo:$failed")
    fi

    echo "$failed"
}

check_recent_activity() {
    local repo=$1

    # Check if any commits in last 7 days
    local recent=$(gh api "repos/$ORG/$repo/commits?since=$(date -d '7 days ago' --iso-8601=seconds 2>/dev/null || date -v-7d +%Y-%m-%dT%H:%M:%SZ)" 2>/dev/null | jq 'length' || echo "0")

    if [ "$recent" -gt 0 ]; then
        repos_with_activity=$((repos_with_activity + 1))
    fi

    echo "$recent"
}

check_security_alerts() {
    local repo=$1

    # Try to get vulnerability alerts (may require specific permissions)
    local alerts=$(gh api "repos/$ORG/$repo/vulnerability-alerts" 2>/dev/null | jq 'length' 2>/dev/null || echo "0")

    echo "$alerts"
}

print_repo_status() {
    local repo=$1

    if [ "$JSON_OUTPUT" = false ]; then
        echo -e "${GREEN}[$repo]${NC}"
    fi

    local prs=$(check_open_prs "$repo")
    local issues=$(check_open_issues "$repo")
    local ci_failures=$(check_ci_status "$repo")
    local activity=$(check_recent_activity "$repo")

    if [ "$JSON_OUTPUT" = false ] && [ "$VERBOSE" = false ]; then
        local status="OK"
        local color=$GREEN

        if [ "$prs" -gt 0 ] || [ "$issues" -gt 0 ]; then
            status="$prs PRs, $issues issues"
            color=$YELLOW
        fi
        if [ "$ci_failures" -gt 0 ]; then
            status="$status, $ci_failures CI failures"
            color=$RED
        fi

        printf "  %-25s %b%s%b\n" "$repo" "$color" "$status" "$NC"
    fi
}

print_summary() {
    if [ "$JSON_OUTPUT" = false ]; then
        echo ""
        echo -e "${BLUE}----------------------------------------${NC}"
        echo -e "${BLUE}Summary${NC}"
        echo -e "${BLUE}----------------------------------------${NC}"
        echo ""

        # Overall health status
        local health_color=$GREEN
        local health_status="HEALTHY"

        if [ "$total_open_prs" -gt 5 ] || [ "$total_failed_checks" -gt 0 ]; then
            health_color=$YELLOW
            health_status="NEEDS ATTENTION"
        fi
        if [ "$total_failed_checks" -gt 3 ]; then
            health_color=$RED
            health_status="CRITICAL"
        fi

        echo -e "Organization Health: ${health_color}${health_status}${NC}"
        echo ""
        echo "Metrics:"
        echo "  Total Open PRs:      $total_open_prs"
        echo "  Total Open Issues:   $total_open_issues"
        echo "  CI Failures (7d):    $total_failed_checks"
        echo "  Active Repos (7d):   $repos_with_activity/${#REPOS[@]}"
        echo ""

        # Recommendations
        if [ "$total_open_prs" -gt 0 ]; then
            echo -e "${YELLOW}Action Items:${NC}"
            if [ "$total_open_prs" -gt 0 ]; then
                echo "  - Review and merge $total_open_prs open PR(s)"
            fi
            if [ "$total_failed_checks" -gt 0 ]; then
                echo "  - Fix $total_failed_checks CI failure(s)"
            fi
            echo ""
        fi

        echo "Run with --verbose for detailed output"
        echo "Run with --json for machine-readable output"
    else
        # JSON output
        cat <<EOF
{
  "timestamp": "$(date --iso-8601=seconds)",
  "organization": "$ORG",
  "summary": {
    "total_open_prs": $total_open_prs,
    "total_open_issues": $total_open_issues,
    "ci_failures": $total_failed_checks,
    "active_repos": $repos_with_activity,
    "total_repos": ${#REPOS[@]}
  },
  "health_status": "$([ $total_failed_checks -gt 3 ] && echo "critical" || ([ $total_open_prs -gt 5 ] || [ $total_failed_checks -gt 0 ]) && echo "needs_attention" || echo "healthy")"
}
EOF
    fi
}

# Main execution
print_header

if [ "$JSON_OUTPUT" = false ]; then
    echo "Checking ${#REPOS[@]} repositories..."
    echo ""
fi

for repo in "${REPOS[@]}"; do
    print_repo_status "$repo"
done

print_summary
