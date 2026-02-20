# AgentHarmony

A comprehensive AI orchestration system with specialized subagents for software development tasks.

## Quick Start - Install in Any Project

Install the AgentHarmony `.opencode` configuration in any project with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/rchiarino/AgentHarmony/main/install.sh | bash
```

Or download and run manually:

```bash
curl -fsSL https://raw.githubusercontent.com/rchiarino/AgentHarmony/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

### What Gets Installed?

The installer downloads only the `.opencode/` directory containing:
- **Agent configurations** - Custom agent definitions and subagents
- **Context files** - Project standards and navigation
- **Skills** - Reusable skill definitions (task-management, code-simplifier)
- **Commands** - Pre-defined command templates

### Handling Existing Installations

If `.opencode` already exists, the installer will prompt you to:
1. **Overwrite** - Delete existing and install fresh
2. **Backup** - Create a timestamped backup before installing
3. **Cancel** - Exit without changes

## Features

- **Human-Guided AI**: AI proposes, human approves, AI executes
- **Context-First**: Automatic context discovery and loading
- **Multi-Agent System**: Specialized agents for different tasks
  - **HarmonyAgent** - Primary orchestrator
  - **TheConductor** - Task breakdown specialist
  - **ContextSniffer** - Context discovery
  - **CoderAgent** - Code implementation
- **Built-in Skills**: Task management and code simplification

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    AGENTHARMONY SYSTEM                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────┐                                        │
│  │  HarmonyAgent   │  ← Primary Orchestrator                │
│  │  (You are here) │                                        │
│  └────────┬────────┘                                        │
│           │                                                  │
│     ┌─────┴─────┬─────────────┬─────────────┐               │
│     ▼           ▼             ▼             ▼               │
│  ┌──────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │Conduc│  │Context   │  │Code      │  │Review    │        │
│  │tor   │  │Sniffer   │  │Coder     │  │(coming)  │        │
│  └──────┘  └──────────┘  └──────────┘  └──────────┘        │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  SKILLS                                             │   │
│  │  • Task Management CLI (.opencode/skills/task-management/) │
│  │  • Code Simplifier    (.opencode/skills/code-simplifier/)  │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Documentation

- [AGENTS.md](.opencode/AGENTS.md) - Agent descriptions and capabilities
- [.opencode/context/navigation.md](.opencode/context/navigation.md) - Project navigation guide
- [.opencode/skills/task-management/SKILL.md](.opencode/skills/task-management/SKILL.md) - Task management documentation
- [.opencode/skills/code-simplifier/SKILL.md](.opencode/skills/code-simplifier/SKILL.md) - Code simplification documentation

## Repository Structure

```
AgentHarmony/
├── .opencode/                        # OpenCode configuration and skills
│   ├── agent/                        # Agent definitions
│   │   ├── core/                     # Core agents
│   │   └── subagents/                # Specialized subagents
│   ├── context/                      # Context files for agents
│   │   ├── core/                     # Core context
│   │   └── project/                  # Project-specific context
│   ├── skills/                       # Skill definitions
│   │   ├── task-management/          # Task tracking CLI
│   │   ├── code-simplifier/          # Code simplification
│   │   ├── frontend-design/          # Frontend design patterns
│   │   ├── tailwind-design-system/  # Tailwind design system
│   │   ├── web-design-guidelines/    # Web design guidelines
│   │   ├── vercel-react-best-practices/ # React performance
│   │   ├── supabase-postgres-best-practices/ # Postgres optimization
│   │   └── verification-before-completion/ # Verification skill
│   ├── context/                  # Context files
│   │   ├── core/                 # Core standards
│   │   └── project/              # Project-specific
│   ├── commands/                 # Command templates
│   └── config/                  # Configuration files
├── install-opencode.sh           # Installation script
├── LICENSE                       # License
└── README.md                     # This file
```

## License

MIT License - See [LICENSE](LICENSE) for details.

## Contributing

This is a personal configuration system. Feel free to fork and customize for your needs!

## Author

**rchiarino** - [GitHub](https://github.com/rchiarino)
