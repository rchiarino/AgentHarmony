<!-- Context: standards/code-quality | Priority: critical | Version: 1.0 -->
# Code Quality Standards

Core coding standards all agents must follow.

## Philosophy

**Modular**: Small, focused, reusable components  
**Functional**: Pure functions, immutability, composition  
**Maintainable**: Self-documenting, testable, predictable

## Golden Rule

> If you can't easily test it, refactor it.

## Critical Patterns (Always Use)

✅ **Pure Functions**: Same input = same output, no side effects  
✅ **Immutability**: Create new data, don't modify existing  
✅ **Composition**: Build complex from simple functions  
✅ **Small Functions**: < 50 lines per function  
✅ **Explicit Dependencies**: Pass dependencies as parameters

## Anti-Patterns (Never Use)

❌ **Mutation**: Modifying data in place  
❌ **Side Effects**: console.log, API calls in pure functions  
❌ **Deep Nesting**: Use early returns  
❌ **God Modules**: Everything in one file  
❌ **Global State**: Pass state explicitly  
❌ **Large Functions**: Keep functions focused

## Examples

### Pure Functions

```javascript
// ✅ Pure
const add = (a, b) => a + b;
const formatUser = (user) => ({ 
  ...user, 
  fullName: `${user.firstName} ${user.lastName}` 
});

// ❌ Impure (side effects)
let total = 0;
const addToTotal = (value) => { 
  total += value; 
  return total; 
};
```

### Immutability

```javascript
// ✅ Immutable
const addItem = (items, item) => [...items, item];
const updateUser = (user, changes) => ({ ...user, ...changes });

// ❌ Mutable
const addItem = (items, item) => { 
  items.push(item); 
  return items; 
};
```

### Composition

```javascript
// ✅ Compose small functions
const processUser = pipe(validateUser, enrichUserData, saveUser);
const isValidEmail = (email) => validateEmail(normalizeEmail(email));

// ❌ Deep inheritance
class ExtendedUserManager extends UserManager { }
```

### Declarative Style

```javascript
// ✅ Declarative
const activeUsers = users
  .filter(u => u.isActive)
  .map(u => u.name);

// ❌ Imperative
const names = [];
for (let i = 0; i < users.length; i++) {
  if (users[i].isActive) {
    names.push(users[i].name);
  }
}
```

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | kebab-case | `user-service.js` |
| Functions | camelCase, verb phrase | `getUser`, `validateEmail` |
| Predicates | is/has/can prefix | `isValid`, `hasPermission` |
| Variables | camelCase, descriptive | `userCount` (not `uc`) |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Classes | PascalCase | `UserManager` |

## Function Structure

```javascript
// ✅ Good structure
function processOrder(order, inventory, logger) {
  // 1. Validation
  if (!isValidOrder(order)) {
    return { success: false, error: 'Invalid order' };
  }
  
  // 2. Check inventory
  const availability = checkAvailability(order.items, inventory);
  if (!availability.inStock) {
    return { success: false, error: 'Items out of stock' };
  }
  
  // 3. Calculate totals
  const totals = calculateTotals(order.items);
  
  // 4. Process payment
  const payment = processPayment(order.payment, totals);
  if (!payment.success) {
    return { success: false, error: payment.error };
  }
  
  // 5. Return result
  logger.info(`Order processed: ${order.id}`);
  return { 
    success: true, 
    data: { orderId: order.id, totals }
  };
}
```

## Error Handling

```javascript
// ✅ Explicit error handling
function parseJSON(text) {
  try {
    const data = JSON.parse(text);
    return { success: true, data };
  } catch (error) {
    return { success: false, error: error.message };
  }
}

// ✅ Validate at boundaries
function createUser(userData) {
  const validation = validateUserData(userData);
  if (!validation.isValid) {
    return { success: false, errors: validation.errors };
  }
  
  const user = saveUser(userData);
  return { success: true, user };
}
```

## Dependency Injection

```javascript
// ✅ Explicit dependencies
function createUserService(database, logger) {
  return {
    createUser: (userData) => {
      logger.info('Creating user');
      return database.insert('users', userData);
    }
  };
}

// ❌ Hidden dependencies
import db from './database.js';
function createUser(userData) { 
  return db.insert('users', userData); 
}
```

## Module Structure

```
component/
├── index.js       # Public interface
├── core.js        # Core logic (pure functions)
├── utils.js       # Helpers
└── tests/
    ├── unit.test.js
    └── integration.test.js
```

## File Organization

- **< 100 lines per module** (ideally < 50)
- **Single responsibility**: One purpose per file
- **Clear exports**: Explicit public interface
- **Internal helpers**: Private functions not exported

## Best Practices Checklist

- [ ] Pure functions whenever possible
- [ ] Immutable data structures
- [ ] Small, focused functions (< 50 lines)
- [ ] Compose small functions
- [ ] Explicit dependencies
- [ ] Validate at boundaries
- [ ] Self-documenting code
- [ ] Test in isolation
- [ ] Early returns (no deep nesting)
- [ ] Descriptive naming
