---
name: verification
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always
---

# Verification Before Completion

## Overview

Claiming work is complete without verification is dishonesty, not efficiency.

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## Discover What CI Checks

Before running verification, **read the CI configuration** to learn the full set of checks that will run on push. Common locations:

- `.github/workflows/*.yml` (GitHub Actions)
- `Makefile` / `justfile` / `Taskfile.yml` (task runners)
- `package.json` scripts (npm/yarn)
- `.circleci/config.yml`, `.gitlab-ci.yml`, `Jenkinsfile`

Pay special attention to:
- **Multiple compile targets** (e.g., `--target wasm32-unknown-unknown`, cross-platform builds, different feature flags)
- **Multiple test suites** (unit, integration, e2e, different test runners)
- **Linting/formatting** that CI enforces but you haven't run locally
- **Matrix builds** — if CI tests against multiple OS/arch/version combos, run what you can locally

Run every check you can reproduce locally. If a CI step can't be run locally (e.g., deploy, secrets-dependent), note it but don't skip the ones you can run.

## Minimum Check Categories

Regardless of what CI discovery finds, always run these categories when the project supports them:

Run these **in order** — stop on first failure, fix it, then restart from step 1. A lint fix might break formatting; a typecheck fix might break tests. Always re-verify from the top.

| Order | Category | Examples |
|-------|----------|----------|
| 1 | **Format** | `prettier --check`, `cargo fmt --check`, `black --check` |
| 2 | **Lint** | `eslint`, `clippy`, `ruff`, `pylint` |
| 3 | **Typecheck** | `tsc --noEmit`, `mypy`, `pyright` |
| 4 | **Build** | `cargo build`, `npm run build` — check CI for multiple targets/feature flags |
| 5 | **Test** | `cargo test`, `npm test`, `pytest` — check CI for multiple suites |

Skip categories that aren't applicable (e.g., no type checker configured). If you can't find the command for a category that should exist, check CI config more carefully or ask the user.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| "All checks pass" | Full pipeline (steps 1-5) ran green in this message | A previous run, "should pass", or running only some steps |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Pipeline passing |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Step N passed, skipping 1 through N-1" | Always run the full pipeline from step 1 |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Pipeline:**
```
✅ Run steps 1→5, all green, report evidence from each
❌ "Should pass now" / "Looks correct" / "Skipping steps"
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Pipeline passes, phase complete"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## Why This Matters

From 24 failure memories:
- your human partner said "I don't believe you" - trust broken
- Undefined functions shipped - would crash
- Missing requirements shipped - incomplete features
- Time wasted on false completion → redirect → rework
- Violates: "Honesty is a core value. If you lie, you'll be replaced."

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness

## The Bottom Line

**No shortcuts for verification.**

Run the command. Read the output. THEN claim the result.

This is non-negotiable.
