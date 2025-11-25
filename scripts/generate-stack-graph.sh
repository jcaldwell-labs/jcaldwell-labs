#!/bin/bash
# Generate stack dependency visualization for jcaldwell-labs organization
# Analyzes projects, identifies relationships, and generates dependency graphs
#
# Design Decisions:
# - Sequential processing: Simple and reliable, adequate for 9 repos (~10s runtime)
# - Embedded templates: Keep script portable as single file (no external dependencies)
# - Fallback data: Works without GitHub API access (useful in restricted environments)
# - Multiple formats: Mermaid (GitHub), DOT (Graphviz), Markdown (analysis)

set -euo pipefail

# Repository list
REPOS=(
    "fintrack"
    "terminal-stars"
    "adventure-engine-v2"
    "boxes-live"
    "smartterm-prototype"
    "atari-style"
    "my-context"
    "tario"
    ".github"
)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Output file paths
OUTPUT_DIR="reports"
MERMAID_FILE="$OUTPUT_DIR/stack-graph.mermaid.md"
DOT_FILE="$OUTPUT_DIR/stack-graph.dot"
ANALYSIS_FILE="$OUTPUT_DIR/stack-analysis.md"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Generate timestamp once for consistency
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "================================================================="
echo "Stack Dependency Visualization Generator"
echo "jcaldwell-labs Organization"
echo "Generated: $TIMESTAMP"
echo "================================================================="
echo ""

# Function to fetch repository metadata
fetch_repo_metadata() {
    local repo=$1
    echo -e "${BLUE}Fetching metadata for $repo...${NC}" >&2
    local result
    result=$(gh repo view "jcaldwell-labs/$repo" --json name,description,primaryLanguage,updatedAt 2>&1)
    local exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        echo -e "${YELLOW}  (API call failed - using fallback data)${NC}" >&2
        echo "{}"
    else
        echo "$result"
    fi
}

# Initialize data structure with known repository information (fallback if API fails)
declare -A REPO_LANGUAGE
declare -A REPO_DESCRIPTION

# Fallback data from organization README
init_fallback_data() {
    REPO_LANGUAGE["fintrack"]="Go"
    REPO_DESCRIPTION["fintrack"]="Financial tracking CLI"
    
    REPO_LANGUAGE["terminal-stars"]="C"
    REPO_DESCRIPTION["terminal-stars"]="Starfield visualization"
    
    REPO_LANGUAGE["adventure-engine-v2"]="C"
    REPO_DESCRIPTION["adventure-engine-v2"]="Text adventure engine"
    
    REPO_LANGUAGE["boxes-live"]="C"
    REPO_DESCRIPTION["boxes-live"]="Terminal canvas (Miro alternative)"
    
    REPO_LANGUAGE["smartterm-prototype"]="C"
    REPO_DESCRIPTION["smartterm-prototype"]="Terminal UI library"
    
    REPO_LANGUAGE["atari-style"]="Python"
    REPO_DESCRIPTION["atari-style"]="Terminal arcade games"
    
    REPO_LANGUAGE["my-context"]="Go"
    REPO_DESCRIPTION["my-context"]="Agent journal and context management"
    
    REPO_LANGUAGE["tario"]="C"
    REPO_DESCRIPTION["tario"]="ASCII platformer game"
    
    REPO_LANGUAGE[".github"]="Markdown"
    REPO_DESCRIPTION[".github"]="Organization profile"
}

# Initialize fallback data
init_fallback_data

echo "Analyzing repositories..."
echo ""

# Fetch all repository data
for repo in "${REPOS[@]}"; do
    metadata=$(fetch_repo_metadata "$repo")
    
    # Check if it's valid JSON and capture the exit code
    echo "$metadata" | jq -e . >/dev/null 2>&1
    jq_exit_code=$?
    
    if [ $jq_exit_code -eq 0 ] && [ "$metadata" != "{}" ]; then
        lang=$(echo "$metadata" | jq -r '.primaryLanguage.name // "Unknown"')
        desc=$(echo "$metadata" | jq -r '.description // "No description"')
        
        REPO_LANGUAGE[$repo]="$lang"
        REPO_DESCRIPTION[$repo]="$desc"
        
        echo -e "  ${GREEN}✓${NC} $repo ($lang) - fetched from API"
    else
        # Use fallback data if API fetch fails
        # Note: If jq exits with error but metadata is not "{}", it means we got
        # invalid JSON from the API (not empty response), so we log a parse error
        if [ $jq_exit_code -ne 0 ] && [ "$metadata" != "{}" ]; then
            echo -e "  ${YELLOW}  (JSON parse error - using fallback data)${NC}" >&2
        fi
        lang="${REPO_LANGUAGE[$repo]}"
        desc="${REPO_DESCRIPTION[$repo]}"
        echo -e "  ${YELLOW}↻${NC} $repo ($lang) - using fallback data"
    fi
done

echo ""
echo "================================================================="
echo "Generating Visualizations"
echo "================================================================="

# Generate Mermaid diagram
cat > "$MERMAID_FILE" << 'MERMAID_HEADER'
# Stack Dependency Graph

**Generated**: TIMESTAMP

## Architecture Overview

This diagram shows the relationships between projects in the jcaldwell-labs organization.

```mermaid
graph TD
    %% Define project categories
    subgraph "Terminal UI Components (C)"
        smartterm[smartterm-prototype<br/>Terminal UI Library]
        boxes[boxes-live<br/>Interactive Canvas]
        terminal[terminal-stars<br/>Starfield Viz]
        tario[tario<br/>Platformer Game]
        adventure[adventure-engine-v2<br/>Text Adventure]
    end
    
    subgraph "Productivity Tools (Go)"
        context[my-context<br/>Context Management]
        fintrack[fintrack<br/>Financial Tracking]
    end
    
    subgraph "Gaming (Python)"
        atari[atari-style<br/>Arcade Games]
    end
    
    subgraph "Organization"
        github[.github<br/>Org Profile]
    end
    
    %% Define relationships
    %% Terminal UI library provides foundation for other C projects
    smartterm -.->|UI Patterns| boxes
    smartterm -.->|UI Components| terminal
    smartterm -.->|UI Components| tario
    smartterm -.->|UI Components| adventure
    
    %% my-context can integrate with productivity tools
    context -.->|Context Tracking| fintrack
    context -.->|Session Logging| boxes
    
    %% All projects follow org standards
    github -.->|Standards & Templates| smartterm
    github -.->|Standards & Templates| boxes
    github -.->|Standards & Templates| terminal
    github -.->|Standards & Templates| tario
    github -.->|Standards & Templates| adventure
    github -.->|Standards & Templates| context
    github -.->|Standards & Templates| fintrack
    github -.->|Standards & Templates| atari
    
    %% Styling
    classDef cProjects fill:#e1f5ff,stroke:#0288d1,stroke-width:2px
    classDef goProjects fill:#e8f5e9,stroke:#388e3c,stroke-width:2px
    classDef pyProjects fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef orgProjects fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    
    class smartterm,boxes,terminal,tario,adventure cProjects
    class context,fintrack goProjects
    class atari pyProjects
    class github orgProjects
```

## Legend

- **Solid arrows**: Direct dependencies
- **Dashed arrows**: Potential integration points or shared patterns
- **Colors**:
  - Blue: C projects (Terminal UI components)
  - Green: Go projects (Productivity tools)
  - Orange: Python projects (Gaming)
  - Purple: Organization infrastructure

MERMAID_HEADER

# Replace timestamp using | delimiter to avoid conflicts with timestamp characters
sed -i "s|TIMESTAMP|$TIMESTAMP|" "$MERMAID_FILE"

echo -e "${GREEN}✓${NC} Generated Mermaid diagram: $MERMAID_FILE"

# Generate DOT file for Graphviz (if available)
cat > "$DOT_FILE" << 'DOT_HEADER'
digraph jcaldwell_labs_stack {
    // Graph attributes
    rankdir=TB;
    bgcolor="#ffffff";
    node [shape=box, style=filled, fontname="Arial"];
    edge [fontname="Arial", fontsize=10];
    
    // Define subgraphs for organization
    subgraph cluster_c {
        label="Terminal UI Components (C)";
        style=filled;
        color=lightblue;
        
        smartterm [label="smartterm-prototype\nTerminal UI Library", fillcolor="#e1f5ff"];
        boxes [label="boxes-live\nInteractive Canvas", fillcolor="#e1f5ff"];
        terminal_stars [label="terminal-stars\nStarfield Viz", fillcolor="#e1f5ff"];
        tario [label="tario\nPlatformer Game", fillcolor="#e1f5ff"];
        adventure [label="adventure-engine-v2\nText Adventure", fillcolor="#e1f5ff"];
    }
    
    subgraph cluster_go {
        label="Productivity Tools (Go)";
        style=filled;
        color=lightgreen;
        
        my_context [label="my-context\nContext Management", fillcolor="#e8f5e9"];
        fintrack [label="fintrack\nFinancial Tracking", fillcolor="#e8f5e9"];
    }
    
    subgraph cluster_python {
        label="Gaming (Python)";
        style=filled;
        color=lightyellow;
        
        atari_style [label="atari-style\nArcade Games", fillcolor="#fff3e0"];
    }
    
    subgraph cluster_org {
        label="Organization";
        style=filled;
        color=plum;
        
        dot_github [label=".github\nOrg Profile", fillcolor="#f3e5f5"];
    }
    
    // Define relationships
    // UI library patterns
    smartterm -> boxes [label="UI Patterns", style=dashed];
    smartterm -> terminal_stars [label="UI Components", style=dashed];
    smartterm -> tario [label="UI Components", style=dashed];
    smartterm -> adventure [label="UI Components", style=dashed];
    
    // my-context integrations
    my_context -> fintrack [label="Context Tracking", style=dashed];
    my_context -> boxes [label="Session Logging", style=dashed];
    
    // Organization standards
    dot_github -> smartterm [label="Standards", style=dotted, color=gray];
    dot_github -> boxes [label="Standards", style=dotted, color=gray];
    dot_github -> terminal_stars [label="Standards", style=dotted, color=gray];
    dot_github -> tario [label="Standards", style=dotted, color=gray];
    dot_github -> adventure [label="Standards", style=dotted, color=gray];
    dot_github -> my_context [label="Standards", style=dotted, color=gray];
    dot_github -> fintrack [label="Standards", style=dotted, color=gray];
    dot_github -> atari_style [label="Standards", style=dotted, color=gray];
}
DOT_HEADER

echo -e "${GREEN}✓${NC} Generated DOT file: $DOT_FILE"

# Generate analysis report
cat > "$ANALYSIS_FILE" << 'ANALYSIS_HEADER'
# Stack Analysis Report

**Generated**: TIMESTAMP

## Overview

This report analyzes the jcaldwell-labs organization stack, identifying project relationships, shared patterns, and integration opportunities.

ANALYSIS_HEADER

sed -i "s|TIMESTAMP|$TIMESTAMP|" "$ANALYSIS_FILE"

# Add repository breakdown
cat >> "$ANALYSIS_FILE" << 'BREAKDOWN'

## Repository Breakdown by Language

BREAKDOWN

# Count by language
echo "### C Projects (Terminal UI Components)" >> "$ANALYSIS_FILE"
echo "" >> "$ANALYSIS_FILE"
for repo in "${REPOS[@]}"; do
    if [ "${REPO_LANGUAGE[$repo]}" = "C" ]; then
        echo "- **$repo**: ${REPO_DESCRIPTION[$repo]}" >> "$ANALYSIS_FILE"
    fi
done

echo "" >> "$ANALYSIS_FILE"
echo "### Go Projects (Productivity Tools)" >> "$ANALYSIS_FILE"
echo "" >> "$ANALYSIS_FILE"
for repo in "${REPOS[@]}"; do
    if [ "${REPO_LANGUAGE[$repo]}" = "Go" ]; then
        echo "- **$repo**: ${REPO_DESCRIPTION[$repo]}" >> "$ANALYSIS_FILE"
    fi
done

echo "" >> "$ANALYSIS_FILE"
echo "### Python Projects (Gaming)" >> "$ANALYSIS_FILE"
echo "" >> "$ANALYSIS_FILE"
for repo in "${REPOS[@]}"; do
    if [ "${REPO_LANGUAGE[$repo]}" = "Python" ]; then
        echo "- **$repo**: ${REPO_DESCRIPTION[$repo]}" >> "$ANALYSIS_FILE"
    fi
done

echo "" >> "$ANALYSIS_FILE"
echo "### Documentation Projects" >> "$ANALYSIS_FILE"
echo "" >> "$ANALYSIS_FILE"
for repo in "${REPOS[@]}"; do
    lang="${REPO_LANGUAGE[$repo]}"
    if [ "$lang" != "C" ] && [ "$lang" != "Go" ] && [ "$lang" != "Python" ]; then
        echo "- **$repo**: ${REPO_DESCRIPTION[$repo]} ($lang)" >> "$ANALYSIS_FILE"
    fi
done

# Add integration opportunities section
cat >> "$ANALYSIS_FILE" << 'INTEGRATION'

## Integration Opportunities

### Primary Integration: my-context

The `my-context` tool (agent journal and context management) can integrate with:

1. **fintrack** - Track financial analysis sessions and decisions
   - Use my-context to log investment research
   - Export financial planning sessions
   - Track budget analysis context

2. **boxes-live** - Log collaborative canvas sessions
   - Track brainstorming sessions
   - Export canvas state with context
   - Document design decisions

3. **Terminal UI Projects** - Development session tracking
   - Log debugging sessions
   - Track feature development context
   - Document design patterns learned

### Shared Component: smartterm-prototype

The `smartterm-prototype` Terminal UI library can provide reusable components for:

1. **boxes-live** - Canvas rendering and interaction
2. **terminal-stars** - Visual effects and frame buffering
3. **tario** - Game UI and input handling
4. **adventure-engine-v2** - Text rendering and menu systems

### Cross-Language Opportunities

While most projects are self-contained, they share:

- **Unix Philosophy**: Small, focused tools that compose together
- **Terminal-First**: All work over SSH, no GUI dependencies
- **Standard Build**: Similar build patterns (Makefile-based)
- **Documentation Standards**: CLAUDE.md, comprehensive READMEs

INTEGRATION

# Add dependency analysis
cat >> "$ANALYSIS_FILE" << 'DEPENDENCIES'

## Dependency Patterns

### C Projects
- **Build System**: Makefile-based compilation
- **Libraries**: ncurses for TUI, standard C library
- **No Inter-Project Dependencies**: Each project is standalone

### Go Projects
- **Build System**: Go modules (go.mod)
- **Standard Library**: Heavy use of Go stdlib
- **Potential Shared Packages**: CLI patterns, configuration management

### Python Projects
- **Build System**: requirements.txt or pyproject.toml
- **Libraries**: Terminal handling (blessed, curses)
- **Standalone**: Independent game implementations

## Architecture Philosophy

All projects follow the Unix philosophy:
1. **Do one thing well** - Each project has a focused purpose
2. **Work together** - Projects can be composed via shell pipelines
3. **Text streams** - Data flows via standard I/O
4. **Scriptable** - All tools provide command-line interfaces

DEPENDENCIES

# Add recommendations
cat >> "$ANALYSIS_FILE" << 'RECOMMENDATIONS'

## Recommendations

### Phase 3b Integration Planning

Based on this analysis, recommended integration work:

1. **my-context + fintrack** (HIGH PRIORITY)
   - Clear use case: financial analysis session tracking
   - Both are Go projects, easier integration
   - Demonstrates productivity tool composition

2. **smartterm-prototype extraction** (MEDIUM PRIORITY)
   - Extract common UI patterns into library
   - Provide clean API for other C projects
   - Reduce code duplication across TUI projects

3. **Build system unification** (PLANNED - Phase 3a)
   - Already in progress with Makefile
   - Provides consistent build/test/install targets
   - Foundation for other integrations

### Shared Component Opportunities

1. **Terminal UI Library** (smartterm-prototype)
   - Status: Already prototyped
   - Next: Extract into reusable library
   - Benefit: Consistent UI across C projects

2. **Context Management Integration** (my-context)
   - Status: Production-ready tool
   - Next: Add hooks for other tools
   - Benefit: Universal session tracking

3. **Build Infrastructure** (Phase 3a)
   - Status: In planning
   - Next: Implement unified Makefile
   - Benefit: Consistent development experience

### Not Recommended

1. **Forced integration of unrelated projects**
   - tario and fintrack have no natural integration point
   - atari-style and adventure-engine-v2 serve different purposes
   - Respect the Unix philosophy: keep tools focused

2. **Shared ANSI library without validated need**
   - Each project handles ANSI codes fine
   - No evidence of code duplication
   - Wait for need to emerge naturally

RECOMMENDATIONS

echo -e "${GREEN}✓${NC} Generated analysis report: $ANALYSIS_FILE"

echo ""
echo "================================================================="
echo "Summary"
echo "================================================================="
echo ""
echo "Generated 3 output files:"
echo ""
echo "  1. Mermaid Diagram:    $MERMAID_FILE"
echo "     View in GitHub or any Mermaid-compatible viewer"
echo ""
echo "  2. DOT Graph:          $DOT_FILE"
echo "     Render with: dot -Tpng $DOT_FILE -o stack-graph.png"
echo "     (Requires graphviz: apt install graphviz)"
echo ""
echo "  3. Analysis Report:    $ANALYSIS_FILE"
echo "     Detailed breakdown and recommendations"
echo ""
echo "================================================================="
echo ""

# Repository statistics
echo "Repository Statistics:"
echo ""

c_count=0
go_count=0
python_count=0
other_count=0

for repo in "${REPOS[@]}"; do
    case "${REPO_LANGUAGE[$repo]}" in
        "C") c_count=$((c_count + 1)) ;;
        "Go") go_count=$((go_count + 1)) ;;
        "Python") python_count=$((python_count + 1)) ;;
        *) other_count=$((other_count + 1)) ;;
    esac
done

echo "  C Projects:      $c_count (Terminal UI Components)"
echo "  Go Projects:     $go_count (Productivity Tools)"
echo "  Python Projects: $python_count (Gaming)"
echo "  Other:           $other_count (Documentation)"
echo "  ─────────────────────"
echo "  Total:           ${#REPOS[@]} repositories"
echo ""

echo "================================================================="
echo "Integration Insights"
echo "================================================================="
echo ""
echo "High-value integration opportunities:"
echo ""
echo "  1. my-context + fintrack"
echo "     → Financial session tracking and context management"
echo ""
echo "  2. smartterm-prototype library extraction"
echo "     → Shared UI components for C projects"
echo ""
echo "  3. Unified build system (Phase 3a)"
echo "     → Foundation for consistent development workflow"
echo ""

echo "================================================================="
echo "Next Steps"
echo "================================================================="
echo ""
echo "1. Review generated diagrams and analysis"
echo "2. Use insights for Phase 3b integration planning"
echo "3. Update diagrams as integrations are implemented"
echo "4. Re-run this script periodically to track evolution"
echo ""
echo "Done!"
