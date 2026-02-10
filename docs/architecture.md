# Architecture Overview

This document explains the architecture of AgentHarmony.

## Design Principles

### 1. Human-Guided AI
AI proposes, humans approve. Every significant action requires explicit approval.

### 2. Context-First
Agents load context before acting. Code matches your patterns from the start.

### 3. Transparency
All agents are editable markdown. No black boxes, no vendor lock-in.

### 4. Modularity
Small, focused components that compose together.

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      User Interface                          │
│                     (CLI / Scripts)                          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    HarmonyAgent (Primary)                    │
│              - Orchestrates workflow                         │
│              - Loads context                                  │
│              - Manages approval gates                        │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
    ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
    │ContextScout  │  │ TaskManager  │  │ CoderAgent   │
    │              │  │              │  │              │
    │Discovers     │  │Breaks down   │  │Implements    │
    │context files │  │complex tasks │  │code          │
    └──────────────┘  └──────────────┘  └──────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Context System                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Core       │  │  Project     │  │   Skill      │       │
│  │  Standards   │  │ Intelligence │  │  Definitions │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

## Component Details

### Agents

All agents are markdown files with YAML frontmatter.

**Structure:**
```markdown
---
name: AgentName
description: "What this agent does"
mode: primary|subagent
temperature: 0.2
permission:
  bash:
    "*": "ask"
---

<context>
  <system_context>...</system_context>
</context>

<workflow>
  <stage>...</stage>
</workflow>
```

**Agent Types:**
- **Primary**: User-facing agents (HarmonyAgent)
- **Subagent**: Specialized workers (ContextScout, CoderAgent)

### Context System

Context provides patterns and standards to agents.

**Context Types:**
- **Core**: Universal standards (code-quality, security)
- **Project**: Your custom patterns (tech-stack, conventions)
- **Skill**: Reusable workflows

**Loading Process:**
1. ContextScout discovers relevant files
2. Agent reads context files
3. Patterns applied to output

### Skills

Skills define reusable workflows and commands.

**Structure:**
- SKILL.md file with metadata
- Command definitions
- Subagent integration

## Workflow

```
1. User Request
        ↓
2. HarmonyAgent analyzes
        ↓
3. ContextScout discovers context
        ↓
4. Agent loads standards
        ↓
5. Propose plan → User approves
        ↓
6. Execute (direct or delegate)
        ↓
7. Validate
        ↓
8. Summarize
```

## Security Model

### Approval Gates
- All file writes require approval
- All command execution requires approval
- All delegation requires approval

### Permission System
- Defined in agent frontmatter
- Pattern-based rules
- Override capabilities

### Context Isolation
- Project context only loads from local
- No external context injection
- User controls all patterns

## Extensibility

### Adding Agents
1. Create markdown file in `.opencode/agent/`
2. Define frontmatter with permissions
3. Add workflow and rules
4. Reference from other agents

### Adding Context
1. Create markdown in `.opencode/context/`
2. Add priority metadata
3. Reference from ContextScout
4. Load in relevant agents

### Adding Skills
1. Create SKILL.md file
2. Define commands
3. Add subagent integration
4. Document usage

## Data Flow

```
User Input
    ↓
Agent (loaded with context)
    ↓
Decision: Direct or Delegate?
    ↓
    ├─→ Direct: Execute with context
    └─→ Delegate: Pass context bundle
            ↓
        Subagent (loaded with context)
            ↓
        Execute
            ↓
        Return to Agent
    ↓
Validate
    ↓
Output
```

## Future Enhancements

- Plugin system for npm packages
- Web UI for visualization
- Parallel execution
- External documentation fetching
- Multi-language support
