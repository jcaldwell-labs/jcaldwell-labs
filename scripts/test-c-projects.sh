#!/usr/bin/env bash
#
# Test All C Projects
# Purpose: Run all test suites for C projects with 100% pass rate
# Created: 2025-11-23 (Phase 3a PR 4/9)
#
# Usage: ./scripts/test-c-projects.sh
#
# Exit codes:
#   0 - All tests passed
#   1 - One or more test suites failed
#

# Don't use set -e - we handle errors explicitly
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track overall status
ALL_PASSED=true

# Project root (parent of jcaldwell-labs)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# C Projects to test
C_PROJECTS=(
    "boxes-live"
    "terminal-stars"
    "tario"
    "adventure-engine-v2"
    "smartterm-prototype"
)

echo "==============================================="
echo "Testing All C Projects"
echo "==============================================="
echo "Project Root: $PROJECT_ROOT"
echo "Projects: ${#C_PROJECTS[@]}"
echo "Date: $(date)"
echo ""

# Test each project
for project in "${C_PROJECTS[@]}"; do
    echo "----------------------------------------"
    echo -e "${BLUE}Testing: $project${NC}"
    echo "----------------------------------------"

    PROJECT_DIR="$PROJECT_ROOT/$project"

    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}✗ SKIP${NC}: Directory not found: $PROJECT_DIR"
        echo ""
        continue
    fi

    if [ ! -f "$PROJECT_DIR/Makefile" ]; then
        echo -e "${RED}✗ SKIP${NC}: No Makefile found"
        echo ""
        continue
    fi

    cd "$PROJECT_DIR"

    # Check if test target exists
    if ! grep -q "^test:" Makefile; then
        echo -e "${YELLOW}⚠ SKIP${NC}: No test target in Makefile"
        echo ""
        continue
    fi

    # Run tests and capture output
    TEST_LOG="/tmp/test-$project.log"
    if make test 2>&1 | tee "$TEST_LOG"; then
        # Check for actual test failures
        # Only match explicit failure indicators, not test names containing "fail"
        if grep -E "(^FAILED|^.*FAIL:|[1-9][0-9]* tests? failed|Failures?: [1-9]|Failed: [1-9])" "$TEST_LOG" > /dev/null; then
            echo -e "${RED}✗ FAILED${NC}: Tests failed"
            ALL_PASSED=false
        else
            echo -e "${GREEN}✓ SUCCESS${NC}: All tests passed"
        fi
    else
        echo -e "${RED}✗ FAILED${NC}: Test suite failed to run"
        ALL_PASSED=false
    fi

    echo ""
done

echo "==============================================="
echo "Test Summary"
echo "==============================================="

if [ "$ALL_PASSED" = true ]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED${NC}"
    echo ""
    echo "All ${#C_PROJECTS[@]} C projects passed their test suites!"
    echo ""
    exit 0
else
    echo -e "${RED}✗ ONE OR MORE TEST SUITES FAILED${NC}"
    echo ""
    echo "Please fix the failures above and try again."
    echo ""
    exit 1
fi
