#!/usr/bin/env bash
# Test All Go Projects - Phase 3a PR 6/9
set -e
RED='\033[0;31m'; GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
ALL_PASSED=true
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
GO_PROJECTS=("fintrack" "my-context")

echo "==============================================="
echo "Testing All Go Projects"
echo "==============================================="

for project in "${GO_PROJECTS[@]}"; do
    echo "----------------------------------------"
    echo -e "${BLUE}Testing: $project${NC}"
    echo "----------------------------------------"
    cd "$PROJECT_ROOT/$project"
    if go test ./... -v 2>&1 | tee /tmp/test-go-$project.log; then
        echo -e "${GREEN}✓ SUCCESS${NC}: All tests passed"
    else
        echo -e "${RED}✗ FAILED${NC}: Tests failed"
        ALL_PASSED=false
    fi
    echo ""
done

echo "==============================================="
if [ "$ALL_PASSED" = true ]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED${NC}"
    exit 0
else
    echo -e "${RED}✗ ONE OR MORE TEST SUITES FAILED${NC}"
    exit 1
fi
