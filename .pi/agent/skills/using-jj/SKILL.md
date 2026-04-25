---
name: using-jj
description: Use whenever `jj root` succeeds. Use `jj` for all version-control operations; do not use `git`.
---

This is a jj (Jujutsu) repository. Use `jj` for ALL version control operations. NEVER run `git` commands. If you don't know the jj equivalent of a git command, run `jj help` -- do not guess or fall back to git.

Do not use deprecated aliases: `jj branch` (use `jj bookmark`).

## Critical: Avoid Interactive Prompts

ALWAYS pass `-m "message"` to `jj describe`, `jj commit`, and `jj squash`. Without `-m`, these commands open `$EDITOR` and the agent will hang indefinitely.

- `jj describe -m "msg"` -- ALWAYS use `-m`
- `jj commit -m "msg"` -- ALWAYS use `-m` (equivalent to `jj describe -m` + `jj new`)
- `jj squash -m "msg"` or `jj squash -u` -- use `-m` to set a new message, `-u` to keep the destination's message
- `jj new` -- do NOT pass `-m`. It does not open an editor. Passing `-m` sets a description on the new empty change, which is almost never what you want.

Never use interactive commands: `jj split`, `jj squash -i`, and `jj resolve` will hang.

## Key Concepts

- **The working copy IS a commit (`@`).** No staging area, no index. File changes are tracked automatically. There is no `git add`.
- **`jj new` finalizes the current change** and starts a new empty one on top. After `jj new`, `@` is the new empty change and `@-` is the one you just finished.
- **Prefer change IDs over commit IDs** -- they are stable across rewrites.
- **`trunk()`** resolves to the latest trunk/main commit from the remote.

## Workflow

**Before touching any code**, run `jj st` to check what `@` contains:

- `@` has completed work → `jj new` first
- `@` is empty → proceed
- `@` is your in-progress work → continue

Then describe before coding: `jj describe -m "what I'm about to do"`. Message first, then code.

**When done**, always finalize with `jj new` (or `jj commit -m "msg"` to describe and finalize in one step). Do not leave the user on a dirty `@` — the user needs a clean `@` to review your work, squash follow-up fixes, and start new tasks.

**Rule: every task ends with `jj new`.** The only exception is if the user explicitly asks you not to.

## Viewing Diffs

### `-r` vs `--from/--to`

- **`jj diff -r <rev>`** — what a single change *introduced* (diff against its parent).
- **`jj diff --from A --to B`** — compares **file-tree snapshots**. Not "changes introduced by A through B." Includes everything that differs between the two trees.

### Common operations

```bash
# Single change
jj diff --git                       # what @ introduced
jj diff --git -r <change-id>        # what <change-id> introduced
jj show --git <change-id>           # same + description/metadata

# Each change in a range, individually
jj log -p --git -r <revset>         # one diff per change, not combined
jj log -p --git -r 'trunk()..@'     # all changes since trunk

# Combined diff of a range
jj diff --git -r A::B               # total diff from A through B

# Snapshot comparison
jj diff --git --from A --to B       # tree-to-tree comparison

# How a change evolved
jj interdiff --git --from <old> --to <new>
jj evolog -p --git -r <change-id>   # full evolution history
```

## Command Reference

| Task                     | Command                                  |
|--------------------------|------------------------------------------|
| Status                   | `jj st`                                  |
| Diff (current change)    | `jj diff --git`                          |
| Diff (specific rev)      | `jj diff --git -r <change-id>`           |
| Each diff in a range     | `jj log -p --git -r <revset>`            |
| Combined diff of range   | `jj diff --git -r A::B`                  |
| Snapshot comparison       | `jj diff --git --from <rev> --to <rev>`  |
| Log                      | `jj log`                                 |
| Show a revision          | `jj show --git <change-id>`              |
| Describe current change  | `jj describe -m "msg"`                   |
| Describe + finalize      | `jj commit -m "msg"`                     |
| Start new change         | `jj new`                                 |
| New change on a revision | `jj new <rev>`                            |
| Edit existing change     | `jj edit <change-id>`                    |
| Squash into parent       | `jj squash -m "msg"` or `jj squash -u`   |
| Abandon change           | `jj abandon <change-id>`                |
| Undo last operation      | `jj undo`                                |
| Restore from parent      | `jj restore [paths]`                     |
| Restore from revision    | `jj restore --from <rev> [paths]`        |
| List bookmarks           | `jj bookmark list`                       |
| Rebase single revision   | `jj rebase -r <rev> -d <dest>`           |
| Rebase with descendants  | `jj rebase -s <rev> -d <dest>`           |

**Always use `--git`** with `jj diff`, `jj show`, and `jj log -p` -- the default color-words output is not machine-readable.

**Verify after mutations** -- run `jj st` after `squash`, `abandon`, `rebase`, `restore`.

**Resolve conflicts** by editing the conflict markers in the files directly, then `jj st` to verify. Run `jj help conflicts` for marker format details. Do not use interactive resolution tools.

## Bookmarks & Pushing

Bookmarks are jj's equivalent of git branches. They do NOT auto-advance on `jj new`.

**Which revision to bookmark:** After `jj new`, point bookmarks at `@-` (the completed change), not `@` (the new empty change).

```bash
jj bookmark set <name> -r @-           # create or move bookmark to completed change
jj git push -b <name>                  # push bookmark to remote
jj git fetch                           # fetch from remote
jj rebase -d trunk()                   # rebase current work onto latest trunk
```

**Always push via bookmark (`-b`).** Never use `jj git push -c` — it creates auto-named bookmarks instead of pushing a single chain.

## GitHub Interop

- **Prefix `gh` commands with `GIT_DIR="$(jj git root)"`** — in non-colocated repos there is no `.git/` at the repo root, so `gh` cannot find the Git directory. The prefix is harmless in colocated repos.
- **Always pass `--head <bookmark-name>` to `gh pr create`** — without it `gh` cannot determine the branch in a jj repo.
