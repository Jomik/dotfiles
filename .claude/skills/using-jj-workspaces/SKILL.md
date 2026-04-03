---
name: using-jj-workspaces
description: Use when parallel isolation is needed — multiple agents/sessions working on the same jj repo, or when the user asks to work in a separate workspace without disturbing their current @.
---

# Jujutsu Workspaces

Multiple working copies backed by a single repo. Each workspace has its own `@` and directory on disk, but they share the same commit graph. Like git worktrees, but jj-native.

**Opt-in, not default.** Only use when parallel isolation is needed — don't create a workspace if you're the only session.

## Commands

```bash
# Create — always pass -r and -m (avoid editor hang)
jj workspace add ../ws-name -r main -m "description of work"

# Work in it — normal jj workflow applies
cd ../ws-name

# List all workspaces
jj workspace list

# Cleanup — forget first, then delete directory
jj workspace forget ws-name
rm -rf ../ws-name
```

## Stale Working Copies

When another session rewrites commits your `@` depends on, your working copy goes stale. jj will warn you. Fix immediately:

```bash
jj workspace update-stale
```

Don't ignore stale warnings — working on stale state leads to confusing diffs and conflicts.

## Dispatching Agents

The orchestrating session creates the workspace, dispatches the agent into it, and is responsible for cleanup unless the agent is explicitly told to clean up.

```bash
jj workspace add ../ws-agent-task -r main -m "task: agent's work"
# dispatch agent with: "cd ../ws-agent-task and work there"
# after agent is done:
jj workspace forget ws-agent-task && rm -rf ../ws-agent-task
```
