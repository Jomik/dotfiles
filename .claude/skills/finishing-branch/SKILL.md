---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work — merge, PR, keep, or discard.
---

# Finishing a Development Branch

## Overview

Guide completion of development work by presenting clear options and handling chosen workflow.

**Core principle:** Verify tests → Present options → Execute choice → Clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

## The Process

### Step 1: Verify

Use the `verification` skill to run the full set of CI checks locally. If anything fails, stop — do not proceed until all checks pass.

### Step 2: Determine Base Branch

Identify what this work branched from (usually `main`). Ask if unclear.

### Step 3: Present Options

Use the `AskUserQuestion` tool with exactly these 3 options:

- **Merge locally** — Merge back to `<base-branch>` locally
- **Create PR** — Push and create a Pull Request
- **Keep as-is** — Keep the work as-is (I'll handle it later)

**Don't add explanation** to the options — keep them concise.

### Step 4: Execute Choice

#### Option 1: Merge Locally
- Fetch latest from remote
- Rebase/merge onto base branch
- Run `verification` skill on merged result
- Clean up the feature branch

#### Option 2: Push and Create PR
- Use the `create-pr` skill

#### Option 3: Keep As-Is
- Report the branch/bookmark name and worktree path
- Don't clean up

### Step 5: Clean Up Ephemeral Artifacts

Delete any plan files in `.claude/plans/` that were created during this session (plans are ephemeral — only specs are permanent).

### Step 6: Cleanup Worktree

For Options 1, 2: if in a Claude Code worktree, use ExitWorktree. Otherwise clean up manually.

For Option 3: keep worktree.

## Quick Reference

| Option | Merge | Push | Keep Worktree | Cleanup Branch | Delete Plans |
|--------|-------|------|---------------|----------------|--------------|
| 1. Merge locally | Y | - | - | Y | Y |
| 2. Create PR | - | Y | Y | - | Y |
| 3. Keep as-is | - | - | Y | - | - |

## Red Flags

**Never:**
- Proceed with failing checks
- Merge without running verification on result
- Force-push without explicit request

**Always:**
- Run verification before offering options
- Present exactly 3 options
- Clean up worktree for Option 1 only

## Integration

**Called by:**
- **implementing** - After all tasks complete

**Pairs with:**
- Claude Code's built-in EnterWorktree / using-jj skill for workspace cleanup
