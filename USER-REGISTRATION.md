# User Registration Guide

Welcome to **jcaldwell-labs**! This guide explains how to get started with our terminal-based open source projects.

## About jcaldwell-labs

jcaldwell-labs is an organization developing Unix philosophy-inspired terminal tools that compete with modern enterprise suites using only terminal-based interfaces.

### Our Projects

| Project | Purpose | Status |
|---------|---------|--------|
| [my-context](https://github.com/jcaldwell-labs/my-context) | Agent journal and context management CLI | Production Ready |
| [fintrack](https://github.com/jcaldwell-labs/fintrack) | Financial tracking and analysis tool | Active Development |
| [boxes-live](https://github.com/jcaldwell-labs/boxes-live) | Terminal-based interactive canvas (Miro alternative) | Active Development |
| [terminal-stars](https://github.com/jcaldwell-labs/terminal-stars) | Starfield visualization with frame buffering | Active Development |
| [tario](https://github.com/jcaldwell-labs/tario) | ASCII side-scrolling platformer game | Active Development |
| [adventure-engine-v2](https://github.com/jcaldwell-labs/adventure-engine-v2) | Text adventure engine with smart terminal UI | Active Development |
| [smartterm-prototype](https://github.com/jcaldwell-labs/smartterm-prototype) | Terminal UI library proof-of-concept | Active Development |
| [atari-style](https://github.com/jcaldwell-labs/atari-style) | Terminal arcade games | Active Development |

## Getting Started

### 1. Create a GitHub Account

If you don't already have one:
1. Visit [github.com](https://github.com)
2. Click "Sign up"
3. Follow the registration process

### 2. Explore Our Projects

Browse our repositories at [github.com/jcaldwell-labs](https://github.com/jcaldwell-labs):
- Read the README files
- Check out the documentation
- Try running the projects locally

### 3. Join the Community

- **Watch** repositories you're interested in to get notifications
- **Star** projects you find useful
- **Fork** projects you want to contribute to

## Contributing

We welcome contributions! Here's how to get involved:

### For Users

1. **Install and use our tools**
   - Each project has installation instructions in its README
   - Report bugs or issues you encounter
   - Suggest features or improvements

2. **Provide feedback**
   - Open issues for bugs or feature requests
   - Share your use cases and experiences
   - Help improve documentation

### For Developers

1. **Find a project to contribute to**
   - Check open issues labeled `good-first-issue` or `help-wanted`
   - Review the project's CONTRIBUTING.md if available
   - Join discussions in existing issues

2. **Set up your development environment**
   ```bash
   # Fork the repository on GitHub
   # Clone your fork
   gh repo clone <your-username>/<project-name>
   cd <project-name>
   
   # Add upstream remote
   git remote add upstream https://github.com/jcaldwell-labs/<project-name>
   
   # Create a feature branch
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the coding style of the project
   - Write tests if applicable
   - Update documentation as needed
   - Keep commits focused and atomic

4. **Submit a pull request**
   ```bash
   # Push your changes
   git push origin feature/your-feature-name
   
   # Create a pull request via GitHub
   gh pr create --fill
   ```

## Development Philosophy

All jcaldwell-labs projects follow the Unix philosophy:

- **Do one thing well**: Each tool has a focused purpose
- **Work together**: Tools compose via pipes and scripting
- **Handle text/data streams**: Everything is scriptable
- **Terminal-first**: No GUI dependencies, works over SSH

## Code of Conduct

We are committed to providing a welcoming and inclusive environment:

- Be respectful and professional
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Report any concerning behavior to project maintainers

## Getting Help

- **Documentation**: Each project has its own README and docs
- **Issues**: Open an issue in the relevant repository
- **Discussions**: Use GitHub Discussions for questions and ideas
- **Email**: Contact maintainers listed in project READMEs

## Tools You'll Need

Depending on which projects you work with, you may need:

### For C Projects (boxes-live, terminal-stars, tario, adventure-engine-v2, smartterm-prototype)
- GCC or Clang compiler
- ncurses library
- make

### For Go Projects (my-context, fintrack)
- Go 1.19 or later
- Standard Go toolchain

### For Python Projects (atari-style)
- Python 3.8 or later
- pip for package management

### General Tools
- Git for version control
- GitHub CLI (optional but recommended): `gh`
- tmux or screen (for testing terminal apps)

## Next Steps

1. Create your GitHub account (if needed)
2. Star repositories you're interested in
3. Pick a project to explore
4. Clone it and try it out
5. Find an issue to work on or report a bug
6. Submit your first contribution!

## Resources

- **Organization**: https://github.com/jcaldwell-labs
- **Coordination Workspace**: This repository - for project management
- **Roadmap**: See [ROADMAP-2025.md](ROADMAP-2025.md) for future plans

---

**Welcome aboard!** We're excited to have you join the jcaldwell-labs community. Whether you're here to use our tools, report bugs, improve documentation, or contribute code, your participation is valued.
