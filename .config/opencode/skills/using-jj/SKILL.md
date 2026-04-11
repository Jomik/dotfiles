---
name: using-jj
description: Use when the project uses jj (Jujutsu) for version control instead of git. Load this after `jj root` succeeds.
---

This is a jj (Jujutsu) repository. Use `jj` for ALL version control operations. NEVER run `git` commands. If you don't know the jj equivalent of a git command, run `jj help` -- do not guess or fall back to git.

Do not use deprecated aliases: `jj checkout` (use `jj edit`), `jj commit` (use `jj new`), `jj branch` (use `jj bookmark`).

## Critical: Avoid Interactive Prompts

ALWAYS pass `-m "message"` to any command that accepts it. Without `-m`, jj opens `$EDITOR` and the agent will hang indefinitely. This applies to:

- `jj describe -m "msg"`
- `jj new -m "msg"`
- `jj squash -m "msg"`

Never use interactive commands: `jj split`, `jj squash -i`, and `jj resolve` will hang.

Rule of thumb: if a jj subcommand has a `-m` flag, always use it.

## Key Concepts

- **The working copy IS a commit (`@`).** No staging area, no index. File changes are tracked automatically. There is no `git add`.
- **`jj new` finalizes the current change** and starts a new empty one on top. After `jj new`, `@` is the new empty change and `@-` is the one you just finished.
- **Bookmarks** are jj's equivalent of git branches.
- **Prefer change IDs over commit IDs** -- they are stable across rewrites.

## Before You Touch Any Code: Check `@`

ALWAYS run `jj st` or `jj log` before making any changes. The working copy IS a commit -- if `@` already contains completed work and you start coding, you silently accumulate unrelated changes into it.

- If `@` has completed work: `jj new -m "..."` first
- If `@` is empty: `jj describe -m "..."` then code
- If `@` is your in-progress work: continue

**Describe before coding.** The message comes first, then the code. Not after.

## Command Reference

| Task                    | Command                              |
|-------------------------|--------------------------------------|
| Status                  | `jj st`                              |
| Diff (current change)   | `jj diff --git`                      |
| Diff (specific rev)     | `jj diff --git -r <change-id>`       |
| Diff between revisions  | `jj diff --git --from <rev> --to <rev>` |
| Log                     | `jj log`                             |
| Show a revision         | `jj show --git <change-id>`          |
| Describe current change | `jj describe -m "msg"`               |
| Start new change        | `jj new -m "msg"`                    |
| Squash into parent      | `jj squash -m "msg"`                 |
| Abandon change          | `jj abandon <change-id>`             |
| Undo last operation     | `jj undo`                            |
| Restore files           | `jj restore [paths]`                 |
| Rebase                  | `jj rebase -r <rev> -d <dest>`       |

**Always use `--git` with `jj diff` and `jj show`** -- the default color-words output is not machine-readable. `--git` gives standard unified diff format.

**Verify after mutations** -- run `jj st` after `squash`, `abandon`, `rebase`, `restore`.

**Resolve conflicts** by editing files directly, then `jj st` to verify. Do not use interactive resolution tools.

## Workflow: Making a Commit

1. `jj st` -- check what `@` contains
2. `jj describe -m "what I'm about to do"` -- describe first
3. Edit files (changes are auto-tracked, no `add`/`stage` step)
4. `jj new -m "next change"` -- finalize and start the next change

## Bookmarks & Pushing

Bookmarks are jj's equivalent of git branches. They do NOT auto-advance on `jj new`.

**Which revision to bookmark:** After `jj new`, `@` is the new empty change. Point bookmarks at `@-` (the completed change), not `@`. If you haven't run `jj new` yet, use `@`.

```bash
jj bookmark set <name> -r @-           # create or move bookmark to completed change
jj git push -b <name>                  # push bookmark to remote
jj git fetch                           # fetch from remote
```

**Always push via bookmark (`-b`).** Never use `jj git push -c`. The `-c` flag creates auto-named bookmarks and pushes changes as separate branches instead of a single chain.

## GitHub Interop

- The `gh` CLI works normally for PRs and issues.
- **Always pass `--head <bookmark-name>` to `gh pr create`** — without it `gh` cannot determine the branch in a jj repo.
