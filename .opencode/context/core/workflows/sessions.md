<!-- Context: workflows/sessions | Priority: high | Version: 1.0 -->
# Session Management Workflow

How to create, use, and manage sessions for complex tasks.

---

## What is a Session?

A **session** is a temporary workspace that preserves context across multi-step workflows.

**Purpose**:
- Store requirements and specifications
- Track task breakdowns
- Pass context between subagents
- Maintain state across multiple steps

---

## When to Create Sessions

**Lazy creation** - only when needed:

| Scenario | Create Session? |
|----------|----------------|
| Simple question | No |
| 1-3 file task | No |
| 4+ file task | Yes |
| Multi-step workflow | Yes |
| Complex dependencies | Yes |
| User requests breakdown | Yes |

**Philosophy**: Only create overhead when necessary. Keep it lean.

---

## Session Structure

```
.tmp/sessions/{session-id}/
├── manifest.json              # Index of all context files
├── features/                  # Feature requirements
│   └── {feature-name}.md
├── tasks/                     # Task breakdowns
│   └── {task-name}.md
├── code/                      # Implementation notes
│   └── {component}.md
└── documentation/             # Documentation context
    └── {doc-name}.md
```

### Manifest Format

The manifest tracks all context files:

```json
{
  "session_id": "20250118-143022-a4f2",
  "created": "2025-01-18T14:30:22Z",
  "context_files": {
    "features/user-auth-context.md": {
      "created": "2025-01-18T14:30:22Z",
      "for": "@the-conductor",
      "keywords": ["user-auth", "authentication", "features"]
    },
    "tasks/user-auth-tasks.md": {
      "created": "2025-01-18T14:32:15Z",
      "for": "@the-conductor",
      "keywords": ["user-auth", "tasks", "breakdown"]
    }
  },
  "context_index": {
    "user-auth": [
      "features/user-auth-context.md",
      "tasks/user-auth-tasks.md"
    ]
  }
}
```

---

## Session Lifecycle

### Step 1: Create

**When**: Complex task identified after approval

**Generate ID**:
```javascript
const sessionId = `${YYYYMMDD}-${HHMMSS}-${random4chars}`;
// Example: 20250118-143022-a4f2
```

**Create structure**:
```bash
mkdir -p .tmp/sessions/{session-id}/{features,tasks,code,documentation}
```

### Step 2: Populate

**Create context files**:

```markdown
# .tmp/sessions/{id}/features/{name}.md

## Feature: {name}

### Requirements
- {requirement 1}
- {requirement 2}

### Constraints
- {constraint 1}
- {constraint 2}

### Keywords
- keyword1, keyword2, keyword3
```

**Update manifest**:
```json
{
  "context_files": {
    "features/{name}.md": {
      "created": "ISO timestamp",
      "for": "@{subagent-name}",
      "keywords": ["keyword1", "keyword2"]
    }
  }
}
```

### Step 3: Use

**Pass context to subagents**:

```javascript
task(
  subagent_type="TheConductor",
  description="Break down feature",
  prompt="Load context from:
  - .tmp/sessions/{id}/features/{feature}.md
  
  Task: Break down the feature into subtasks
  
  Context includes requirements and constraints."
)
```

**Discover related context**:

```javascript
// Search manifest by keywords
const related = manifest.context_index["keyword"];
// Returns: ["features/file1.md", "tasks/file2.md"]
```

### Step 4: Cleanup ⚠️ (CRITICAL RULE)

**Always confirm before cleanup**:

```markdown
## Task Complete

**Summary:**
- {what was done}

**Session Files:**
.tmp/sessions/{id}/
- manifest.json
- features/
- tasks/

---

⚠️ **Cleanup Confirmation Required**

Is this complete and satisfactory?

Should I clean up temporary session files at .tmp/sessions/{id}/?

[yes/no/keep]
```

**Only delete after explicit approval!**

---

## Context Preservation

### For Multi-Step Workflows

**Step 1**: Initial request
```
User: "Build user authentication system"
→ Create session abc123
→ Create features/auth.md
→ Delegate to TheConductor
```

**Step 2**: Later request
```
User: "Implement login component"
→ Search manifest for "login" or "auth"
→ Find: features/auth.md, tasks/auth-tasks.md
→ Pass to CoderAgent
→ CoderAgent uses full context
```

**Result**: No context loss!

### Keyword Strategy

**When creating context files**:
1. Add 3-5 relevant keywords to frontmatter
2. Include in manifest context_index
3. Use consistent terminology

**Example**:
```markdown
---
keywords: [user-auth, authentication, login, security, jwt]
---
```

**Benefits**:
- Automatic discovery
- Related task linking
- No manual tracking needed

---

## Concurrent Sessions

**Multiple users can work simultaneously**:

```
User A Session: abc123 (auth system)
User B Session: def456 (payment system)
```

**Isolation guaranteed**:
- Unique session IDs
- Separate folders
- Independent manifests
- No conflicts

---

## Best Practices

1. **Lazy Creation**: Only create when needed
2. **Clear Naming**: Descriptive file names
3. **Keywords**: Add relevant tags for discovery
4. **Minimal Content**: Only what's needed
5. **Confirm Cleanup**: Always ask before deleting
6. **Regular Cleanup**: Approve cleanup to keep workspace clean

---

## Anti-Patterns

❌ **Creating sessions for simple tasks** - Overhead not needed  
❌ **No keywords** - Makes discovery impossible  
❌ **Auto-cleanup** - Violates critical rule  
❌ **Cluttered sessions** - Keep focused and minimal  
❌ **Orphaned sessions** - Clean up when done  

---

## Example: Complete Session Flow

```javascript
// Step 1: User requests complex feature
User: "Build authentication system"

// Step 2: Create session
const sessionId = "20250118-143022-a4f2";
mkdir -p .tmp/sessions/${sessionId}/{features,tasks}

// Step 3: Create context
Write .tmp/sessions/${sessionId}/features/auth-context.md:
---
keywords: [user-auth, authentication, jwt, security]
---
## Feature: Authentication System
### Requirements
- JWT tokens
- Login/signup endpoints
- Password hashing

// Step 4: Update manifest
Write .tmp/sessions/${sessionId}/manifest.json:
{
  "session_id": "20250118-143022-a4f2",
  "context_files": {
    "features/auth-context.md": {
      "keywords": ["user-auth", "authentication"]
    }
  }
}

// Step 5: Delegate with context
task(
  subagent_type="TheConductor",
  prompt="Load .tmp/sessions/${sessionId}/features/auth-context.md
  Break down authentication system"
)

// Step 6: Later, user requests related task
User: "Implement login endpoint"

// Step 7: Discover context
Search manifest for "login" or "auth"
→ Found: features/auth-context.md

// Step 8: Pass to specialist
task(
  subagent_type="CoderAgent",
  prompt="Load .tmp/sessions/${sessionId}/features/auth-context.md
  Implement login endpoint"
)

// Step 9: Confirm completion
User: "Looks good, clean up"

// Step 10: Cleanup after approval
rm -rf .tmp/sessions/${sessionId}/
```

---

## Summary

**Sessions provide**:
- ✅ Context preservation across steps
- ✅ Automatic discovery by keywords
- ✅ Concurrent safety
- ✅ Safe cleanup with confirmation

**Remember**:
- Create lazily (only when needed)
- Add keywords for discovery
- Always confirm cleanup
- Keep minimal and focused
