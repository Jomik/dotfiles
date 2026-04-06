---
name: design
description: Use when the user wants to build, add, fix, or change something in the codebase. Single entry point — detects what exists and produces specs and plans.
---

# Design

Produces specs and implementation plans. Detects the current phase from file state and picks up where you left off.

## Input Gathering

If the user provides a **GitHub issue or PR URL**, fetch it with `gh` and follow any referenced issues, PRs, and commits to build context. Carry the issue/PR number forward so specs, plans, and PRs reference it (e.g., `Closes #N`).

## Phase Detection

Check what exists:

1. Scan `docs/specs/` for specs covering the requested work
2. Scan `.plans/` for plans related to this work

| File state | Action |
|-----------|--------|
| No spec, design unclear | Brainstorm (Phase 1) then write spec (Phase 2) |
| No spec, design direction clear | Write spec (Phase 2) |
| Spec exists, needs changes | Amend spec (Phase 2, amendment mode) |
| Spec exists, no plan | Write plan (Phase 3) |
| Spec + plan exist | "Plan ready. Start a fresh session to implement." |
| Bug fix or small improvement | Write plan directly (Phase 3), then "Ready to implement." |

**"Design direction clear" criteria:** The user's request specifies the approach (not just the goal), names the components or areas involved, and leaves no open design trade-offs. If the request is only a goal or problem statement (e.g., "make it faster", "add auth"), direction is unclear — brainstorm first.

**When is a spec needed?** Specs capture design decisions for **new functionality** — new features, new subsystems, significant behavioral changes that need a target-state description. Bug fixes and small improvements (corrections, refinements, plumbing missing behavior through existing architecture) don't introduce new functionality and don't need a spec — go straight to a plan.

**Inline vs full plan for bug fixes / small improvements:**
- **Inline mode** (micro-plan, skip plan review): touches at most one source file plus its test, no public API changes, and the fix is fully specified.
- **Full plan** (with plan review): anything larger — multiple files, public API changes, or needs exploration to fully scope.

**When in doubt, pick the earlier phase.** Brainstorming is cheap; skipping it risks rework.

**If multiple specs cover overlapping areas:** identify all relevant specs and flag conflicts. Get user resolution before proceeding.

Present your assessment: what you found, what phase you're entering, and why. Wait for confirmation before proceeding.

## Phase 1: Brainstorm

Collaborative dialogue to converge on a design direction. No documents yet — just conversation.

**Ask clarifying questions:**
- One question at a time — don't overwhelm
- Use `AskUserQuestion` tool with multiple-choice options for trade-off decisions; open-ended for goals and constraints
- 2-4 questions maximum. If the user gives detailed answers, you may need fewer.

**Propose 2-3 approaches:**
- Present different approaches with trade-offs using `AskUserQuestion`
- Lead with your recommended option (marked as recommended) and explain why

**Present design:**
- Present in sections scaled to complexity — for smaller designs, combine sections and reduce checkpoints
- Ask after each section whether it looks right so far (for large designs) or present the whole design with a single checkpoint (for small ones)
- Cover: architecture, components, data flow, error handling, testing
- Design for isolation: units with one clear purpose, well-defined interfaces, independently testable
- In existing codebases: follow existing patterns

**Completion:** Summarize the agreed design direction in 2-3 sentences. Ask: "Does this capture the design direction? Ready to move to spec writing?" Proceed to Phase 2 on confirmation.

## Phase 2: Write Spec

### Guidelines

- **Specs describe the complete target system** — no phasing, no build order. That belongs in plans.
- **If something isn't ready to design, it's a non-goal** — not a "future phase"
- **YAGNI ruthlessly** — remove anything not needed for stated goals
- **In existing codebases** — follow existing patterns

### Amendment Mode

When updating an existing spec (not creating a new one):
1. Read the existing spec
2. Apply targeted changes — preserve approved sections
3. Scope the review panel to changed sections plus ripple effects

### Document Structure

Save to `docs/specs/YYYY-MM-DD-<topic>-design.md`. Scale each section to its complexity — not every spec needs every section.

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

### Spec Review Panel

Use the `multi-perspective-review` skill. Dispatch 2-3 `document-reviewer` agents with complementary lenses chosen for this spec's content. The panel must cover:

> - **Design quality:** Are components well-isolated with clean interfaces? Is the design maintainable long-term? Are there simpler alternatives that achieve the same goals?
> - **Accuracy:** 3rd party API/library claims verified against actual docs (Context7 or WebFetch)
> - **No ephemeral metadata** that will rot (Status, Date, Version, Author)
> - **No build-order or phasing language** — specs describe the target system, not how to build it

If review loop exceeds 3 iterations: stop and ask the user for guidance.

### Commit and Approval

Commit the spec after the review panel passes, before presenting to the user. Use the project's VCS.

> "Spec committed to `<path>`. The review panel checked internal consistency and technical accuracy. The main question is whether this matches what you actually want built. Let me know if you want any changes before we move to planning."

If the user requests changes, apply them and re-run the review panel on affected sections. Proceed to Phase 3 on approval.

## Phase 3: Write Plan

### Inline Mode

For small bug fixes / improvements that touch one file: write a minimal single-task plan file directly. Skip the plan review panel.

### Full Plan

Write comprehensive implementation plans assuming the engineer has zero context for the codebase. Document everything: which files to touch, code, testing commands, how to verify. DRY. YAGNI. TDD. Frequent commits.

Save to `.plans/YYYY-MM-DD-<feature-name>.md`. Plans are ephemeral — do NOT commit to VCS. `.plans/` is globally gitignored.

**Scope check:** If the spec covers multiple independent subsystems, suggest separate plans — one per subsystem.

#### Plan Header

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** Use the `implementing` skill to execute this plan.

**Goal:** [One sentence]
**Architecture:** [2-3 sentences]
**Spec:** `docs/specs/<filename>.md` (omit if no spec — e.g., bug fixes)
```

#### Task Structure

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

### Plan Review Panel

Use the `multi-perspective-review` skill. Dispatch 2-3 `document-reviewer` agents with the plan path and spec path.

All reviewers receive this checklist:

> - **Spec compliance:** Does the plan cover all spec requirements? Any scope creep?
> - **Task decomposition:** Are tasks atomic? Are steps actionable?
> - **Design fit across tasks:** Do abstractions chosen in earlier tasks compose well for later tasks? Would a different design in task N make tasks N+1 through end simpler or harder?
> - **Buildability:** Could an implementer follow this without getting stuck?

Same agent that wrote the plan fixes issues. If loop exceeds 3 iterations, ask the user.

### Completion

> "Plan saved to `.plans/<filename>.md`. Start a fresh session to implement."

## Integration

**Pairs with:**
- **multi-perspective-review** — spec and plan review panels
- **implementing** — produces plans that implementing executes (in a separate session)
