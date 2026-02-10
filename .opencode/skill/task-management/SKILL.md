# Task Management Skill

Skill for breaking down and managing complex tasks.

---

name: task-management
description: "Task breakdown and management system"
version: 1.0

---

## Commands

### /task breakdown

Break down a complex feature into subtasks.

**Usage:**
```
/task breakdown "Create user authentication system"
```

**Process:**
1. Analyzes feature complexity
2. Creates task structure in `.tmp/tasks/{feature}/`
3. Generates subtask files with dependencies
4. Shows execution order

### /task status

Check status of current tasks.

**Usage:**
```
/task status
/task status --feature="auth-system"
```

### /task next

Get next executable tasks (dependencies satisfied).

**Usage:**
```
/task next
```

## Task File Structure

```
.tmp/tasks/{feature-name}/
├── task.json           # Main task definition
├── subtask_01.json     # Individual subtasks
├── subtask_02.json
└── ...
```

## Subagent Integration

This skill uses the TaskManager subagent:

```javascript
task(
  subagent_type="TaskManager",
  description="Break down feature",
  prompt="Create task breakdown for: {feature description}"
)
```

## Best Practices

- Break tasks into < 1 hour chunks
- Mark parallel tasks explicitly
- Define clear validation criteria
- Include required context files
