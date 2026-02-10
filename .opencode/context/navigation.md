# Context Navigation

Quick reference for finding context files.

## Core Standards

| File | Purpose | Priority |
|------|---------|----------|
| [core/standards/code-quality.md](core/standards/code-quality.md) | Coding standards, patterns, anti-patterns | Critical |
| [core/standards/security-patterns.md](core/standards/security-patterns.md) | Security requirements, validation | Critical |

## Workflows

| File | Purpose | Priority |
|------|---------|----------|
| [core/workflows/task-delegation.md](core/workflows/task-delegation.md) | How to delegate to subagents | High |

## Project Intelligence

| File | Purpose | Priority |
|------|---------|----------|
| [project/README.md](project/README.md) | Template for your patterns | High |

Add your own patterns to the `project/` directory.

## Quick Lookup by Task

### Writing Code
1. Load: `core/standards/code-quality.md`
2. Load: `project/tech-stack.md` (your patterns)
3. Delegate to: CoderAgent

### Security Review
1. Load: `core/standards/security-patterns.md`
2. Check: validation, auth, authorization

### Complex Feature
1. Delegate to: TaskManager
2. Execute subtasks with context

### Finding Patterns
1. Delegate to: ContextScout
2. Load discovered files

## Tags

<!-- Priority: critical -->
- code-quality.md
- security-patterns.md

<!-- Priority: high -->
- task-delegation.md
- project/*.md

<!-- Priority: medium -->
- skill definitions
- examples
