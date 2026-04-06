---
name: multi-perspective-review
description: Use at any review gate to get deeper coverage by dispatching multiple reviewers in parallel with different, complementary lenses. Works for specs, plans, code, architecture, or any artifact worth reviewing from more than one angle.
---

# Multi-Perspective Review

Dispatch 2-3 reviewers in parallel, each with a narrow focus. A focused reviewer goes deeper than a generalist skimming a broad checklist.

## Lens Selection

Pick 2-3 lenses for the review panel. Each must be:
- **Non-overlapping** with the others — no two reviewers check the same thing
- **Relevant** to this specific artifact — adapt to what matters most here

Example dimensions (illustrative, not exhaustive — adapt to the artifact):

correctness, security, completeness, scope/simplicity, implementability, buildability, decomposition, spec alignment, architecture/design, DRY/YAGNI, file organization, testing quality, performance, error handling, concurrency, external API accuracy, edge cases, …

## Dispatch

Dispatch all reviewers in parallel using the Agent tool. Each gets:

- **Shared context** — document path, VCS diff range, spec/plan reference, whatever applies
- **Lens criteria** — what to focus on and what to ignore. Be specific: "Review for X. Do NOT check Y or Z — other reviewers handle those."
- **Model override** where appropriate — opus for the lens needing deepest reasoning, sonnet for others

Use `code-reviewer` for code reviews, `document-reviewer` for document reviews (specs, plans, etc.). Both are prompt-driven — the dispatch prompt defines what to review.

## Synthesis

After all reviewers return, the orchestrator produces a unified report:

1. **Deduplicate** — same issue at same location flagged by multiple reviewers → merge into one
2. **Severity** — if reviewers disagree, take the higher severity
3. **Unified issue list** — attribute each issue to the lens that found it
4. **Verdict** — PASS only if all reviewers PASS

## Re-Review Loop

On FAIL:

1. Fix issues (implementer for code, orchestrator for docs)
2. Re-dispatch only the reviewer(s) whose issues were fixed — passing reviewers don't re-run
3. Merge new results with previously-passing results
4. Repeat (max 3 iterations, then escalate to human)

Exception: if a fix is large enough to potentially affect another reviewer's domain, re-dispatch that reviewer too.
