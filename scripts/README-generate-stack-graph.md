# Stack Dependency Visualization Script

## Overview

`generate-stack-graph.sh` analyzes the jcaldwell-labs organization and generates visualizations showing inter-project relationships, dependencies, and integration opportunities.

## Purpose

- **Understand project relationships** - See how projects relate to each other
- **Plan cross-project integrations** - Identify natural integration points (Phase 3b)
- **Identify shared components** - Find opportunities for code reuse
- **Onboarding documentation** - Help new contributors understand the organization

## Usage

```bash
./scripts/generate-stack-graph.sh
```

## Output Files

The script generates three files in the `reports/` directory:

### 1. `stack-graph.mermaid.md`
Mermaid diagram showing visual architecture of the organization.

**View:**
- On GitHub (auto-renders Mermaid)
- In VS Code with Mermaid extension
- Online at [mermaid.live](https://mermaid.live)

### 2. `stack-graph.dot`
Graphviz DOT format for alternative rendering.

**Render to PNG:**
```bash
dot -Tpng reports/stack-graph.dot -o stack-graph.png
```

**Requirements:**
```bash
sudo apt install graphviz  # Ubuntu/Debian
brew install graphviz      # macOS
```

### 3. `stack-analysis.md`
Detailed text analysis including:
- Repository breakdown by language
- Integration opportunities
- Dependency patterns
- Architecture philosophy
- Recommendations for Phase 3b

## How It Works

1. **Fetch Metadata** - Uses GitHub CLI to fetch repository information
2. **Fallback Data** - If API is unavailable, uses hardcoded data from README
3. **Analyze Relationships** - Identifies integration patterns based on:
   - Language similarity (Go projects can share code)
   - Architectural patterns (C projects share TUI patterns)
   - Logical connections (my-context integrates with productivity tools)
4. **Generate Visualizations** - Creates Mermaid and DOT diagrams
5. **Write Analysis** - Documents findings and recommendations

## Integration Insights

The script identifies several key relationships:

### Primary Integration: my-context
- **fintrack** - Financial session tracking
- **boxes-live** - Collaborative canvas logging
- Development session tracking for all projects

### Shared Component: smartterm-prototype
- Terminal UI library for C projects
- Provides reusable components for:
  - boxes-live (canvas rendering)
  - terminal-stars (visual effects)
  - tario (game UI)
  - adventure-engine-v2 (text rendering)

### Organization Standards: .github
- Templates and community health files
- Standards applied across all projects

## Use Cases

### Phase 3b Planning
Use the analysis to understand which integrations make sense:
```bash
./scripts/generate-stack-graph.sh
cat reports/stack-analysis.md | grep -A 10 "Integration Opportunities"
```

### New Contributor Onboarding
Show the architecture overview:
```bash
./scripts/generate-stack-graph.sh
# Share reports/stack-graph.mermaid.md in documentation
```

### Integration Discovery
Find natural connection points before starting integration work:
```bash
./scripts/generate-stack-graph.sh
cat reports/stack-analysis.md | grep -A 20 "Recommendations"
```

### Tracking Evolution
Re-run periodically to see how relationships change:
```bash
# Save current state
./scripts/generate-stack-graph.sh
cp reports/stack-analysis.md reports/stack-analysis-$(date +%Y-%m-%d).md

# Later, compare
diff reports/stack-analysis-2025-01-01.md reports/stack-analysis.md
```

## Project Categories

The script organizes projects into categories:

- **C Projects (5)**: Terminal UI Components
  - smartterm-prototype, boxes-live, terminal-stars, tario, adventure-engine-v2
  
- **Go Projects (2)**: Productivity Tools
  - my-context, fintrack
  
- **Python Projects (1)**: Gaming
  - atari-style
  
- **Documentation (1)**: Organization
  - .github

## Architecture Philosophy

All visualizations reflect the Unix philosophy:
- **Do one thing well** - Each project is focused
- **Work together** - Projects compose via pipelines
- **Text streams** - Data flows via standard I/O
- **Scriptable** - All tools are CLI-based

## Limitations

### What This Script Does NOT Do

- **Detect actual code dependencies** - Shows logical relationships, not `import` statements
- **Parse source code** - Uses metadata only
- **Identify breaking changes** - Static analysis only
- **Guarantee integration feasibility** - Recommendations require validation

### Why These Limitations Exist

- **Privacy**: Doesn't clone or analyze private code
- **Speed**: Quick analysis without full repository downloads
- **Simplicity**: Focuses on architectural relationships
- **Tool-agnostic**: Works without language-specific parsers

## Future Enhancements

Potential improvements (see issue tracker):

1. **Actual dependency parsing** - Scan `import` statements, `go.mod`, etc.
2. **API usage analysis** - Detect cross-project API calls
3. **Shared code detection** - Find duplicated patterns
4. **Historical tracking** - Show how relationships evolved
5. **Interactive visualization** - Web-based graph explorer

## Related Tools

- `check-prs.sh` - Check PR status across repos
- `repo-health.sh` - Check repository health
- `action-dashboard.sh` - Comprehensive action overview

## Contributing

To update the fallback data when new repositories are added:

1. Edit the `init_fallback_data()` function
2. Add new repository with language and description
3. Update the `REPOS` array
4. Re-run the script to verify

## Support

For issues or questions:
- Open an issue in jcaldwell-labs/jcaldwell-labs
- Tag with `tooling` and `phase-3b-prep`

## Version

**Version**: 1.0  
**Created**: 2025-11-25  
**Phase**: Phase 3b preparation

## Origin

Created in response to external feedback suggesting dependency visualization for:
- Understanding project relationships
- Planning cross-project integrations
- Identifying shared component opportunities
- Onboarding documentation

See: `EXTERNAL-FEEDBACK-ANALYSIS.md` - Issue #2 (Stack Graph Script)
