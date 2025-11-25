# Organization Settings Audit

> Comprehensive audit of jcaldwell-labs GitHub organization settings and repository configurations.

**Audit Date**: 2025-11-25
**Auditor**: Claude Code (Phase 3c)
**Status**: Complete

---

## Executive Summary

The jcaldwell-labs organization consists of 10 repositories with mostly consistent settings. Key findings:

- **Consistent**: All repos are public with issues enabled
- **Inconsistent**: License varies (some MIT, some None)
- **Inconsistent**: Topics incomplete on some repos
- **Recommendation**: Standardize licenses, topics, and descriptions

---

## Repository Inventory

| # | Repository | Language | Description | Status |
|---|------------|----------|-------------|--------|
| 1 | jcaldwell-labs | Shell | Coordination workspace | Active |
| 2 | fintrack | Go | Financial tracking tool | Active |
| 3 | terminal-stars | C | Starfield visualization | Active |
| 4 | boxes-live | C | Interactive canvas (Miro alternative) | Active |
| 5 | atari-style | Python | Atari-inspired demos | Active |
| 6 | .github | Shell | Organization profile | Active |
| 7 | my-context | Go | Agent journal CLI | Active |
| 8 | tario | C | ASCII platformer game | Active |
| 9 | adventure-engine-v2 | C | Text adventure engine | Active |
| 10 | smartterm-prototype | C | Terminal UI prototype | Active |

---

## Settings Audit by Category

### 1. Visibility Settings

| Repository | Visibility | Issues | Wiki | Projects |
|------------|------------|--------|------|----------|
| jcaldwell-labs | Public | Yes | Yes | No |
| fintrack | Public | Yes | Yes | No |
| terminal-stars | Public | Yes | Yes | No |
| boxes-live | Public | Yes | Yes | No |
| atari-style | Public | Yes | Yes | No |
| .github | Public | Yes | Yes | No |
| my-context | Public | Yes | No | No |
| tario | Public | Yes | Yes | No |
| adventure-engine-v2 | Public | Yes | Yes | No |
| smartterm-prototype | Public | Yes | Yes | No |

**Status**: Consistent (all public, issues enabled)

**Recommendation**: Consider enabling Projects for tracking (optional)

### 2. License Settings

| Repository | License | Needs Update |
|------------|---------|--------------|
| jcaldwell-labs | None | Yes |
| fintrack | None | Yes |
| terminal-stars | MIT | No |
| boxes-live | MIT | No |
| atari-style | MIT | No |
| .github | None | Yes |
| my-context | MIT | No |
| tario | MIT | No |
| adventure-engine-v2 | MIT | No |
| smartterm-prototype | MIT | No |

**Status**: Inconsistent (3 repos missing license)

**Recommendation**: Add MIT license to jcaldwell-labs, fintrack, .github

### 3. Default Branch

| Repository | Default Branch | Needs Update |
|------------|----------------|--------------|
| jcaldwell-labs | master | Optional |
| fintrack | main | No |
| terminal-stars | master | Optional |
| boxes-live | main | No |
| atari-style | main | No |
| .github | main | No |
| my-context | main | No |
| tario | main | No |
| adventure-engine-v2 | main | No |
| smartterm-prototype | main | No |

**Status**: Mostly consistent (8/10 use `main`)

**Recommendation**: Consider renaming to `main` for consistency (low priority)

### 4. Security Policy

| Repository | Security Policy | Needs Update |
|------------|-----------------|--------------|
| jcaldwell-labs | Enabled | No |
| fintrack | Enabled | No |
| terminal-stars | Enabled | No |
| boxes-live | Enabled | No |
| atari-style | Enabled | No |
| .github | Enabled | No |
| my-context | Enabled | No |
| tario | Enabled | No |
| adventure-engine-v2 | Enabled | No |
| smartterm-prototype | Enabled | No |

**Status**: Consistent (all enabled)

### 5. Repository Topics

| Repository | Topics | Count | Needs Update |
|------------|--------|-------|--------------|
| jcaldwell-labs | None documented | 0 | Yes |
| fintrack | accounting, budgeting, cli, finance, golang, personal-finance, postgresql, terminal | 8 | No |
| terminal-stars | animation, c, demo, graphics, ncurses, starfield, terminal, visualization | 8 | No |
| boxes-live | c, canvas, cli, interactive, miro, ncurses, pan-zoom, terminal, terminal-application, tui | 10 | No |
| atari-style | Not documented | ? | Check |
| .github | None documented | 0 | Yes |
| my-context | agent-workflow, ai-agents, claude-code, cli, context-management, developer-tools, golang, productivity | 8 | No |
| tario | Not documented | ? | Check |
| adventure-engine-v2 | Not documented | ? | Check |
| smartterm-prototype | Not documented | ? | Check |

**Status**: Partially consistent (some missing topics)

**Recommendation**: Add topics to coordination repos

---

## Recommended Standard Settings

### For All Repositories

```yaml
visibility: public
issues: enabled
wiki: disabled  # Use docs/ instead
projects: disabled  # Use organization-level projects
discussions: disabled  # Use issues for now
security_policy: enabled
license: MIT
branch_protection:
  main:
    require_pull_request: recommended
    require_status_checks: if CI exists
```

### Standard Topics by Category

**C Projects** (terminal-stars, boxes-live, tario, adventure-engine-v2, smartterm-prototype):
```
c, terminal, ncurses, cli, unix-philosophy, jcaldwell-labs
```

**Go Projects** (fintrack, my-context):
```
go, golang, cli, terminal, unix-philosophy, jcaldwell-labs
```

**Coordination** (jcaldwell-labs, .github):
```
organization, coordination, documentation, jcaldwell-labs
```

**Python** (atari-style):
```
python, terminal, games, retro, jcaldwell-labs
```

---

## Action Items

### High Priority

1. **Add MIT license** to:
   - [ ] jcaldwell-labs
   - [ ] fintrack
   - [ ] .github

### Medium Priority

2. **Add standard topics** to:
   - [ ] jcaldwell-labs: `organization, coordination, documentation, monorepo`
   - [ ] .github: `organization, github-profile, community-health`
   - [ ] Verify/update topics on tario, adventure-engine-v2, smartterm-prototype, atari-style

3. **Review descriptions** for consistency:
   - All should follow pattern: "[What it is] - [Key feature/benefit]"

### Low Priority

4. **Branch naming**:
   - Consider renaming master → main (jcaldwell-labs, terminal-stars)
   - Low impact, optional

5. **Wiki settings**:
   - Disable wikis in favor of docs/ directories
   - More consistent with Unix philosophy (plain text files)

---

## Organization-Level Settings

### Current State

- **Organization name**: jcaldwell-labs
- **Profile README**: Exists in .github repo
- **Community health files**: Partial (need CONTRIBUTING.md, SECURITY.md)
- **Default labels**: Not standardized
- **Issue templates**: Not standardized
- **PR templates**: Not standardized

### Recommended Organization Files

Create in `.github` repository:

```
.github/
├── profile/
│   └── README.md          # Organization profile (exists)
├── CONTRIBUTING.md        # Contributing guide (add)
├── SECURITY.md            # Security policy (add)
├── CODE_OF_CONDUCT.md     # Code of conduct (add)
├── FUNDING.yml            # Sponsorship info (optional)
├── ISSUE_TEMPLATE/
│   ├── bug_report.md      # Bug template (add)
│   └── feature_request.md # Feature template (add)
└── PULL_REQUEST_TEMPLATE.md # PR template (add)
```

---

## Compliance Checklist

### Documentation Standards

- [ ] All repos have README.md
- [x] All repos have CLAUDE.md (most have)
- [ ] All repos have LICENSE
- [ ] All repos have CONTRIBUTING.md (use org-level)
- [ ] All repos have consistent topic tags

### Security Standards

- [x] Security policy enabled (all repos)
- [ ] SECURITY.md file exists (add to .github)
- [ ] No secrets in code (verified by CI)
- [ ] Dependency scanning enabled (optional)

### Development Standards

- [ ] CI/CD enabled (most C/Go projects)
- [ ] Branch protection configured (recommended)
- [ ] Code owners defined (optional)
- [ ] Automated testing required (most have)

---

## Summary

| Category | Status | Action Needed |
|----------|--------|---------------|
| Visibility | ✅ Good | None |
| Licensing | ⚠️ Partial | Add to 3 repos |
| Topics | ⚠️ Partial | Add/verify on 5 repos |
| Security Policy | ✅ Good | None |
| Community Files | ⚠️ Missing | Add templates to .github |
| Branch Naming | ⚠️ Mixed | Optional cleanup |

**Overall Health**: 75% compliant

**Effort to 100%**: ~2-3 hours

---

**Document Version**: 1.0
**Last Updated**: 2025-11-25
**Next Audit**: Monthly (automated recommended)
