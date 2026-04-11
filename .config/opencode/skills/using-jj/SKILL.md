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

## Viewing Diffs: Critical Concepts

Understanding diff commands is essential. Getting them wrong makes it look like
separate changes have been "merged into one."

### `-r` vs `--from/--to`: Two completely different things

- **`jj diff -r <rev>`** shows what a single change *introduced* (the diff
  between that revision and its parent). This is a **patch** view.
- **`jj diff --from A --to B`** compares **file-tree snapshots** at A and B.
  This is NOT "the changes introduced by A through B." If A and B have
  different parents or are on different branches, the result includes everything
  that differs between the two trees -- not just what any particular set of
  commits introduced. **This is the #1 source of confusion.**

### Viewing a single change's diff

```bash
jj diff --git                       # what @ introduced (vs its parent)
jj diff --git -r <change-id>        # what <change-id> introduced (vs its parent)
jj show --git <change-id>           # same as above, but also shows description/metadata
```

### Viewing each change in a range individually

To see what each change in a range introduced **separately** (one diff per
change, not combined):

```bash
jj log -p --git -r <revset>         # shows each change's own diff, one by one
jj log -p --git -r @---::@          # example: last 3 changes, each shown individually
jj log -p --git -r 'trunk()..@'     # all changes since trunk, each shown individually
```

`jj log -p` is the correct way to review a series of changes. Each change is
displayed with its description and its own diff (what it introduced vs its
parent). Changes are NOT merged together.

### Viewing the combined diff of a range

If you genuinely want a single combined diff for everything a range of changes
introduced (like `git diff A..B`):

```bash
jj diff --git -r A::B               # combined diff of all changes from A to B inclusive
```

This passes a multi-revision revset to `-r`, and jj computes the total diff.
It is equivalent to `jj diff --git --from A- --to B` (note: `A-` is A's
parent, so A's changes are included).

**When to use which:**
- Reviewing work: `jj log -p --git -r <revset>` (see each change separately)
- Checking what you changed overall: `jj diff --git -r trunk()..@` (combined)
- Comparing two snapshots: `jj diff --git --from A --to B` (tree comparison)

### Comparing how a change evolved (interdiff)

To see how a change has been modified (e.g. after amending or rebasing):

```bash
jj interdiff --git --from <old-rev> --to <new-rev>
jj evolog -p --git -r <change-id>   # full evolution history of a change
```

`jj interdiff` compares *patches* (what two revisions each introduced),
rebasing the `--from` revision onto `--to`'s parents first. This is different
from `jj diff --from/--to` which compares file-tree snapshots.

## Command Reference

| Task                    | Command                              |
|-------------------------|--------------------------------------|
| Status                  | `jj st`                              |
| Diff (current change)   | `jj diff --git`                      |
| Diff (specific rev)     | `jj diff --git -r <change-id>`       |
| Each diff in a range    | `jj log -p --git -r <revset>`        |
| Combined diff of range  | `jj diff --git -r A::B`              |
| Snapshot comparison      | `jj diff --git --from <rev> --to <rev>` |
| Log                     | `jj log`                             |
| Show a revision         | `jj show --git <change-id>`          |
| Describe current change | `jj describe -m "msg"`               |
| Start new change        | `jj new -m "msg"`                    |
| Squash into parent      | `jj squash -m "msg"`                 |
| Abandon change          | `jj abandon <change-id>`             |
| Undo last operation     | `jj undo`                            |
| Restore files           | `jj restore [paths]`                 |
| Rebase                  | `jj rebase -r <rev> -d <dest>`       |

**Always use `--git` with `jj diff`, `jj show`, and `jj log -p`** -- the default color-words output is not machine-readable. `--git` gives standard unified diff format.

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
