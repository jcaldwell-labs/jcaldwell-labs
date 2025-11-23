#!/usr/bin/env bash
#
# Build All C Projects
# Purpose: Build all C projects in the organization with zero warnings
# Created: 2025-11-23 (Phase 3a PR 3/9)
#
# Usage: ./scripts/build-c-projects.sh
#
# Exit codes:
#   0 - All projects built successfully
#   1 - One or more projects failed to build
#

set -e

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

# C Projects to build
C_PROJECTS=(
    "boxes-live"
    "terminal-stars"
    "tario"
    "adventure-engine-v2"
    "smartterm-prototype"
)

echo "==============================================="
echo "Building All C Projects"
echo "==============================================="
echo "Project Root: $PROJECT_ROOT"
echo "Projects: ${#C_PROJECTS[@]}"
echo "Date: $(date)"
echo ""

# Build each project
for project in "${C_PROJECTS[@]}"; do
    echo "----------------------------------------"
    echo -e "${BLUE}Building: $project${NC}"
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

    # Clean build
    if make clean &> /dev/null; then
        echo -e "${GREEN}✓${NC} Cleaned"
    fi

    # Build and capture output
    BUILD_LOG="/tmp/build-$project.log"
    if make 2>&1 | tee "$BUILD_LOG"; then
        # Check for warnings
        if grep -i "warning" "$BUILD_LOG" > /dev/null; then
            echo -e "${YELLOW}⚠ WARNING${NC}: Build succeeded but has warnings"
            grep -i "warning" "$BUILD_LOG"
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
echo "Build Summary"
echo "==============================================="

if [ "$ALL_PASSED" = true ]; then
    echo -e "${GREEN}✓ ALL PROJECTS BUILT SUCCESSFULLY${NC}"
    echo ""
    echo "All ${#C_PROJECTS[@]} C projects built with zero warnings!"
    echo ""
    exit 0
else
    echo -e "${RED}✗ ONE OR MORE PROJECTS FAILED${NC}"
    echo ""
    echo "Please fix the failures above and try again."
    echo ""
    exit 1
fi
