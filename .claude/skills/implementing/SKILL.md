---
name: implementing
description: Use when an implementation plan exists in .plans/ and is ready to execute. Dispatches fresh agents per task with two-stage review.
---

# Implementing a Plan

**You are an orchestrator. You MUST NOT write implementation code yourself.** Every task is dispatched to a fresh `implementer` agent — no exceptions, regardless of complexity or how many tasks are in the plan. Complex tasks get a higher-tier model, not your direct involvement.

Execute one plan at a time by dispatching a fresh `implementer` agent per task, with two lightweight review gates after each: spec gate first, then code quality gate. The real depth comes in the final review after all tasks complete. If you have multiple plans, run this skill once per plan sequentially.

**Why fresh agents:** Each agent gets isolated context. You precisely craft their instructions so they stay focused. They never inherit your session history — you construct exactly what they need.

**Core principle:** Fresh agent per task + two-stage review (spec then quality) = high quality, fast iteration.

## The Process

**On entry:**

1. **Pre-flight checks:**
   - Verify VCS working tree is clean (no uncommitted changes). If dirty, ask the user to commit or stash before proceeding.
   - Verify the current branch/bookmark is not main/master. If it is, ask the user to create a feature branch first.
   - Verify the plan file exists and contains at least one task with checkbox steps. If malformed, report and stop.
   - If the plan references a spec, check whether the spec has been modified more recently than the plan. If so, warn the user the plan may be stale and ask whether to proceed. If the user wants to re-plan, stop and let them update the plan before re-invoking this skill.
2. **Create tasks:** Read the plan file. Create a `TaskCreate` entry for each plan task (subject = task name, description = brief summary).
3. **Report scope:** Tell the user: "Plan has N tasks. Each goes through implementation + two review gates (~3 agent dispatches per task), then a comprehensive final review."
4. **Resume handling:** If resuming a partially-complete plan, check VCS history for commits related to unchecked tasks before re-dispatching. If implementation commits exist for an unchecked task, skip re-implementation and proceed to the review stage. Create tasks only for remaining work.

For each task in the plan, complete ALL of the following steps in order. Do not proceed to the next step until the current step succeeds. Do not proceed to the next task until step 5 is reached.

**Report progress before each step:** Tell the user what's happening (e.g., "Task 3/8: Dispatching implementer as sonnet — multi-file coordination across 4 files", "Task 3/8: Spec gate — iteration 1").

1. **Dispatch `implementer` agent** — with full task text, context, tier-specific instructions, and TDD methodology (reference the `test-driven-development` skill).
2. **Handle implementer status** — DONE proceeds to Stage 1. BLOCKED triggers escalation (see below). Do not proceed to Stage 1 until status is DONE or DONE_WITH_CONCERNS.
3. **Stage 1 — Spec Compliance Gate** — dispatch a single `code-reviewer` agent with a **combined spec + scope lens**:
   - Checks: (a) Does the implementation cover every requirement in the task spec? (b) Are there any unrequested changes, over-engineering, or scope misinterpretation?
   - Include the full task requirements, implementer's report, and the VCS diff
   - If issues found: dispatch a new `implementer` at the same tier with the original task text + prior report + specific issues to fix. Re-review after the fix.
   - Do not proceed to Stage 2 until this stage passes
4. **Stage 2 — Code Quality Gate** — dispatch a single `code-reviewer` agent with a **code quality lens**:
   - Checks: correctness, obvious bugs, error handling, lint/format passing, consistency with surrounding code patterns
   - Include the implementer's report and VCS diff
   - If issues found: dispatch a new `implementer` at the same tier with the original task text + prior report + specific issues to fix. Then restart from Stage 1 — a Stage 2 fix may break spec compliance.
   - Do not proceed to step 5 until this stage passes

**Iteration limits:** Each stage has one counter per task, incremented on every run regardless of cause, never reset. Max 3 attempts per stage. Example: Stage 1 passes (attempt 1), Stage 2 fails (attempt 1), fix applied, Stage 1 re-runs (attempt 2), Stage 2 re-runs (attempt 2). If either stage hits 3 attempts, escalate to the user.
5. **Mark task complete** — only reachable after Stages 1 and 2 both pass. Update the plan file: change all `- [ ]` checkboxes for this task to `- [x]`. Update the task status via `TaskUpdate`.

Stages are **strictly sequential** — Stage 1 MUST pass before Stage 2 begins. Every task requires both stages regardless of size or complexity. Do not skip, defer, or batch them. Per-task gates are single-agent, single-lens — the comprehensive multi-perspective review happens after all tasks complete. No review step may be skipped for any reason: not time pressure, task simplicity, or similarity to a previous task.

After all tasks are complete:

1. **Final spec-compliance review** (if a spec exists) — verify the complete implementation satisfies the spec. This checks the whole, not individual tasks. The per-task spec gate catches drift early; this final review checks cross-task integration and completeness — requirements that span multiple tasks.
   - Dispatch 2-3 `code-reviewer` agents using the `multi-perspective-review` skill, with the spec as reference
   - One reviewer MUST have a **spec-compliance** lens: "Does the implementation cover every requirement in the spec? Flag anything missing, divergent, or partially implemented."
   - Choose remaining lenses based on what matters most (architecture, security, performance, etc.)
   - If issues found → fix → re-review. The `multi-perspective-review` skill manages the re-review loop (max 3 iterations, then escalate to user).
   - If no spec exists (micro-plan from inline fix), skip this step.
2. **Documentation staleness check** — gather the full diff (branch vs base), identify doc files in the repo (CLAUDE.md, README.md, `docs/` directory — skip CHANGELOG.md). If any exist, dispatch the `document-reviewer` agent with the diff summary and the list of doc files. Fix any stale documentation, re-review until approved. Max 3 iterations, then escalate to user.
3. **Finish** — use the `finishing-branch` skill to decide how to integrate the work.

## Model Tiering for Implementer

Default haiku. Evaluate these criteria in order — first match wins:

| Model | Criteria (any one triggers) |
|-------|---------------------------|
| **opus** | Task requires choosing between architectural alternatives not in the plan, OR requires understanding patterns across 5+ files, OR involves design decisions with cross-cutting impact |
| **sonnet** | Task touches 3+ files, OR requires coordinating changes across module boundaries, OR involves non-trivial error handling or concurrency |
| **haiku** | Default — 1-2 files, complete spec, isolated changes |

**Report the tier and reason to the user** when dispatching each implementer (e.g., "Task 3: Dispatching as sonnet — touches 4 files across two modules"). Similarly report tier escalations.

## Tier-Specific Prompt Injection

When dispatching the implementer, append tier-specific instructions to the prompt:

**For haiku dispatch — append:**

> **Escalation:** If you are stuck or uncertain, report BLOCKED immediately with a description of what's wrong. Do not spend time diagnosing — escalate quickly.

**For sonnet/opus dispatch — append:**

> **Constructive push-back:** You are expected to think critically about the task. Before implementing, evaluate feasibility, design quality, spec gaps, and cross-cutting concerns. If you identify issues, report them with status DONE_WITH_CONCERNS or NEEDS_CONTEXT. Be specific: describe the problem, explain why it matters, and propose alternatives.
>
> **Getting unstuck — oracle protocol:** If stuck after reasonable investigation, dispatch a diagnostic consultant before escalating. Use the Agent tool with `model: opus` and provide a structured diagnostic:
>
> - **Symptom:** What's happening vs. expected
> - **Hypotheses Tested:** What you tried and ruled out
> - **Evidence Gathered:** Files read, commands run, outputs observed
> - **What's Confusing:** The specific thing that doesn't make sense
>
> The consultant investigates independently and returns ranked hypotheses. If their hypotheses also don't resolve the issue, then escalate BLOCKED with both your findings and the consultant's.

## Handling Implementer Status

**DONE:** Proceed to Stage 1 (per-task spec gate).

**DONE_WITH_CONCERNS:** Read concerns before proceeding. If about correctness or scope, address before review. If observations ("this file is getting large"), note and proceed.

**NEEDS_CONTEXT:** Provide missing context and re-dispatch.

**BLOCKED:** Assess the blocker by reading the BLOCKED description:
1. Missing context → re-dispatch same tier with more context
2. Too complex for current tier → re-dispatch with higher tier:
   - haiku → sonnet (gains oracle capability)
   - sonnet → opus
3. Still blocked after opus + oracle → escalate to human

**Never** ignore an escalation or force the same model to retry without changes.

## Dispatch Prompt Checklists

Reviewers dispatched by this skill do not invoke the `verification` skill — CI verification is deferred to `finishing-branch`.

**Implementer** — include in prompt:
- Full task text (copy-pasted from plan, never a file reference)
- Scene-setting context (what exists, what this task builds on)
- Project conventions relevant to the task
- Lint/format commands (from package.json / pyproject.toml / Makefile / etc.)
- Tier-specific instructions (see above)
- TDD methodology (reference `test-driven-development` skill)
- Instruction: "Run lint/format and fix issues before reporting DONE."

**Stage 1 (spec) reviewer** — include in prompt:
- Full task requirements
- Implementer's report
- VCS diff
- Instruction: "Combined spec + scope check. Does the implementation cover every requirement? Are there unrequested changes or scope misinterpretation?"

**Stage 2 (quality) reviewer** — include in prompt:
- Implementer's report
- VCS diff
- Instruction: "Focus on correctness, bugs, lint/format, consistency with surrounding code."

**Documentation staleness reviewer** — include in prompt:
- Diff summary (what changed and where)
- List of doc files to check
- Instruction: "Flag any documentation that is stale, inaccurate, or missing coverage of the changes in this diff."

**Final review reviewers** — include in prompt:
- Lens criteria (focus + ignore)
- Plan/spec reference
- Full branch diff

Model selection for the final review is handled by the `multi-perspective-review` skill.

## Integration

**Required skills (invoked directly):**
- **multi-perspective-review** — parallel review panels with synthesis (final review only — per-task gates use single reviewers)
- **finishing-branch** — integrate the work after all reviews pass (also requires: `verification`, `create-pr`)
- **test-driven-development** — TDD methodology included in implementer dispatch prompts

**Referenced but not invoked as skills:**
- **code-review** — for standalone/ad-hoc use; the implementing skill dispatches `code-reviewer` agents directly with its own protocol. Note: `code-review` mandates the `verification` skill during review; this implementing skill defers full CI verification to `finishing-branch`.
