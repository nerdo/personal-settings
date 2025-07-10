# Claude Development Workflows & Standards

## 🚨 TRIGGER MAP - When to Use Each Workflow

### Immediate Action Triggers
| User Says | Action Required |
|-----------|----------------|
| "it worked", "that fixed it", "problem solved" | → Update JOURNAL.md IMMEDIATELY |
| "fix", "bug", "error", "broken", "not working" | → Bug Fixing Workflow |
| "add", "create", "implement", "feature", "new" | → Adding New Features Workflow |
| "refactor", "clean up", "improve", "reorganize" | → Refactoring Code Workflow |
| "replace", "migrate", "overhaul", "rewrite" | → Making Drastic Changes Workflow |
| ANY code-related request | → TDD-First Workflow (MANDATORY) |

### STOP Triggers - Halt Immediately
- Ambiguous requirements detected
- No tests exist for code being modified
- About to use `any` type
- File exceeds 500 lines
- External data without validation
- No version control for drastic changes
- Uncommitted changes before major work
- Tests failing after 3 attempts

## CRITICAL: This Document Contains MANDATORY Procedures

Every workflow and standard in this document is REQUIRED. These are step-by-step procedures you MUST follow, not suggestions. Deviations require explicit user approval.

## 🌐 Language Adaptations

**FUNDAMENTAL PRINCIPLE**: All principles and workflows in this document apply to EVERY language. TypeScript is the reference implementation, but the concepts are universal.

### How to Apply These Standards
1. **Principles over tools** - The principle matters more than the specific tool
2. **Language-appropriate implementation** - Use idiomatic solutions for each language
3. **When in doubt** - Apply the TypeScript approach conceptually using language-specific tools

### Tool Mapping
| Principle | TypeScript | PHP | Other Languages |
|-----------|------------|-----|-----------------|
| Validation Library | ArkType | respect/validation, symfony/validator | Use language's preferred validation library |
| Package Manager | pnpm | Composer | pip, cargo, gem, etc. |
| Testing Framework | vitest | PHPUnit | pytest, cargo test, rspec, etc. |
| Type Safety | TypeScript strict mode | PHP 8+ types, PHPStan level 9 | Use language's strongest type system |
| Code Quality | ESLint, Prettier | PHP-CS-Fixer, PHPStan | Language-appropriate linters |

### Key Adaptations
- **"Never use `any`"** → Never use untyped/dynamic types when typed alternatives exist
- **"Use TypeScript"** → Use the language's type system to its fullest
- **"Use ArkType for validation"** → Use a robust validation library, never hand-roll validation
- **"Use ArkType's match for transformation"** → Use type-safe transformation patterns

## 🚀 Workflow: Starting Any Task

**TRIGGERS**: ANY new request, conversation start, context switch

### Step 1: Read Project Context
Execute in this exact order:
- [ ] Read CLAUDE.md (this file) completely
- [ ] Read JOURNAL.md (if exists) - contains lessons from past fixes
- [ ] Read PLANNING.md (if exists) - architecture and conventions
- [ ] Read TASK.md (if exists) - current task list

### Step 2: Clarify Requirements
Before ANY implementation:
- [ ] Identify ambiguous requirements
- [ ] List specific questions about:
  - Expected behavior and edge cases
  - Error handling requirements
  - Performance constraints
  - Security considerations
- [ ] WAIT for user response before proceeding

### Step 3: Create Task List
Using TodoWrite tool:
- [ ] Break request into specific subtasks
- [ ] Add all subtasks with appropriate priority
- [ ] Mark first task as in_progress
- [ ] Update TASK.md if task isn't already listed

## 🧪 Workflow: TDD-First for ALL Code Changes (MANDATORY)

**TRIGGERS**: 
- ANY code modification request
- Keywords: "code", "implement", "fix", "add", "change", "update", "modify"
- File extensions: .js, .ts, .py, .java, .go, etc.

This workflow MUST be followed for:
- Bug fixes
- Feature additions
- Code updates
- Refactoring
- ANY code modification

### Step 1: Locate or Create Tests
- [ ] Search for existing test files using `**/*.test.*` or `**/*.spec.*` patterns
- [ ] If tests exist:
  - [ ] Read ALL relevant test files
  - [ ] Understand current test coverage
  - [ ] Identify gaps in test coverage
- [ ] If NO tests exist:
  - [ ] STOP - do not write any implementation code
  - [ ] Create test file alongside source file
  - [ ] Write comprehensive tests for existing functionality FIRST

### Step 2: Write Tests for the Change
- [ ] Write test(s) that define expected behavior
- [ ] For bugs: Test should fail, demonstrating the bug
- [ ] For features: Test should fail, showing missing functionality
- [ ] For refactoring: Tests should pass before and after
- [ ] Run tests to confirm they fail (or pass for refactoring)

### Step 3: Implement the Change
- [ ] Write MINIMAL code to make tests pass
- [ ] Run tests frequently during implementation
- [ ] Do NOT write code beyond what tests require
- [ ] Do NOT add features not covered by tests

### Step 4: Verify and Refactor
- [ ] All tests must pass
- [ ] Check test coverage if available
- [ ] Refactor if needed (tests still passing)
- [ ] Add any edge case tests discovered during implementation

## 🐛 Workflow: Bug Fixing

**TRIGGERS**: 
- Keywords: "bug", "error", "fix", "broken", "issue", "problem", "crash", "fail"
- Error messages in user's message
- Stack traces or exceptions mentioned

### Step 1: Understand the Bug
- [ ] Search for error message using Grep tool
- [ ] Read all files containing the error
- [ ] Trace execution path to find root cause
- [ ] Check JOURNAL.md for similar past issues

### Step 2: Plan the Fix
Create todos:
- [ ] "Analyze and reproduce the bug"
- [ ] "Apply TDD-First workflow for the fix"
- [ ] "Verify fix resolves issue"
- [ ] "Run lint/test/build verification"

### Step 3: Apply TDD-First Workflow
- [ ] MANDATORY: Follow the "TDD-First for ALL Code Changes" workflow above
- [ ] Do NOT skip to implementation without tests
- [ ] Ensure test fails first, demonstrating the bug
- [ ] Then implement minimal fix to make test pass

### Step 4: Verification
Run in this exact order:
- [ ] `pnpm lint` (or project's lint command)
- [ ] `pnpm test` (or project's test command)
- [ ] `pnpm build` (or project's build command)
- [ ] ALL must pass before proceeding

### Step 5: Document the Fix
**TRIGGER**: When user confirms "it worked" or "that fixed it" or similar:
- [ ] IMMEDIATELY update JOURNAL.md using this format:

```markdown
## YYYY-MM-DD

### [CRITICAL] Issue: Brief Description (if critical)
### Issue: Brief Description (if not critical)

- **What failed**: Approach that didn't work
- **Solution**: What actually worked  
- **Why it worked**: Root cause or explanation
- **Lesson**: Pattern to recognize for similar situations
- **Affects**: Files/components/commands involved
- **Author**: Claude (AI Assistant)
```

- [ ] Do this BEFORE asking "what's next?"

## ✨ Workflow: Adding New Features

**TRIGGERS**: 
- Keywords: "add", "create", "implement", "new feature", "build", "develop"
- Feature descriptions or user stories
- Enhancement requests

### Step 1: Requirements Analysis
- [ ] Ask about expected behavior for ALL edge cases
- [ ] Ask about error handling requirements
- [ ] Ask about performance requirements
- [ ] Use context7 MCP to retrieve relevant documentation for tech stack

### Step 2: Research & Planning
- [ ] Search codebase for similar features using Grep
- [ ] Read existing patterns to maintain consistency
- [ ] List all files that need changes
- [ ] Identify potential side effects
- [ ] Create detailed todo list with TodoWrite

### Step 3: Implementation
- [ ] MANDATORY: Follow the "TDD-First for ALL Code Changes" workflow
- [ ] For EACH component, apply full TDD cycle
- [ ] Do NOT write implementation before tests

**Implementation constraints:**
- [ ] Use type-safe language features (TypeScript: never plain JavaScript)
- [ ] Enable strictest type checking (TypeScript: strict mode)
- [ ] NEVER use untyped/dynamic types - use unknown + validation (TypeScript: avoid `any`)
- [ ] Keep files under 500 lines (split if larger)
- [ ] Follow existing code conventions exactly

**Data layer requirements:**
- [ ] Create interface in domain layer
- [ ] Create composable base test suite for the interface (see Test Standards → Composable Interface Testing)
- [ ] Create fake/sample implementation for initial design and testing
- [ ] Ensure fake implementation passes all base tests
- [ ] Real implementation must:
  - Use parameterized queries (NEVER concatenate SQL)
  - Validate ALL inputs using validation library (TypeScript: ArkType)
  - Use language-appropriate database drivers
  - Handle errors with structured error types
  - Pass ALL base test suite tests without modification
  - Add minimal implementation-specific tests only

### Step 4: Security Validation
- [ ] Verify NO SQL injection possible
- [ ] Check for XSS vulnerabilities
- [ ] Validate at ALL system boundaries
- [ ] Never log sensitive data (passwords, tokens, PII)

### Step 5: Final Verification
- [ ] Run `pnpm lint`
- [ ] Run `pnpm test`
- [ ] Run `pnpm build`
- [ ] Update README.md if needed
- [ ] Write TSDoc for all public functions

## 🔄 Workflow: Refactoring Code

**TRIGGERS**: 
- Keywords: "refactor", "clean up", "improve", "reorganize", "optimize"
- Code smell discussions
- Technical debt mentions

### Step 1: Apply TDD-First Workflow
- [ ] MANDATORY: Follow the "TDD-First for ALL Code Changes" workflow
- [ ] Existing tests MUST pass before starting refactoring
- [ ] If no tests exist, STOP and write them FIRST
- [ ] Create refactoring todo list

### Step 2: Incremental Refactoring
- [ ] Make ONE small change at a time
- [ ] Run tests after EACH change
- [ ] If tests fail, revert immediately
- [ ] Keep commits small and focused

### Step 3: Apply Standards
- [ ] Enforce 500 line file limit
- [ ] Follow import ordering (most to least important)
- [ ] Maintain consistent patterns
- [ ] Update documentation if needed

## 🔄 Workflow: Making Drastic Changes

**TRIGGERS**: 
- Keywords: "replace", "migrate", "overhaul", "rewrite", "major change"
- Architecture changes
- Framework migrations
- Large-scale refactoring

### Step 1: Version Control Safety Check
Before ANY major changes:
- [ ] Check if project is under version control (git, jj, etc.)
- [ ] If NO version control exists:
  - [ ] STOP immediately
  - [ ] Prompt user: "This project has no version control. Options:"
    - [ ] "Initialize git repository (`git init`)"
    - [ ] "Initialize jj repository (`jj init`)"
    - [ ] "Proceed without version control (NOT recommended)"
- [ ] If version control exists, check for uncommitted changes
- [ ] If uncommitted changes exist:
  - [ ] STOP and prompt user to commit changes first
  - [ ] Show `git status` or equivalent output
  - [ ] Wait for user confirmation before proceeding

### Step 2: Plan Drastic Changes
- [ ] Identify files to be modified, added, or deleted
- [ ] Create todo list for the transformation
- [ ] Explain to user what will happen to each file
- [ ] Get user approval before proceeding

### Step 3: Execute Changes
- [ ] Make direct changes to files (add/modify/delete as needed)
- [ ] NEVER create backup copies (e.g., `file.ts.bak`, `old_file.ts`)
- [ ] NEVER keep old files alongside new ones
- [ ] Let version control handle the history

### Step 4: Verify Results
- [ ] Run lint/test/build verification
- [ ] Show user what changed with version control commands
- [ ] Commit changes when user is satisfied

### Common Drastic Change Scenarios
- **File replacement**: Delete old file, create new file
- **Mass refactoring**: Direct edits to existing files
- **Architecture changes**: Add new files, delete obsolete ones
- **Framework migration**: Replace files with new implementations

## 📝 Required Standards & Formats

### Error Handling Structure
Create error hierarchies, NOT string messages:

```typescript
BaseError (id, timestamp, metadata: Record<string, any>)
├── ValidationError (field, value, constraint)
│   ├── InvalidEmailError
│   ├── MissingFieldError
│   └── InvalidDateFormatError
├── AuthenticationError (attemptedAction, userId?)
│   ├── InvalidCredentialsError
│   └── ExpiredTokenError (expiredAt)
└── ExternalServiceError (service, endpoint)
    ├── APITimeoutError (timeoutMs, elapsedMs)
    └── RateLimitExceededError (limit, resetAt)
```

### Test Standards
- Use `makeTest*` prefix for factory functions
- Place factories at END of test files
- Create fakes, NOT mocks (unless existing codebase uses mocks)
- Each test must be independent

### Composable Interface Testing (MANDATORY for all interfaces)

**FUNDAMENTAL PRINCIPLE**: Write tests once for the interface contract, reuse them for ALL implementations.

#### Structure
1. **Base Test Suite** - Tests the interface contract itself
   - Tests ALL methods defined in the interface
   - Tests expected behaviors and edge cases
   - Tests error conditions and validation
   - Implementation-agnostic (works with any concrete type)

2. **Implementation Tests** - Minimal setup for each concrete implementation
   - Inherits or composes the base test suite
   - Provides factory method to create its specific instance
   - Adds implementation-specific tests only when needed

#### Implementation Pattern

**Base Test Suite Example (TypeScript):**
```typescript
// feature-flag-repository.test-base.ts
export function createBaseRepositoryTests(
  getRepository: () => FeatureFlagRepository,
  cleanup?: () => Promise<void>
) {
  describe('FeatureFlagRepository Contract', () => {
    let repository: FeatureFlagRepository;
    
    beforeEach(() => {
      repository = getRepository();
    });
    
    afterEach(async () => {
      if (cleanup) await cleanup();
    });
    
    describe('findById', () => {
      it('returns feature flag when exists', async () => {
        // Test implementation
      });
      
      it('returns null when not found', async () => {
        // Test implementation
      });
      
      it('validates ID format', async () => {
        // Test implementation
      });
    });
    
    // ... all other interface methods
  });
}
```

**Concrete Implementation Tests:**
```typescript
// sample-data-feature-flag-repository.test.ts
describe('SampleDataFeatureFlagRepository', () => {
  createBaseRepositoryTests(
    () => new SampleDataFeatureFlagRepository(sampleData)
  );
  
  // Add implementation-specific tests if needed
  it('loads sample data correctly', () => {
    // Specific to this implementation
  });
});

// database-feature-flag-repository.test.ts
describe('DatabaseFeatureFlagRepository', () => {
  createBaseRepositoryTests(
    () => new DatabaseFeatureFlagRepository(dbConnection),
    async () => { await dbConnection.clear(); }
  );
});
```

#### Testing Flow
1. **Design Phase**: Start with sample/fake implementation
   - Create interface
   - Write base test suite
   - Implement fake with sample data
   - Ensure all base tests pass

2. **Implementation Phase**: Add real implementations
   - Create new implementation (DB, API, etc.)
   - Reuse base test suite
   - Add only implementation-specific concerns
   - All base tests must pass unchanged

#### Requirements
- [ ] EVERY interface MUST have a base test suite
- [ ] Base tests MUST be implementation-agnostic
- [ ] ALL implementations MUST pass the base test suite
- [ ] Implementation tests MUST be minimal (just setup + specific concerns)
- [ ] Use dependency injection for testability

### Interface Naming Standards
- Do NOT use prefix on interface names (e.g., NO `IFeatureFlagRepository`)
- Use clean names for interfaces (e.g., `FeatureFlagRepository`)
- Use specific descriptive names for implementations (e.g., `SampleDataFeatureFlagRepository`)
- File naming for interfaces:
  - Follow project's file naming convention (e.g., kebab-case: `feature-flag-repository`)
  - Inject `.interface` before file extension
  - Examples: `feature-flag-repository.interface.ts`, `user-service.interface.js`

### Type Definition Standards

**FUNDAMENTAL PRINCIPLE**: Single source of truth for all types. When validation is needed, the validation schema IS the type definition.

#### Core Rules
1. **Schema-first for boundary types** - Types that need validation MUST be defined through validation schemas
2. **Use inferred types** - Extract types from schemas, never duplicate definitions
3. **No manual duplication** - NEVER hand-write types that can be inferred from schemas
4. **Validation library as type source** - Let the validation library generate TypeScript types

#### When This Applies
- ALL types at system boundaries (API requests/responses, database models, configs)
- Any type that requires validation or transformation
- Types that map to external data sources

#### When This Doesn't Apply
- Internal-only types that never touch boundaries
- Pure computational types (e.g., internal state machines)
- Types that have no validation requirements

**See "Type Definition Through Validation" in Data Validation Requirements section for implementation details.**

### Import Ordering
1. Most important classes for the file
2. Direct dependencies
3. Supporting classes  
4. External dependencies

### Commit Message Format
```
<type>(<scope>): <subject>

<body>

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

### Response Templates

**Bug Fix Response:**
1. Root cause: [why the bug occurs]
2. Solution: [approach to fix]
3. Changes needed:
   - file_path:line_number - [what changes]
4. Tests to add: [specific test cases]

**Feature Implementation Response:**
1. Overview: [1-2 sentence summary]
2. Implementation plan:
   - [ ] Task 1
   - [ ] Task 2
3. Files to modify/create:
   - file_path - [purpose]
4. Potential impacts: [side effects]

## 🛑 NEVER Rules (Absolute Constraints)

- NEVER use untyped/dynamic types without explicit justification (TypeScript: `any`)
- NEVER concatenate SQL strings (use parameterized queries)
- NEVER commit debug statements (console.log, var_dump, print, etc.)
- NEVER use Reflection/magic methods for testing private methods
- NEVER log sensitive data (passwords, tokens, PII)
- NEVER apply workarounds without user approval
- NEVER auto-push commits
- NEVER delete code unless explicitly instructed
- NEVER create files over 500 lines
- NEVER skip the lint/test/build verification
- NEVER trust external data without validation
- NEVER use raw database results without validation
- NEVER skip validation for "internal" APIs
- NEVER create backup copies of files when version control exists
- NEVER skip writing tests before implementation

## ✅ ALWAYS Rules (Mandatory Practices)

- ALWAYS use type-safe language features (TypeScript for JavaScript projects)
- ALWAYS write tests FIRST (TDD)
- ALWAYS use language's preferred package manager (Node: pnpm)
- ALWAYS use appropriate testing framework (TypeScript: vitest)
- ALWAYS use validation library (TypeScript: ArkType)
- ALWAYS mark todos completed immediately
- ALWAYS update JOURNAL.md when user confirms fix
- ALWAYS use structured logging
- ALWAYS include co-author attribution in commits
- ALWAYS use context7 for documentation lookup
- ALWAYS validate ALL external data at system boundaries
- ALWAYS create validation schemas before implementing features
- ALWAYS test validation with invalid data scenarios
- ALWAYS rely on version control for file history and backups

## 🚨 Pre-Implementation Checklist

Before writing ANY code:
- [ ] Have I checked the TRIGGER MAP?
- [ ] Have I asked clarifying questions?
- [ ] Have I created a todo list?
- [ ] Have I searched for existing tests FIRST?
- [ ] Have I planned which tests to write?
- [ ] Have I searched for similar code?
- [ ] Have I used context7 for documentation?
- [ ] Do I understand the security implications?
- [ ] Have I identified ALL external data sources?
- [ ] Have I planned validation for each data source?
- [ ] Are validation schemas defined before implementation?
- [ ] Is version control in place for drastic changes?
- [ ] Are all current changes committed before major modifications?

## 📋 Task Completion Checklist

Before marking ANY task complete:
- [ ] Did `pnpm lint` pass?
- [ ] Did `pnpm test` pass?
- [ ] Did `pnpm build` pass?
- [ ] Have I marked the todo as completed?
- [ ] Should I update TASK.md?
- [ ] Is ALL external data properly validated?
- [ ] Are validation tests covering edge cases?

## 🔧 Tech Stack Defaults

For new projects, unless specified otherwise:

**TypeScript/Node.js:**
- Package manager: pnpm
- Language: TypeScript with strict mode
- Testing: vitest (command: `vitest run`)
- Validation: ArkType
- Formatter: prettier with `@townsquare-interactive/prettier-config`
- Database drivers: pg, mysql2, or better-sqlite3

**Other Languages:**
- Use language's standard tooling (see Language Adaptations section)
- Apply equivalent principles with language-appropriate tools

## 🔒 Data Validation Requirements (CRITICAL)

**FUNDAMENTAL PRINCIPLE**: The core system must ONLY work with validated, strongly-typed entities. ALL external data must be validated at system boundaries.

### External Data Sources (MUST validate ALL)
- [ ] User input (forms, API requests, command line arguments)
- [ ] Configuration files (JSON, YAML, TOML, etc.)
- [ ] Environment variables
- [ ] Database query results
- [ ] File parsing (CSV, XML, JSON, etc.)
- [ ] External API responses
- [ ] Network requests/responses
- [ ] Command line output parsing
- [ ] Third-party library responses

### Validation Implementation Rules
1. **Use validation library** for ALL validation (TypeScript: ArkType)
2. **Validate at entry points** - the moment data enters your system
3. **Create validation functions** with clear error messages
4. **Never trust external data** - even from "trusted" sources
5. **Test validation thoroughly** - include edge cases and malformed data

### Data Transformation Rules
1. **Use validation library for ALL transformations** - NEVER hand-code transformations
2. **Transform at system boundaries** - alongside validation
3. **Use type-safe transformation patterns** (TypeScript: ArkType's `match`)
4. **Type-safe transformations only** - input and output types must be defined
5. **Test transformations thoroughly** - include edge cases and type conversions

### Required Validation Pattern
```typescript
// Define schema
const UserSchema = type({
  id: "string",
  email: "email",
  age: "number>0"
});

// Validate function
function validateUser(raw: unknown): User {
  const result = UserSchema(raw);
  if (result instanceof type.errors) {
    throw new ValidationError("Invalid user data", result);
  }
  return result; // Now strongly typed as User
}

// Usage at boundary
const userData = validateUser(request.body);
```

### Required Transformation Pattern
```typescript
// Define schemas for both shapes
const SampleFeatureFlagSchema = type({
  flag_id: "string",
  is_enabled: "boolean",
  display_name: "string"
});

const FeatureFlagSchema = type({
  id: "string",
  enabled: "boolean",
  name: "string"
});

// Use ArkType's match for transformation
const transformToFeatureFlag = match(
  SampleFeatureFlagSchema,
  (data): FeatureFlag => ({
    id: data.flag_id,
    enabled: data.is_enabled,
    name: data.display_name
  })
);

// Usage at boundary (validate and transform)
const featureFlag = transformToFeatureFlag(rawData);
```

### Validation Checklist for Each External Data Source
- [ ] Schema defined using ArkType
- [ ] Validation function created
- [ ] Error handling for invalid data
- [ ] Tests for valid cases
- [ ] Tests for invalid cases
- [ ] Tests for edge cases (empty, null, undefined)
- [ ] Tests for malformed data

### Type Definition Through Validation

**PRINCIPLE**: For types at system boundaries, the validation schema IS the type definition. Never duplicate.

#### Implementation Pattern (TypeScript with ArkType)
```typescript
// WRONG - Duplicated type definition
interface User {
  id: string;
  email: string;
  age: number;
}
const UserSchema = type({
  id: "string",
  email: "email",
  age: "number>0"
});

// CORRECT - Single source of truth
const UserSchema = type({
  id: "string",
  email: "email",
  age: "number>0"
});
type User = typeof UserSchema.infer;  // Type derived from schema

// For API responses
const ApiResponseSchema = type({
  data: UserSchema,
  meta: {
    timestamp: "number",
    version: "string"
  }
});
type ApiResponse = typeof ApiResponseSchema.infer;
```

#### Benefits
- **Single source of truth** - Schema defines both validation AND type
- **Always in sync** - Type updates automatically with schema changes
- **Prevents drift** - Impossible for type and validation to disagree
- **Runtime safety** - Type safety guaranteed by validation

#### Requirements
- [ ] Define schema FIRST for all boundary types
- [ ] Derive TypeScript types from schemas using inference
- [ ] NEVER manually duplicate type definitions
- [ ] Use schema-derived types throughout the codebase
- [ ] Export both schema AND derived type from modules

### Common Validation Mistakes to Avoid
- Assuming database data is valid (it can be corrupted)
- Trusting environment variables without validation
- Not validating configuration on startup
- Skipping validation for "internal" APIs
- Using `any` type instead of proper validation
- Validating only happy path scenarios
- Defining types separately from validation schemas

## 🔄 Data Transformation Requirements

**When you need to transform data between different shapes, ALWAYS use your validation library.**

See the "Data Transformation Rules" and "Required Transformation Pattern" in the **Data Validation Requirements** section above for detailed implementation guidelines.

Key points:
- NEVER hand-code data transformations
- Use type-safe transformation functions (TypeScript: ArkType's `match`)
- Transform data at system boundaries alongside validation

## 📊 Structured Logging Requirements

All logs must use structured data:
- Include correlation IDs (request ID, trace ID)
- Use appropriate levels: ERROR, WARN, INFO, DEBUG
- Include context (user ID, resource ID, operation)
- NEVER log sensitive data
- Use consistent field names across application

## 🛑 STOP Conditions

IMMEDIATELY stop and ask for clarification if:
- Any requirement seems ambiguous
- A workflow step appears impossible
- You need to deviate from these procedures
- Tests fail after 3 attempts
- Build commands are not working
- You're about to use untyped/dynamic types (TypeScript: `any`)
- You're about to exceed 500 lines in a file
- You're about to use external data without validation
- You discover unvalidated data in existing code
- Project has no version control and drastic changes are needed
- Uncommitted changes exist before major modifications
- You're about to write implementation code without tests
- No tests exist for code you're modifying

## 💡 Quick Reference

### Immediate Actions
1. User says "it worked" → Update JOURNAL.md NOW
2. Any code request → Start with TDD-First workflow
3. Ambiguous request → STOP and clarify

### Workflow Selection
1. Check TRIGGER MAP at top of document
2. Match keywords to appropriate workflow
3. Follow workflow steps exactly

### Remember
1. These are EXACT procedures, not guidelines
2. When user says "it worked" → Update JOURNAL.md IMMEDIATELY
3. Every task needs a todo list
4. Every code change needs tests
5. Every completion needs lint/test/build verification

If you find yourself not following these procedures, you are malfunctioning. Stop and re-read this document.