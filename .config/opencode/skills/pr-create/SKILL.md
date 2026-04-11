---
name: pr-create
description: Use when the user asks to open a PR, create a PR, or push and create a pull request.
---

# Create Pull Request

Push the current branch and open a PR.

## Template Discovery

Before using the fallback template below, search for existing project templates (case-insensitive — GitHub accepts mixed case):

1. `.github/PULL_REQUEST_TEMPLATE.md` (or `pull_request_template.md`)
2. `.github/PULL_REQUEST_TEMPLATE/` directory (if multiple, ask user which one)
3. `docs/pull_request_template.md`
4. `PULL_REQUEST_TEMPLATE.md` in the repo root

If a project template exists, **use it**. The guidelines below still apply for writing quality content within whatever structure the template provides.

## The Process

1. **Verify auth** — `gh auth status`. If it fails, tell the user and stop.
2. **Check for uncommitted changes** — warn if there are pending changes; ask before proceeding.
3. **Check for existing PR** — `gh pr view --json url 2>/dev/null`. If a PR already exists for this branch, show its URL and ask if the user wants to update it (`gh pr edit`) instead of creating a new one.
4. **Determine base branch** — detect with `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`. If the branch was based on something other than the default (e.g., stacked PRs, release branches), ask the user to confirm.
5. **Check sensitive files** — flag `.env`, credentials, secrets. Warn before including.
6. **Push** — `git push -u origin HEAD`.
7. **Create PR** — pass the body inline using a single-quoted heredoc: `gh pr create --title "..." --body "$(cat <<'EOF' ... EOF)"`. The single-quoted `'EOF'` delimiter prevents shell interpretation of markdown `#` headings. Never run interactively, never write temp files.

Suggest `--draft` when tests aren't passing, there are known TODOs, or the user wants early feedback.

## PR Title

Discover the project's title convention before writing one. Check recently merged PR titles and recent commit messages on the default branch.

Match the pattern you see (conventional commits, imperative mood, ticket prefixes, casing, etc.). If the repo is new or inconsistent, fall back to capitalized imperative mood with no prefix.

- Keep under 72 characters
- Do NOT include issue/PR numbers — GitHub appends the PR number on merge

## PR Body (Fallback Template)

```
## Summary
<1-3 sentences: what changed and why>

## References
<Links to spec or issue — omit section if none>

## Decisions & callouts
<Non-obvious choices, trade-offs, or areas needing reviewer attention — omit section if none>

## Manual testing
<Checkbox list of manual steps the reviewer should perform — omit section if none>
```

### Writing guidelines

- **Omit empty sections** — drop the heading entirely rather than writing "N/A" or leaving placeholders.
- **Be concise** — every sentence should be useful to the reviewer. No filler, no restating the diff.
- **Summary** should explain *why*, not just *what*. The diff already shows what changed.
- **Decisions & callouts** — flag anything a reviewer might question or miss. Trade-offs, alternative approaches considered, known limitations.

### References guidelines

- Use **persistent links** — link to files at a specific commit SHA, not a branch (branch links go stale after merge). For GitHub: `https://github.com/org/repo/blob/<sha>/path/to/file`
- GitHub issues and PRs are already persistent — use `owner/repo#123` format or full URL.
- **Never reference local-only paths** (e.g., `.opencode/plans/`) — these are not committed and meaningless to reviewers.
- **Verify every link** before creating the PR — use `gh api` or `curl -s -o /dev/null -w '%{http_code}'` to confirm each returns 200.
- If a link is broken, fix it or remove it — a dead link is worse than no link.

### Manual testing guidelines

- Format as a **checkbox list**:
  ```
  - [ ] Step one — expected outcome
  - [ ] Step two — expected outcome
  ```
- Each item: a concrete action + what the reviewer should observe.
- **Exclude anything verified by CI** (linting, type checks, unit tests) — only steps requiring human judgment.
