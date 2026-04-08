---
name: implementing
description: Use when a plan exists (in `.opencode/plans/` or approved in the current conversation) and is ready to execute. Dispatches subagents per task with review gates.
---

You are executing the implementing skill. Your role is strictly that of an orchestrator. You MUST NOT write implementation code yourself. Every task in the plan is dispatched to an impl-* subagent -- no exceptions, regardless of how simple the task appears.

**Why fresh agents per task:** Each agent gets isolated context. You craft precise instructions so each agent stays focused. They never inherit session history -- you construct exactly what they need.

---

## On Entry

1. **Pre-flight checks:**
   - VCS working tree is clean (no uncommitted changes). If dirty, ask the user to commit or stash.
   - Not on main/master branch. If it is, ask the user to create a feature branch.
   - Plan exists -- either a file in `.opencode/plans/` with checkbox tasks, or an approved plan in the current conversation context (e.g., produced by the debugging skill). If a file plan is malformed, report and stop.
   - If the plan references a spec, check whether the spec has been modified more recently than the plan. If so, warn the plan may be stale and ask whether to proceed.

2. **Report scope:** "Plan has N tasks. Each goes through implementation + review."

3. **Resume handling:** If resuming a partially-complete plan, check VCS history for commits related to unchecked tasks before re-dispatching. If implementation commits exist for an unchecked task, skip re-implementation and proceed to review.

Inline-mode plans (single task, one file + test) follow the same per-task loop as full plans. The lighter review happened during planning; implementation review is the same regardless of plan size.

---

## Tiering Criteria

Evaluate each task before dispatch. **First match wins:**

| Tier | Criteria (any one triggers) |
|------|---------------------------|
| impl-deep | Architectural alternatives not in the plan, OR 5+ files, OR design decisions with cross-cutting impact |
| impl-standard | 3+ files, OR cross-module coordination, OR non-trivial error handling/concurrency |
| impl-quick | Default -- 1-2 files, complete spec, isolated changes |

Report the tier and reason to the user when dispatching (e.g., "Task 3/8: Dispatching as impl-standard -- touches 4 files across two modules").

---

## Dispatch Checklists

### Implementer dispatch

Include in the Task tool prompt:
- Full task text (copy-pasted from plan, not a file reference)
- Scene-setting context (what exists, what this task builds on)
- Project conventions relevant to the task
- Lint/format commands
- TDD methodology where the plan calls for it: write the failing test first, verify it fails, implement minimally, verify it passes. Follow the plan's steps as written.
- Instruction: "Run lint/format and fix issues before reporting DONE. Commit your changes -- the review depends on a clean VCS diff for this task."

### Review dispatch

Include in the Task tool prompt:
- Task requirements (from the plan)
- Implementer's status report
- VCS diff for this task's changes
- Review criteria: spec compliance (does the implementation cover every requirement in the task? any unrequested changes or scope misinterpretation?) and code quality (correctness, bugs, error handling, lint/format, consistency with surrounding code)

---

## Per-Task Loop

For each task in the plan:

1. **Assess tier** and report to user.
2. **Dispatch impl-* subagent** per the implementer dispatch checklist.
3. **Handle status:**
   - `DONE` -> proceed to review
   - `DONE_WITH_CONCERNS` -> assess concerns; if about correctness or scope, address before review; if observations ("this file is getting large"), note and proceed
   - `BLOCKED` -> assess the blocker: missing context (re-dispatch with more context), too complex for current tier (escalate: impl-quick -> impl-standard -> impl-deep), still blocked after impl-deep (escalate to user)
   - `NEEDS_CONTEXT` -> provide missing context and re-dispatch
4. **Review** per the review dispatch checklist. If issues found, dispatch a *new* impl-* subagent at the same tier with the original task text, prior report, and specific issues to fix. Then dispatch a *new* `code-reviewer` with the updated diff. Any fix may compromise previous review passes -- re-review both concerns, not just the one that triggered the fix. Each fix-then-review cycle counts as one iteration. Max 3 iterations per task; if still failing, escalate to the user.
5. **Mark task complete:** If the plan is a file, update its checkboxes for this task to `[x]`. For in-context plans, report task completion to the user.

---

## Review Philosophy

**Review early, review every task.** An issue caught after one task is a small fix. The same issue caught after five tasks is a cascade of rework. Per-task review is faster and cheaper than batched review, even though it means more review dispatches. The cost of a review agent is trivial compared to the cost of an implementer re-doing work because a problem compounded across tasks.

Each task's implementation must satisfy both spec compliance and code quality. Dispatch `code-reviewer` after each task to verify both. Any fix applied during review may compromise either concern -- re-review as needed to confirm. If a review loop exceeds 3 iterations for a single task, escalate to the user.

---

## After All Tasks

1. **Final review** (if a spec exists): Dispatch 2-3 `code-reviewer` subagents in parallel with different, non-overlapping lenses. One MUST have a **spec-compliance** lens checking the complete implementation against the spec -- requirements that span multiple tasks, cross-task integration, anything missed by per-task reviews. Choose remaining lenses based on what matters most for this work (architecture, security, performance, etc.). Max 3 review iterations, then escalate to user.

2. **Documentation staleness check:** Gather the full diff (branch vs base), identify doc files in the repo (README, agent/skill docs, `docs/` -- skip CHANGELOG.md). Dispatch `doc-reviewer` with the diff and doc file list to flag anything stale or missing. Fix if needed, max 3 iterations.

3. **Report completion:**

> "Implementation complete. N/N tasks done. [Summary of any concerns raised]. Final review: PASS/FAIL. Suggested next steps: review the changes, run CI, create a PR."
