---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior. Enforces root cause investigation before proposing fixes.
---

# Systematic Debugging

NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.

If you have not completed Phase 1, you cannot propose fixes. Symptom fixes are failure.

## When to Use

Use for ANY technical issue: test failures, bugs, unexpected behavior, performance problems, build failures, integration issues.

Use ESPECIALLY when:
- A "quick fix" seems obvious
- You have already tried a fix that did not work
- You do not fully understand the issue
- The system has multiple interacting components

Do NOT skip because the issue "seems simple." Simple bugs have root causes too.

## Phase 1: Root Cause Investigation

BEFORE attempting ANY fix:

1. **Read error messages carefully.** Read stack traces completely. Note line numbers, file paths, error codes. Do not skip past warnings.

2. **Reproduce consistently.** What are the exact steps? Does it happen every time? If not reproducible, gather more data -- do not guess.

3. **Check recent changes.** Git diff, recent commits, new dependencies, config changes, environmental differences.

4. **Gather evidence at component boundaries.** In multi-component systems (API -> service -> database, CI -> build -> deploy), add diagnostic logging at each boundary BEFORE proposing fixes. Run once, observe WHERE it breaks, THEN investigate that component.

5. **Trace data flow backward.** Find where the bad value appears, then ask: what called this with that value? Keep tracing up the call chain until you find the source. Fix at the source, not where the error manifests.

## Phase 2: Pattern Analysis

1. **Find working examples.** Locate similar working code in the same codebase.
2. **Compare.** What is different between the working and broken code? List every difference.
3. **Understand dependencies.** What components, config, or environment does this code assume?

## Phase 3: Hypothesis and Testing

1. **Form a single hypothesis.** State it clearly: "X is the root cause because Y."
2. **Test minimally.** Make the SMALLEST possible change to test the hypothesis. One variable at a time.
3. **Evaluate.** If it worked, proceed to Phase 4. If not, form a NEW hypothesis. Do NOT layer additional fixes on top.

## Phase 4: Fix Plan

Do NOT implement the fix yourself. Produce a plan and hand off to the `implementing` skill.

1. **Create a failing test case** if feasible -- automated test or minimal reproduction script. Include it as the first step of the plan.
2. **Write the fix plan.** The plan must address the root cause only -- one change at a time, no "while I'm here" improvements.
   - **Single source file** (plus its test): describe the plan inline in the conversation (task, files, steps with checkboxes).
   - **Multiple source files**: write to `.opencode/plans/` so it can be executed in a fresh session.
3. **Load the `implementing` skill** to execute the plan. The implementing skill handles both inline plans and `.opencode/plans/` files. For inline plans, the implementing skill dispatches a subagent with fresh context -- this is the firewall against investigation fatigue leaking into the fix.
4. **Verify** after implementation: tests pass, no regressions, issue resolved.

### If the fix does not work

- Count how many fixes you have attempted.
- If fewer than 3: return to Phase 1 with the new information.
- **If 3 or more: STOP.** Three failed fixes indicate an architectural problem, not a bug. Each fix revealing new problems in different places is the pattern. Discuss fundamentals with the user before attempting more fixes.

### After fixing: defense in depth

Once the root cause is fixed, consider whether the bug could recur through a different code path. If so, include defense-in-depth tasks in the fix plan: validation at entry points, business logic boundaries, or environment guards. Goal: make the bug structurally impossible, not just fixed.

## Red Flags -- STOP and Return to Phase 1

If you catch yourself thinking any of the following, you are skipping the process:

- "Quick fix for now, investigate later"
- "Just try changing X and see"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Let me fix multiple things and run tests"
- Proposing solutions before tracing data flow
- "One more fix attempt" after 2+ failures

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging is faster than guess-and-check thrashing. |
| "Just try this first, then investigate" | The first fix sets the pattern. Do it right from the start. |
| "Multiple fixes at once saves time" | Cannot isolate what worked. Causes new bugs. |
| "I see the problem, let me fix it" | Seeing symptoms is not understanding root cause. |
| "One more fix attempt" after 2+ failures | 3+ failures = architectural problem. Question the approach. |

## Condition-Based Waiting (for flaky tests)

When debugging test flakiness caused by timing, replace arbitrary delays with condition polling:

```
# Bad: guessing at timing
sleep(300ms)
assert result exists

# Good: waiting for actual condition
wait until result exists (timeout 5s, poll every 10ms)
assert result exists
```

Always include a timeout with a clear error message. If an arbitrary delay IS correct (testing actual timed behavior like debounce), document WHY.
