---
name: using-jj
description: Use when about to perform any VCS operation (commit, status, diff, push, log, branch, etc.). Ensures jj is used when available.
---

# Jujutsu (jj) Version Control

## Hard Rule

**Never run `git` commands in a jj repo.** Use jj exclusively. If you don't know the jj equivalent of a git command, run `jj help` -- do not guess or fall back to git.

Do not use `jj checkout` (deprecated alias for `jj edit`), `jj commit` (deprecated alias for `jj new`), or `jj branch` (deprecated alias for `jj bookmark`). Use the current names. These deprecated aliases still exist but should not be used.

## Mental Model

1. **The working copy IS a commit (`@`).** No staging area, no index. File changes are tracked automatically. There is no `git add`.
2. **Changes are mutable (unless immutable).** You can edit any mutable change freely. Trunk commits (e.g., on `main`) are immutable -- create a new change on top instead. Use `jj log` to check.
3. **Many small changes.** Each change is one atomic, verifiable unit. Work until tests pass / code compiles, then `jj new`.
4. **Describe before coding.** Always `jj desc -m "..."` before making changes, not after.
5. **Always `jj new` first, squash after.** When fixing something in an earlier change, ALWAYS create a new change on top first. After the fix is done, decide: does it logically belong to the parent change? If yes, `jj squash`. If no, keep it separate. Never `jj edit` back to amend directly — `jj new` + `jj squash` achieves the same result with less risk of accumulating unrelated work.

## Before You Touch Any Code: Check `@`

**ALWAYS run `jj st` or `jj log` before making any changes.** The working copy IS a commit — if `@` already contains completed work and you start coding, you're silently accumulating unrelated changes into it.

```bash
jj st                                  # or jj log -- check what @ contains
# If @ has completed work → jj new first
# If @ is empty → jj desc -m "..." then code
# If @ is your in-progress work → continue
```

**This is the #1 mistake agents make:** assuming `@` is clean and starting to code without checking.

## The Workflow Loop

1. `jj st` — check what `@` contains
2. If `@` is empty → `jj desc -m "..."` → code and test
3. If `@` is your in-progress work → continue coding and testing
4. If `@` has completed work → `jj new` → `jj desc -m "..."` → code and test
5. When tests pass → go to step 1

- **Never skip describe.** The message comes before the code.
- **Never accumulate multiple logical changes in one change.** If you're doing two things, `jj new` to split.
- After `jj new`, `@` is the new empty change and `@-` is the one you just finished.

## Fixes Go Forward, Not Backward

**Always `jj new` first. Decide whether to squash AFTER the fix is complete.**

The workflow is always the same regardless of whether the fix "belongs" to an earlier change:

```bash
jj new abc123                          # ALWAYS start a new change on top
jj desc -m "fix: description"          # describe before coding
# ... fix the issue ...
# NOW decide:
jj squash -u                           # if fix belongs to parent change (keeps parent's description)
# OR keep as separate change            # if fix is a separate concern
```

**After fixing, ask: does this belong in the parent's description?**

**Squash into parent** (logically part of that change):
- Typo in code that change introduced
- Missing import for a function that change added
- Off-by-one in logic that change was specifically about

**Keep separate** (different concern):
- CI config/linting/formatting fixes
- A bug exposed by the change but in different code
- Unrelated test failures
- Anything you'd describe differently than the original change

### Red Flags — STOP If You Catch Yourself Thinking:

| Thought | What to do instead |
|---|---|
| "I'll just quickly fix this in the existing change" | `jj new <change-id>` first. Always. Squash after if it belongs. |
| "It's only a one-line fix, not worth a new change" | Size doesn't matter. `jj new` first, squash after. |
| "Let me `jj edit` back to fix that" | No. `jj new <id>`, fix, then `jj squash` if it belongs. Same result, safer. |
| "Squashing later is extra work" | `jj squash` is one command. The cost is near zero. |
| "This CI fix is part of the same work" | CI/linting/formatting fixes are almost never part of the original change. Keep separate. |

## Agent Rules

- **Always use `-m` flags for `jj desc`** -- `jj desc -m "..."`. Never open an editor.
- **Always use `-u` or `-m` with `jj squash`** to avoid opening an editor (which will hang). If both the source and destination changes have descriptions, jj opens an editor to combine them — this blocks the agent indefinitely.
  - `jj squash -u` — use the destination (parent) description, discard the source description. **Use this by default** when the parent already has a good description.
  - `jj squash -m "..."` — provide an explicit combined description. Use when you want to reword.
- **Always use `--git` with `jj diff`** -- the default color-words output is not machine-readable. Use `jj diff --git` to get standard unified diff format.
- **Never use interactive commands** -- `jj split` and `jj squash -i` will hang. For `jj resolve`, only use with `--tool` flag (e.g., `--tool :ours`).
- **Resolve conflicts** by editing files directly, then `jj st` to verify.
- **Prefer change IDs** over commit IDs -- they're stable across rewrites.
- **Verify after mutations** -- run `jj st` after `squash`, `abandon`, `rebase`, `restore`.

## Quick Reference

| Action | Command |
|---|---|
| Describe change | `jj desc -m "message"` |
| View status | `jj st` |
| View log | `jj log` |
| View diff | `jj diff --git` |
| View diff of revision | `jj diff --git -r <change-id>` |
| Diff between revisions | `jj diff --git --from <rev> --to <rev>` |
| Start new change | `jj new` |
| Edit existing change | `jj edit <change-id>` |
| Squash into parent | `jj squash -u` (keep parent desc) or `jj squash -m "..."` |
| Abandon change | `jj abandon <change-id>` |
| Undo last operation | `jj undo` |
| Restore files | `jj restore [paths]` |

## Bookmarks & Pushing

Bookmarks are jj's equivalent of git branches. They move on rewrites (rebase) but do NOT auto-advance on `jj new`.

```bash
# Create or move bookmark to last completed change
jj bookmark create <name> -r @-
jj bookmark move <name> --to @-

# Push to remote
jj git push -b <name>

# Fetch from remote
jj git fetch
```

**Which revision to bookmark:** After `jj new`, `@` is the new empty change. Point bookmarks at `@-` (the completed change), not `@`. If you haven't run `jj new` yet (e.g., you're still on the change you want to push), use `@`.

### Pushing: Always Use Bookmarks, Not `-c`

**Never use `jj git push -c <change-id>`.** The `-c` flag creates an auto-named bookmark and pushes that single change. When you have a chain of changes (e.g., spec → implementation), using `-c` on each change pushes them as separate branches — not as a single chain on one branch.

**Always push via bookmark (`-b`).** Point the bookmark at the tip of your chain. jj will push all ancestor commits automatically — you don't need to name each one.

```bash
# WRONG: pushes two separate branches
jj git push -c abc123 -c def456

# RIGHT: one bookmark at the tip, ancestors included automatically
jj bookmark create my-feature -r @-
jj git push -b my-feature
```

## Context Switching

To interrupt current work for an urgent fix:

```bash
jj desc -m "WIP: current work description"  # label what you're doing
jj new main                                   # new change based on main
jj desc -m "Fix: urgent issue"                # describe the fix
# ... fix and test ...
jj bookmark create hotfix -r @                # bookmark the fix (still on it)
jj git push -b hotfix                         # push
jj edit <original-change-id>                  # return to WIP work
```

No stashing needed. Your WIP change stays as-is -- `jj edit` returns you to it.
