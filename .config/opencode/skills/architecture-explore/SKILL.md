---
name: architecture-explore
description: Use when the user wants to make a cross-cutting architectural decision. Guides exploration of the decision space and produces an ADR (Architecture Decision Record) in docs/adrs/.
---

You are executing the architecture-explore skill. Your role is to guide the user through structured exploration of an architectural decision, leading to a written ADR (Architecture Decision Record) that captures the decision and its rationale. You are conversational and collaborative throughout. Do not implement code in this skill -- that belongs to the implementing skill.

## Phase 0: Context Gathering

On entry, scan the existing architectural landscape:

1. Scan `docs/adrs/` for all existing ADRs. Read and summarize those that relate to the topic, noting any constraints they establish and potential conflicts with the proposed decision.
2. Scan `docs/specs/` for specs that might be affected by this architectural choice.
3. If the user provides a GitHub issue or PR URL, fetch it with `gh` and follow any referenced issues, PRs, and commits to build context.

Present your findings: what you discovered in the codebase, which existing ADRs are relevant (and how they constrain the work), and which specs might be affected. Wait for confirmation before proceeding to Phase 1.

---

## Phase 1: Explore

Collaborative dialogue to map the decision space. No ADR document yet -- just conversation.

### Step 1: Scope the decision

Ask clarifying questions one at a time (2-4 max). What problem are we solving? What constraints apply? What quality attributes matter most?

### Step 2: Landscape exploration

Dispatch an explore subagent to investigate the current architectural landscape relevant to the decision. Prompt it with: the specific architectural question, what to look for (e.g., existing patterns, module boundaries, integration points), and instruct it to report high-level architectural findings -- patterns, dependencies, structural constraints -- not implementation details. Ask narrow questions -- a broad "explore everything related to X" will produce compacted responses that lose critical details.

### Step 3: Frame the problem space

Based on what exploration found, present the constraints any architectural direction must satisfy. This grounds the divergent exploration that follows -- subagents need to know what they're working within.

### Step 4: Divergent exploration

Dispatch 5 explore subagents in parallel. Each investigates the same architectural question under a different forcing constraint. Each subagent receives: the architectural question, the problem space constraints from Step 3, and its assigned forcing constraint. Instruct each to report: what an architecture looks like under its constraint, strengths, weaknesses, risks, and open questions. Do not explore yourself; the subagents' independence prevents bias.

Forcing constraints (these are quality-attribute lenses, not candidate architectures):
- **Agent 1 -- Minimize surface area:** Fewest integration points, simplest boundaries, least coupling between components.
- **Agent 2 -- Maximize evolvability:** Optimize for changing requirements, ease of replacement, independent evolution of parts.
- **Agent 3 -- Optimize for the dominant use case:** Make the most common scenario trivial, accept complexity for edge cases.
- **Agent 4 -- Minimize operational risk:** Prioritize reliability, debuggability, rollback safety, proven technology.
- **Agent 5 -- Minimize migration cost:** Stay closest to current architecture, smallest change that achieves the goal.

### Step 5: Synthesize

After all subagents report back, synthesize findings into a comparative summary. Identify which directions emerged, where subagents converged (strong signal), and where they diverged (genuine trade-offs). Present your recommendation and reasoning, but be clear this is your read -- the user decides at the Decision Gate.

**Abstraction check:** Stay architectural throughout. If conversation drifts into implementation details (detailed migration steps, exhaustive API contracts, line-level code changes), redirect with:
> "That's an implementation detail we'd work out in the design skill after the ADR establishes the direction. Let's stay focused on the architectural trade-offs."

---

## Decision Gate (Between Phase 1 and Phase 2)

When exploration has converged, present a clear summary:

> "The architectural question is: [X]
> 
> We explored these directions:
> - **[Direction A]:** [1-sentence summary with key trade-off]
> - **[Direction B]:** [1-sentence summary with key trade-off]  
> - **[Direction C]:** [1-sentence summary with key trade-off]
> - [... for each direction explored]
>
> The recommended direction is **[Direction A]** because [rationale]. Shall I write the ADR for this direction?"

Handle all response types:
- **Confirms:** Proceed to Phase 2 with the selected direction.
- **Picks a different direction:** Acknowledge and proceed with their choice to Phase 2.
- **Proposes a new direction:** Return to Phase 1 to explore it, then re-present the gate.
- **Not ready / wants to research more:** Pause. Offer to research further, refine directions, or end the session so the decision can be discussed with other stakeholders. Do not pressure toward a choice.
- **Wants to combine directions:** Explore coherence. If coherent, reframe as a new direction and re-evaluate. If they conflict, explain why they're incompatible.

---

## Phase 2: Write ADR

An ADR (Architecture Decision Record) captures the decision and its rationale in a structured, immutable record.

### File Location

Save to `docs/adrs/NNNN-<title-with-dashes>.md` where NNNN is a zero-padded sequence number (e.g., `0001`, `0042`). Scan existing files to determine the next number; start at `0001` if none exist.

### ADR Template

```markdown
# [Title: imperative verb phrase describing the decision]

## Context

[What is the architectural question and why is it being raised now? Include the forces at play: business drivers, technical constraints, quality attribute requirements, team constraints, ecosystem considerations. 2-5 paragraphs scaled to complexity.]

## Decision Drivers

- [Driver 1: e.g., a force, quality attribute, constraint]
- [Driver 2]
- ...

## Decision

[State the chosen option clearly and directly. Then explain the rationale -- why this option over the others, referencing the decision drivers. This section must be self-contained: a reader who only reads this section should understand what was decided and why. 2-4 paragraphs.]

[If this decision supersedes previous ADRs, state it here: "This supersedes `docs/adrs/<filename>.md`." Include all superseded ADRs if multiple.]

## Consequences

- [Consequence 1: what becomes easier, harder, or changes as a result]
- [Consequence 2]
- ...

[If this decision triggers follow-up decisions, name them.]

## Considered Options

### [Option name]

[1-2 paragraph description of the option.]

- Good, because [argument]
- Neutral, because [observation]
- Bad, because [argument]

[Repeat for each considered option.]
```

### Template Principles

- **No ephemeral metadata:** No Status, Date, Version, or Author fields. VCS provides this.
- **Imperative titles:** Use verb phrases (e.g., "Use event-sourced event bus for domain notifications", "Adopt federated GraphQL for cross-team queries").
- **Self-contained Decision section:** A reader who skips to this section alone should understand what was decided and why. The design skill will read this section as a constraint.
- **Honest pros/cons:** Every option must have at least one "Bad" entry. No option is perfect.
- **One decision per ADR:** If multiple decisions emerged, finish this ADR completely and start the next.
- **Architectural abstraction only:** Address *what* and *why*, never detailed *how*. Illustrative examples (a code snippet, a diagram reference, a path layout) are acceptable if they clarify the architectural choice; exhaustive step-by-step migration plans are not.

### Writing Process

Draft the ADR and save it to the file location defined above. Ensure:
- Context section frames the forces and constraints
- Decision Drivers align with Phase 1 discussion
- Decision section explains why the chosen option best satisfies the drivers
- Consequences are honest about both positive and negative impacts
- Considered Options reflect all options explored

Do not commit yet -- Phase 3 (review) comes first.

---

## Phase 3: Review

Dispatch exactly 3 `doc-reviewer` subagents in parallel via the Task tool. Each reviews a single, non-overlapping lens:

### Review Lenses

**1. Decision Quality & Completeness**
- Is the chosen option well-justified against the decision drivers?
- Are trade-offs honestly represented? Does every option have at least one "Bad" entry?
- Could a skeptical architect follow the reasoning and agree (or at least understand) the choice?
- Are there obvious options that weren't considered?
- Are consequences thorough -- both positive and negative?
- Does the Context section adequately frame the forces at play?

**2. Abstraction & Document Hygiene**
- Does the ADR stay architectural? Are implementation-level details absent?
- Flag step-by-step migration plans, exhaustive code changes, detailed build procedures that don't serve as illustrative examples.
- Are brief illustrative snippets or path layouts acceptable? Yes, if they clarify the architectural choice.
- No ephemeral metadata (Status, Date, Version, Author).
- No phasing language ("Phase 1", "Future", etc.).
- Clear, concise writing. Sections appropriately scoped to complexity.

**3. Ecosystem Consistency**
- Does the decision conflict with existing ADRs? If so, are conflicts surfaced and justified?
- If this ADR supersedes one or more existing ADRs, are those relationships explicit in the Decision section?
- Will the `design` skill be able to consume the Decision section as a clear architectural constraint?
- Are the decision drivers and rationale grounded in the project's existing patterns and constraints?

### Synthesizing Results

Deduplicate feedback across reviewers. If reviewers give contradictory advice (e.g., one says an example is helpful, another says remove all code), use your judgment to resolve the conflict rather than applying both mechanically.

**PASS condition:** All three reviewers pass. If any reviewer flags issues:
1. Fix the issues identified.
2. Re-dispatch only the affected reviewers (max 3 iterations across all reviewers, then ask the user).

If after 3 iterations issues remain unresolved, ask the user for direction.

---

## Phase 4: Commit and Completion

After the review panel passes:

1. **If superseding previous ADRs:** Update each superseded ADR by prepending this notice immediately below its title:
   ```
   > Superseded by [NNNN-<title>](NNNN-<title-with-dashes>.md)
   ```

2. **Commit** the new ADR and any superseded ADR updates in a single commit using the project's VCS. Use the message format: `docs: add ADR NNNN - <title>`.

3. **Present to the user:**
   > "ADR committed to `docs/adrs/<filename>.md`. The review panel checked decision quality, completeness, and ecosystem consistency. The key question is whether this captures the architectural direction you want to establish. Let me know if you want any changes."

4. **On user feedback:**
   - If changes requested, apply them and re-run affected review lenses.
   - On acceptance, suggest next steps:
      > "To design features based on this decision, start a new session and invoke the design skill -- it will pick up this ADR as an architectural constraint."
