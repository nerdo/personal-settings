# Development Guidelines

## Thought Process

**Clarifying Questions**: Before acting on a prompt, ask clarifying questions to disambiguate parts of the prompt, refine details, and ultimately improve the results.

**Implications**: Before implementing any solution:

1. List potential side effects
2. Identify affected files/components
3. Consider edge cases

**Use context7**: Context7 is an MCP server that pulls up-to-date, version-specific documentation and code examples directly from the source. It is designed to get better answers, no hallucinations and an AI that actually understands the stack. When available, use context7 to retrieve the relevant specific documentation for our versions of the parts of our tech stack.

## Architecture & Design Principles

**Data Layer Isolation**: Always create a separate data layer for input and output. Modules must only use their own entities and call externally defined functions for data access. This ensures modules can be tested without external dependencies like databases or real APIs. The I/O layer implementations are tested independently.

Example:

```typescript
// Domain layer (testable without DB)
class UserService {
  constructor(private userRepo: UserRepository) {}
  async getActiveUsers() {
    return this.userRepo.findByStatus("active");
  }
}

// Data layer (separate, mockable)
interface UserRepository {
  findByStatus(status: string): Promise<User[]>;
}
```

**Complexity Management**: When encountering complexity, always seek to simplify by decoupling the complex implementation details from the simple "what" being asked. Create interfaces that allow drivers to hide complexity and map complex logic to simpler data types. This improves testability and isolates bugs to specific drivers.

**Pattern Implementation**: When applying patterns like repository pattern, focus strictly on what the module actually needs. Always favor simpler implementations with fewer entities over granular entities that don't provide value to the module.

## Testing Requirements

**Write Tests For Core Functionality**: You must write tests for core functionality. Use a domain driven philosophy where entities are created to represent the input and output data of the core functionality. Ensure it can be tested without depending on databases, APIs, etc. Those details should have separate layers that translate to and from the domain.

**Test Independence**: Do not use automatic setup functions unless absolutely necessary. Each test must stand alone. Refactor setup steps into explicitly called, private utility methods within the test suite.

**Avoid Mocks**: Unless in an existing codebase where using mocks is the standard or introducing fakes would overcomplicate the existing setup, create fakes instead of using mocks.

Example fake implementation:
```typescript
class FakeUserRepository implements UserRepository {
  private users: User[];
  
  constructor(initialData?: { users?: User[] }) {
    this.users = initialData?.users || [];
  }
  
  async findByStatus(status: string): Promise<User[]> {
    return this.users.filter(u => u.status === status);
  }
  
  // Helper method for single user
  addTestUser(user: User): void {
    this.users.push(user);
  }
}
```

**Factory Function Standards**:

- Use `make` instead of `create` for factory functions
- In test contexts, name them `makeTestEntity` when used for test data
- When overriding test data, pass arguments that clearly indicate what is being overridden
- Place all factory functions at the end of test suites

**Private Method Testing**: Never use Reflection for testing private methods. When this scenario arises, I will be prompted to convert private methods to public ones.

**Dependency Extraction**: When making private methods public for testing would require complex typed dependencies (like Eloquent models), extract the logic into a separate method that accepts entities with no external dependencies. Avoid unstructured arrays as arguments or return types. Objects are acceptable, but external dependencies like Eloquent objects that tie to database systems are not.

**Pre-Refactoring Testing**: Before any refactoring, if tests don't exist to cover the change, create tests first to validate existing behavior. This may require some smaller "blind" refactorings (refactorings performed without test coverage, sometimes necessary to make the code testable), but this must be done first with verification before proceeding to the main refactoring.

**Use Accessibility Attributes**: When testing front-end components, follow the best practice of making the tests mimic human behavior by using accessibility attributes and avoid interacting with elements by class names, ids, etc.

## Code Organization

**Import Ordering**: Dependencies must be sorted by order of importance to the current file's functionality:

1. Most important/central classes to the file's purpose
2. Direct dependencies of the central classes
3. Supporting classes
4. External dependencies (testing frameworks, etc.)

Example: In an OpenAI service test file, order should be: OpenAI service → API dependency → entity classes → external testing frameworks like Mockery.

## Development Workflow

**Use Test Driven Development**:
1. Write failing test first
2. Write minimal code to pass
3. Refactor while keeping tests green
4. Repeat cycle as needed for the task

**Commit Standards**: Use conventional commit syntax for all commits.

**Workaround Policy**: I must be prompted before applying any workaround. Actual fixes are always prioritized over workarounds.

**Readability first**: Prioritize readability and simplicity over performance except when explicitly asked to optimize performance.

**Security practices**: Validate and sanitize input at system boundaries. Boundaries include API endpoints, database queries, file operations, and external service calls. When possible, convert validated values into domain-specific entities that are used throughout the module. Always encode output appropriately for the context (HTML escaping, SQL parameterization, etc.) when rendering user-supplied data.

## Front-End Development

**React Development**: When creating React components, create custom hooks for behaviors and test them independently of the user interface. Use this feedback loop to make changes.

**Favor Smaller, Composable Components**: Avoid monolithic components and favor composition, grouping components logically by their purpose.

## Error Handling

**Structure, not Strings**: Avoid generic error messages that rely solely on human-readable strings. Instead:

- Create structured error objects with unique identifiers
- Base errors should contain data/metadata fields, not message strings
- Capture context through structured data (timestamps, user IDs, request IDs, etc.)
- Build a hierarchy of error types with descriptive, context-specific names
- Error types should be self-documenting through their class names and data structure

This allows errors to be traced in logs and programmatically handled based on type and data rather than string matching.

Example hierarchy:

```
BaseError (id, timestamp, metadata: Record<string, any>)
├── ValidationError (field, value, constraint)
│   ├── InvalidEmailError
│   ├── MissingFieldError
│   └── InvalidDateFormatError
├── UserNotFoundError (userId, searchCriteria)
├── ResourceNotFoundError (resourceType, resourceId)
├── AuthenticationError (attemptedAction, userId?)
│   ├── InvalidCredentialsError
│   ├── ExpiredTokenError (expiredAt)
│   └── InsufficientPermissionsError (requiredPermissions, actualPermissions)
└── ExternalServiceError (service, endpoint)
    ├── APITimeoutError (timeoutMs, elapsedMs)
    ├── RateLimitExceededError (limit, resetAt)
    └── ServiceUnavailableError (httpStatus, retryAfter?)
```

## Logging Practices

**Structured Logging**: Use structured logging with consistent fields across the application:

- Log with structured data objects, not string concatenation
- Include correlation IDs (request ID, trace ID) for distributed tracing
- Use appropriate log levels: ERROR for actionable issues, WARN for potential problems, INFO for business events, DEBUG for development
- Never log sensitive data (passwords, tokens, PII)
- Include contextual data that helps diagnose issues (user ID, resource ID, operation name)

**Error Logging**: When logging errors, include:

- The error's unique ID from the structured error object
- Relevant context without duplicating what's already in the error object
- Stack traces for unexpected errors only
- Sanitized request/response data when relevant

## Personal Memory Management

**When to update memory files**:

1. **Global memory (~/.claude/CLAUDE.md)**:
   - User explicitly says "remember this" or "update your memory"
   - User establishes a new personal preference
   - Only update when explicitly asked

2. **Project memory (./CLAUDE.md)**:
   - User corrects a repeated mistake specific to the project
   - User establishes project-specific conventions
   - User provides project-specific commands or workflows

**Handling conflicts**:
- If user asks to add something that conflicts with existing guidelines, ask for clarification before proceeding
- Project memory takes precedence over global memory for project-specific tasks

## Common Verification Commands

**Final Verification**: Before considering any task complete, run these commands in order:

For Node/TypeScript projects:
- `pnpm lint` or `npm run lint`
- `pnpm test` or `npm test`
- `pnpm build` or `npm run build`

For PHP projects:
- `phpunit` or `./vendor/bin/phpunit`
- Check composer.json for specific test commands

**Finding the Right Commands**:
1. Check the project's CLAUDE.md file for project-specific commands
2. Look in package.json (Node) or composer.json (PHP) for available scripts
3. If still unsure, ask the user for the correct commands

## Always/Never Rules

**ALWAYS**:

- Run linter, tests, and build - in that order - as final verification before considering any task complete
- Use TypeScript strict mode in new projects
- Validate inputs at system boundaries (API endpoints, file operations, external services)
- Check if a library/framework is already in use before suggesting alternatives
- Mark todos as completed immediately after finishing a task
- Use structured logging with consistent fields
- Follow existing code conventions in the codebase
- Suggest committing when a task is complete (but only commit when explicitly asked)

**NEVER**:

- Commit console.log statements to production code
- Use `any` type without explicit justification
- Use Reflection for testing private methods
- Log sensitive data (passwords, tokens, PII)
- Apply workarounds without prompting for approval

## Tech Stack Preferences

For new node-based projects...

- Use pnpm instead of npm.
- Use TypeScript not JavaScript.
- Use vitest not jest, and when creating the test command in package.json, set it up to be `vitest run`, not `vitest`.
- Use ArkType for defining types/entities and validating inputs to the system.

## Code References

When referencing specific functions or pieces of code, use the pattern `file_path:line_number` to allow easy navigation to the source code location.

Example:
```
The error handling logic is in src/services/auth.ts:45
```

## Response Templates

**Bug Fix Response Format**:

1. Root cause: [brief explanation of why the bug occurs]
2. Solution: [approach to fix the issue]
3. Changes needed:
   - file_path:line_number - [what changes]
   - file_path:line_number - [what changes]
4. Tests to add: [list specific test cases]

**Feature Implementation Response Format**:

1. Overview: [1-2 sentence summary]
2. Implementation plan:
   - [ ] Task 1
   - [ ] Task 2
3. Files to modify/create:
   - file_path - [purpose]
4. Potential impacts: [list any side effects]

**Code Review Response Format**:

1. Issues found:
   - file_path:line_number - [issue description]
2. Suggestions:
   - [improvement with rationale]
3. Security concerns: [if any]
4. Performance considerations: [if any]

**Error Analysis Response Format**:

1. Error type: [classification from error hierarchy]
2. Affected component: file_path:line_number
3. Steps to reproduce: [if applicable]
4. Fix recommendation: [specific solution]

## Common Scenarios

**When asked to "fix" something**: First reproduce the issue, then follow Bug Fix Response Format

**When asked to "add" something**: First clarify scope if unclear, then follow Feature Implementation Format

**When asked to "improve" something**: First analyze current state, propose changes, await confirmation before implementing

**When asked to "refactor" something**: First ensure tests exist for current behavior, then follow Pre-Refactoring Testing guidelines

**When encountering an error**: Follow Error Analysis Response Format, investigate root cause before proposing fixes

## Miscellaneous

When creating a `.gitignore` file, ignore the Claude local settings files.
