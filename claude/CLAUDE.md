# Development Guidelines

## Architecture & Design Principles

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

**Commit Standards**: Use conventional commit syntax for all commits.

**Workaround Policy**: I must be prompted before applying any workaround. Actual fixes are always prioritized over workarounds.

**React Development**: When creating React components, create custom hooks for behaviors so they can be tested independently of the user interface.

## Personal Memory Management

When references are made to personal memory or preferences for Claude, these refer to memories stored in `~/.claude/CLAUDE.md`. This file should be updated when personal preferences or memory updates are requested.
