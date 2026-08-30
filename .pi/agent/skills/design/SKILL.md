---
name: design
description: Use when the user wants to design, plan, or scope a feature, fix, or change before implementing it. Produces a design document.
---

# Design

Structured thinking before implementation. Brainstorm → Design doc.

## Core Principle

**Decide before building.** A design doc captures decisions so they survive context loss. Without it, every new session re-derives the same conclusions — or worse, different ones.

**Show your reasoning.** At each phase, report to the user: what you explored, what you propose, and why. This is not optional narration — it is how you and the user stay aligned. Design is collaborative — the user approves direction, not just output.

## On Entry

1. **Discover project conventions.** Look for existing design docs, specs, ADRs, or planning artifacts in the repo. Identify the pattern: where they live, what format they use, how detailed they are. Follow the project's convention — don't impose a new one. If nothing exists, note it and move on — you'll propose a format in Phase 2.
2. **Check what already exists** for this work. Existing design docs, ADRs, related specs, prior plans. If an ADR exists, treat its decisions as constraints.
3. **Detect your starting phase:**

| What exists | Start at |
|---|---|
| Nothing, direction unclear | Brainstorm |
| Nothing, direction clear | Design doc |
| Design doc exists, needs changes | Amend it |
| Design doc exists | Done — tell the user; a fresh session can implement from it |

"Direction clear" means: the user specifies the approach (not just the goal), names the components, and leaves no open design trade-offs. If only a goal is stated ("make it faster", "add auth"), brainstorm first. When in doubt, brainstorm — it's cheap.

**Report:** What you found, what phase you're entering, why. Proceed unless the user redirects.

## Phase 1: Brainstorm

**Why:** Exploring alternatives is cheap. Committing to the wrong direction is expensive.

Collaborative dialogue — no documents yet.

1. Ask focused clarifying questions — don't dump a list. Be conversational.
2. Propose 2-3 approaches with trade-offs. Lead with your recommendation and why.
3. In existing codebases: follow existing patterns unless an ADR establishes new ones.

**Report:** Summarize the agreed direction in 2-3 sentences. Ask if ready to move on. Proceed on confirmation.

## Phase 2: Design Doc

**Why:** A design doc captures the WHAT and WHY so the plan can focus on HOW. It outlives the conversation.

### What belongs in a design doc

- Component responsibilities and relationships
- Interfaces described in prose (not signatures)
- Data flow at the component boundary level (not internal call sequences)
- Error strategies (failure modes, retry policy, degradation)
- Key invariants and constraints
- Non-goals (what you're explicitly not doing)

This is not a checklist to fill. Match the scope — a focused feature is a few paragraphs, not a multi-section document. Expand only when the system is genuinely complex.

### What does NOT belong

- Code, type names, file paths, function signatures
- Build order or phasing (that's the plan)
- Ephemeral metadata (status, date, author)

**Litmus test:** If it would change when someone renames a variable or moves a file, it belongs in the plan, not the design doc.

Use role names ("the transport layer", "the connection manager") not codebase identifiers. Architecture diagrams (ASCII boxes) are fine.

**Be opinionated.** The brainstorm explored options. The design doc commits to decisions. Don't present alternatives — pick one and state why.

**YAGNI ruthlessly.** If it's not needed for the stated goals, cut it. Things you're not designing are non-goals, not "future phases."

### Format and location

Follow the project's existing convention. If none exists, propose a location and format to the user — prefer concise (a single `DESIGN.md` or equivalent) unless complexity demands more structure.

**Report:** Present the design doc. It captures decisions — the main question is whether it matches what the user wants built.

## Completion

The deliverable is the design document — committed to the repo. A fresh session can implement from it without needing this conversation's context.
