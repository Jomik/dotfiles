---
name: brainstorming
description: You MUST use this before creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation.
---

# Brainstorming Ideas Into Designs

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

<HARD-GATE>
Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it.
</HARD-GATE>

## Steps

You MUST create a task for each of these steps and complete them in order.

### 1. Explore project context

Check files, docs, and recent commits to understand the current state.

### 2. Ask clarifying questions

- Before asking detailed questions, assess scope: if the request describes multiple independent subsystems, flag this immediately and help the user decompose into sub-projects
- Ask questions one at a time — only one question per message
- Prefer multiple choice questions using `AskUserQuestion` when possible, but open-ended is fine too
- Focus on understanding: purpose, constraints, success criteria

### 3. Propose 2-3 approaches

- Present different approaches with trade-offs using `AskUserQuestion`, with your recommended option first (marked as recommended)
- Lead with your recommended option and explain why

### 4. Present design

- Present the design in sections scaled to their complexity: a few sentences if straightforward, up to 200-300 words if nuanced
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Design for isolation: break the system into units that each have one clear purpose, communicate through well-defined interfaces, and can be understood and tested independently
- In existing codebases: follow existing patterns. Include targeted improvements only where existing code has problems that affect the work. Don't propose unrelated refactoring.

### 5. Write design doc and commit

- Save to `docs/specs/YYYY-MM-DD-<topic>-design.md` (user preferences for spec location override this default)
- Commit via project's VCS

### 6. Spec review panel

Use the `multi-perspective-review` skill. Dispatch 2-3 `document-reviewer` agents in parallel, each with a different lens chosen by the orchestrator based on what matters most for this spec.

All reviewers receive the path to the spec document and this shared checklist addendum:

> **Additional checks for spec review:**
> - **External claims:** Verify any claims about 3rd party APIs/libraries against actual documentation using Context7 (preferred) or WebFetch
> - **Architecture:** Do units have clear boundaries and well-defined interfaces? Can each be understood and tested independently?
> - **No ephemeral metadata:** Flag any fields that will rot (e.g. Status, Date, Version, Author). The date is in the filename; status is derivable from whether a plan/implementation exists.

Follow the `multi-perspective-review` skill for synthesis and re-review loop. If loop exceeds 3 iterations: stop and ask the user for guidance on the unresolved issues (show what the reviewer flagged and what you've tried).

### 7. User reviews written spec

> "Spec written and committed to `<path>`. Please review it and let me know if you want to make any changes before we start writing the implementation plan."

Wait for user approval. Only proceed once the user approves.

### 8. Transition to implementation

Invoke the `writing-plans` skill to create the implementation plan. Do not invoke any other skill — `writing-plans` is the next step.

## Key Principles

- **One question at a time** — Don't overwhelm with multiple questions
- **Multiple choice preferred** — Easier to answer than open-ended when possible
- **YAGNI ruthlessly** — Remove unnecessary features from all designs
- **Explore alternatives** — Always propose 2-3 approaches before settling
- **Incremental validation** — Present design, get approval before moving on
