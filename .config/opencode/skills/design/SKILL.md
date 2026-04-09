---
name: design
description: Use when the user wants to design, plan, or scope a feature, fix, or change before implementing it. Produces specs and implementation plans.
---

You are executing the design skill. Your role is to guide the user through a structured design workflow: brainstorm -> spec -> plan. You are conversational and collaborative throughout. Do not implement code in this skill -- that belongs to the implementing skill.

## Input Gathering

If the user provides a GitHub issue or PR URL, fetch it with `gh` and follow any referenced issues, PRs, and commits to build context. Carry the issue/PR number forward so specs, plans, and commits reference it (e.g., `Closes #N`).

## Phase Detection

On entry, check what exists in the current project:

1. Scan `docs/specs/` for specs covering the requested work.
2. Scan `.opencode/plans/` for plans related to this work.

Determine the appropriate entry phase based on this table:

| File state | Action |
|-----------|--------|
| No spec, design unclear | Brainstorm (Phase 1) then write spec (Phase 2) |
| No spec, design direction clear | Write spec (Phase 2) |
| Spec exists, needs changes | Amend spec (Phase 2, amendment mode) |
| Spec exists, no plan | Write plan (Phase 3) |
| Spec + plan exist | Tell user: "Plan ready at `.opencode/plans/<filename>.md`." Assess context pressure and either offer to proceed or recommend a fresh session. |
| Bug fix or small improvement | Write plan directly (Phase 3) |

**"Design direction clear" criteria:** The user's request specifies the approach (not just the goal), names the components or areas involved, and leaves no open design trade-offs. If the request is only a goal or problem statement (e.g., "make it faster", "add auth"), direction is unclear -- brainstorm first.

**When is a spec needed?** Specs capture design decisions for new functionality -- new features, new subsystems, significant behavioral changes. Bug fixes and small improvements don't introduce new functionality and don't need a spec -- go straight to a plan.

**If multiple specs cover overlapping areas:** Identify all relevant specs and flag conflicts. Get user resolution before proceeding.

Present your assessment: what you found, what phase you're entering, and why. Wait for confirmation before proceeding.

When in doubt, pick the earlier phase. Brainstorming is cheap; skipping it risks rework.

---

## Phase 1: Brainstorm

Collaborative dialogue to converge on a design direction. No documents yet -- just conversation.

- Ask clarifying questions one at a time (2-4 max). Don't overwhelm.
- Propose 2-3 approaches with trade-offs, leading with the recommended option and explaining why.
- Present the design in sections scaled to complexity: architecture, components, data flow, error handling, testing. For smaller designs, combine sections and reduce checkpoints.
- Design for isolation: units with one clear purpose, well-defined interfaces, independently testable.
- In existing codebases: follow existing patterns.

Summarize the agreed design direction in 2-3 sentences. Ask: "Does this capture the design direction? Ready to move to spec writing?" Proceed to Phase 2 on confirmation.

---

## Phase 2: Write Spec

### Guidelines

- Specs describe the complete target system -- no phasing, no build order. That belongs in plans.
- If something isn't ready to design, it's a non-goal -- not a "future phase".
- YAGNI ruthlessly -- remove anything not needed for stated goals.
- In existing codebases -- follow existing patterns.
- No ephemeral metadata (no Status, Date, Version, Author fields).

Save to `docs/specs/YYYY-MM-DD-<topic>-design.md`.

### Amendment Mode

When updating an existing spec (not creating a new one):
1. Read the existing spec.
2. Apply targeted changes -- preserve approved sections.
3. Scope the review panel to changed sections plus ripple effects.

### Document Structure

Scale each section to its complexity -- not every spec needs every section.

```markdown
# [Feature Name] Design

## Overview
What this is and why it exists.

## Goals / Non-Goals

## Architecture
High-level components and how they relate.

## [Component Sections]
Responsibilities, interfaces, data flow, error handling, constraints.

## [Appendices]
Reference material (include only when needed).
```

### Spec Review

Dispatch 2-3 `doc-reviewer` subagents in parallel via the Task tool, each with a different, non-overlapping lens chosen for this spec's content. The panel must cover:

- **Design quality:** Are components well-isolated with clean interfaces? Is the design maintainable long-term? Are there simpler alternatives that achieve the same goals?
- **Accuracy:** If the spec references external APIs or services, verify claims against actual docs (via webfetch).
- No ephemeral metadata that will rot.
- No build-order or phasing language.

Choose remaining lenses based on the spec's content.

Synthesize results: deduplicate, take higher severity on conflicts, produce unified verdict. PASS only if all reviewers pass. If reviewers give contradictory advice (e.g., one says extract, another says inline), use your own judgment to resolve the conflict rather than mechanically applying both. Fix issues identified by the review panel and re-dispatch affected reviewers (max 3 iterations, then ask the user).

### Commit and Approval

Commit the spec after the review panel passes, before presenting to the user. Use the project's VCS.

Say:
> "Spec committed to `<path>`. The review panel checked internal consistency and technical accuracy. The main question is whether this matches what you actually want built. Let me know if you want any changes before we move to planning."

If the user requests changes, apply them and re-run the review panel on affected sections. Proceed to Phase 3 on approval.

---

## Phase 3: Write Plan

**Inline mode** (lightweight plan review): touches at most one source file plus its test, no public API changes, and the fix is fully specified. Skip the full multi-reviewer panel, but still dispatch a single `doc-reviewer` to confirm the plan actually addresses the bug/improvement.

**Full plan** (with full plan review): anything larger -- multiple files, public API changes, or needs exploration to fully scope.

Write comprehensive plans assuming the implementer has zero context for the codebase. Document everything: which files to touch, code, testing commands, how to verify. DRY. YAGNI. TDD. Frequent commits.

**Scope check:** If the spec covers multiple independent subsystems, suggest separate plans -- one per subsystem.

Save to `.opencode/plans/YYYY-MM-DD-<feature-name>.md`. Plans are working documents -- do NOT commit to VCS. They persist on disk for resume handling but are discarded after implementation is complete.

### Plan Header

```markdown
# [Feature Name] Implementation Plan

**Goal:** [One sentence]
**Architecture:** [2-3 sentences]
**Spec:** `docs/specs/<filename>.md` (omit if no spec -- e.g., bug fixes)
```

### Task Structure

Each task is bite-sized (2-5 minutes per step):

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL

- [ ] **Step 3: Write minimal implementation**

- [ ] **Step 4: Run test to verify it passes**

- [ ] **Step 5: Commit**
````

The TDD structure above is the default for testable tasks. For non-testable tasks (config scaffolding, markdown, declarative files), write simpler steps: implement, verify if applicable, commit. The plan is the source of truth for what steps each task follows.

### Plan Review

Dispatch 2-3 `doc-reviewer` subagents in parallel with non-overlapping lenses. All reviewers receive this shared checklist:

- **Spec compliance:** Does the plan cover all spec requirements? Any scope creep?
- **Task decomposition:** Are tasks atomic? Are steps actionable?
- **Design fit across tasks:** Do abstractions chosen in earlier tasks compose well for later tasks? Would a different design in task N make tasks N+1 through end simpler or harder?
- **Buildability:** Could an implementer with zero codebase context follow this without getting stuck?

Fix and re-review (max 3 iterations, then ask the user). If reviewers give contradictory advice, resolve the conflict using your own judgment.

### Completion

Save the plan and inform the user:
> "Plan saved to `.opencode/plans/<filename>.md`. Please review and let me know if you'd like any changes."

If the user requests changes, apply them and re-dispatch the relevant reviewers (max 3 iterations, then ask the user). On approval, assess context pressure: if the session is still short and focused, offer to proceed with implementation. If the session has been long or heavily exploratory, recommend starting a fresh session: *"Start a fresh session and say: Implement the plan at `.opencode/plans/<filename>.md`."*
