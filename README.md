# AgentHarmony

A lightweight, extensible AI agent framework focused on **context-aware execution** and **human-guided workflows**.

## 🎯 Philosophy

AgentHarmony believes that AI should augment human decision-making, not replace it. Every action requires approval, every pattern is customizable, and every agent is transparent.

## 🚀 Quick Start

```bash
# Make the runner executable
chmod +x scripts/run.sh

# Run your first command
./scripts/run.sh "Create a simple calculator function"
```

## 📁 Structure

```
AgentHarmony/
├── .opencode/
│   ├── agent/
│   │   ├── core/
│   │   │   └── harmony-agent.md      # Primary agent
│   │   └── subagents/
│   │       ├── core/
│   │       │   ├── context-scout.md   # Discovers relevant context
│   │       │   └── task-manager.md    # Breaks down complex tasks
│   │       └── code/
│   │           └── coder-agent.md     # Code implementation specialist
│   ├── context/
│   │   ├── core/
│   │   │   ├── standards/
│   │   │   │   ├── code-quality.md    # Coding standards
│   │   │   │   └── security-patterns.md
│   │   │   └── workflows/
│   │   │       └── task-delegation.md
│   │   └── project/                   # Your custom patterns
│   │       └── README.md
│   └── skill/
│       └── task-management/
│           └── SKILL.md
├── scripts/
│   └── run.sh                         # Main runner
├── docs/
│   └── architecture.md
└── README.md                          # This file
```

## 🎭 Core Concepts

### 1. Context-First Execution

Before doing anything, agents load relevant context:

```
User Request
    ↓
ContextSniffer discovers patterns
    ↓
Agent loads YOUR standards
    ↓
Code matches your project ✅
```

### 2. Approval Gates

Agents **always** ask before:
- Writing files
- Editing code
- Running commands
- Delegating tasks

### 3. Editable Agents

All agents are markdown files. Edit them directly:

```bash
nano .opencode/agent/core/harmony-agent.md
```

## 🛠️ Customization

### Add Your Coding Patterns

Edit `.opencode/context/project/tech-stack.md`:

```markdown
# My Tech Stack

## Framework
- Next.js 14 with App Router
- TypeScript with strict mode
- Tailwind CSS

## Patterns
- API routes use Zod validation
- Components are Server Components by default
- Database: Prisma with PostgreSQL

## Example API Route
```typescript
// Good pattern
export async function POST(req: Request) {
  const body = await req.json();
  const validated = userSchema.parse(body);
  const user = await prisma.user.create({ data: validated });
  return Response.json(user, { status: 201 });
}
```
```

### Create New Subagents

Add specialized agents in `.opencode/agent/subagents/`:

```markdown
---
name: FrontendSpecialist
description: "React/Next.js specialist"
mode: subagent
---

## Expertise
- React Server Components
- Tailwind CSS
- Next.js App Router

## Process
1. Check for existing component patterns
2. Follow project naming conventions
3. Include proper TypeScript types
4. Add JSDoc comments
```

## 📖 Workflow

1. **Analyze** - Agent understands your request
2. **Discover** - ContextSniffer finds relevant patterns
3. **Load** - Agent reads your standards
4. **Propose** - Plan presented for approval
5. **Execute** - Implementation with validation
6. **Validate** - Quality checks
7. **Summarize** - Completion report

## 🚧 Roadmap

- [ ] Plugin system for npm packages
- [ ] External documentation fetching
- [ ] Parallel task execution
- [ ] Web UI for visualization
- [ ] Team context sharing

## 🤝 Contributing

1. Agents are markdown - edit freely
2. Context is king - add your patterns
3. Approval is required - never auto-execute
4. Test your changes

## 📄 License

MIT License - See LICENSE file

---

**Built with ❤️ for humans who want AI that understands their code.**
