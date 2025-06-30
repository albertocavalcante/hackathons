# CLAUDE.md - Hackathons Mono Repository

This file provides guidance to Claude Code (claude.ai/code) when working with code in this hackathons mono repository.

**📚 Quick Navigation**: [📖 Repository README](./README.md) • [🔧 GitHub Actions Setup](./.github/README.md) • [🚀 Modular Hackathon](./2025-06-29-modular-hack-weekend/README.md)

## Repository Overview

This is a mono repository for various hackathons and experimental projects, with each event organized in dated subdirectories. The repository serves as a central workspace for AI/ML hackathons, competitions, and proof-of-concept projects.

## Mono Repository Structure

```text
hackathons/ (mono repo root)
├── MODULE.bazel                              # Bazel workspace configuration
├── CLAUDE.md                                 # This file - general mono repo guidance
├── README.md                                 # Public-facing repository documentation
├── 2025-06-29-modular-hack-weekend/         # Modular AI hackathon project
│   ├── CLAUDE.md                             # Project-specific Claude guidance
│   ├── README.md                             # Project documentation
│   ├── Makefile                              # Project automation
│   ├── infrastructure/                       # Terraform infrastructure
│   └── modular-hackathon.code-workspace      # VS Code workspace
└── (future hackathons will be added here)
```

## General Development Principles

### Project Organization
- **Dated Directories**: Each hackathon/project uses format `YYYY-MM-DD-event-name`
- **Self-Contained**: Each project directory contains all necessary files and documentation
- **Consistent Structure**: Common patterns across projects for easier navigation
- **Isolated Dependencies**: Each project manages its own dependencies and infrastructure

### VS Code Workspace Integration
The repository integrates with VS Code multi-root workspaces:

```json
{
  "folders": [
    { "path": "./hackathons" },
    { "path": "../fork-modular" },
    { "path": "../fork-openai-whisper" },
    { "path": "../terraform-provider-lambda" },
    { "path": "../fork-tinygrad" }
  ]
}
```

### Cross-Project Knowledge Sharing
- **Common Patterns**: Reuse successful patterns across hackathons
- **Shared Infrastructure**: Common infrastructure patterns in separate projects
- **Documentation**: Each project maintains its own CLAUDE.md with specific guidance
- **Version Control**: Individual project evolution while maintaining mono repo benefits

## Working with Specific Projects

### Current Projects

1. **2025-06-29-modular-hack-weekend**: Modular AI hackathon focusing on MAX inference, Mojo programming, and cloud GPU infrastructure

### Navigation Guidelines

When working on a specific project:

1. **Change Directory**: Navigate to the specific project directory
2. **Read Project CLAUDE.md**: Each project has specific guidance and setup instructions
3. **Use Project Tools**: Each project may have its own Makefile, scripts, and workflows
4. **Respect Project Scope**: Keep changes isolated to the specific project unless making mono repo improvements

### Example Workflow

```bash
# Navigate to specific hackathon
cd 2025-06-29-modular-hack-weekend

# Read project-specific guidance
cat CLAUDE.md

# Use project-specific automation
make help
make cloud-setup
make plan apply
```

## Adding New Projects

When adding a new hackathon or project:

1. **Create Dated Directory**: Use format `YYYY-MM-DD-event-name`
2. **Copy Template Structure**: Base on existing successful project
3. **Create Project CLAUDE.md**: Specific guidance for the new project
4. **Update Root Documentation**: Add project to this file and root README.md
5. **Maintain Isolation**: Ensure new project doesn't interfere with existing ones

## Global Tools and Dependencies

### Required Tools (Workspace Level)
- **Git**: Version control across all projects
- **VS Code**: Multi-root workspace support
- **Docker**: Containerization for consistent environments
- **Bazel**: Build system coordination (via MODULE.bazel)

### Project-Specific Tools
Each project manages its own dependencies:
- Programming language runtimes
- Framework-specific tools
- Cloud provider CLIs
- Infrastructure tools (Terraform, etc.)

## Security and Best Practices

### Secrets Management
- **Never Commit Secrets**: Use environment variables and .gitignore
- **Project-Level .gitignore**: Each project protects its sensitive files
- **Cloud Credentials**: Store securely, reference via environment variables
- **API Keys**: Use secure credential management for each project

### Code Quality
- **Project Standards**: Each project may have different coding standards
- **Documentation**: Maintain project-specific documentation
- **Testing**: Each project implements appropriate testing strategies
- **Dependencies**: Keep project dependencies isolated and up-to-date

## Emergency Procedures

### Mono Repo Issues
- **Workspace Conflicts**: Navigate to specific project directory
- **Bazel Issues**: Check MODULE.bazel configuration
- **Cross-Project Dependencies**: Avoid or document explicitly

### Project Recovery
- **Backup Strategy**: Each project should implement appropriate backup
- **State Recovery**: Infrastructure projects should use remote state
- **Rollback Procedures**: Document rollback steps in project CLAUDE.md

## Contributing Guidelines

### Project-Level Changes
- Follow project-specific contribution guidelines
- Keep changes isolated to the specific project
- Update project documentation as needed

### Mono Repo Level Changes
- Update this file for structural changes
- Coordinate across projects when needed
- Maintain backward compatibility when possible

## Integration Points

### Shared Resources
- **Documentation Patterns**: Common documentation structure
- **Infrastructure Templates**: Reusable infrastructure patterns
- **Tooling Scripts**: Shared automation where beneficial
- **Knowledge Base**: Cross-project lessons learned

### External Integrations
- **Cloud Providers**: Each project manages its own cloud resources
- **CI/CD**: Project-specific automation and deployment
- **Monitoring**: Project-appropriate monitoring and logging
- **External APIs**: Project-specific API integrations

This mono repository structure provides flexibility for diverse hackathon projects while maintaining organization and enabling knowledge sharing across events and experiments.