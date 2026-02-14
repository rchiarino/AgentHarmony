---
description: "Discover relevant context files for any task"
---

Discover context files for: $ARGUMENTS

Search the following directories:
- .opencode/context/core/standards/
- .opencode/context/core/workflows/
- .opencode/context/project/

For each file, analyze:
1. Filename relevance to task
2. Content relevance to task
3. Priority markers (critical/high/medium/low)

Return ranked list with:
- file: path relative to .opencode/context/
- priority: critical | high | medium | low
- reason: why this file is relevant
- relevant_sections: specific sections to read

@.opencode/context/navigation.md
@.opencode/AGENTS.md
