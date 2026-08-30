---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior. Enforces root cause investigation before proposing fixes.
---

# Systematic Debugging

NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.

If you have not completed Phase 1, you cannot propose fixes. Symptom fixes are failure.

## Core Principle

**Show your reasoning.** At each phase, report to the user: what you observed, what you conclude, and why. This is not optional narration — it is the mechanism that prevents you from drifting into guess-and-check. If you cannot articulate why you believe something, you do not yet believe it.

## Pay Extra Attention When

- A "quick fix" seems obvious
- You have already tried a fix that did not work
- You do not fully understand the issue
- The system has multiple interacting components

## Phase 1: Gather Evidence

**Why:** You cannot reason about what you haven't observed. Evidence first, theories later.

1. **Read error messages carefully.** Full stack traces, line numbers, error codes. Do not skip warnings.
2. **Reproduce consistently.** Exact steps. If not reproducible: check logs, add instrumentation at suspect boundaries, widen inputs. If still not reproducible, escalate to user with what you have.
3. **Check recent changes.** VCS diff, recent commits, new dependencies, config changes.
4. **Gather evidence at component boundaries.** In multi-component systems, observe WHERE it breaks before investigating WHY.
5. **Trace data flow backward.** Find the bad value, then trace upstream until you find where the invariant was first violated. That is the root cause — not where the error eventually manifests.

**Report:** Summarize all evidence before moving on. This written summary is your working memory — later phases depend on it, not on what you vaguely recall from tool calls.

## Phase 2: Compare

**Why:** Bugs are deviations from working behavior. The delta between working and broken code reveals the cause.

1. **Find a working analogue** in the codebase. If none exists, skip to Phase 3.
2. **List every difference** between working and broken code.
3. **Understand assumptions.** What components, config, or environment does this code depend on?

**Report:** What you found, what differs, what that implies.

## Phase 3: Hypothesize

**Why:** A single clear hypothesis is testable. A vague suspicion is not.

1. **Consolidate.** Review your Phase 1 summary and Phase 2 findings together.
2. **Form one hypothesis.** State it: "X is the root cause because Y." Root cause means the first point where an invariant is violated — not a downstream consequence.
3. **Test it without fixing.** Confirm or refute through observation: add logging, inspect state, trace a specific input through the path. This is experimentation, not repair — you are gathering signal, not changing behavior.
4. **If refuted:** Record WHY it was wrong (this prevents circling back). Form a new hypothesis.

**Report:** Your hypothesis, how you tested it, and the result.

### Escalation

If 3 hypotheses fail, STOP. Three misses means you are missing something fundamental — a wrong assumption about how the system works. Discuss with the user before continuing.

## Phase 4: Prove It

**Why:** A failing test is proof that outlives this conversation. It makes the root cause undeniable and the fix verifiable.

1. **Write a test** that fails because of the root cause — not coincidentally. The test must fail with no fix applied, for the mechanistic reason you identified.
2. **Run it, confirm it fails.** If it passes, your hypothesis is wrong. Return to Phase 3.
3. **Done.** Proven root cause + failing test. The fix is a separate concern.

If a test isn't feasible (environment-specific, timing, infrastructure), document reproduction steps and evidence instead. The deliverable is still: proven root cause + reproduction method.

**Report:** The test (or reproduction), confirmation it fails, and a one-sentence statement of root cause.

## Red Flags — STOP and Return to Phase 1

If you catch yourself doing any of the following, you are skipping the process:

- "Quick fix for now, investigate later"
- "Just try changing X and see"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Let me fix multiple things and run tests"
- Proposing solutions before tracing data flow
- "One more attempt" after 2+ failed hypotheses

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging is faster than guess-and-check thrashing. |
| "Just try this first, then investigate" | The first fix sets the pattern. Do it right from the start. |
| "Multiple fixes at once saves time" | Cannot isolate what worked. Causes new bugs. |
| "I see the problem, let me fix it" | Seeing symptoms ≠ understanding root cause. |
| "One more attempt" after 2+ failures | 3+ failures = missing something fundamental. Question your assumptions. |
