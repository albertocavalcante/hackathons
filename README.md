# Hackathons Monorepo

A centralized workspace for AI/ML hackathons, competitions, and experimental projects. Each event is organized in dated directories with self-contained infrastructure and documentation.

## Repository Structure

```text
hackathons/
├── .github/workflows/              # CI/CD automation (GitHub requirement)
├── .github/scripts/                # Shared automation scripts
├── 2025-06-29-modular-hack-weekend/ # Modular AI hackathon project
├── CLAUDE.md                       # Development guidance for AI tools
├── .gitattributes                  # Merge strategies for seamless rebases
├── .gitconfig                      # Enhanced git configuration
└── README.md                       # This file
```

> **Note**: GitHub workflows are located at the repository root because GitHub only supports workflows in `.github/workflows/` regardless of monorepo structure.

## Projects

### 2025-06-29-modular-hack-weekend
Modular Platform hackathon focusing on MAX inference, Mojo programming, and cloud GPU infrastructure. See [project README](./2025-06-29-modular-hack-weekend/README.md) for details.

## Development Workflow

### Getting Started
1. Navigate to the specific project directory
2. Read the project's README.md for setup instructions
3. Use the project's Makefile for automation commands
4. Open the VS Code workspace file for integrated development

### Adding New Projects
1. Create directory using format: `YYYY-MM-DD-event-name`
2. Copy structure from existing project as template
3. Update project-specific documentation
4. Add entry to this README

### Git Workflow Enhancement
This repository includes tools for seamless post-squash-merge rebases:
- **Smart rebase helper**: `.github/scripts/post-squash-rebase.sh`
- **Makefile command**: `make post-squash-rebase`
- **Git configuration**: Enhanced merge strategies and conflict resolution

## Workspace Integration

Each project includes a VS Code workspace file that integrates:
- This monorepo for organization and shared infrastructure
- External forks and dependencies for project-specific technologies
- Coordinated development across multiple repositories while maintaining isolation

## Project Organization Standards

```text
YYYY-MM-DD-event-name/
├── README.md                    # Project overview and setup
├── CLAUDE.md                    # AI development guidance
├── Makefile                     # Project automation
├── infrastructure/              # Cloud infrastructure code
├── *.code-workspace            # VS Code workspace integration
└── (project-specific files)
```

---

**Getting started?** Navigate to a project directory and follow its README.  
**Adding a project?** Use the dated directory format and project template structure.  
**Need help?** Check project documentation or [CLAUDE.md](./CLAUDE.md) for development guidance.
