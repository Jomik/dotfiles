---
name: using-dotfiles
description: Use when working on dotfiles or configuration files in ~/.config. Load this skill when editing, adding, or managing files tracked by the dotfiles repository.
---

`dotfiles` is a thin wrapper around git (via [dotfiles.sh](https://github.com/eli-schwartz/dotfiles.sh)) that stores metadata in `~/.dotfiles` with `$HOME` as the worktree. Use `dotfiles` instead of `git` for all version control operations on these files -- it accepts the same commands.

Untracked files are hidden by design (`status.showUntrackedFiles = no`). To track a new file, `dotfiles add` it explicitly.

`dotfiles ignore <pattern>` appends patterns to the repo's exclude file and stages them as `.gitignore` -- use it instead of manually editing ignore files.
