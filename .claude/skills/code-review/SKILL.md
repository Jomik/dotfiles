---
name: code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
---

# Requesting Code Review

Dispatch the `code-reviewer` agent to catch issues before they cascade. The reviewer gets precisely crafted context — never your session's history.

**Core principle:** Review early, review often.

## When to Request Review

**Mandatory:**
- After each task during implementation
- After completing major feature
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing complex bug

## How to Request

**1. Get VCS revision range:**

Determine the project's VCS by checking for `.jj/` directory. Use the appropriate command:

- **git:** `BASE_SHA=$(git rev-parse HEAD~1)` and `HEAD_SHA=$(git rev-parse HEAD)`
- **jj:** Use appropriate revision range for the change set

**2. Dispatch code-reviewer agent:**

Dispatch the `code-reviewer` agent with `model: opus` and the following context in the prompt:

- **Review criteria** (the agent is prompt-driven — include the full checklist):
  - Code Quality: separation of concerns, error handling, type safety, DRY, edge cases
  - Architecture: design decisions, scalability, performance, security
  - Testing: tests test logic (not mocks), edge cases covered, integration tests where needed, all passing
  - Requirements: all plan requirements met, matches spec, no scope creep, breaking changes documented
  - Production Readiness: migration strategy, backward compatibility, documentation, no obvious bugs
  - File Organization: single responsibility per file, independent testability, follows plan structure, file size
- What was implemented (brief description)
- Plan or requirements reference (task from plan, or ad-hoc requirements)
- VCS diff range (revision identifiers)
- Lint and format commands to verify (from project config)

**3. Act on feedback:**
- Fix Critical issues immediately
- Fix Important issues before proceeding
- Note Minor issues for later
- Push back if reviewer is wrong (with reasoning)
- Use the `receiving-code-review` skill when evaluating feedback

## Integration with Workflows

**Implementing skill:**
- Review after EACH task
- Catch issues before they compound
- Fix before moving to next task

**Ad-Hoc Development:**
- Review before merge
- Review when stuck

## Verification

The reviewer MUST use the `verification` skill to run the full set of CI checks locally as part of the review. If any check fails, treat as a Critical issue — code must be clean before merge.

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical issues
- Proceed with unfixed Important issues
- Argue with valid technical feedback
- Approve with lint or format violations

**If reviewer wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
- Request clarification
