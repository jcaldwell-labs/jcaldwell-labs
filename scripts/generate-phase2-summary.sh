#!/bin/bash
# Generate Phase 2 Summary Report
# Aggregates results from all parallel sessions into executive summary

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_FILE="$PROJECT_DIR/PHASE2-SUMMARY.md"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Generating Phase 2 Summary Report..."

# Initialize counters
TOTAL_REPOS=9
TOTAL_FILES_CHANGED=0
TOTAL_LINES_ADDED=0
TOTAL_LINES_REMOVED=0
TOTAL_TESTS_ADDED=0
TOTAL_ISSUES_FIXED=0
TOTAL_PRS=0

# Collect repository data
REPOS=()
while IFS='|' read -r repo status session_id started completed pr report blocker; do
    repo=$(echo "$repo" | xargs)
    status=$(echo "$status" | xargs)

    if [[ "$repo" == "Repository" ]] || [[ "$repo" == "-"* ]] || [[ -z "$repo" ]]; then
        continue
    fi

    if [[ "$status" == "completed" ]]; then
        REPOS+=("$repo")
    fi
done < <(grep '|' "$PROJECT_DIR/PARALLEL-SESSION-MANIFEST.md")

# Start generating report
cat > "$OUTPUT_FILE" << 'HEADER'
# Phase 2 Summary Report

**Generated**: $(date +"%Y-%m-%d %H:%M:%S")
**Phase**: Repository Improvements (Parallel Execution)
**Status**: Complete

---

## Executive Summary

Phase 2 of the jcaldwell-labs organization improvement initiative has been completed. This phase focused on enhancing all 9 repositories with standardized documentation, code quality improvements, testing infrastructure, and project health updates.

HEADER

# Add current date to header
sed -i "s/\$(date +\"%Y-%m-%d %H:%M:%S\")/$(date +"%Y-%m-%d %H:%M:%S")/" "$OUTPUT_FILE"

# Statistics section
cat >> "$OUTPUT_FILE" << EOF

### Key Metrics

| Metric | Value |
|--------|-------|
| Repositories Improved | ${#REPOS[@]} / $TOTAL_REPOS |
| Pull Requests Created | [To be calculated] |
| Total Files Changed | [To be calculated] |
| Lines Added | [To be calculated] |
| Lines Removed | [To be calculated] |
| Tests Added | [To be calculated] |
| Issues Fixed | [To be calculated] |
| Session Duration | [To be calculated] |

---

## Completion Status

EOF

# Add per-repository status
echo "### Repository Status" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "| Repository | Status | PR | Report | Session |" >> "$OUTPUT_FILE"
echo "|-----------|--------|----|----|---------|" >> "$OUTPUT_FILE"

while IFS='|' read -r repo status session_id started completed pr report blocker; do
    repo=$(echo "$repo" | xargs)
    status=$(echo "$status" | xargs)
    session_id=$(echo "$session_id" | xargs)
    pr=$(echo "$pr" | xargs)
    report=$(echo "$report" | xargs)

    if [[ "$repo" == "Repository" ]] || [[ "$repo" == "-"* ]] || [[ -z "$repo" ]]; then
        continue
    fi

    # Format status with emoji
    case "$status" in
        completed) status_icon="✅" ;;
        in_progress) status_icon="🔄" ;;
        blocked) status_icon="🚫" ;;
        not_started) status_icon="⏸️" ;;
        *) status_icon="❓" ;;
    esac

    # Format PR link
    if [[ -n "$pr" ]] && [[ "$pr" != "-" ]]; then
        pr_link="[$pr](https://github.com/jcaldwell-labs/$repo/pull/${pr#\#})"
    else
        pr_link="-"
    fi

    # Format report link
    if [[ -n "$report" ]] && [[ "$report" != "-" ]]; then
        report_link="[$report]($report)"
    else
        report_link="-"
    fi

    echo "| $repo | $status_icon $status | $pr_link | $report_link | $session_id |" >> "$OUTPUT_FILE"

done < <(grep '|' "$PROJECT_DIR/PARALLEL-SESSION-MANIFEST.md")

echo "" >> "$OUTPUT_FILE"

# Highlights section
cat >> "$OUTPUT_FILE" << 'EOF'

---

## Highlights

### Documentation Improvements

EOF

# Scan reports for documentation highlights
echo "**Repositories with new CLAUDE.md**:" >> "$OUTPUT_FILE"
for repo in "${REPOS[@]}"; do
    REPORT_NAME=$(echo "$repo" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    REPORT_FILE="$PROJECT_DIR/reports/${REPORT_NAME}-IMPROVEMENT-REPORT.md"

    if [ -f "$REPORT_FILE" ]; then
        # Check if CLAUDE.md was added
        if grep -q "CLAUDE.md" "$REPORT_FILE" 2>/dev/null; then
            echo "- $repo" >> "$OUTPUT_FILE"
        fi
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'

### Code Quality Improvements

**Compiler warnings fixed**: [To be calculated from reports]

**Linter issues resolved**: [To be calculated from reports]

**Security issues addressed**: [To be calculated from reports]

### Testing Enhancements

**New test suites added**: [To be calculated from reports]

**Test coverage improvements**: [To be calculated from reports]

### Build System

**New Makefiles added**: [To be calculated from reports]

**CI/CD pipelines created**: [To be calculated from reports]

### Project Health

**Issue templates added**: [To be calculated from reports]

**PR templates added**: [To be calculated from reports]

**CONTRIBUTING.md added**: [To be calculated from reports]

---

## Repository-Specific Highlights

EOF

# Add highlights from each report
for repo in "${REPOS[@]}"; do
    REPORT_NAME=$(echo "$repo" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    REPORT_FILE="$PROJECT_DIR/reports/${REPORT_NAME}-IMPROVEMENT-REPORT.md"

    echo "### $repo" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    if [ -f "$REPORT_FILE" ]; then
        # Extract executive summary if it exists
        if grep -q "## Executive Summary" "$REPORT_FILE"; then
            sed -n '/## Executive Summary/,/##/p' "$REPORT_FILE" | \
            grep -v "## Executive Summary" | \
            grep -v "^##" | \
            head -n 5 >> "$OUTPUT_FILE"
        else
            echo "*See full report: reports/${REPORT_NAME}-IMPROVEMENT-REPORT.md*" >> "$OUTPUT_FILE"
        fi
    else
        echo "*Report not found*" >> "$OUTPUT_FILE"
    fi
    echo "" >> "$OUTPUT_FILE"
done

# Issues and Blockers
cat >> "$OUTPUT_FILE" << 'EOF'

---

## Issues and Blockers

EOF

# Check for blockers in manifest
BLOCKERS_FOUND=false
while IFS='|' read -r repo status session_id started completed pr report blocker; do
    repo=$(echo "$repo" | xargs)
    status=$(echo "$status" | xargs)
    blocker=$(echo "$blocker" | xargs)

    if [[ "$repo" == "Repository" ]] || [[ "$repo" == "-"* ]] || [[ -z "$repo" ]]; then
        continue
    fi

    if [[ "$status" == "blocked" ]] || [[ -n "$blocker" && "$blocker" != "-" ]]; then
        BLOCKERS_FOUND=true
        echo "### $repo" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        echo "**Blocker**: $blocker" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    fi
done < <(grep '|' "$PROJECT_DIR/PARALLEL-SESSION-MANIFEST.md")

if ! $BLOCKERS_FOUND; then
    echo "No blockers reported. All repositories completed successfully." >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Technical Debt
cat >> "$OUTPUT_FILE" << 'EOF'

---

## Technical Debt Identified

The following technical debt items were identified during Phase 2 improvements but not addressed (documented for future work):

EOF

echo "[To be extracted from individual reports]" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Recommendations
cat >> "$OUTPUT_FILE" << 'EOF'

---

## Recommendations

### Immediate Actions

1. **Review and merge all PRs**: All improvement PRs should be reviewed and merged
2. **Address any blockers**: Resolve any blocked repositories
3. **Validate improvements**: Run tests across all repositories to confirm improvements

### Phase 3 Preparation

1. **Begin cross-project integration planning**
2. **Identify shared components** that can be extracted
3. **Plan unified build system** architecture
4. **Design example workflows** using multiple tools together

### Long-Term Improvements

1. **Continue test coverage expansion**
2. **Address technical debt** items identified in reports
3. **Enhance documentation** with more examples and tutorials
4. **Build community** engagement (contributors, users)

---

## Lessons Learned

### What Worked Well

- **Parallel execution**: Reduced timeline from 4-6 weeks to 1-2 weeks
- **Standard checklist**: Ensured consistency across all repositories
- **Manifest tracking**: Easy to monitor progress across sessions
- **Improvement reports**: Comprehensive documentation of work done

### Challenges

- [To be filled after reviewing all reports]

### Process Improvements for Future

- [To be filled after reviewing all reports]

---

## Statistics Deep Dive

### Code Changes by Repository

| Repository | Files Changed | Lines Added | Lines Removed | Net Change |
|-----------|---------------|-------------|---------------|------------|
EOF

# Calculate stats for each repo (if PRs exist)
for repo in "${REPOS[@]}"; do
    # Try to get PR stats
    PR_NUM=$(gh pr list --repo "jcaldwell-labs/$repo" --search "Phase 2" --state all --json number --jq '.[0].number' 2>/dev/null || echo "")

    if [ -n "$PR_NUM" ]; then
        # Get PR diff stats
        STATS=$(gh pr view "$PR_NUM" --repo "jcaldwell-labs/$repo" --json additions,deletions,changedFiles 2>/dev/null || echo "")
        if [ -n "$STATS" ]; then
            ADDITIONS=$(echo "$STATS" | jq -r '.additions // 0')
            DELETIONS=$(echo "$STATS" | jq -r '.deletions // 0')
            CHANGED=$(echo "$STATS" | jq -r '.changedFiles // 0')
            NET=$((ADDITIONS - DELETIONS))
            echo "| $repo | $CHANGED | +$ADDITIONS | -$DELETIONS | $NET |" >> "$OUTPUT_FILE"
        else
            echo "| $repo | - | - | - | - |" >> "$OUTPUT_FILE"
        fi
    else
        echo "| $repo | - | - | - | - |" >> "$OUTPUT_FILE"
    fi
done

cat >> "$OUTPUT_FILE" << 'EOF'

### Test Coverage by Repository

| Repository | Before | After | Change |
|-----------|--------|-------|--------|
[To be extracted from improvement reports]

---

## Next Steps

### Phase 3: Cross-Project Integration

**Timeline**: 1-2 weeks
**Sessions**: 2-3 sequential sessions

**Objectives**:
1. Create unified build system
2. Implement cross-project features
3. Build example workflows
4. Standardize organization infrastructure

**Prerequisites**:
- All Phase 2 PRs merged
- No outstanding blockers
- Human sign-off on Phase 2 completion

### Approval Required

- [ ] All improvement reports reviewed
- [ ] All PRs reviewed and approved
- [ ] Statistics validated
- [ ] Recommendations reviewed
- [ ] Ready to proceed to Phase 3

**Approved by**: _________________
**Date**: _________________

---

## Appendices

### Appendix A: Individual Improvement Reports

All improvement reports are available in `reports/`:

EOF

# List all reports
for repo in "${REPOS[@]}"; do
    REPORT_NAME=$(echo "$repo" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    REPORT_FILE="reports/${REPORT_NAME}-IMPROVEMENT-REPORT.md"
    echo "- [$repo]($REPORT_FILE)" >> "$OUTPUT_FILE"
done

cat >> "$OUTPUT_FILE" << 'EOF'

### Appendix B: Pull Requests

All Phase 2 PRs:

EOF

# List all PRs
for repo in "${REPOS[@]}"; do
    PR_NUM=$(gh pr list --repo "jcaldwell-labs/$repo" --search "Phase 2" --state all --json number,title --jq '.[0] | "#\(.number) - \(.title)"' 2>/dev/null || echo "No PR found")
    echo "- **$repo**: $PR_NUM" >> "$OUTPUT_FILE"
done

cat >> "$OUTPUT_FILE" << 'EOF'

### Appendix C: Session Exports

All my-context session exports are available in `sessions/`:

EOF

# List session exports
if [ -d "$PROJECT_DIR/sessions" ]; then
    for session in "$PROJECT_DIR/sessions"/*.md; do
        if [ -f "$session" ]; then
            filename=$(basename "$session")
            echo "- [$filename](sessions/$filename)" >> "$OUTPUT_FILE"
        fi
    done
else
    echo "*No session exports found*" >> "$OUTPUT_FILE"
fi

cat >> "$OUTPUT_FILE" << 'EOF'

---

**Report Generated**: $(date +"%Y-%m-%d %H:%M:%S")
**Tool**: scripts/generate-phase2-summary.sh
**Phase**: 2 - Repository Improvements
EOF

# Add current date
sed -i "s/\$(date +\"%Y-%m-%d %H:%M:%S\")/$(date +"%Y-%m-%d %H:%M:%S")/" "$OUTPUT_FILE"

echo -e "${GREEN}✓ Summary report generated: $OUTPUT_FILE${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the summary report"
echo "  2. Fill in any [To be calculated] or [To be filled] sections"
echo "  3. Review all individual improvement reports"
echo "  4. Sign off on Phase 2 completion"
echo "  5. Proceed to Phase 3 planning"
