# Hackathons Mono Repository

A centralized workspace for AI/ML hackathons, competitions, and experimental projects. Each event is organized in dated directories with self-contained infrastructure and documentation.

## 🎯 Active Projects

### 🚀 [Modular AI Hackathon (June 29, 2025)](./2025-06-29-modular-hack-weekend/)

Modular Platform, MAX inference, Mojo programming, cloud GPU infrastructure

---

## 🏗️ Repository Structure

```text
hackathons/
├── .github/workflows/           # CI/CD with Terraform validation
├── 2025-06-29-modular-hack-weekend/    # Current hackathon project
├── CLAUDE.md                   # Development guidance for Claude Code
└── README.md                   # This file
```

## 🛠️ Workspace Integration

This mono repository works with external forks and dependencies through VS Code multi-root workspaces. Each hackathon project includes a `.code-workspace` file that integrates:

- **This mono repository**: Central organization and infrastructure
- **External forks**: Project-specific technology repositories
- **Common patterns**: Shared automation and documentation structure

The workspace approach enables coordinated development across multiple related repositories while maintaining project isolation.

## 📁 Project Organization

### Directory Naming Convention

- **Format**: `YYYY-MM-DD-event-name`
- **Example**: `2025-06-29-modular-hack-weekend`

### Standard Project Structure

```text
YYYY-MM-DD-event-name/
├── README.md                   # Project overview and setup guide
├── CLAUDE.md                   # Development guidance
├── Makefile                    # Project automation
├── infrastructure/             # Terraform infrastructure code
├── *.code-workspace           # VS Code workspace integration
└── (project-specific files)
```

## 🚀 Getting Started

1. **Choose a project** from the active projects list above
2. **Navigate to project directory** and read its README.md
3. **Open VS Code workspace** for integrated development experience
4. **Follow project-specific setup** instructions and automation

## 🤝 Contributing

### Adding New Hackathons

1. Create dated directory: `YYYY-MM-DD-event-name`
2. Copy structure from existing successful project
3. Update project documentation
4. Add project link to this README

### Development Workflow

- Each project is self-contained with its own infrastructure
- Use project-specific Makefiles for automation
- Follow CI/CD patterns established in `.github/workflows/`
- Maintain documentation for future reference

---

**🚀 Ready to start?** Choose a project above and follow its README for complete setup instructions.

**💡 New hackathon?** Create a dated directory and follow the project template structure.

**📚 Need help?** Check project-specific documentation or [CLAUDE.md](./CLAUDE.md) for development guidance.
