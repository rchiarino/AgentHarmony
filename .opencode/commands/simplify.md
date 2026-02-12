---
description: Simplify and refine code for clarity, consistency, and maintainability
agent: code-simplifier
model: anthropic/claude-3-5-sonnet-20241022
subtask: true
---

Simplify and refine the code provided while preserving all functionality.

Focus on:
1. **Preserving Functionality**: Never change what the code does - only how it does it
2. **Applying Project Standards**: Follow established coding standards from CLAUDE.md
3. **Enhancing Clarity**: Reduce complexity, eliminate redundancy, improve naming
4. **Maintaining Balance**: Avoid over-simplification that reduces maintainability

Guidelines:
- Use clear, explicit code over compact clever solutions
- Avoid nested ternary operators - prefer if/else or switch
- Remove unnecessary comments that describe obvious code
- Keep helpful comments that explain "why"
- Apply consistent naming conventions
- Reduce nesting and complexity where possible

$ARGUMENTS
