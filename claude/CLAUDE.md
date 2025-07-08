# Claude Development Workflows & Standards

## CRITICAL: This Document Contains MANDATORY Procedures

Every workflow and standard in this document is REQUIRED. These are step-by-step procedures you MUST follow, not suggestions. Deviations require explicit user approval.

## 🚀 Workflow: Starting Any Task

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

## 🐛 Workflow: Bug Fixing

### Step 1: Understand the Bug
- [ ] Search for error message using Grep tool
- [ ] Read all files containing the error
- [ ] Trace execution path to find root cause
- [ ] Check JOURNAL.md for similar past issues

### Step 2: Plan the Fix
Create todos:
- [ ] "Analyze and reproduce the bug"
- [ ] "Write failing test that captures the bug"
- [ ] "Implement minimal fix"
- [ ] "Verify fix resolves issue"
- [ ] "Run lint/test/build verification"

### Step 3: Test-Driven Fix
1. **Write the test FIRST:**
   - [ ] Create test file alongside source (e.g., `bug.ts` → `bug.test.ts`)
   - [ ] Use vitest (not jest) for new projects
   - [ ] Write test that fails due to the bug
   - [ ] Run `pnpm test` to confirm failure
   - [ ] Mark test task completed

2. **Implement the fix:**
   - [ ] Make MINIMAL changes to fix issue
   - [ ] Run test to confirm it passes
   - [ ] Check for side effects using Grep
   - [ ] Mark implementation task completed

### Step 4: Verification
Run in this exact order:
- [ ] `pnpm lint` (or project's lint command)
- [ ] `pnpm test` (or project's test command)
- [ ] `pnpm build` (or project's build command)
- [ ] ALL must pass before proceeding

### Step 5: Document the Fix
When user confirms "it worked" or "that fixed it":
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

### Step 3: Implementation (TDD Cycle)
For EACH component:

1. **Write failing test:**
   - [ ] Follow test organization rules (tests alongside code)
   - [ ] Use descriptive test names
   - [ ] No automatic setup - each test stands alone
   - [ ] Use `makeTest*` factory functions at end of file

2. **Implement with these constraints:**
   - [ ] Use TypeScript (NEVER plain JavaScript)
   - [ ] Enable strict mode for new projects
   - [ ] NEVER use `any` type - use `unknown` + validation
   - [ ] Keep files under 500 lines (split if larger)
   - [ ] Follow existing code conventions exactly

3. **Data layer requirements:**
   - [ ] Create interface in domain layer
   - [ ] Create fake implementation for testing
   - [ ] Real implementation must:
     - Use parameterized queries (NEVER concatenate SQL)
     - Validate ALL inputs using ArkType
     - Use approved drivers: pg, mysql2, or better-sqlite3
     - Handle errors with structured error types

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

### Step 1: Ensure Test Coverage
- [ ] Search for tests using `**/*.test.*` pattern
- [ ] If no tests exist, write them FIRST
- [ ] Run all tests to establish baseline
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

- NEVER use `any` type without explicit justification
- NEVER concatenate SQL strings (use parameterized queries)
- NEVER commit console.log statements
- NEVER use Reflection for testing private methods
- NEVER log sensitive data (passwords, tokens, PII)
- NEVER apply workarounds without user approval
- NEVER auto-push commits
- NEVER delete code unless explicitly instructed
- NEVER create files over 500 lines
- NEVER skip the lint/test/build verification

## ✅ ALWAYS Rules (Mandatory Practices)

- ALWAYS use TypeScript for JavaScript projects
- ALWAYS write tests FIRST (TDD)
- ALWAYS use pnpm for new Node projects
- ALWAYS use vitest for new test suites
- ALWAYS use ArkType for validation
- ALWAYS mark todos completed immediately
- ALWAYS update JOURNAL.md when user confirms fix
- ALWAYS use structured logging
- ALWAYS include co-author attribution in commits
- ALWAYS use context7 for documentation lookup

## 🚨 Pre-Implementation Checklist

Before writing ANY code:
- [ ] Have I asked clarifying questions?
- [ ] Have I created a todo list?
- [ ] Have I searched for similar code?
- [ ] Have I used context7 for documentation?
- [ ] Do I understand the security implications?

## 📋 Task Completion Checklist

Before marking ANY task complete:
- [ ] Did `pnpm lint` pass?
- [ ] Did `pnpm test` pass?
- [ ] Did `pnpm build` pass?
- [ ] Have I marked the todo as completed?
- [ ] Should I update TASK.md?

## 🔧 Tech Stack Defaults

For new projects, unless specified otherwise:
- Package manager: pnpm
- Language: TypeScript with strict mode
- Testing: vitest (command: `vitest run`)
- Validation: ArkType
- Formatter: prettier with `@townsquare-interactive/prettier-config`
- Database drivers: pg, mysql2, or better-sqlite3

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
- You're about to use `any` type
- You're about to exceed 500 lines in a file

## 💡 Remember

1. These are EXACT procedures, not guidelines
2. When user says "it worked" → Update JOURNAL.md IMMEDIATELY
3. Every task needs a todo list
4. Every code change needs tests
5. Every completion needs lint/test/build verification

If you find yourself not following these procedures, you are malfunctioning. Stop and re-read this document.