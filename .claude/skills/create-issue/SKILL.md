---
name: create-issue
description: Use when the user asks to create a GitHub issue, file a bug, or track a task. Also use when the user describes a problem they found and wants to capture it.
---

# Create GitHub Issue

File a well-structured GitHub issue.

**Announce at start:** "I'm using the create-issue skill to file a GitHub issue."

## The Process

1. **Determine the repository** — infer from the current working directory (`gh repo view --json nameWithOwner -q .nameWithOwner`). Ask if targeting a different repo.
2. **Determine permission level** — run `gh repo view --json viewerPermission -q .viewerPermission`. WRITE or ADMIN means the user can act on the codebase (include Root cause/Fix sections). READ or lower means they're an external reporter (omit those sections).
3. **Gather context** — ask the user what the issue is about if not already clear. Check current branch and recent changes for relevant context.
4. **Pick a template** — read the appropriate template from `skills/create-issue/templates/`:
   - `bug-report.md` — when something is broken or behaving incorrectly
   - `task.md` — for improvements, missing features, or cleanup work
5. **Draft the issue** — fill in the template. Show the title and body to the user for review before creating.
6. **Create via `gh issue create`** — include labels if the project uses them.
7. **Report back** — print the issue URL.

## Title

- Prefix with the affected component/area followed by a colon (e.g. `ScanView: add timeout when board not found`)
- Keep under 80 characters
- Use imperative mood for tasks ("add", "remove"), descriptive for bugs ("X crashes when Y")

## Template Rules

### WRITE / ADMIN permission

Include all sections from the template. **Root cause** and **Fix** sections are valuable here — the user can act on the codebase and provide actionable diagnosis.

For the task template, **Fix** should be concrete: name the file, view, function, or component so an implementer (or agent) can act without re-investigating.

### READ or lower permission

Use the bug-report template but **omit Root cause and Fix sections**. The user is an external reporter — focus on enabling reproduction, not prescribing solutions. The maintainers know their code better.

The task template should generally not be used for external repos (feature requests have their own conventions per-project).

## General Guidelines

- **Omit empty sections** — drop the heading entirely rather than writing "N/A"
- **Link related issues** — use `#123` shorthand for same-repo issues
- **One issue per problem** — if multiple things are found, create multiple issues
- **Text over screenshots** — error messages and logs should be pasted as text (searchable, copyable)
- **Search before filing** — check for existing issues: `gh issue list -S "keyword" --repo owner/repo`
- **Labels** — apply labels if the project uses them. Don't suggest creating new labels without asking.
