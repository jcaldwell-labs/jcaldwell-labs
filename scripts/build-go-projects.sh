#!/usr/bin/env bash
# Build All Go Projects
# Phase 3a PR 5/9
#
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

ALL_PASSED=true
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
GO_PROJECTS=("fintrack" "my-context")

echo "==============================================="
echo "Building All Go Projects"
echo "==============================================="
echo "Projects: ${#GO_PROJECTS[@]}"
echo ""

for project in "${GO_PROJECTS[@]}"; do
    echo "----------------------------------------"
    echo -e "${BLUE}Building: $project${NC}"
    echo "----------------------------------------"

    PROJECT_DIR="$PROJECT_ROOT/$project"

    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}✗ SKIP${NC}: Directory not found"
        continue
    fi

    cd "$PROJECT_DIR"

    BUILD_LOG="/tmp/build-go-$project.log"
    if go build -v ./... 2>&1 | tee "$BUILD_LOG"; then
        if grep -i "warning" "$BUILD_LOG" > /dev/null; then
            echo -e "${RED}⚠ WARNING${NC}: Build has warnings"
            ALL_PASSED=false
        else
            echo -e "${GREEN}✓ SUCCESS${NC}: Built with zero warnings"
        fi
    else
        echo -e "${RED}✗ FAILED${NC}: Build failed"
        ALL_PASSED=false
    fi

    echo ""
done

echo "==============================================="
if [ "$ALL_PASSED" = true ]; then
    echo -e "${GREEN}✓ ALL PROJECTS BUILT SUCCESSFULLY${NC}"
    exit 0
else
    echo -e "${RED}✗ ONE OR MORE PROJECTS FAILED${NC}"
    exit 1
fi
