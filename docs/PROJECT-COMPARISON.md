# Project Comparison Matrix

> How jcaldwell-labs terminal tools compare to enterprise alternatives.

**Created**: 2025-11-25
**Audience**: Developers evaluating terminal-first alternatives

---

## Philosophy

JCaldwell Labs builds terminal-first tools that compete with enterprise web applications. Our belief:

> **The terminal is not a limitation—it's a feature.**

Benefits of terminal-based tools:
- **Speed**: No browser overhead, instant startup
- **Remote-friendly**: Works over SSH, in containers, on servers
- **Composable**: Pipe data between tools, script everything
- **Focused**: No distractions, no notifications, no ads
- **Lightweight**: Minimal resource usage
- **Accessible**: Works on any system with a terminal

---

## Comparison Matrix

### Visual Planning & Collaboration

| Feature | boxes-live | Miro | Lucidchart |
|---------|------------|------|------------|
| **Infinite canvas** | Yes | Yes | Yes |
| **Pan and zoom** | Yes | Yes | Yes |
| **Real-time collaboration** | Planned | Yes | Yes |
| **Works offline** | Yes | No | No |
| **Works over SSH** | Yes | No | No |
| **Startup time** | <100ms | 3-5s | 3-5s |
| **Memory usage** | ~5MB | ~500MB | ~400MB |
| **Keyboard-first** | Yes | Partial | Partial |
| **Cost** | Free | $8-16/mo | $7-15/mo |
| **Self-hosted** | Yes | No | No |

**boxes-live** excels when you need:
- Quick visual planning without leaving terminal
- Offline diagramming during travel
- Low-resource environments (CI/CD, remote servers)
- Scriptable canvas manipulation

---

### Context & Task Management

| Feature | my-context | Jira | Linear | Notion |
|---------|------------|------|--------|--------|
| **Task tracking** | Yes | Yes | Yes | Yes |
| **Session journaling** | Yes | No | No | Partial |
| **Decision logging** | Yes | Via comments | Via comments | Yes |
| **File associations** | Yes | No | No | No |
| **CLI-native** | Yes | No | No | No |
| **Works offline** | Yes | No | No | No |
| **Export to markdown** | Yes | Partial | Partial | Yes |
| **Startup time** | <50ms | N/A | N/A | N/A |
| **Database backend** | PostgreSQL | Cloud | Cloud | Cloud |
| **AI agent integration** | Native | Via API | Via API | Via API |
| **Cost** | Free | $7-14/mo | $8/mo | $8-15/mo |

**my-context** excels when you need:
- Track decisions during development sessions
- Maintain context across multi-day work
- Integrate with AI coding assistants
- Keep notes alongside code, not in a separate app

---

### Financial Tracking

| Feature | fintrack | Mint | YNAB | Quicken |
|---------|----------|------|------|---------|
| **Transaction tracking** | Yes | Yes | Yes | Yes |
| **Budgeting** | Yes | Yes | Yes | Yes |
| **Reports** | CLI tables | Web dashboard | Web/App | Desktop |
| **Bank sync** | Planned | Yes | Yes | Yes |
| **Data ownership** | Full | Limited | Limited | Full |
| **Privacy** | Local-first | Cloud | Cloud | Local |
| **Works offline** | Yes | No | Partial | Yes |
| **Scriptable** | Yes | No | No | No |
| **Cost** | Free | Free* | $15/mo | $50-100/yr |

*Mint discontinued new signups

**fintrack** excels when you need:
- Full control over financial data
- Automated reports via scripts/cron
- Integration with custom workflows
- Privacy-focused tracking

---

### Terminal Visualization

| Feature | terminal-stars | Web demos | Native apps |
|---------|----------------|-----------|-------------|
| **Smooth animation** | 60fps buffered | Varies | Varies |
| **Resource usage** | ~2MB | ~100MB+ | ~50MB+ |
| **Works over SSH** | Yes | No | No |
| **Educational value** | High (C code) | Low (hidden) | Medium |
| **Extensible** | Yes (fork/modify) | No | Sometimes |

**terminal-stars** excels when you need:
- Learn graphics programming fundamentals
- Create terminal-based visualizations
- Demonstrate physics/animation concepts
- Build screensavers for terminal environments

---

### Text Adventure Games

| Feature | adventure-engine-v2 | Inform 7 | Twine | ink |
|---------|---------------------|----------|-------|-----|
| **Parser-based** | Yes | Yes | No | No |
| **Terminal UI** | Smart terminal | Basic | No | No |
| **Story format** | Custom JSON | Inform | HTML | ink |
| **Learning curve** | Low | High | Low | Medium |
| **Extensible** | C code | Limited | JS | C# |
| **Works over SSH** | Yes | No | No | No |

**adventure-engine-v2** excels when you need:
- Create terminal-playable interactive fiction
- Learn game engine architecture
- Build educational text games
- SSH-friendly gaming

---

### Platform Games

| Feature | tario | Web games | Unity 2D |
|---------|-------|-----------|----------|
| **Platform** | Terminal | Browser | Desktop/Mobile |
| **Resource usage** | ~1MB | ~100MB+ | ~200MB+ |
| **Works over SSH** | Yes | No | No |
| **Development complexity** | Low | Medium | High |
| **Learning value** | High (C/physics) | Medium | Medium |
| **Frame buffer** | Custom ASCII | Canvas | Engine |

**tario** excels when you need:
- Learn game physics fundamentals
- Create games for constrained environments
- Nostalgic ASCII gaming experience
- Educational game development

---

## When to Choose Terminal Tools

### Choose terminal-first when:

1. **You live in the terminal** - Developers who use vim/neovim, tmux, and SSH daily
2. **Resources matter** - Constrained environments, older hardware, VMs, containers
3. **Offline is important** - Travel, unreliable internet, air-gapped systems
4. **Privacy is critical** - Sensitive data that shouldn't leave your machine
5. **Composability needed** - Unix pipes, scripting, automation
6. **Learning is the goal** - Understand how things work at a low level

### Choose enterprise tools when:

1. **Team collaboration** - Real-time multi-user editing is essential
2. **Rich media** - Images, videos, embedded content
3. **Non-technical users** - Team members unfamiliar with terminals
4. **Mobile access** - Need to access from phones/tablets
5. **Integrations** - Heavy reliance on specific SaaS integrations

---

## Feature Roadmap

### boxes-live
- [x] Pan and zoom
- [x] Box creation and editing
- [ ] Multi-user collaboration (network sync)
- [ ] Export to SVG/PNG
- [ ] Import from common formats

### my-context
- [x] Session tracking
- [x] Note journaling
- [x] File associations
- [x] PostgreSQL backend
- [x] Markdown export
- [ ] Cross-session search
- [ ] Analytics dashboard

### fintrack
- [x] Transaction entry
- [x] Category management
- [x] Reports
- [ ] Bank import (OFX/QIF)
- [ ] Investment tracking
- [ ] Multi-currency support

### terminal-stars
- [x] 60fps rendering
- [x] Frame buffering
- [x] Motion effects
- [ ] Color themes
- [ ] Configuration file

### tario
- [x] Side-scrolling physics
- [x] Platform collision
- [x] Smooth animation
- [ ] Level editor
- [ ] Custom sprites

### adventure-engine-v2
- [x] Parser engine
- [x] Smart terminal UI
- [x] Story loading
- [ ] Save/load games
- [ ] Scripted events

---

## Resource Comparison

### Memory Usage (typical)

```
Terminal tools:
  boxes-live       ~5 MB
  my-context       ~3 MB
  fintrack         ~8 MB
  terminal-stars   ~2 MB
  tario            ~1 MB
  adventure-engine ~2 MB

Enterprise web apps:
  Miro            ~500 MB (Chrome tab)
  Jira            ~400 MB (Chrome tab)
  Notion          ~350 MB (Chrome tab)
  Slack           ~300 MB (electron)
```

### Startup Time

```
Terminal tools:
  boxes-live       <100 ms
  my-context       <50 ms
  fintrack         <100 ms
  terminal-stars   <50 ms

Enterprise web apps:
  Miro            3-5 seconds
  Jira            5-10 seconds
  Notion          2-4 seconds
```

---

## Getting Started

### Quick Install

```bash
# Clone the organization's projects
for repo in boxes-live my-context fintrack terminal-stars tario adventure-engine-v2; do
  gh repo clone jcaldwell-labs/$repo ~/projects/$repo
done

# Build a C project
cd ~/projects/boxes-live
make

# Build a Go project
cd ~/projects/my-context
make build
```

### Try Each Tool

```bash
# Visual planning
./boxes-live

# Context tracking
my-context start "trying-out-$(date +%Y-%m-%d)"
my-context note "First impression: fast startup"
my-context stop

# Financial tracking
fintrack add expense --amount 15.99 --category food --description "Lunch"
fintrack report --month

# Starfield visualization
./terminal-stars

# Platform game
./tario

# Text adventure
./adventure-engine
```

---

## Migration Guides

### From Miro to boxes-live

If you use Miro for quick diagrams and brainstorming:

1. **Simplify your workflow** - boxes-live is for quick, text-based diagrams
2. **Learn the keybindings** - N for new box, Tab to select, arrows to move
3. **Export limitation** - Currently text-only, use for planning not presentation
4. **Best for**: Architecture diagrams, sprint boards, relationship maps

### From Notion to my-context

If you use Notion for project notes:

1. **Session-based** - my-context is designed for work sessions, not wikis
2. **Export regularly** - Use `my-context export` to create markdown archives
3. **File tracking** - Associate notes with actual files in your project
4. **Best for**: Development journals, decision logs, AI assistant context

### From Spreadsheets to fintrack

If you use Excel/Sheets for finances:

1. **CLI-first** - Commands replace manual cell entry
2. **PostgreSQL** - Structured data with proper queries
3. **Reports** - Built-in reporting replaces pivot tables
4. **Best for**: Personal finance tracking, expense categorization

---

## Contributing

See each project's README for contribution guidelines:

- [boxes-live](https://github.com/jcaldwell-labs/boxes-live)
- [my-context](https://github.com/jcaldwell-labs/my-context)
- [fintrack](https://github.com/jcaldwell-labs/fintrack)
- [terminal-stars](https://github.com/jcaldwell-labs/terminal-stars)
- [tario](https://github.com/jcaldwell-labs/tario)
- [adventure-engine-v2](https://github.com/jcaldwell-labs/adventure-engine-v2)

---

**Document Version**: 1.0
**Last Updated**: 2025-11-25
