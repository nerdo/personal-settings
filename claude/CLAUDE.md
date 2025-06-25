# Development Guidelines

## Architecture & Design Principles

**Clarifying Questions**: Before executing a plan, if there are clarifying questions that would be helpful to ask in order to achieve any of the goals stated in the prompt or implied by these guidelines, you must ask before taking action.

**Data Layer Isolation**: Always create a separate data layer for input and output. Modules must only use their own entities and call externally defined functions for data access. This ensures modules can be tested without external dependencies like databases or real APIs. The I/O layer implementations are tested independently.

**Complexity Management**: When encountering complexity, always seek to simplify by decoupling the complex implementation details from the simple "what" being asked. Create interfaces that allow drivers to hide complexity and map complex logic to simpler data types. This improves testability and isolates bugs to specific drivers.

**Pattern Implementation**: When applying patterns like repository pattern, focus strictly on what the module actually needs. Always favor simpler implementations with fewer entities over granular entities that don't provide value to the module.

## Testing Requirements

**Test Independence**: Do not use automatic setup functions unless absolutely necessary. Each test must stand alone. Refactor setup steps into explicitly called, private utility methods within the test suite.

**Factory Function Standards**:

- Use `make` instead of `create` for factory functions
- In test contexts, name them `makeTestEntity` when used for test data
- When overriding test data, pass arguments that clearly indicate what is being overridden
- Place all factory functions at the end of test suites

**Private Method Testing**: Never use Reflection for testing private methods. When this scenario arises, I will be prompted to convert private methods to public ones.

**Dependency Extraction**: When making private methods public for testing would require complex typed dependencies (like Eloquent models), extract the logic into a separate method that accepts entities with no external dependencies. Avoid unstructured arrays as arguments or return types. Objects are acceptable, but external dependencies like Eloquent objects that tie to database systems are not.

**Pre-Refactoring Testing**: Before any refactoring, if tests don't exist to cover the change, create tests first to validate existing behavior. This may require some smaller "blind" refactorings, but this must be done first with verification before proceeding to the main refactoring.

## Code Organization

**Import Ordering**: Dependencies must be sorted by order of importance to the current file's functionality:

1. Most important/central classes to the file's purpose
2. Direct dependencies of the central classes
3. Supporting classes
4. External dependencies (testing frameworks, etc.)

Example: In an OpenAI service test file, order should be: OpenAI service → API dependency → entity classes → external testing frameworks like Mockery.

## Development Workflow

**Use Test Driven Development**: Write tests representing the use cases and ensure that they will fail by writing the bare minimum to get it to compile and run. Then get them to pass with literals and very simple logic when necessary. Refactor to add the real implementation and verify that tests are still passing.

**Commit Standards**: Use conventional commit syntax for all commits.

**Workaround Policy**: I must be prompted before applying any workaround. Actual fixes are always prioritized over workarounds.

**React Development**: When creating React components, create custom hooks for behaviors and test them independently of the user interface. Use this feedback loop to make changes.

**Readability first**: Prioritize readability and simplicity over performance except when explicitly asked to optimize performance.

**Security practices**: Validate and sanitize input at system boundaries. Boundaries include API endpoints, database queries, file operations, and external service calls. When possible, convert validated values into domain-specific entities that are used throughout the module. Always encode output appropriately for the context (HTML escaping, SQL parameterization, etc.) when rendering user-supplied data.

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

When references are made to personal memory or preferences for Claude, these refer to memories stored in `~/.claude/CLAUDE.md`. This file should be updated when personal preferences or memory updates are requested.
