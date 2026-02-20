# AgentHarmony - Agent System Documentation

Central documentation for all agents, subagents, and automated workflows in the AgentHarmony project.

---

## Table of Contents

- [Agent Overview](#agent-overview)
- [The 6-Stage Workflow](#the-6-stage-workflow)
- [Critical Rules (Never Violate)](#critical-rules-never-violate)
- [Subagent Directory](#subagent-directory)
- [Slash Commands with Subagents](#slash-commands-with-subagents)
- [Context Loading](#context-loading)
- [Session Management](#session-management)
- [Quick Reference](#quick-reference)

---

## Agent Overview

### Primary Agent: HarmonyAgent

**Role**: Universal coordinator for all tasks  
**Location**: `.opencode/agent/core/harmony-agent.md`  
**Philosophy**: Human-guided AI - AI proposes, human approves, AI executes

**Capabilities**:
- Answers questions (conversational mode)
- Executes tasks with approval gates
- Coordinates subagents for complex work
- Preserves context across multi-step workflows
- Loads relevant standards before coding

**When to Use**:
- General questions → Direct answer
- Simple tasks (1-3 files) → Execute directly
- Complex tasks (4+ files) → Delegate to subagents
- Context discovery → Use ContextSniffer first

---

## The 6-Stage Workflow

HarmonyAgent follows a systematic 6-stage workflow for all tasks:

```
Stage 1: ANALYZE
    ↓
Stage 2: DISCOVER CONTEXT (Always use ContextSniffer first)
    ↓
Stage 3: LOAD STANDARDS
    ↓
Stage 4: PROPOSE & GET APPROVAL ⚠️ (MANDATORY)
    ↓
Stage 5: EXECUTE
    ↓
Stage 6: VALIDATE & CONFIRM ⚠️ (MANDATORY)
```

### Stage 1: Analyze
- Determine if request is question or task
- Assess complexity
- Identify required resources

### Stage 2: Discover Context
**ALWAYS use ContextSniffer first**:

```javascript
task(
  subagent_type="ContextSniffer",
  description="Find context for {task}",
  prompt="Search .opencode/context/ for files relevant to: {task description}. Return ranked list with priorities."
)
```

### Stage 3: Load Standards
Before executing, load required context:

```
IF writing code:
  READ .opencode/context/core/standards/code-quality.md
  READ .opencode/context/project/tech-stack.md (if exists)

IF delegating:
  READ .opencode/context/core/workflows/task-delegation.md
```

### Stage 4: Propose & Approve ⚠️ (CRITICAL RULE)
Present plan to user and WAIT for explicit approval:

```
## Proposed Plan

**Task:** {description}

**Steps:**
1. {step 1}
2. {step 2}
3. {step 3}

**Files to modify:**
- {file 1}
- {file 2}

**Context loaded:**
- {context file 1}
- {context file 2}

**Approval needed before proceeding.**

Approve? [y/n/details]
```

### Stage 5: Execute
- Simple tasks: Execute directly
- Complex tasks: Delegate to subagents
- Track progress

### Stage 6: Validate & Confirm ⚠️ (CRITICAL RULE)
- Check quality (tests, linting, standards)
- Show summary of changes
- Ask user if satisfied
- Confirm cleanup of temporary files

---

## Critical Rules (Never Violate)

### Rule 1: Approval Gate (Absolute)
**NEVER** execute (write, edit, bash, task delegation) without explicit user approval.

**Applies to**:
- Writing files
- Editing files
- Running bash commands
- Delegating to subagents

**Does NOT apply to**:
- Reading files
- Searching/discovery
- Analyzing code

### Rule 2: Context-First (Always)
**ALWAYS** load relevant context before executing:

```
BEFORE writing code:
  → ContextSniffer discovers files
  → Load code-quality.md
  → Load project patterns
  → Then implement
```

### Rule 3: Stop on Failure (Mandatory)
On test failures or errors:

```
STOP → REPORT → PROPOSE FIX → WAIT APPROVAL → FIX
```

**Never auto-fix without permission!**

### Rule 4: Report Before Fix
When issues found:
1. STOP execution immediately
2. REPORT all issues clearly
3. PROPOSE fix plan with steps
4. REQUEST approval
5. Only then apply fixes

---

## Skills

### Available Skills

All skills are located in `.opencode/skills/`:

| Skill | Purpose | Location |
|-------|---------|-----------|
| **task-management** | Track and manage feature subtasks | `.opencode/skills/task-management/` |
| **code-simplifier** | Simplify and refine code | `.opencode/skills/code-simplifier/` |
| **frontend-design** | Create production-grade frontend interfaces | `.opencode/skills/frontend-design/` |
| **tailwind-design-system** | Build scalable design systems with Tailwind | `.opencode/skills/tailwind-design-system/` |
| **web-design-guidelines** | Web interface guidelines and accessibility | `.opencode/skills/web-design-guidelines/` |
| **vercel-react-best-practices** | React/Next.js performance optimization | `.opencode/skills/vercel-react-best-practices/` |
| **supabase-postgres-best-practices** | Postgres performance and best practices | `.opencode/skills/supabase-postgres-best-practices/` |
| **verification-before-completion** | Verification before completion | `.opencode/skills/verification-before-completion/` |

### Task Management Skill

The task-management skill provides CLI commands for tracking feature implementations:

```bash
# Show task status
bash .opencode/skills/task-management/router.sh status [feature]

# Show next eligible tasks
bash .opencode/skills/task-management/router.sh next [feature]

# Mark task complete
bash .opencode/skills/task-management/router.sh complete <feature> <seq> "summary"

# Validate tasks
bash .opencode/skills/task-management/router.sh validate [feature]
```

**Integration with TheConductor**: When TheConductor breaks down a feature, it creates task files in `.tmp/tasks/{feature}/` that this skill can track and manage.

---

## Subagent Directory

### Core Subagents

| Subagent | Purpose | When to Use |
|----------|---------|-------------|
| **ContextSniffer** | Discover context files | ALWAYS first for any task |
| **TheConductor** | Break down complex features | 4+ files, complex dependencies |
| **CoderAgent** | Implement code | Specific coding tasks |

### Subagent Invocation Pattern

```javascript
task(
  subagent_type="{SubagentName}",
  description="Brief description",
  prompt="Load context from {path} before starting.
  
  Task: {detailed description}
  
  Standards to follow:
  - {standard 1}
  - {standard 2}
  
  Expected output:
  - {output 1}
  - {output 2}"
)
```

---

## Slash Commands with Subagents

Use the Task tool with slash commands to invoke specialized workflows:

### Pattern

```javascript
task(
  subagent_type="[subagent-name]",
  prompt="/[command-name] [arguments]"
)
```

### Available Commands

#### Context Discovery
```javascript
// ALWAYS run this first for any task
task(
  subagent_type="ContextSniffer",
  prompt="/context/discover {task description}"
)
```

#### Task Breakdown
```javascript
// For complex features
task(
  subagent_type="TheConductor",
  prompt="/task/breakdown {feature description}"
)
```

#### Code Implementation
```javascript
// For specific coding tasks
task(
  subagent_type="CoderAgent",
  prompt="/code/implement {task} with context from {path}"
)
```

### Quick Reference Table

| Task | Command | Subagent |
|------|---------|----------|
| Discover context | `/context/discover` | `ContextSniffer` |
| Break down feature | `/task/breakdown` | `TheConductor` |
| Implement code | `/code/implement` | `CoderAgent` |

---

## Context Loading

### Context Hierarchy

Agents load context in this priority order:

1. **Core Standards** (universal patterns)
   - `.opencode/context/core/standards/code-quality.md`
   - `.opencode/context/core/standards/security-patterns.md`

2. **Workflows** (how to do things)
   - `.opencode/context/core/workflows/task-delegation.md`

3. **Project-Specific** (YOUR patterns) ← Most important!
   - `.opencode/context/project/README.md`
   - `.opencode/context/project/tech-stack.md`

**Project context overrides everything else!**

### Context Index

Quick reference for context files:

| Task Type | Load This |
|-----------|-----------|
| Write code | `core/standards/code-quality.md` |
| Security review | `core/standards/security-patterns.md` |
| Delegate task | `core/workflows/task-delegation.md` |
| Project patterns | `project/*.md` |

### Always Check Navigation

Before loading context, check:
```
.opencode/context/navigation.md
```

---

## Session Management

### When Sessions Are Created

Sessions are created **lazily** - only when needed for complex tasks:

```
Simple task (1-3 files) → No session
Complex task (4+ files) → Create session
```

### Session Structure

```
.tmp/sessions/{session-id}/
├── manifest.json          # Tracks all context files
├── features/              # Feature requirements
├── tasks/                 # Task breakdowns
├── code/                  # Implementation notes
└── documentation/         # Documentation context
```

### Session Lifecycle

1. **Create**: When complex task identified
2. **Populate**: Add context files with keywords
3. **Use**: Pass context paths to subagents
4. **Cleanup**: Ask user before deleting

### Cleanup Protocol ⚠️ (CRITICAL RULE)

**ALWAYS** confirm before cleanup:

```
Task complete. Is this satisfactory?

Should I clean up temporary session files at .tmp/sessions/{id}/?
```

**Never delete without explicit approval!**

---

## Quick Reference

### Workflow Checklist

For every task:

- [ ] Use ContextSniffer to discover relevant files
- [ ] Load required standards
- [ ] Create plan and show user
- [ ] **WAIT for approval before executing**
- [ ] Execute plan
- [ ] Use task-management skill to track progress
- [ ] Validate results
- [ ] Summarize changes
- [ ] **Confirm cleanup with user**

### Task Management Skill Commands

When working with TheConductor on complex features:

```bash
# Check overall progress
bash .opencode/skills/task-management/router.sh status

# Find next eligible tasks
bash .opencode/skills/task-management/router.sh next my-feature

# Mark task complete with summary
bash .opencode/skills/task-management/router.sh complete my-feature 05 "Implemented authentication module"

# Validate task files
bash .opencode/skills/task-management/router.sh validate my-feature

# Show dependency tree
bash .opencode/skills/task-management/router.sh deps my-feature 07

# Find parallelizable tasks
bash .opencode/skills/task-management/router.sh parallel my-feature
```

**Workflow Integration**:
1. TheConductor creates tasks in `.tmp/tasks/{feature}/`
2. Use skill commands to track and manage progress
3. Mark tasks complete as you finish them
4. Find next eligible tasks based on dependencies

### Execution Decision Tree

```
Receive Request
    ↓
Question? → Answer directly (no approval)
    ↓
Task?
    ↓
Simple (1-3 files)? → Execute directly (after approval)
    ↓
Complex (4+ files)? → Delegate to TheConductor
    ↓
Need context? → ContextSniffer first
```

### Response Patterns

**For Questions**:
- Answer directly and concisely
- No approval needed

**For Tasks**:
- Follow full 6-stage workflow
- Always get approval before execution
- Validate and confirm completion

**For Errors**:
- STOP execution
- REPORT issues clearly
- PROPOSE fix plan
- WAIT for approval
- Never auto-fix

---

## Best Practices

1. **Be Specific**: Clear requirements get better results
2. **Review Plans**: Take time to review before approving
3. **Use Multi-Step**: Break complex work into steps
4. **Leverage Subagents**: Let specialists handle their domains
5. **Clean Up**: Approve session cleanup when done
6. **Consistent Keywords**: Helps find related context
7. **Provide Feedback**: Refine patterns over time

---

## Configuration

HarmonyAgent is configured in `.opencode/agent/core/harmony-agent.md`. You can customize:

- Delegation thresholds
- Context loading behavior
- Critical rules enforcement
- Workflow stages

**Default delegation threshold**: 4+ files → delegate to TheConductor

---

Happy building! Remember: AI proposes, human approves, AI executes.
