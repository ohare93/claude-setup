---
description: Increase test coverage by targeting untested branches and edge cases
---

# Expand Unit Tests

Expand existing unit tests adapted to project's testing framework.

## Workflow

### 1. Analyze Coverage

Run coverage report to identify:
- Untested branches
- Edge cases
- Low-coverage areas

### 2. Identify Gaps

Review code for:
- Logical branches
- Error paths
- Boundary conditions
- Null/empty inputs

### 3. Write Tests

Use project's framework:
- JavaScript/TypeScript: Jest, Vitest, Mocha
- Python: pytest, unittest
- Go: testing, testify
- Rust: built-in test framework

### 4. Target Specific Scenarios

- Error handling and exceptions
- Boundary values (min/max, empty, null)
- Edge cases and corner cases
- State transitions and side effects

### 5. Verify Improvement

Run coverage again, confirm measurable increase.

## Guidelines

- Present new test code blocks only
- Follow existing test patterns and naming conventions
