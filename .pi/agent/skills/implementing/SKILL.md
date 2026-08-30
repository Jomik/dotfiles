---
name: implementing
description: Use when a committed spec exists and is ready to implement. Maps the affected code, decomposes work into atomic patches, dispatches mason per patch, and enforces sentinel review gates.
---

You are executing the implementing skill. Your role is orchestration: map the spec to the codebase, define atomic implementation tasks, dispatch masons, classify their results, and manage review. You MUST NOT write implementation code yourself. Use cartographer for codebase reconnaissance and mason for concrete patches.

---

## On Entry

1. **Pre-flight checks:**
   - Check VCS status. If the working tree contains unrelated user changes, ask the user how to preserve them before implementation.
   - Detect VCS and follow AGENTS.md: use jj whenever `jj root` succeeds; otherwise use git.
   - Git: do not implement on main/master; ask for a feature branch.
   - Jj: `@` must be a distinct mutable working-copy change, not the trunk commit itself. An empty child of `trunk()` is valid. Create a new change before editing trunk directly.
   - Verify the referenced spec is committed. The spec and VCS history are the source of truth.

2. **Resume before planning:**
   - Inspect commits since the spec and the current working-copy diff.
   - Match completed commits to spec requirements and skip completed work.
   - If the working copy contains partial implementation matching the spec, enter recovery for that task instead of starting new work.
   - Do not rely on session-only task state. VCS is the durable progress ledger.

3. **Reconnaissance:**
   - For every non-trivial implementation, dispatch one cartographer before decomposition.
   - Give cartographer the relevant spec sections and ask for: affected files, symbols, callers, existing helpers, tests, module boundaries, and likely atomic seams. Cartographer is read-only and does not design or edit.
   - Skip reconnaissance only for a genuinely trivial, already-known single-file edit; state why.
   - If an imp cannot access the target path because of sandboxing, the parent may read configuration files directly, but still must not implement project code while this skill is active.

4. **Decompose into atomic patches:**
   - Use the spec plus cartographer map to create ordered tasks.
   - Each task must name:
     - one observable behavior or enabling invariant;
     - exact source files and symbols expected to change;
     - exact test files or focused check;
     - acceptance criteria for sentinel;
     - explicit non-goals;
     - a conventional commit message.
   - A task must be small enough for one mason execution window and one independently reviewable commit. Prefer one behavior, roughly 1–3 production files, and focused tests. This is a heuristic, not a quota.
   - Split foundations, conversion, integration, and UI wiring into separate tasks when each can be validated independently.
   - Mason executes a patch; mason does not discover or design a feature.

5. **Present tasks to the user:**
   - Show the numbered task list and review gates. Wait for approval or adjustments.
   - After approval, the orchestrator may split an approved task into smaller atomic patches without asking again when scope and acceptance criteria are unchanged. Announce the split.

There is no errand/chore API. Do not reference `plan_errands`, `track_errands`, or `add_chores`.

---

## Per-Task Loop

### 1. Record the starting state

Before summoning mason, record:
- current revision/change ID;
- clean or dirty working-copy state;
- the exact task being attempted.

This lets the orchestrator distinguish a real commit from a no-op.

### 2. Dispatch mason

Keep the prompt concise. Include only:
- exact files/symbols from reconnaissance;
- required behavior;
- focused acceptance check;
- explicit non-goals;
- relevant spec excerpt, not the full spec;
- VCS/commit instruction;
- TDD instruction when the spec requires it.

Template:

```text
Implement this atomic patch.

Files/symbols:
- ...

Required behavior:
- ...

Focused check:
- ...

Non-goals:
- ...

Use the repository's VCS workflow. Record the intended jj change before editing
when applicable. Format affected files, run the smallest focused check available,
commit with `<message>`, and leave a clean working copy.

Return a non-empty status report containing: COMPLETE, BLOCKED, NEEDS_SPLIT,
INCOMPLETE, or NO_CHANGE; commit/change ID; files changed; focused check result;
and any deviation.
```

Do not ask mason to remap the repository, copy a full design document, run every possible validation command, or solve multiple independent changes in one summon.

### 3. Classify the result using agent output and VCS evidence

Never treat agent status alone as success.

- **Provider/auth/harness failure:** no repository work occurred. Retry with a fresh mason. This does not count as an implementation attempt.
- **Commit exists and working copy is clean:** proceed to the review gate even if mason violated its report contract by returning empty output. VCS is authoritative; record the missing report.
- **Agent reports COMPLETE but no commit exists:** the claim is invalid. Classify from the working copy: dirty means INCOMPLETE; clean means no-op.
- **Agent returns empty output, no commit, clean working copy:** report-contract violation and no-op. Retry once with a shorter, more concrete prompt. If repeated, return to the cartographer map and split the task.
- **Dirty working copy, no commit:** incomplete or truncated work. Preserve it. Inspect the pending diff and dispatch a read-only sentinel diagnostic for a concrete completion list when needed, then send a narrowly scoped recovery mason. Never discard partial work silently.
- **Truncated with no changes:** the task did not fit the execution window. Split it before retrying.
- **NEEDS_SPLIT:** validate mason's proposed slices against the approved scope and cartographer map, then use them directly when sound. Re-run reconnaissance only if the slices reveal an unmapped seam.
- **BLOCKED:** escalate only when a user decision, missing requirement, unavailable dependency, access problem, or irreducible architectural conflict is required.
- **NO_CHANGE:** dispatch sentinel with the named seams, required behavior, and expected coverage to verify the behavior already exists. If sentinel passes, record the task complete without a commit; otherwise treat it as a no-op.

Retries are based on progress, not a flat attempt count. **No progress** means no new commit, no pending diff growth, and no new concrete diagnostic or split. Two consecutive no-progress results after reconnaissance and atomic splitting are a genuine blocker; escalate with evidence and halt. Repeated truncations that continue to produce coherent diff growth should be converted into smaller reviewable patches rather than escalated automatically.

### 4. Review gate

For each committed atomic task:

1. Fetch the exact committed diff for that task.
2. Dispatch sentinel with:
   - task requirements, acceptance criteria, and non-goals;
   - the relevant spec excerpt;
   - exact committed diff/revision;
   - correctness, error-handling, consistency, and unrequested-change criteria;
   - instruction to run the full validation tools available in the project;
   - required first-line verdict: `PASS`, `PASS WITH WARNINGS`, or `FAIL`, followed by exact file/symbol findings and validation results.
3. Classify the first-line verdict:
   - **PASS:** task complete.
   - **PASS WITH WARNINGS:** task complete unless a warning contradicts acceptance criteria; record deferred warnings.
   - **FAIL:** convert each blocking finding into a focused fix prompt naming exact files/symbols. Dispatch mason, then re-run only the failed gate.
4. Maximum three fix cycles for the same proven issue. If the issue changes, reclassify it rather than blindly incrementing a counter. After three failed fixes, preserve the current VCS state, report the repeated failure evidence, escalate to the user, and halt that task.

Review is a gate, not a mason chore. Mason owns the patch; sentinel owns full validation and review.

---

## Final Review

After all atomic tasks pass:

1. **Full implementation diff:** collect the complete diff from the spec base through the latest completed task.

2. **Parallel sentinel lenses:** dispatch 3–5 sentinels with distinct lenses.
   - One MUST be spec compliance and cross-task integration.
   - Remaining lenses must target actual risks from the implementation, not generic defaults.
   - Announce each lens before dispatching.
   - All lenses must PASS. For a failure, identify the smallest responsible seam and dispatch a focused mason fix; do not send the full diff as an unbounded implementation task.
   - Maximum three total final-review fix cycles before escalation.

3. **Documentation check:** dispatch arbiter with the full diff and relevant README/docs files. Skip CHANGELOG and committed specs. If documentation is stale, dispatch a focused mason documentation patch and re-check.

4. **Completion report:**

   > Implementation complete. N/N atomic tasks passed. Final review: PASS/FAIL. [Recorded warnings or concerns.]

   If PASS and the repository has a configured git remote/forge, ask whether to create a PR using the pr-create skill. In jj, create/push a bookmark as required by that skill before PR creation. If no forge is configured, report completion without a PR handoff. If FAIL, report exact outstanding issues and wait for direction.

---

## Principles

- **Map first, then dispatch.** Cartographer discovers; the orchestrator decomposes; mason executes.
- **Atomic patches beat feature-sized prompts.** The smallest independently valid commit is the unit of work.
- **Concrete seams are required.** Include file paths, symbols, tests, and non-goals.
- **VCS is the progress ledger.** Commits and pending diffs replace unavailable chore-tracking tools.
- **Repository evidence beats agent status.** Verify every claimed completion.
- **Mason commits; the orchestrator does not.** History edits are allowed only for cleanup explicitly required by the VCS workflow.
- **Preserve partial work.** Diagnose and recover; never discard silently.
- **Validation is separate from implementation.** Mason runs a focused check; sentinel runs the full gate.
- **Split before escalating.** Escalate decisions and genuine blockers, not ordinary task-size problems.
- **Keep prompts lean.** Relevant context only; do not bury the patch in the full spec or repeated workflow boilerplate.
