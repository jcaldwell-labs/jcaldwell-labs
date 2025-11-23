#!/usr/bin/env bash
#
# Pre-PR Validation Script
# Purpose: Validate code quality BEFORE creating Pull Request
# Created: 2025-11-23 (from Phase 2 lessons learned)
#
# Usage: ./scripts/pre-pr-check.sh [path-to-repo]
#
# Exit codes:
#   0 - All checks passed, ready to create PR
#   1 - One or more checks failed, DO NOT create PR
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track overall status
ALL_PASSED=true

# Default to current directory
REPO_PATH="${1:-.}"

echo "==============================================="
echo "Pre-PR Validation Check"
echo "==============================================="
echo "Repository: $REPO_PATH"
echo "Date: $(date)"
echo ""

cd "$REPO_PATH"

# Detect project type
detect_project_type() {
    if [ -f "go.mod" ]; then
        echo "go"
    elif [ -f "Makefile" ] && grep -q "\.c" Makefile 2>/dev/null; then
        echo "c"
    elif [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        echo "python"
    elif [ -f "package.json" ]; then
        echo "node"
    else
        echo "unknown"
    fi
}

PROJECT_TYPE=$(detect_project_type)
echo "Detected project type: $PROJECT_TYPE"
echo ""

# Function to run a check
run_check() {
    local check_name="$1"
    local check_command="$2"
    local required="$3"  # "required" or "optional"

    echo "----------------------------------------"
    echo "Check: $check_name"
    echo "Command: $check_command"
    echo ""

    if eval "$check_command"; then
        echo -e "${GREEN}✓ PASS${NC}: $check_name"
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "${RED}✗ FAIL${NC}: $check_name"
            ALL_PASSED=false
        else
            echo -e "${YELLOW}⚠ SKIP${NC}: $check_name (optional)"
        fi
        return 1
    fi
}

# Check 1: Git status (no uncommitted changes)
check_git_status() {
    if [ -d ".git" ]; then
        run_check \
            "Git Status (no uncommitted changes)" \
            "[ -z \"\$(git status --porcelain)\" ]" \
            "required"
    fi
}

# Check 2: Build succeeds with zero warnings
check_build() {
    case "$PROJECT_TYPE" in
        go)
            run_check \
                "Build (Go)" \
                "go build -v ./... 2>&1 | tee /tmp/build.log && ! grep -i 'warning' /tmp/build.log" \
                "required"
            ;;
        c)
            if [ -f "Makefile" ]; then
                run_check \
                    "Build (C with Makefile)" \
                    "make clean && make 2>&1 | tee /tmp/build.log && ! grep -i 'warning' /tmp/build.log" \
                    "required"
            fi
            ;;
        python)
            run_check \
                "Build (Python syntax check)" \
                "python -m py_compile \$(find . -name '*.py' -not -path '*/venv/*' -not -path '*/.venv/*')" \
                "required"
            ;;
        *)
            echo "⚠ Build check skipped (unknown project type)"
            ;;
    esac
}

# Check 3: Tests pass 100%
check_tests() {
    case "$PROJECT_TYPE" in
        go)
            run_check \
                "Tests (Go)" \
                "go test ./... -v" \
                "required"
            ;;
        c)
            if [ -f "Makefile" ] && grep -q "^test:" Makefile; then
                run_check \
                    "Tests (C with Makefile)" \
                    "make test" \
                    "required"
            fi
            ;;
        python)
            if [ -f "pytest.ini" ] || [ -d "tests" ]; then
                run_check \
                    "Tests (Python pytest)" \
                    "pytest" \
                    "required"
            fi
            ;;
        *)
            echo "⚠ Test check skipped (unknown project type or no tests configured)"
            ;;
    esac
}

# Check 4: Linter clean (zero errors)
check_linter() {
    case "$PROJECT_TYPE" in
        go)
            # Try golangci-lint first, fallback to go vet
            if command -v golangci-lint &> /dev/null; then
                run_check \
                    "Linter (golangci-lint)" \
                    "golangci-lint run --timeout=5m" \
                    "required"
            else
                run_check \
                    "Linter (go vet)" \
                    "go vet ./..." \
                    "required"
            fi
            ;;
        c)
            # Check for common C issues
            run_check \
                "Linter (C warnings check)" \
                "! find . -name '*.c' -exec gcc -Wall -Wextra -fsyntax-only {} \; 2>&1 | grep -i 'warning'" \
                "optional"
            ;;
        python)
            if command -v flake8 &> /dev/null; then
                run_check \
                    "Linter (flake8)" \
                    "flake8 ." \
                    "required"
            elif command -v pylint &> /dev/null; then
                run_check \
                    "Linter (pylint)" \
                    "pylint \$(find . -name '*.py' -not -path '*/venv/*')" \
                    "required"
            fi
            ;;
        *)
            echo "⚠ Linter check skipped (unknown project type)"
            ;;
    esac
}

# Check 5: No debug code
check_debug_code() {
    local debug_patterns=(
        "console\.log"
        "debugger"
        "pdb\.set_trace"
        "import pdb"
        "fmt\.Println.*DEBUG"
        "printf.*DEBUG"
        "TODO.*REMOVE"
    )

    local found_debug=false
    for pattern in "${debug_patterns[@]}"; do
        if git diff --cached | grep -E "$pattern" &> /dev/null; then
            echo -e "${RED}Found debug code: $pattern${NC}"
            found_debug=true
        fi
    done

    if [ "$found_debug" = true ]; then
        echo -e "${RED}✗ FAIL${NC}: Debug code found in staged changes"
        ALL_PASSED=false
        return 1
    else
        echo -e "${GREEN}✓ PASS${NC}: No debug code found"
        return 0
    fi
}

# Check 6: Commit messages follow conventions
check_commit_messages() {
    # Check last commit message format
    local last_commit_msg=$(git log -1 --pretty=%B 2>/dev/null)

    if [ -n "$last_commit_msg" ]; then
        # Check if follows conventional commits (roughly)
        if echo "$last_commit_msg" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?: .{1,}'; then
            echo -e "${GREEN}✓ PASS${NC}: Commit message follows conventions"
            return 0
        else
            echo -e "${YELLOW}⚠ WARNING${NC}: Commit message doesn't follow conventional commits format"
            echo "  Expected: type(scope): description"
            echo "  Examples: feat: add user auth, fix: resolve bug in parser"
            echo "  Actual: $last_commit_msg"
            # Don't fail on this, just warn
            return 0
        fi
    fi
}

# Check 7: Coverage check (if applicable)
check_coverage() {
    case "$PROJECT_TYPE" in
        go)
            if [ -f "go.mod" ]; then
                run_check \
                    "Coverage (Go)" \
                    "go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out | grep total | awk '{if (\$3+0 >= 50) exit 0; else exit 1}'" \
                    "optional"
            fi
            ;;
        python)
            if command -v pytest &> /dev/null && [ -f ".coveragerc" ]; then
                run_check \
                    "Coverage (Python)" \
                    "pytest --cov --cov-report=term-missing --cov-fail-under=50" \
                    "optional"
            fi
            ;;
        *)
            echo "⚠ Coverage check skipped"
            ;;
    esac
}

# Check 8: Security scan (basic)
check_security() {
    case "$PROJECT_TYPE" in
        go)
            if command -v gosec &> /dev/null; then
                run_check \
                    "Security Scan (gosec)" \
                    "gosec ./..." \
                    "optional"
            fi
            ;;
        python)
            if command -v bandit &> /dev/null; then
                run_check \
                    "Security Scan (bandit)" \
                    "bandit -r . -ll" \
                    "optional"
            fi
            ;;
        *)
            echo "⚠ Security scan skipped"
            ;;
    esac
}

# Check 9: Documentation updated
check_documentation() {
    # Check if code changes exist without doc changes
    local code_changed=$(git diff --cached --name-only | grep -E '\.(go|c|py|js|ts)$' | wc -l)
    local docs_changed=$(git diff --cached --name-only | grep -E '\.(md|txt|rst)$' | wc -l)

    if [ "$code_changed" -gt 0 ] && [ "$docs_changed" -eq 0 ]; then
        echo -e "${YELLOW}⚠ WARNING${NC}: Code changed but no documentation updated"
        echo "  Consider updating README.md or relevant docs"
    else
        echo -e "${GREEN}✓ PASS${NC}: Documentation check"
    fi
}

# Check 10: No large files
check_file_sizes() {
    local large_files=$(git diff --cached --name-only | xargs -I {} du -k {} 2>/dev/null | awk '$1 > 1000 {print $2}')

    if [ -n "$large_files" ]; then
        echo -e "${RED}✗ WARNING${NC}: Large files detected (>1MB):"
        echo "$large_files"
        echo "  Consider using Git LFS or excluding from repository"
    else
        echo -e "${GREEN}✓ PASS${NC}: No large files"
    fi
}

# Run all checks
echo "Running validation checks..."
echo ""

check_git_status
check_build
check_tests
check_linter
check_debug_code
check_commit_messages
check_coverage
check_security
check_documentation
check_file_sizes

echo ""
echo "==============================================="
echo "Validation Summary"
echo "==============================================="

if [ "$ALL_PASSED" = true ]; then
    echo -e "${GREEN}✓ ALL CHECKS PASSED${NC}"
    echo ""
    echo "You are ready to create a Pull Request!"
    echo ""
    echo "Next steps:"
    echo "1. Push your changes: git push origin \$(git branch --show-current)"
    echo "2. Create PR on GitHub"
    echo "3. Reference Phase 2 lessons: docs/PR-FAILURE-PROTOCOL.md"
    echo ""
    exit 0
else
    echo -e "${RED}✗ ONE OR MORE CHECKS FAILED${NC}"
    echo ""
    echo "DO NOT create a Pull Request yet!"
    echo ""
    echo "Please fix the failing checks above and run this script again."
    echo ""
    echo "Common fixes:"
    echo "  - Linter errors: Run linter and fix reported issues"
    echo "  - Test failures: Debug failing tests locally"
    echo "  - Build errors: Check compiler warnings and errors"
    echo "  - Uncommitted changes: Commit or stash your changes"
    echo ""
    echo "Phase 2 Lesson: Most CI failures can be prevented with"
    echo "local validation before PR creation."
    echo ""
    exit 1
fi
