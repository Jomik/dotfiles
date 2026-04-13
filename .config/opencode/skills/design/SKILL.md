---
name: design
description: Use when the user wants to design, plan, or scope a feature, fix, or change before implementing it. Produces specs and implementation plans.
---

You are executing the design skill. Your role is to guide the user through a structured design workflow: brainstorm -> spec -> plan. You are conversational and collaborative throughout. Do not implement code in this skill -- that belongs to the implementing skill.

## Input Gathering

If the user provides a GitHub issue or PR URL, fetch it with `gh` and follow any referenced issues, PRs, and commits to build context. Carry the issue/PR number forward so specs, plans, and commits reference it (e.g., `Closes #N`).

## Phase Detection

On entry, check what exists in the current project:

1. Scan `docs/adrs/` for ADRs related to the requested work.
2. Scan `docs/specs/` for specs covering the requested work.
3. Scan `.opencode/plans/` for plans related to this work.

**ADR handling:** If relevant ADRs exist, read them and carry them forward as architectural constraints. An ADR's "Decision" section defines the chosen direction -- treat it as a constraint, not a suggestion. Where an ADR's patterns differ from the current codebase, **follow the ADR**. Note which ADRs are active and summarize how they constrain the current work when presenting your assessment.

Determine the appropriate entry phase based on this table:

| File state | Action |
|-----------|--------|
| No spec, design unclear | Brainstorm (Phase 1) then write spec (Phase 2) |
| No spec, design direction clear | Write spec (Phase 2) |
| ADR exists, no spec | Write spec (Phase 2) |
| Spec exists, needs changes | Amend spec (Phase 2, amendment mode) |
| Spec exists, no plan | Write plan (Phase 3) |
| Spec + plan exist | Tell user: "Plan ready at `.opencode/plans/<filename>.md`." Assess context pressure and either offer to proceed or recommend a fresh session. |
| Bug fix or small improvement | Write plan directly (Phase 3) |

**"Design direction clear" criteria:** The user's request specifies the approach (not just the goal), names the components or areas involved, and leaves no open design trade-offs. A relevant ADR counts as a clear direction for the areas it covers. If the request is only a goal or problem statement (e.g., "make it faster", "add auth") and no ADR applies, direction is unclear -- brainstorm first.

**When is a spec needed?** Specs capture design decisions for new functionality -- new features, new subsystems, significant behavioral changes. Bug fixes and small improvements don't introduce new functionality and don't need a spec -- go straight to a plan.

**If multiple specs cover overlapping areas:** Identify all relevant specs and flag conflicts. Get user resolution before proceeding.

**If an ADR conflicts with an existing spec:** The ADR takes precedence -- it represents a more recent architectural decision. Flag the conflict to the user and propose amending the spec.

Present your assessment: what you found, what phase you're entering, and why. Wait for confirmation before proceeding.

When in doubt, pick the earlier phase. Brainstorming is cheap; skipping it risks rework.

---

## Phase 1: Brainstorm

Collaborative dialogue to converge on a design direction. No documents yet -- just conversation.

- Ask clarifying questions one at a time (2-4 max). Don't overwhelm.
- Propose 2-3 approaches with trade-offs, leading with the recommended option and explaining why.
- Present the design in sections scaled to complexity: architecture, components, data flow, error handling, testing. For smaller designs, combine sections and reduce checkpoints.
- Design for isolation: units with one clear purpose, well-defined interfaces, independently testable.
- In existing codebases: follow existing patterns -- unless a relevant ADR establishes new patterns for the affected areas, in which case follow the ADR.

Summarize the agreed design direction in 2-3 sentences. Ask: "Does this capture the design direction? Ready to move to spec writing?" Proceed to Phase 2 on confirmation.

---

## Phase 2: Write Spec

### Guidelines

- Specs describe the complete target system -- no phasing, no build order. That belongs in plans.
- Specs capture **design decisions and constraints**, not code. Write prose describing component responsibilities, protocol surface (in words, not signatures), error strategies, and key invariants. Do not include: code blocks, concrete type/class/method/property names from the codebase, file paths, import statements, function signatures, before/after renaming tables, or file-change manifests. Those all belong in plans. Use role names ("the transport protocol", "the mock", "the connection manager") not codebase identifiers (`BLETransport`, `MockTransport`, `BoardConnection`). The litmus test: if it would change when someone renames a variable or moves a file, it doesn't belong in the spec. Architecture diagrams (ASCII boxes showing component relationships) are fine -- they describe structure, not code.
- If something isn't ready to design, it's a non-goal -- not a "future phase".
- YAGNI ruthlessly -- remove anything not needed for stated goals.
- In existing codebases -- follow existing patterns, unless a relevant ADR establishes new patterns for the affected areas.
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

Dispatch `doc-reviewer` subagents in parallel via the Task tool. Scale the number of reviewers to the spec's complexity. Assign each reviewer a single, non-overlapping lens. The panel as a whole must cover at minimum:

- Are components well-isolated with clean interfaces? Are there simpler alternatives that achieve the same goals?
- If the spec references external APIs or services, verify claims against actual documentation.
- No implementation details: flag any code blocks, concrete type/class/method names, file paths, function signatures, property listings, before/after renaming tables, or file-change manifests. Specs use role names and prose, not codebase identifiers; all code-level detail belongs in plans.
- No ephemeral metadata that will rot.
- No build-order or phasing language.

Add lenses relevant to the specific spec's content.

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
**ADR:** `docs/adrs/<filename>.md` (omit if no ADR applies)
```

### Task Structure

Each task is bite-sized (2-5 minutes per step):

````markdown
- [ ] Task N: [Component Name]

**Files:**
- Create: `exact/path/to/new-file`
- Modify: `exact/path/to/existing-file`
- Test: `exact/path/to/test-file`

1. **Write the failing test**

[Test code in the project's language -- include the actual test, not a placeholder.]

2. **Run test to verify it fails**

Run: `[test command targeting the specific test]`
Expected: FAIL

3. **Write minimal implementation**

4. **Run test to verify it passes**

5. **Commit**
````

The TDD structure above is the default for testable tasks. For non-testable tasks (config scaffolding, markdown, declarative files), write simpler steps: implement, verify if applicable, commit. The plan is the source of truth for what steps each task follows.

### Plan Review

Dispatch `doc-reviewer` subagents in parallel. Scale the number of reviewers to the plan's complexity. Assign each reviewer a single, non-overlapping lens. The panel as a whole must cover:

- Does the plan cover all spec requirements without scope creep?
- Are tasks atomic and steps actionable?
- Do abstractions chosen in earlier tasks compose well for later tasks?
- Could an implementer with zero codebase context follow this without getting stuck?

Add lenses relevant to the specific plan.

Fix and re-review (max 3 iterations, then ask the user). If reviewers give contradictory advice, resolve the conflict using your own judgment.

### Completion

Save the plan and inform the user:
> "Plan saved to `.opencode/plans/<filename>.md`. Please review and let me know if you'd like any changes."

If the user requests changes, apply them and re-dispatch the relevant reviewers (max 3 iterations, then ask the user). On approval, assess context pressure: if the session is still short and focused, offer to proceed with implementation. If the session has been long or heavily exploratory, recommend starting a fresh session: *"Start a fresh session and say: Implement the plan at `.opencode/plans/<filename>.md`."*
