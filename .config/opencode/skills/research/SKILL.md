---
name: research
description: Use when the user needs to investigate a topic before designing — library landscape, prior art, codebase patterns, best practices. Produces a research brief in docs/refs/.
---

You are executing the research skill. Your role is to investigate a topic thoroughly before design work begins — mapping the landscape of options, prior art, codebase patterns, and external best practices. You produce a research brief that specs and ADRs can reference. Do not design or implement — that belongs to other skills.

## When to Use

- Evaluating libraries, frameworks, or tools before choosing
- Understanding how other projects solve a similar problem
- Mapping existing codebase patterns before proposing changes
- Gathering best practices or security considerations for an unfamiliar domain
- Any time the user says "research", "investigate", "look into", "what are the options"

Do NOT use for: debugging (use systematic-debugging), architectural decisions (use architecture-explore after research), or implementation (use design → implementing).

## Phase 1: Define the Question

Establish what we need to learn. Ask 1-3 clarifying questions max:

- What is the specific question or decision this research supports?
- What constraints exist (language, platform, licensing, existing patterns)?
- What do we already know or assume?

Produce a **research question** — one sentence stating what the brief must answer. Confirm with the user before proceeding.

## Phase 2: Investigate

Two tracks, run in parallel where possible:

### Codebase Investigation

Dispatch explore subagents via the Task tool. Each subagent gets a narrow, specific question — not "explore everything about X." Scale the number to the question's scope (1-3 subagents typical).

Examples of good subagent prompts:
- "Find all places where authentication is handled. Report: which libraries are used, what patterns exist, where the boundaries are."
- "Map the data flow from API request to database write for the orders module. Report: layers involved, error handling patterns, serialization approach."

### External Research

Use webfetch to investigate external sources:
- Official documentation for candidate libraries/tools
- Comparison articles, benchmarks, known issues
- Prior art — how other projects solve this problem

Be specific with URLs. Prefer official docs and reputable sources. Do not fabricate URLs — if you don't know the exact URL, ask the user to provide it.

If the topic is purely internal (codebase patterns, existing architecture), skip external research and note in the brief that external sources were not applicable.

### Evidence Standard

Every claim in the brief must trace to either:
- A codebase finding (file path + what was found)
- An external source (URL + what it says)

No unsourced assertions. If something is your inference, label it as such.

## Phase 3: Synthesize

Write the brief to `docs/refs/YYYY-MM-DD-<topic>-research.md`. The date prefix is for file sorting, not metadata — the brief body must not include date/author/status fields.

### Brief Template

```
# [Topic] Research Brief

## Question

[The research question from Phase 1.]

## Summary

[2-4 paragraphs: what we found, what the key trade-offs are, what stands out.]

## Findings

### [Finding Area 1]

[What we learned. Cite sources — file paths for codebase, URLs for external.]

### [Finding Area 2]

[...]

## Options

[If the research concerns a choice (library, approach, pattern), list candidates with pros/cons. If purely investigative, omit this section.]

### [Option A]

- Good, because [...]
- Bad, because [...]

### [Option B]

- Good, because [...]
- Bad, because [...]

## Open Questions

[Anything unresolved that design or ADR work should address.]
```

### Template Principles

- No ephemeral metadata (no Date, Author, Status). VCS provides this.
- Findings over opinions. Label inferences explicitly.
- Concise — aim for the shortest brief that answers the question. Scale sections to complexity.
- Options section only when there's a genuine choice to make.

## Phase 4: Review

Dispatch 1-2 `doc-reviewer` subagents in parallel. Scale to brief complexity. Each gets a non-overlapping lens:

**Lens 1 — Accuracy & Evidence**
- Are claims sourced? Codebase findings cite file paths? External claims cite URLs?
- Are options fairly represented (not strawman alternatives)?
- Are there obvious gaps — sources that should have been consulted but weren't?

**Lens 2 — Usefulness & Clarity** (for larger briefs)
- Does the summary actually answer the research question?
- Could someone reading only the Summary make an informed decision?
- Is the brief concise? Flag padding or unnecessary sections.
- No ephemeral metadata. No implementation details. No design decisions.

Fix issues and re-review (max 2 iterations, then ask user).

## Phase 5: Commit and Handoff

After review passes:

1. Commit the brief using the project's VCS. Message format: `docs: add research brief — <topic>`.
2. Present to user:
   > "Brief committed to `docs/refs/<filename>.md`. Key findings: [1-2 sentence summary]. This is ready to reference from a spec or ADR. Next step depends on what the research was for — invoke the design skill or architecture-explore skill in a new session."
3. If the user wants to continue to design in the same session, that's fine — load the design skill and carry the brief forward as context.
