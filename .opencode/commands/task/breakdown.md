---
description: "Break down complex features into manageable subtasks"
---

Break down the following feature: $ARGUMENTS

Create a structured task breakdown with:
1. Atomic subtasks (can be completed independently)
2. Clear dependencies (what must happen first)
3. Parallel opportunities (what can run simultaneously)
4. Validation criteria (how to verify completion)

Output format:
- task.json: Main task definition
- subtask_NN.json: Individual subtasks

Include:
- Task descriptions
- Dependencies
- Estimated time
- Context files needed
- Validation criteria

@.opencode/context/core/workflows/task-delegation.md
@.opencode/AGENTS.md
