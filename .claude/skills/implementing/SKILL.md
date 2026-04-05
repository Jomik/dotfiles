---
name: implementing
description: Use when executing a single implementation plan with independent tasks in the current session
---

# Implementing a Plan

**You are an orchestrator. You MUST NOT write implementation code yourself.** Every task is dispatched to a fresh `implementer` agent — no exceptions, regardless of complexity or how many tasks are in the plan. Complex tasks get a higher-tier model, not your direct involvement.

Execute one plan at a time by dispatching a fresh `implementer` agent per task, with two-stage multi-perspective review after each: spec gate first, then code quality gate. If you have multiple plans, run this skill once per plan sequentially.

**Why fresh agents:** Each agent gets isolated context. You precisely craft their instructions so they stay focused. They never inherit your session history — you construct exactly what they need.

**Core principle:** Fresh agent per task + two-stage review (spec then quality) = high quality, fast iteration.

## The Process

For each task in the plan, complete ALL of the following steps in order. Do not proceed to the next step until the current step succeeds. Do not proceed to the next task until step 5 is reached.

1. **Dispatch `implementer` agent** — with full task text, context, and tier-specific instructions.
2. **Handle implementer status** — DONE proceeds to step 3. BLOCKED triggers escalation (see below). Do not proceed to step 3 until status is DONE or DONE_WITH_CONCERNS.
3. **Stage 1 — Spec Gate (parallel)** — dispatch in parallel via Agent tool:
   - `spec-compliance` agent — adversarial check that code matches spec
   - `code-reviewer` agent with a **scope lens** — checks for unrequested work, over-engineering, gold plating, scope misinterpretation
   - Use the `multi-perspective-review` skill for synthesis and re-review loop
   - Do not proceed to step 4 until this stage passes
4. **Stage 2 — Code Quality Gate (parallel)** — dispatch 2-3 `code-reviewer` agents in parallel, each with a different lens:
   - Pick complementary, non-overlapping lenses most relevant to this change (use the `multi-perspective-review` skill for lens selection)
   - Use the `multi-perspective-review` skill for synthesis and re-review loop
   - Do not proceed to step 5 until this stage passes
5. **Mark task complete** — only reachable after steps 3 and 4 both pass.

Stages are **strictly sequential** — Stage 1 (spec gate) MUST pass before Stage 2 (code quality gate) begins. Within each stage, reviewers run in **parallel**. Every task requires both stages regardless of size or complexity. Do not skip them. Do not defer them. Do not batch them for later.

After all tasks:

1. Dispatch final multi-perspective code review across entire implementation (2-3 `code-reviewer` agents with complementary lenses in parallel — use `multi-perspective-review` skill)
2. Dispatch `document-reviewer` to check documentation staleness (see below)
3. Use `finishing-branch` skill

## Model Tiering for Implementer

The `implementer` agent defaults to `model: haiku`. Override based on task complexity:

| Complexity | Model | Signals |
|-----------|-------|---------|
| Simple | haiku (default) | 1-2 files, complete spec, isolated function |
| Medium | sonnet (override) | Multi-file coordination, integration concerns, pattern matching |
| Complex | opus (override) | Architectural judgment, broad codebase understanding, design decisions |

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

**DONE:** Proceed to spec compliance review.

**DONE_WITH_CONCERNS:** Read concerns before proceeding. If about correctness or scope, address before review. If observations ("this file is getting large"), note and proceed.

**NEEDS_CONTEXT:** Provide missing context and re-dispatch.

**BLOCKED:** Assess the blocker by reading the BLOCKED description:
1. Missing context → re-dispatch same tier with more context
2. Too complex for current tier → re-dispatch with higher tier:
   - haiku → sonnet (gains oracle capability)
   - sonnet → opus
3. Still blocked after opus + oracle → escalate to human

**Never** ignore an escalation or force the same model to retry without changes.

## Dispatching Agents

**Implementer dispatch prompt should include:**
- Full task text (copy-pasted from plan, never a file reference)
- Scene-setting context (what exists, what this task builds on)
- Project rules and conventions relevant to the task
- Verification commands to run (tests, linting, formatting — see below)
- Tier-specific escalation instructions (see above)

**Linting & formatting requirement:** Before reporting DONE, the implementer MUST run the project's lint and format checks (e.g., `npm run lint`, `cargo clippy`, `ruff check`, `prettier --check`, etc.) and fix any issues. Identify the correct commands from the project's config files (package.json, Makefile, pyproject.toml, etc.). Include these commands in the dispatch prompt so the implementer knows what to run.

**Spec-compliance dispatch prompt should include:**
- Full task requirements (what was requested)
- Implementer's report (what they claim they built)

**Code-reviewer dispatch prompt should include:**
- The lens criteria (what to focus on, what to ignore)
- What was implemented (from implementer's report)
- Plan or requirements reference
- VCS revision range for diff
- Model override where appropriate (opus for the lens needing deepest reasoning, sonnet for others)

## Documentation Review (After Final Code Review)

After the final code-review passes, check whether user-facing documentation is still accurate.

1. Gather the full diff (branch vs base)
2. Identify which doc files exist in the repo: **CLAUDE.md**, **README.md**, **`docs/` directory**. Skip CHANGELOG.md (pipeline-generated).
3. If any exist, dispatch the `document-reviewer` agent with:
   - The diff summary (what changed and where)
   - The list of doc files to review
   - Instruction: "Flag any documentation that is stale, inaccurate, or missing coverage of the changes in this diff."
4. If issues found → fix them directly → re-run `document-reviewer`. Repeat until approved.
5. If no doc files exist, skip this step.

## Red Flags

Never:
- Implement tasks yourself — always dispatch an `implementer` agent, even for "simple" or "obvious" tasks
- Combine multiple plans into a single implementation pass — run one plan at a time
- Start implementation on main/master branch without explicit user consent
- Skip reviews — both stages (spec gate and code quality gate) are required for every task
- Proceed to the next task before both stages pass for the current task
- Run reviewers within a stage sequentially — within a stage, reviewers MUST run in parallel
- Proceed with unfixed issues
- Dispatch multiple implementation agents in parallel (conflicts)
- Make agents read plan files (provide full text instead)
- Skip scene-setting context
- Ignore agent questions (answer before letting them proceed)
- Accept "close enough" on spec compliance
- Skip review loops (issues found = fix = review again)
- Start code quality gate before spec gate passes
- Move to next task while either stage has open issues

The following are not valid reasons to skip a review step: "reviews can wait", "let me keep moving", "this is simple enough", "I'll review later", time pressure, task simplicity, or similarity to a previous task.

**If agent asks questions:**
- Answer clearly and completely
- Provide additional context if needed

**If reviewer finds issues:**
- Implementer (same agent) fixes them
- Reviewer reviews again
- Repeat until approved

## Integration

**Required skills:**
- **multi-perspective-review** — parallel review panels with synthesis
- **finishing-branch** — complete development after all tasks
- **code-review** — standalone code review dispatch
- **test-driven-development** — agents follow TDD for each task
