#!/bin/bash
# Phase 2 Rollup Validation Script
# Collects and validates completion of all Phase 2 parallel sessions

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "Phase 2 Rollup Validation"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
TOTAL_REPOS=9
COMPLETED=0
IN_PROGRESS=0
NOT_STARTED=0
BLOCKED=0

# Arrays to track status
COMPLETED_REPOS=()
IN_PROGRESS_REPOS=()
NOT_STARTED_REPOS=()
BLOCKED_REPOS=()

echo "1. Checking manifest file..."
if [ ! -f "$PROJECT_DIR/PARALLEL-SESSION-MANIFEST.md" ]; then
    echo -e "${RED}ERROR: PARALLEL-SESSION-MANIFEST.md not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Manifest file found${NC}"
echo ""

echo "2. Parsing session status..."
# Parse manifest (skip header rows)
while IFS='|' read -r repo status session_id started completed pr report blocker; do
    # Trim whitespace
    repo=$(echo "$repo" | xargs)
    status=$(echo "$status" | xargs)

    # Skip header/separator rows
    if [[ "$repo" == "Repository" ]] || [[ "$repo" == "-"* ]] || [[ -z "$repo" ]]; then
        continue
    fi

    case "$status" in
        completed)
            ((COMPLETED++))
            COMPLETED_REPOS+=("$repo")
            ;;
        in_progress)
            ((IN_PROGRESS++))
            IN_PROGRESS_REPOS+=("$repo")
            ;;
        blocked)
            ((BLOCKED++))
            BLOCKED_REPOS+=("$repo")
            ;;
        not_started)
            ((NOT_STARTED++))
            NOT_STARTED_REPOS+=("$repo")
            ;;
    esac
done < <(grep '|' "$PROJECT_DIR/PARALLEL-SESSION-MANIFEST.md")

echo "Status Summary:"
echo -e "  ${GREEN}Completed:${NC}     $COMPLETED / $TOTAL_REPOS"
echo -e "  ${YELLOW}In Progress:${NC}   $IN_PROGRESS / $TOTAL_REPOS"
echo -e "  ${YELLOW}Not Started:${NC}   $NOT_STARTED / $TOTAL_REPOS"
echo -e "  ${RED}Blocked:${NC}       $BLOCKED / $TOTAL_REPOS"
echo ""

if [ $COMPLETED -eq $TOTAL_REPOS ]; then
    echo -e "${GREEN}✓ All repositories completed!${NC}"
elif [ $IN_PROGRESS -gt 0 ]; then
    echo -e "${YELLOW}⚠ Sessions still in progress:${NC}"
    for repo in "${IN_PROGRESS_REPOS[@]}"; do
        echo "  - $repo"
    done
elif [ $NOT_STARTED -gt 0 ]; then
    echo -e "${YELLOW}⚠ Repositories not started:${NC}"
    for repo in "${NOT_STARTED_REPOS[@]}"; do
        echo "  - $repo"
    done
fi

if [ $BLOCKED -gt 0 ]; then
    echo -e "${RED}⚠ Blocked repositories:${NC}"
    for repo in "${BLOCKED_REPOS[@]}"; do
        echo "  - $repo"
    done
fi
echo ""

echo "3. Validating improvement reports..."
MISSING_REPORTS=()
for repo in "${COMPLETED_REPOS[@]}"; do
    # Convert repo name to uppercase for report filename
    REPORT_NAME=$(echo "$repo" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    REPORT_FILE="$PROJECT_DIR/reports/${REPORT_NAME}-IMPROVEMENT-REPORT.md"

    if [ ! -f "$REPORT_FILE" ]; then
        MISSING_REPORTS+=("$repo")
        echo -e "${YELLOW}⚠ Missing report for: $repo${NC}"
    fi
done

if [ ${#MISSING_REPORTS[@]} -eq 0 ]; then
    echo -e "${GREEN}✓ All completed repositories have reports${NC}"
else
    echo -e "${RED}✗ ${#MISSING_REPORTS[@]} completed repositories missing reports${NC}"
fi
echo ""

echo "4. Validating pull requests..."
MISSING_PRS=()
for repo in "${COMPLETED_REPOS[@]}"; do
    # Check if repo has open or merged PRs with "Phase 2" in title
    PR_COUNT=$(gh pr list --repo "jcaldwell-labs/$repo" --search "Phase 2" --state all --json number --jq 'length' 2>/dev/null || echo "0")

    if [ "$PR_COUNT" -eq 0 ]; then
        MISSING_PRS+=("$repo")
        echo -e "${YELLOW}⚠ No Phase 2 PR found for: $repo${NC}"
    fi
done

if [ ${#MISSING_PRS[@]} -eq 0 ]; then
    echo -e "${GREEN}✓ All completed repositories have PRs${NC}"
else
    echo -e "${RED}✗ ${#MISSING_PRS[@]} completed repositories missing PRs${NC}"
fi
echo ""

echo "5. Checking for blockers..."
if [ $BLOCKED -gt 0 ]; then
    echo -e "${RED}⚠ ${BLOCKED} repositories have blockers${NC}"
    echo "Review manifest for blocker details"
else
    echo -e "${GREEN}✓ No blockers reported${NC}"
fi
echo ""

echo "6. Validating session exports..."
MISSING_EXPORTS=()
for repo in "${COMPLETED_REPOS[@]}"; do
    # Look for session export file
    EXPORT_PATTERN="$PROJECT_DIR/sessions/*${repo}*.md"
    if ! ls $EXPORT_PATTERN 1> /dev/null 2>&1; then
        MISSING_EXPORTS+=("$repo")
        echo -e "${YELLOW}⚠ Missing session export for: $repo${NC}"
    fi
done

if [ ${#MISSING_EXPORTS[@]} -eq 0 ]; then
    echo -e "${GREEN}✓ All completed repositories have session exports${NC}"
else
    echo -e "${YELLOW}⚠ ${#MISSING_EXPORTS[@]} completed repositories missing session exports${NC}"
    echo "(Session exports are optional but recommended)"
fi
echo ""

# Overall validation
echo "=========================================="
echo "Overall Validation Result"
echo "=========================================="

CRITICAL_ISSUES=0
if [ $COMPLETED -ne $TOTAL_REPOS ]; then
    ((CRITICAL_ISSUES++))
    echo -e "${RED}✗ Not all repositories completed ($COMPLETED/$TOTAL_REPOS)${NC}"
fi

if [ ${#MISSING_REPORTS[@]} -gt 0 ]; then
    ((CRITICAL_ISSUES++))
    echo -e "${RED}✗ Missing improvement reports: ${#MISSING_REPORTS[@]}${NC}"
fi

if [ ${#MISSING_PRS[@]} -gt 0 ]; then
    ((CRITICAL_ISSUES++))
    echo -e "${RED}✗ Missing PRs: ${#MISSING_PRS[@]}${NC}"
fi

if [ $BLOCKED -gt 0 ]; then
    ((CRITICAL_ISSUES++))
    echo -e "${RED}✗ Blocked repositories: $BLOCKED${NC}"
fi

echo ""
if [ $CRITICAL_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓✓✓ PHASE 2 VALIDATION PASSED ✓✓✓${NC}"
    echo ""
    echo "All repositories completed, all reports generated, all PRs created."
    echo "Ready to proceed with human review and Phase 2 summary generation."
    echo ""
    echo "Next steps:"
    echo "  1. Review all improvement reports in reports/"
    echo "  2. Review all PRs"
    echo "  3. Run: ./scripts/generate-phase2-summary.sh"
    echo "  4. Approve transition to Phase 3"
    exit 0
else
    echo -e "${RED}✗✗✗ PHASE 2 VALIDATION FAILED ✗✗✗${NC}"
    echo ""
    echo "$CRITICAL_ISSUES critical issue(s) found."
    echo ""
    echo "Required actions:"
    if [ $COMPLETED -ne $TOTAL_REPOS ]; then
        echo "  - Wait for in-progress sessions to complete"
        echo "  - Launch sessions for not-started repositories"
        echo "  - Resolve blocked repositories"
    fi
    if [ ${#MISSING_REPORTS[@]} -gt 0 ]; then
        echo "  - Generate missing improvement reports"
    fi
    if [ ${#MISSING_PRS[@]} -gt 0 ]; then
        echo "  - Create missing PRs"
    fi
    echo ""
    echo "Re-run this script after addressing issues."
    exit 1
fi
