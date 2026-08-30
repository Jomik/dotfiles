---
name: jira-story-split
description: Use when the user wants to split a Jira epic or large story into well-formed vertical slices.
---

# Jira Story Splitting

Split a Jira epic or large story into well-formed vertical slices.

## Workflow

### Phase 1: Understand

1. **Read the epic/story** — use `view_jira_issue` to get description and acceptance criteria.
2. **Read siblings** — use `search_jira_issues` with JQL `parent = EPIC-KEY`, then `view_jira_issue` on 1–2 siblings to learn the team's format/style.
3. **Identify the user** — Who benefits from this change? What system behavior changes from their perspective?

### Phase 2: Validate before splitting

4. **Check INVEST (except Small)** — Does the input satisfy Independent, Negotiable, Valuable, Estimable, Testable? (See references/splitting-patterns.md §2.)
   - If it's a **task or component** masquerading as a story (no user-visible value on its own), combine it with related pieces until it represents an increment of value. Do not split tasks into smaller tasks.
   - If it's **not too big**, don't split — stop here.
   - If it **can't be estimated**, consider a spike (Pattern 9).
5. **Confirm it's a vertical slice** — Does it touch multiple layers to deliver value? If it's a single-layer change, it may be a horizontal slice that needs reframing.

### Phase 3: Split

6. **Try multiple patterns** — see references/splitting-patterns.md §5. Don't stop at the first pattern that fits; compare candidates.
7. **Apply the meta-pattern** — Find the core complexity, identify variations, reduce to one for the first slice.
8. **Evaluate candidate splits** using two rules:
   - Prefer the split that lets you **deprioritize or discard** a story (reveals waste).
   - Prefer the split that produces **more equally-sized** stories (more prioritization freedom).

### Phase 4: Write stories

9. **Each story must pass INVEST** — especially Valuable and Independent. Every story should be demoable/testable on its own without requiring other stories from the split.
10. **Answer Who/What/Why** — not just What. The story describes a change in system behavior from the user's perspective.
11. **Write behavioral acceptance criteria** — describe observable system behavior, not implementation steps. "User can X" not "Code does Y".
12. **Mark the starting slice** — identify which story is the simplest end-to-end path (walking skeleton).
13. **Match team format** — use the structure observed in sibling stories.

### Phase 5: Create in Jira

14. **Create stories** — use `create_jira_issue` with proper ADF formatting for description/AC fields.
15. **Link to origin** — use `create_jira_split_link` to create "split to" links from the original story to each new slice.
16. **Link dependencies** — use `create_jira_blocks_link` only if genuine ordering constraints exist between the slices. Minimize these — too many links signals horizontal slicing.

## Quality Checks

Before creating stories, verify:

- [ ] Each story delivers user-visible value independently
- [ ] Stories are vertical slices (not architectural layers)
- [ ] No story is "only valuable when combined with another from this split"
- [ ] Acceptance criteria describe behavior, not implementation
- [ ] The first story is the simplest possible end-to-end slice
- [ ] Dependencies are minimized (ideally zero)
- [ ] Stories answer Who/What/Why (not just What)
- [ ] Format matches existing team stories

## Anti-Patterns to Avoid

- Splitting by architectural layer (API story + consumer story + DB story)
- "As a developer, I want..." — tasks pretending to be stories
- Technical dependency chains forced by the split
- Implementation details in acceptance criteria
- Exhaustively enumerating all stories when in a complex/uncertain domain

## References

- **Splitting patterns & INVEST:** references/splitting-patterns.md
- **Source:** [Humanizing Work Guide to Splitting User Stories](https://www.humanizingwork.com/the-humanizing-work-guide-to-splitting-user-stories/)

## References

See the `using-jira` skill for ADF format, custom fields, and payload structures.
