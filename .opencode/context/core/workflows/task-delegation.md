<!-- Context: workflows/delegation | Priority: high | Version: 1.0 -->
# Task Delegation Workflow

How to properly delegate tasks to subagents.

## Philosophy

**Right Tool for the Job**: Delegate to specialists when appropriate  
**Clear Communication**: Explicit requirements and context  
**Quality Gates**: Validate subagent output before proceeding

## When to Delegate

### Always Delegate
- Task affects 4+ files
- Requires specialized knowledge
- Has complex dependencies
- User explicitly requests it

### Consider Delegating
- Time estimate > 30 minutes
- Multiple components involved
- Requires research or discovery

### Execute Directly
- Simple, single-file changes
- Clear requirements
- Under 15 minutes
- Well-understood pattern

## Delegation Process

### Step 1: Prepare Context Bundle

Create a context file with all necessary information:

```
.tmp/context/{session-id}/bundle.md
```

**Include:**
- Task description
- Standards to follow
- Relevant context files
- Constraints and requirements
- Expected output
- Examples (if helpful)

### Step 2: Delegate

```javascript
task(
  subagent_type="SubagentName",
  description="Brief task description",
  prompt="Load context from .tmp/context/{session-id}/bundle.md
  
  Task: {detailed description}
  
  Requirements:
  - {requirement 1}
  - {requirement 2}
  
  Expected Output:
  - {output 1}
  - {output 2}
  
  Validation Criteria:
  - {criteria 1}
  - {criteria 2}"
)
```

### Step 3: Monitor and Validate

- Wait for subagent completion
- Review output against criteria
- Validate quality
- Handle errors appropriately

### Step 4: Track with Task Management Skill

After subagent completes, update task status:

```bash
# Mark subtask complete (for TheConductor breakdowns)
bash .opencode/skills/task-management/router.sh complete {feature} {seq} "implementation summary"

# Check next eligible tasks
bash .opencode/skills/task-management/router.sh next {feature}

# View overall progress
bash .opencode/skills/task-management/router.sh status {feature}

# Validate task integrity
bash .opencode/skills/task-management/router.sh validate {feature}
```

## Context Bundle Template

```markdown
# Context Bundle

## Task
{Clear description of what needs to be done}

## Standards
Load these files:
- .opencode/context/core/standards/code-quality.md
- .opencode/context/core/standards/security-patterns.md
- {project-specific files}

## Requirements
- {requirement 1}
- {requirement 2}
- {constraint 1}

## Constraints
- {limitation 1}
- {must use X}
- {must not use Y}

## Examples
```javascript
// Good example
{code example}
```

## Expected Output
- {file 1} - {purpose}
- {file 2} - {purpose}

## Validation
- {how to verify}
```

## Subagent Routing Guide

| Task Type | Delegate To |
|-----------|-------------|
| Find context files | ContextSniffer |
| Break down complex task | TheConductor |
| Write code | CoderAgent |
| Write tests | TestEngineer |
| Review code | CodeReviewer |
| Create documentation | DocWriter |
| Validate build | BuildAgent |
| UI design | FrontendSpecialist |
| DevOps tasks | DevOpsSpecialist |

## Delegation Patterns

### Pattern 1: Simple Delegation

For straightforward tasks:

```javascript
task(
  subagent_type="CoderAgent",
  description="Implement utility function",
  prompt="Load context from .opencode/context/core/standards/code-quality.md
  
  Task: Create a function to validate email addresses
  
  Requirements:
  - Pure function
  - Returns { success: boolean, error?: string }
  - Validates format and domain
  
  Create in: src/utils/validation.js"
)
```

### Pattern 2: Complex Delegation

For multi-step tasks:

```javascript
// First: Break down with TheConductor
task(
  subagent_type="TheConductor",
  description="Break down auth feature",
  prompt="Create task breakdown for: Add user authentication
  
  Include:
  - Database schema
  - API routes
  - Frontend components
  - Validation logic"
)

// Then: Track and execute with task-management skill
// Check status: bash .opencode/skills/task-management/router.sh status {feature}
// Find next tasks: bash .opencode/skills/task-management/router.sh next {feature}
// Execute each subtask with CoderAgent
// Mark complete: bash .opencode/skills/task-management/router.sh complete {feature} {seq} "summary"
```

### Pattern 3: Parallel Delegation

For independent tasks:

```javascript
// These can run in parallel
task(subagent_type="CoderAgent", description="Task A", ...)
task(subagent_type="CoderAgent", description="Task B", ...)
task(subagent_type="CoderAgent", description="Task C", ...)

// Wait for all, then proceed
```

## Error Handling

### Subagent Reports Error

```
## Subagent Error

**Subagent:** {name}
**Error:** {description}

**Proposed Resolution:**
{explanation}

**Options:**
1. Retry with modified requirements
2. Handle differently
3. Abort task

What would you like to do?
```

### Subagent Output Invalid

```
## Validation Failed

**Issue:** Subagent output doesn't meet criteria

**Expected:**
- {criterion 1}
- {criterion 2}

**Received:**
- {what was delivered}

**Proposed Fix:**
{explanation}

Apply fix? [y/n/modify]
```

## Best Practices

1. **Clear Requirements**: Be specific about what you want
2. **Provide Context**: Always include relevant standards
3. **Set Boundaries**: Define what's in/out of scope
4. **Give Examples**: Show patterns to follow
5. **Validate Output**: Check against criteria
6. **Handle Errors**: Have a plan for failures
7. **Respect Time**: Don't over-delegate simple tasks

## Anti-Patterns

❌ **Vague Requirements**: "Make it better"
❌ **No Context**: Expecting subagent to guess standards
❌ **Missing Validation**: Not checking output quality
❌ **Over-Delegation**: Delegating 5-minute tasks
❌ **Ignoring Errors**: Continuing despite failures
❌ **Unclear Scope**: Not defining boundaries

## Quality Checklist

Before delegating:

- [ ] Task is appropriate for delegation
- [ ] Requirements are clear
- [ ] Context files identified
- [ ] Success criteria defined
- [ ] Error handling planned

After delegation:

- [ ] Output meets requirements
- [ ] Standards were followed
- [ ] No errors introduced
- [ ] Integration successful
- [ ] Task status updated with skill (if using TheConductor)

## Task Management Skill Integration

When using TheConductor to break down features, integrate with the task-management skill:

### Workflow

1. **TheConductor creates breakdown** → Files in `.tmp/tasks/{feature}/`
2. **Check status** → `bash .opencode/skills/task-management/router.sh status {feature}`
3. **Find next tasks** → `bash .opencode/skills/task-management/router.sh next {feature}`
4. **Delegate to CoderAgent** → Execute subtask
5. **Mark complete** → `bash .opencode/skills/task-management/router.sh complete {feature} {seq} "summary"`
6. **Repeat** → Until all subtasks done

### Skill Commands Reference

| Command | Purpose |
|---------|---------|
| `status [feature]` | Show task progress |
| `next [feature]` | Show eligible tasks (deps satisfied) |
| `complete <f> <seq> "msg"` | Mark subtask done |
| `blocked [feature]` | Show blocked tasks |
| `validate [feature]` | Check task integrity |
