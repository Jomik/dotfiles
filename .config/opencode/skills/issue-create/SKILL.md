---
name: issue-create
description: Use when the user asks to create a GitHub issue, file a bug, or track a task. Also use when the user describes a problem they found and wants to capture it.
---

# Create GitHub Issue

File a well-structured GitHub issue.

## Template Discovery

Before using the fallback templates below, check for existing project templates:

1. `.github/ISSUE_TEMPLATE/` directory (modern YAML/md templates).
2. `.github/ISSUE_TEMPLATE.md` (legacy single template).
3. `.github/ISSUE_TEMPLATE/config.yml` (may restrict blank issues).

If project templates exist, **use them** — match the user's issue type to the appropriate template. If the template is a YAML form (`.yml`), extract its fields and format them as Markdown headers in the `--body` content. If the repo enforces strict YAML forms (`blank_issues_enabled: false` in `config.yml`) and CLI creation fails, output the drafted markdown and give the user the web URL to submit manually. The guidelines below still apply for writing quality content within whatever structure the template provides.

If multiple templates exist and the match is ambiguous, list them and ask.

## The Process

1. **Determine the repository** — infer from cwd (`gh repo view --json nameWithOwner -q .nameWithOwner`). Ask if targeting a different repo.
2. **Check for duplicates** — `gh issue list --state all -S "keyword"`. If a duplicate exists, inform the user and ask whether to comment on it instead.
3. **Determine permission level** — `gh repo view --json viewerPermission -q .viewerPermission`. This controls which sections to include (see Template Rules below).
4. **Pick a template** — bug report or task, based on the user's description.
5. **Draft the issue** — fill in the template. Show the proposed title and body to the user for review. **Stop and wait for user approval before proceeding.**
6. **Create** — pass the body inline using a single-quoted heredoc: `gh issue create --title "..." --body "$(cat <<'EOF' ... EOF)"` (never run interactively, never write temp files). The single-quoted `'EOF'` delimiter prevents shell interpretation of markdown `#` headings. Include `--label` if the project uses them (`gh label list` to check) and `--assignee` if requested.
7. **Report back** — print the issue URL.

## Title

- Prefix with affected component/area (unless the repo uses a different convention): `ScanView: add timeout when board not found`
- Keep under 80 characters
- Imperative mood for tasks ("add", "remove"), descriptive for bugs ("X crashes when Y")
- No prefixes like `[BUG]` — use labels for categorization

## Template Rules

### WRITE / ADMIN permission

Include all sections from the templates. **Root cause** and **Fix** sections are valuable — the user can act on the codebase.

For tasks, **Fix** should be concrete: name the file, function, or component so an implementer can act without re-investigating.

### READ or lower permission

Use the bug report template but **omit Root cause and Fix sections**. The user is an external reporter — focus on reproduction, not diagnosis.

The task template should generally not be used for external repos (feature requests have their own per-project conventions).

## Bug Report Template (Fallback)

```
## Problem
<What's wrong — 1-3 sentences>

## Expected behavior
<What should happen instead>

## Steps to reproduce
1. <Step one>
2. <Step two>
3. <Observed result>

## Error output
<Exact error messages, stack traces, or logs. Omit section if none.>

## Root cause
<What in the code causes this — file/function references. Omit if unknown.>

## Fix
<Suggested fix approach. Omit if no clear fix yet.>

## Context
<How discovered, related issues/PRs, regression info, urgency. Omit if nothing to add.>
```

## Task Template (Fallback)

```
## Problem
<What's missing or suboptimal — 1-3 sentences>

## Fix
<What should be done — concrete enough to act on>

## Context
<How discovered, related issues/PRs, urgency. Omit if nothing to add.>
```

## Writing Guidelines

- **Omit empty sections** — drop the heading entirely rather than writing "N/A".
- **Be concise** — every sentence should help the reader understand or fix the problem. No filler.
- **Text over screenshots** — error messages and logs must be pasted as text (searchable, copyable).
- **One issue per problem** — if multiple things are found, create multiple issues.
- **Link related issues** — use `#123` shorthand for same-repo references.
- **Labels** — apply if the project uses them. Don't suggest creating new labels without asking.
