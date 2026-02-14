# Context Navigation

Quick reference for finding context files.

---

## Core Standards (Critical Priority)

| File | Purpose | When to Load |
|------|---------|--------------|
| [core/standards/code-quality.md](core/standards/code-quality.md) | Coding standards, patterns, anti-patterns | BEFORE any coding task |
| [core/standards/security-patterns.md](core/standards/security-patterns.md) | Security requirements, validation | BEFORE auth/data tasks |

---

## Workflows (High Priority)

| File | Purpose | When to Load |
|------|---------|--------------|
| [core/workflows/task-delegation.md](core/workflows/task-delegation.md) | How to delegate to subagents | BEFORE delegating |
| [core/workflows/sessions.md](core/workflows/sessions.md) | Session management | FOR complex tasks |

---

## Project Intelligence (High Priority)

| File | Purpose | When to Load |
|------|---------|--------------|
| [project/README.md](project/README.md) | Project-specific patterns | BEFORE any task |

Add your own patterns to the `project/` directory.

---

## Quick Lookup by Task

### Starting Any Task
1. **ALWAYS run first**: ContextSniffer with `/context/discover`
2. Load critical standards based on task type
3. Load project patterns

### Writing Code
1. **Load**: `core/standards/code-quality.md`
2. **Load**: `core/standards/security-patterns.md` (if auth/data)
3. **Load**: `project/tech-stack.md` (your patterns)
4. **Delegate to**: CoderAgent

### Complex Feature
1. **Load**: `core/workflows/task-delegation.md`
2. **Load**: `core/workflows/sessions.md`
3. **Delegate to**: TheConductor
4. **Use skill**: `bash .opencode/skills/task-management/router.sh next {feature}`
5. Execute subtasks and mark complete with skill

### Finding Patterns
1. **Delegate to**: ContextSniffer
2. Load discovered files
3. Follow loaded standards

---

## Skills

### Task Management Skill

Track and manage feature implementations:

```bash
# Check status
bash .opencode/skills/task-management/router.sh status [feature]

# Find next eligible tasks
bash .opencode/skills/task-management/router.sh next [feature]

# Mark task complete
bash .opencode/skills/task-management/router.sh complete <feature> <seq> "summary"

# Validate tasks
bash .opencode/skills/task-management/router.sh validate [feature]
```

**Location**: `.opencode/skills/task-management/SKILL.md`

---

## Workflow Reminder

```
FOR EVERY TASK:

1. ANALYZE
   ↓
2. DISCOVER CONTEXT (ContextSniffer) ⚠️ MANDATORY
   ↓
3. LOAD STANDARDS
   ↓
4. PROPOSE PLAN → GET APPROVAL ⚠️ MANDATORY
   ↓
5. EXECUTE
   ↓
6. VALIDATE & CONFIRM ⚠️ MANDATORY
```

---

## Critical Rules Reference

1. ⚠️ **Approval Gate**: Always ask before execution
2. ⚠️ **Context-First**: Always discover context first
3. ⚠️ **Stop on Failure**: Report before fixing
4. ⚠️ **Confirm Cleanup**: Ask before deleting

---

## Tags

<!-- Priority: critical -->
- code-quality.md
- security-patterns.md

<!-- Priority: high -->
- task-delegation.md
- sessions.md
- project/*.md

<!-- Priority: medium -->
- skill definitions
- examples
