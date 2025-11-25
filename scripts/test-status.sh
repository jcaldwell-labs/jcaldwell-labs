#!/bin/bash
#
# test-status.sh - Run tests across all projects and report status
#
# Usage: ./scripts/test-status.sh [--quick] [--verbose]
#
# Options:
#   --quick    Only check if tests exist, don't run them
#   --verbose  Show detailed test output
#
# Reports:
#   - Test pass/fail status per project
#   - Coverage information (if available)
#   - Build status
#

set -euo pipefail

# Project locations (relative to parent directory)
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects}"

# C Projects
C_PROJECTS=(
    "terminal-stars"
    "boxes-live"
    "tario"
    "adventure-engine-v2"
    "smartterm-prototype"
)

# Go Projects
GO_PROJECTS=(
    "fintrack"
    "my-context"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Parse arguments
QUICK_MODE=false
VERBOSE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --quick)
            QUICK_MODE=true
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
total_projects=0
passed_projects=0
failed_projects=0
skipped_projects=0

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  JCaldwell Labs Test Status Report${NC}"
    echo -e "${BLUE}  $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

test_c_project() {
    local project=$1
    local project_dir="$PROJECTS_DIR/$project"

    total_projects=$((total_projects + 1))

    if [ ! -d "$project_dir" ]; then
        echo -e "  ${YELLOW}SKIP${NC} - Directory not found"
        skipped_projects=$((skipped_projects + 1))
        return
    fi

    cd "$project_dir"

    # Check if Makefile exists
    if [ ! -f "Makefile" ]; then
        echo -e "  ${YELLOW}SKIP${NC} - No Makefile"
        skipped_projects=$((skipped_projects + 1))
        return
    fi

    # Check if test target exists
    if ! grep -q "^test:" Makefile 2>/dev/null; then
        echo -e "  ${YELLOW}SKIP${NC} - No test target"
        skipped_projects=$((skipped_projects + 1))
        return
    fi

    if [ "$QUICK_MODE" = true ]; then
        echo -e "  ${GREEN}HAS TESTS${NC}"
        passed_projects=$((passed_projects + 1))
        return
    fi

    # Build first
    if [ "$VERBOSE" = true ]; then
        echo "  Building..."
    fi

    if ! make clean >/dev/null 2>&1; then
        true  # clean might not exist
    fi

    if ! make >/dev/null 2>&1; then
        echo -e "  ${RED}FAIL${NC} - Build failed"
        failed_projects=$((failed_projects + 1))
        return
    fi

    # Run tests
    if [ "$VERBOSE" = true ]; then
        echo "  Running tests..."
        if make test 2>&1; then
            echo -e "  ${GREEN}PASS${NC}"
            passed_projects=$((passed_projects + 1))
        else
            echo -e "  ${RED}FAIL${NC}"
            failed_projects=$((failed_projects + 1))
        fi
    else
        if make test >/dev/null 2>&1; then
            echo -e "  ${GREEN}PASS${NC}"
            passed_projects=$((passed_projects + 1))
        else
            echo -e "  ${RED}FAIL${NC}"
            failed_projects=$((failed_projects + 1))
        fi
    fi
}

test_go_project() {
    local project=$1
    local project_dir="$PROJECTS_DIR/$project"

    total_projects=$((total_projects + 1))

    if [ ! -d "$project_dir" ]; then
        echo -e "  ${YELLOW}SKIP${NC} - Directory not found"
        skipped_projects=$((skipped_projects + 1))
        return
    fi

    cd "$project_dir"

    # Check if it's a Go project
    if [ ! -f "go.mod" ]; then
        echo -e "  ${YELLOW}SKIP${NC} - No go.mod"
        skipped_projects=$((skipped_projects + 1))
        return
    fi

    if [ "$QUICK_MODE" = true ]; then
        # Check if any test files exist
        if find . -name "*_test.go" -type f | grep -q .; then
            echo -e "  ${GREEN}HAS TESTS${NC}"
            passed_projects=$((passed_projects + 1))
        else
            echo -e "  ${YELLOW}NO TESTS${NC}"
            skipped_projects=$((skipped_projects + 1))
        fi
        return
    fi

    # Run tests
    if [ "$VERBOSE" = true ]; then
        echo "  Running tests..."
        if go test ./... 2>&1; then
            # Get coverage
            local coverage=$(go test -cover ./... 2>/dev/null | grep -oP 'coverage: \K[0-9.]+' | head -1 || echo "N/A")
            echo -e "  ${GREEN}PASS${NC} (coverage: ${coverage}%)"
            passed_projects=$((passed_projects + 1))
        else
            echo -e "  ${RED}FAIL${NC}"
            failed_projects=$((failed_projects + 1))
        fi
    else
        if go test ./... >/dev/null 2>&1; then
            local coverage=$(go test -cover ./... 2>/dev/null | grep -oP 'coverage: \K[0-9.]+' | head -1 || echo "N/A")
            echo -e "  ${GREEN}PASS${NC} (coverage: ${coverage}%)"
            passed_projects=$((passed_projects + 1))
        else
            echo -e "  ${RED}FAIL${NC}"
            failed_projects=$((failed_projects + 1))
        fi
    fi
}

print_summary() {
    echo ""
    echo -e "${BLUE}----------------------------------------${NC}"
    echo -e "${BLUE}Summary${NC}"
    echo -e "${BLUE}----------------------------------------${NC}"
    echo ""

    local health_color=$GREEN
    if [ "$failed_projects" -gt 0 ]; then
        health_color=$RED
    elif [ "$skipped_projects" -gt $((total_projects / 2)) ]; then
        health_color=$YELLOW
    fi

    echo -e "Test Status: ${health_color}$passed_projects/$total_projects passed${NC}"
    echo ""
    echo "Results:"
    echo -e "  ${GREEN}Passed:${NC}  $passed_projects"
    echo -e "  ${RED}Failed:${NC}  $failed_projects"
    echo -e "  ${YELLOW}Skipped:${NC} $skipped_projects"
    echo ""

    if [ "$failed_projects" -gt 0 ]; then
        echo -e "${RED}Action Required:${NC} Fix failing tests before merging PRs"
    fi
}

# Main execution
print_header

echo -e "${BLUE}C Projects:${NC}"
for project in "${C_PROJECTS[@]}"; do
    printf "  %-25s" "$project"
    test_c_project "$project"
done

echo ""
echo -e "${BLUE}Go Projects:${NC}"
for project in "${GO_PROJECTS[@]}"; do
    printf "  %-25s" "$project"
    test_go_project "$project"
done

print_summary

# Return non-zero if any tests failed
[ "$failed_projects" -eq 0 ]
