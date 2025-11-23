#!/usr/bin/env bash
#
# Improvement Report Generator
# Purpose: Auto-generate improvement report draft from session data
# Created: 2025-11-23 (from Phase 2 lessons learned)
#
# Usage: ./scripts/generate-improvement-report.sh <repo-name> <session-id> <pr-number>
#
# Outputs: reports/<REPO>-IMPROVEMENT-REPORT.md (80% complete draft)
#

set -e

REPO_NAME="$1"
SESSION_ID="$2"
PR_NUMBER="$3"

if [ -z "$REPO_NAME" ] || [ -z "$SESSION_ID" ]; then
    echo "Usage: $0 <repo-name> <session-id> [pr-number]"
    echo ""
    echo "Example: $0 fintrack session-A 42"
    echo ""
    echo "Generates: reports/FINTRACK-IMPROVEMENT-REPORT.md"
    exit 1
fi

REPO_UPPER=$(echo "$REPO_NAME" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
OUTPUT_FILE="reports/${REPO_UPPER}-IMPROVEMENT-REPORT.md"

echo "Generating improvement report for $REPO_NAME..."
echo "Session: $SESSION_ID"
echo "PR: ${PR_NUMBER:-TBD}"
echo "Output: $OUTPUT_FILE"
echo ""

# Ensure reports directory exists
mkdir -p reports

# Try to extract data from my-context if available
extract_my_context_data() {
    if command -v my-context &> /dev/null; then
        echo "Extracting data from my-context session: $SESSION_ID"
        # Try to export the session
        MY_CONTEXT_EXPORT=$(my-context export "$SESSION_ID" 2>/dev/null || echo "")

        if [ -n "$MY_CONTEXT_EXPORT" ]; then
            echo "✓ my-context data found"
            return 0
        fi
    fi
    echo "⚠ my-context data not available"
    return 1
}

# Extract git statistics
extract_git_stats() {
    if [ -d "repos/$REPO_NAME" ]; then
        cd "repos/$REPO_NAME"

        # Find the PR branch if PR number provided
        if [ -n "$PR_NUMBER" ]; then
            PR_BRANCH=$(gh pr view "$PR_NUMBER" --json headRefName --jq '.headRefName' 2>/dev/null || echo "")
            if [ -n "$PR_BRANCH" ]; then
                echo "Found PR branch: $PR_BRANCH"

                # Get statistics
                LINES_ADDED=$(git diff origin/main...$PR_BRANCH --shortstat | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+' || echo "0")
                LINES_DELETED=$(git diff origin/main...$PR_BRANCH --shortstat | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+' || echo "0")
                FILES_CHANGED=$(git diff origin/main...$PR_BRANCH --name-only | wc -l)

                cd - > /dev/null
                return 0
            fi
        fi
        cd - > /dev/null
    fi

    # Defaults if can't extract
    LINES_ADDED="TBD"
    LINES_DELETED="TBD"
    FILES_CHANGED="TBD"
    return 1
}

# Generate the report
generate_report() {
    cat > "$OUTPUT_FILE" << 'EOF'
# [REPO_NAME_PLACEHOLDER] Improvement Report

**Repository**: [REPO_NAME_PLACEHOLDER]
**Session ID**: [SESSION_ID_PLACEHOLDER]
**Date**: [DATE_PLACEHOLDER]
**Duration**: [DURATION_PLACEHOLDER] (fill in manually)

---

## Executive Summary

<!-- 2-3 sentence summary of what was accomplished -->

[REPO_NAME_PLACEHOLDER] received [targeted/comprehensive] improvements focused on [primary areas]. The repository was [already in good shape / needed significant work]. Phase 2/3 improvements [added/fixed/enhanced] [key accomplishments].

**Key Achievement**: [Most important outcome]

---

## Checklist Completion

### Documentation ✅
- [ ] CLAUDE.md verified
- [ ] README.md improved
- [ ] CONTRIBUTING.md added/verified
- [ ] Architecture documented
- [ ] Dependencies documented
- [ ] Troubleshooting section added

### Code Quality ✅
- [ ] Linter/formatter run
- [ ] Code comments improved
- [ ] Compiler warnings fixed
- [ ] TODOs addressed
- [ ] Security issues checked
- [ ] Dead code removed

### Testing ✅
- [ ] Test suite verified
- [ ] Tests added for critical paths
- [ ] All tests passing
- [ ] Coverage documented
- [ ] Integration tests added
- [ ] Test documentation updated

### Build System ✅
- [ ] Build instructions verified
- [ ] Makefile added/improved
- [ ] Build targets added
- [ ] Dependencies documented
- [ ] Clean build tested

### CI/CD ✅
- [ ] GitHub Actions workflow added
- [ ] Tests run in CI
- [ ] Build verification added
- [ ] Linter added to CI
- [ ] CI badge added to README

### Project Health ✅
- [ ] Open issues reviewed
- [ ] Issue templates added
- [ ] PR template added
- [ ] GitHub description updated
- [ ] License verified
- [ ] Changelog added/updated

---

## Repository-Specific Tasks

<!-- Fill in from roadmap repository-specific checklist -->

- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]

---

## What Was Done

### Changes Made

<!-- List major changes -->

1. **[Component/File 1]**
   - [Change description]
   - [Rationale]
   - [Impact]

2. **[Component/File 2]**
   - [Change description]
   - [Rationale]
   - [Impact]

### Files Added

<!-- Auto-generated from git diff -->

- `[path/to/new/file1]` - [Purpose]
- `[path/to/new/file2]` - [Purpose]

### Files Modified

<!-- Auto-generated from git diff -->

- `[path/to/modified/file1]` - [What changed]
- `[path/to/modified/file2]` - [What changed]

---

## Findings

### Issues Found

<!-- Document any problems discovered -->

**Issue 1: [Description]**
- Severity: [Critical / High / Medium / Low]
- Impact: [What it affects]
- Resolution: [How it was fixed / GitHub issue created]

### Security Concerns

<!-- Document security review findings -->

**[Finding or "None identified"]**

### Technical Debt

<!-- Document debt discovered -->

**[Findings or "Minimal"]**

---

## Metrics

### Before

<!-- Fill in actual metrics -->

- **Test coverage**: [%]
- **Compiler warnings**: [count]
- **Open issues**: [count]
- **Documentation completeness**: [%]
- **Lines of code**: [count]
- **CI/CD**: [Present/Absent]

### After

<!-- Fill in actual metrics -->

- **Test coverage**: [%] ([+/- % change])
- **Compiler warnings**: [count] ([+/- change])
- **Open issues**: [count] ([+/- change])
- **Documentation completeness**: [%] ([+/- change])
- **Lines of code**: [count] ([+/- change])
- **CI/CD**: [Present/Absent]

### Net Change

<!-- Auto-populated from git stats -->

- **Lines added**: [LINES_ADDED_PLACEHOLDER]
- **Lines deleted**: [LINES_DELETED_PLACEHOLDER]
- **Files changed**: [FILES_CHANGED_PLACEHOLDER]
- **Build warnings**: [before] → [after]
- **Test pass rate**: [before] → [after]

---

## Pull Requests

<!-- List all PRs created for this repository in this phase -->

- **PR #[PR_NUMBER_PLACEHOLDER]**: [Title]
  - **URL**: https://github.com/jcaldwell-labs/[REPO_NAME_PLACEHOLDER]/pull/[PR_NUMBER_PLACEHOLDER]
  - **Status**: [Open / Merged / Closed]
  - **Impact**: [Description]

---

## Blockers and Dependencies

<!-- Document any blockers encountered -->

**[Blockers or "None"]**

---

## Recommendations

### Immediate Actions

<!-- What should be done right after merging this work -->

1. [Recommendation 1]
2. [Recommendation 2]

### Future Improvements

<!-- What could be done later -->

1. [Future enhancement 1]
2. [Future enhancement 2]

---

## Assessment

### Project State: [EXCELLENT / GOOD / NEEDS WORK]

<!-- Overall assessment of repository health -->

[REPO_NAME_PLACEHOLDER] [assessment paragraph]

**Strengths**:
- ✅ [Strength 1]
- ✅ [Strength 2]

**Areas for Improvement**:
- ⚠️ [Area 1]
- ⚠️ [Area 2]

**Readiness for [Next Phase]**: [Ready / Needs work / Not applicable]

---

## Sign-off

- [ ] All checklist items completed or documented as N/A
- [ ] All tests passing
- [ ] PR created and ready for review
- [ ] Documentation updated
- [ ] No critical blockers
- [ ] Build succeeds cleanly
- [ ] [Language-specific quality check passed]

**Completed by**: [SESSION_ID_PLACEHOLDER]
**Date**: [DATE_PLACEHOLDER]
**Duration**: [DURATION_PLACEHOLDER]
**Status**: ✅ Complete

---

**Report Version**: 1.0
**Generated**: [DATE_PLACEHOLDER]
**Session**: [SESSION_ID_PLACEHOLDER] (jcaldwell-labs Phase [X] initiative)
EOF

    # Replace placeholders
    sed -i "s/\[REPO_NAME_PLACEHOLDER\]/$REPO_NAME/g" "$OUTPUT_FILE"
    sed -i "s/\[SESSION_ID_PLACEHOLDER\]/$SESSION_ID/g" "$OUTPUT_FILE"
    sed -i "s/\[DATE_PLACEHOLDER\]/$(date +%Y-%m-%d)/g" "$OUTPUT_FILE"
    sed -i "s/\[LINES_ADDED_PLACEHOLDER\]/$LINES_ADDED/g" "$OUTPUT_FILE"
    sed -i "s/\[LINES_DELETED_PLACEHOLDER\]/$LINES_DELETED/g" "$OUTPUT_FILE"
    sed -i "s/\[FILES_CHANGED_PLACEHOLDER\]/$FILES_CHANGED/g" "$OUTPUT_FILE"

    if [ -n "$PR_NUMBER" ]; then
        sed -i "s/\[PR_NUMBER_PLACEHOLDER\]/$PR_NUMBER/g" "$OUTPUT_FILE"
    fi
}

# Main execution
extract_git_stats
generate_report

echo ""
echo "✓ Generated report draft: $OUTPUT_FILE"
echo ""
echo "Next steps:"
echo "1. Review and fill in the [bracketed] sections"
echo "2. Add findings and recommendations"
echo "3. Verify all metrics are accurate"
echo "4. Add session-specific notes"
echo "5. Commit to coordination repo:"
echo "   git add $OUTPUT_FILE"
echo "   git commit -m 'docs: Add $REPO_NAME improvement report'"
echo ""
echo "The report is ~80% complete. Human review required for:"
echo "  - Executive summary (fill in accomplishments)"
echo "  - Findings section (document issues discovered)"
echo "  - Recommendations (immediate and future)"
echo "  - Assessment (overall project health)"
echo ""
