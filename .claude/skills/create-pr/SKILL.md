---
name: create-pr
description: Use when the user asks to open a PR, create a PR, or push and create a pull request.
---

# Create Pull Request

Push the current branch/bookmark and open a PR.

**Announce at start:** "I'm using the create-pr skill to open a pull request."

## The Process

1. **Check for uncommitted changes** — if there are pending changes, ask the user before proceeding
2. **Determine base branch** — usually `main`. Ask if unclear.
3. **Push** — push the branch/bookmark to remote
4. **Create PR via `gh pr create`**

## PR Title

Follow the project's commit message convention — PRs are squash merged, so the title becomes the final commit message.

## PR Body Format

```
## Summary
<1-3 sentences: what changed and why>

## References
<Links to spec, plan, or issue — omit section if none>

## Decisions & callouts
<Non-obvious choices, trade-offs, or areas needing reviewer attention — omit section if none>

## Manual testing
<Checkbox list of manual steps the reviewer should perform — omit section if none>
```

### References guidelines

- Use **persistent links** — link to files at a specific commit SHA, not a branch (branch links go stale after merge). For GitHub: `https://github.com/org/repo/blob/<sha>/path/to/file`
- GitHub issues and PRs are already persistent — use `owner/repo#123` format (renders as a clickable link) or full URL
- Link to specs and issues by their full URL or GitHub shorthand, not just a bare number or path
- **Verify every link works** before creating the PR — use `gh api` or `curl -s -o /dev/null -w '%{http_code}'` to confirm each returns 200
- If a link is broken or inaccessible, fix it or remove it — a dead link is worse than no link

### Manual testing guidelines

- Format as a **checkbox list** so reviewers can check off items as they go:
  ```
  - [ ] Step one description
  - [ ] Step two description
  ```
- Each item should be a concrete, actionable step a reviewer can perform
- Include expected outcomes ("should show X", "should return 200")
- **Do not** include items verified by CI (linting, type checks, unit tests) — only steps that require human judgment or manual interaction

Omit any section that doesn't apply.
