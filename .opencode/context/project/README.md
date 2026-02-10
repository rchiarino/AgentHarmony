# Project Intelligence

Your project-specific patterns and context.

## Purpose

This directory contains YOUR custom patterns that make AgentHarmony generate code matching YOUR project.

## Getting Started

1. Copy the template below
2. Customize with your actual patterns
3. Save as `tech-stack.md`
4. Commit to your repository

## Template

```markdown
# My Project Context

## Tech Stack

### Frontend
- Framework: [React/Next.js/Vue/etc.]
- Styling: [Tailwind/CSS-in-JS/etc.]
- State Management: [Redux/Zustand/Context/etc.]

### Backend
- Runtime: [Node.js/Python/Go/etc.]
- Framework: [Express/FastAPI/Gin/etc.]
- Database: [PostgreSQL/MongoDB/etc.]
- ORM: [Prisma/Drizzle/etc.]

### Tools
- Package Manager: [npm/yarn/pnpm]
- Testing: [Jest/Vitest/Playwright]
- Linting: [ESLint/Prettier]

## Code Patterns

### API Routes

```typescript
// Pattern for API routes
export async function POST(req: Request) {
  try {
    // 1. Parse and validate
    const body = await req.json();
    const validated = schema.parse(body);
    
    // 2. Business logic
    const result = await service.create(validated);
    
    // 3. Return response
    return Response.json(result, { status: 201 });
  } catch (error) {
    return Response.json(
      { error: error.message }, 
      { status: 400 }
    );
  }
}
```

### React Components

```typescript
// Pattern for components
interface Props {
  // Define props
}

export const ComponentName: React.FC<Props> = ({ prop1, prop2 }) => {
  // Component logic
  
  return (
    // JSX
  );
};
```

### Database Models

```typescript
// Pattern for database models
model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

## Naming Conventions

### Files
- Components: PascalCase.tsx
- Utilities: camelCase.ts
- Styles: ComponentName.module.css
- Tests: ComponentName.test.tsx

### Code
- Variables: camelCase
- Constants: UPPER_SNAKE_CASE
- Types/Interfaces: PascalCase
- Functions: camelCase, verb phrases

## Architecture

### Folder Structure
```
src/
├── components/     # Reusable UI components
├── features/       # Feature-specific code
├── hooks/          # Custom React hooks
├── lib/            # Utilities and helpers
├── types/          # TypeScript types
└── styles/         # Global styles
```

### Patterns
- Feature-based organization
- Co-location of related files
- Shared code in lib/
- Types in dedicated directory

## Security Requirements

- All inputs validated with Zod
- Authentication required for protected routes
- SQL injection prevention via parameterized queries
- XSS prevention via output encoding

## Testing Standards

- Unit tests for utilities
- Integration tests for APIs
- E2E tests for critical flows
- Minimum 80% coverage
```

## Tips

- **Be Specific**: Include actual code examples from your project
- **Keep Updated**: Update as your project evolves
- **Version Control**: Commit changes so team stays in sync
- **Examples Matter**: Show good examples, not just descriptions
