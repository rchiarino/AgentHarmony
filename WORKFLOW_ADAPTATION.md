# AgentHarmony - OpenCode Workflow Adaptation

## Overview

Your OpenCode settings have been adapted to follow the **OpenAgentsControl workflow** with:
- 6-stage systematic workflow
- Context-first discovery with ContextSniffer
- Mandatory approval gates
- Session management for complex tasks
- Task-management skill integration
- Clear delegation patterns

---

## What Was Created/Updated

### 1. Central Documentation
- **`.opencode/AGENTS.md`** - Central agent documentation with:
  - 6-stage workflow explanation
  - Critical rules (absolute enforcement)
  - Subagent directory and routing
  - Slash command patterns
  - Context loading hierarchy
  - Session management guide

### 2. Enhanced Primary Agent
- **`.opencode/agent/core/harmony-agent.md`** - Updated with:
  - 6-stage workflow (Analyze → Discover → Load → Approve → Execute → Validate)
  - 4 CRITICAL RULES (never violate)
  - Detailed execution paths
  - Session management integration
  - Error handling protocols
  - Context-first philosophy

### 3. Command Templates
Created slash command templates for subagents:
- **`.opencode/commands/context/discover.md`** - Context discovery
- **`.opencode/commands/task/breakdown.md`** - Task decomposition
- **`.opencode/commands/code/implement.md`** - Code implementation

### 4. Session Management
- **`.opencode/context/core/workflows/sessions.md`** - Complete guide on:
  - When to create sessions
  - Session structure
  - Context preservation
  - Cleanup protocols

### 5. Updated Navigation
- **`.opencode/context/navigation.md`** - Quick reference with:
  - File priorities
  - Workflow reminder
  - Critical rules reference

---

## The 6-Stage Workflow

Every task now follows this workflow:

```
┌──────────────────────────────────────────────────────────────┐
│  Stage 1: ANALYZE                                            │
│  • Determine if question or task                             │
│  • Assess complexity                                         │
└────────────────────┬─────────────────────────────────────────┘
                     ↓
┌──────────────────────────────────────────────────────────────┐
│  Stage 2: DISCOVER CONTEXT ⚠️ MANDATORY                      │
│  • ALWAYS use ContextSniffer first                             │
│  • Find relevant context files                               │
│  • Rank by priority (critical/high/medium/low)               │
└────────────────────┬─────────────────────────────────────────┘
                     ↓
┌──────────────────────────────────────────────────────────────┐
│  Stage 3: LOAD STANDARDS                                     │
│  • Load critical context files                               │
│  • Load project-specific patterns                            │
│  • Prepare execution context                                 │
└────────────────────┬─────────────────────────────────────────┘
                     ↓
┌──────────────────────────────────────────────────────────────┐
│  Stage 4: PROPOSE & GET APPROVAL ⚠️ MANDATORY                │
│  • Create detailed plan                                      │
│  • Show user for review                                      │
│  • WAIT for explicit approval                                │
│  • NEVER execute without approval                            │
└────────────────────┬─────────────────────────────────────────┘
                     ↓
┌──────────────────────────────────────────────────────────────┐
│  Stage 5: EXECUTE                                            │
│  • Simple tasks: Execute directly                            │
│  • Complex tasks: Delegate to subagents                      │
│  • Track progress                                            │
└────────────────────┬─────────────────────────────────────────┘
                     ↓
┌──────────────────────────────────────────────────────────────┐
│  Stage 6: VALIDATE & CONFIRM ⚠️ MANDATORY                    │
│  • Run tests/validation                                      │
│  • Report results                                            │
│  • Summarize changes                                         │
│  • Confirm completion                                        │
│  • Ask before cleanup                                        │
└──────────────────────────────────────────────────────────────┘
```

---

## Critical Rules (Absolute)

### ⚠️ Rule 1: Approval Gate
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

### ⚠️ Rule 2: Context-First
**ALWAYS** use ContextSniffer first to discover relevant context files before executing.

```javascript
// ALWAYS run this first
task(
  subagent_type="ContextSniffer",
  description="Find context for {task}",
  prompt="Search .opencode/context/ for files relevant to: {task}"
)
```

### ⚠️ Rule 3: Stop on Failure
On test failures or errors:

```
STOP → REPORT → PROPOSE FIX → WAIT APPROVAL → FIX
```

**Never auto-fix without permission!**

### ⚠️ Rule 4: Confirm Cleanup
**ALWAYS** confirm before deleting session files or cleanup operations.

---

## How to Use

### For Simple Questions
Just ask - HarmonyAgent will answer directly without approval.

Example: "What does this function do?"

### For Tasks
HarmonyAgent will:
1. Use ContextSniffer to discover relevant files
2. Load required standards
3. Create a plan
4. **Show you the plan and WAIT for approval**
5. Execute after you approve
6. Validate and confirm completion

Example: "Create a React component"

### For Complex Features
HarmonyAgent will:
1. Discover context
2. Delegate to TaskManager for breakdown
3. Show you the plan
4. **WAIT for your approval**
5. Execute subtasks with task-management skill tracking
6. Validate and confirm

Example: "Build user authentication system"

---

## Delegation Patterns

### Simple Task (1-3 files)
```
You ask → HarmonyAgent executes directly (after approval)
```

### Complex Task (4+ files)
```
You ask → HarmonyAgent delegates to TaskManager → 
TaskManager creates breakdown → 
HarmonyAgent shows plan → 
You approve → 
HarmonyAgent executes subtasks
```

### Coding Task
```
You ask → ContextSniffer discovers files → 
HarmonyAgent loads standards → 
Shows plan → You approve → 
Delegates to CoderAgent → 
CoderAgent implements → 
HarmonyAgent validates
```

---

## Example Workflow

### User Request
```
User: "Build a user authentication system with login and signup"
```

### HarmonyAgent Response

**Stage 1-2: Analyze & Discover**
```
I'll help you build a user authentication system. Let me first discover relevant context files.

[Calls ContextSniffer]

Context discovered:
- core/standards/code-quality.md (critical - coding standards)
- core/standards/security-patterns.md (critical - auth security)
- core/workflows/task-delegation.md (high - for task breakdown)
```

**Stage 3-4: Load & Propose**
```
## Proposed Plan

**Task:** Build user authentication system

**Context Discovered:**
- core/standards/code-quality.md - Coding standards
- core/standards/security-patterns.md - Auth security requirements
- core/workflows/task-delegation.md - Task breakdown process

**Steps:**
1. Create session for context preservation
2. Delegate to TaskManager for task breakdown
3. Create database schema
4. Implement auth utilities (hashing, tokens)
5. Create API endpoints
6. Build UI components
7. Add middleware
8. Validate and test

**Files to be created:**
- Database schema
- Auth utilities
- API routes
- UI components

**Approval needed before proceeding.**

Do you approve this plan? [yes/no/modify]
```

**Stage 5-6: Execute & Validate**
```
[User: "yes"]

[HarmonyAgent executes plan with subagents]

## Summary

**Task Completed:** User authentication system

**Files Created:**
- src/db/schema.ts - User model
- src/lib/auth.ts - Auth utilities
- src/app/api/auth/* - API routes
- src/components/auth/* - UI components

**Validation:**
- ✅ All tests passing
- ✅ Security patterns followed
- ✅ Code quality standards met

**Next Steps:**
- Review the implementation
- Test login/signup flows
- Add any additional features

Is this complete and satisfactory?
Should I clean up temporary session files? [yes/no/keep]
```

---

## Task Management Skill

When TaskManager breaks down complex features, the task-management skill tracks and manages progress.

### Skill Commands

```bash
# Check overall status
bash .opencode/skills/task-management/router.sh status [feature]

# Find next eligible tasks (dependencies satisfied)
bash .opencode/skills/task-management/router.sh next [feature]

# Mark task complete with summary
bash .opencode/skills/task-management/router.sh complete <feature> <seq> "summary"

# Validate task integrity
bash .opencode/skills/task-management/router.sh validate [feature]

# Show blocked tasks
bash .opencode/skills/task-management/router.sh blocked [feature]

# Show dependency tree
bash .opencode/skills/task-management/router.sh deps <feature> <seq>
```

### Workflow Integration

```
User: "Build authentication system"
  ↓
HarmonyAgent delegates to TaskManager
  ↓
TaskManager creates .tmp/tasks/user-auth/
  ↓
HarmonyAgent shows plan → You approve
  ↓
bash .opencode/skills/task-management/router.sh next user-auth
  ↓
[Shows subtask_01 and subtask_02 are ready]
  ↓
Delegate to CoderAgent for subtask_01
  ↓
CoderAgent completes implementation
  ↓
bash .opencode/skills/task-management/router.sh complete user-auth 01 "Implemented auth"
  ↓
Repeat until all subtasks complete
```

### Task File Format

Tasks are stored in `.tmp/tasks/{feature}/`:
- `task.json` - Feature metadata
- `subtask_XX.json` - Individual subtasks with dependencies

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `.opencode/AGENTS.md` | Central agent documentation |
| `.opencode/agent/core/harmony-agent.md` | Primary agent configuration |
| `.opencode/context/navigation.md` | Quick context lookup |
| `.opencode/context/core/workflows/sessions.md` | Session management |
| `.opencode/context/core/workflows/task-delegation.md` | Delegation patterns |
| `.opencode/skills/task-management/SKILL.md` | Task management skill docs |

---

## Next Steps

1. **Review AGENTS.md** - Understand the full system
2. **Test with a simple task** - Try: "Create a README"
3. **Test with a complex task** - Try: "Build a small feature"
4. **Customize** - Adjust thresholds in harmony-agent.md if needed

---

## Philosophy Reminder

**Human-Guided AI**: AI proposes, human approves, AI executes. Never autonomous.

**Context-First**: Load standards before coding. Match patterns, avoid rework.

**Transparent**: All decisions explained, all agents editable, all actions logged.

**Safe**: Always ask before acting. Never auto-fix. Always confirm cleanup.

---

Your OpenCode environment is now configured with the complete OpenAgentsControl workflow!
