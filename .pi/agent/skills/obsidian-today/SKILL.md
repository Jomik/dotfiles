---
name: obsidian-today
description: Use when the user says "today", "morning plan", "plan my day", "what should I work on", or asks about their priorities for the day.
---

# Today — Morning Plan

Build a prioritized plan for Jonas's day from the Obsidian vault ("notes").

## Workflow

1. **Read the most recent daily note** using `obsidian vault=notes daily:read`. If today's doesn't exist, read the most recent Inbox note (e.g. `Inbox/YYYY-MM-DD.md`). Focus on the `## Day Close` section and its subsections:
   - `### Tomorrow` — yesterday's stated priorities
   - `### Open Questions` — unresolved items
   - `### Blocked / Waiting` — anything that might have unblocked
   - `### In Progress` — work needing continuation

2. **Check recent Inbox notes for patterns** — Read the 2–3 most recent prior Inbox notes to identify carry-over tasks, stale blockers (same item 3+ days), and decisions needing follow-up.

3. **Check today's inbox** — `obsidian vault=notes read path="Inbox/YYYY-MM-DD.md"` for anything captured this morning.

4. **Check Work folder** — `obsidian vault=notes search:context query="" path="Work"` for active threads.

5. **Present the plan** — No preamble, no questions. This is a morning glance.

## Output Format

```markdown
## Today — YYYY-MM-DD

### Priorities
1. **[Highest priority]** — why this matters today
2. **[Second priority]** — context
3. **[Third priority]** — context

### Carry-Over
- [Items from yesterday's "Tomorrow" or "In Progress" that aren't done]
- ⚠️ flag anything carried 3+ days

### Blocked / Waiting
- [Item] — who/what is blocking, suggested unblock action

### Open Questions to Resolve
- [1-2 highest-leverage questions from recent notes]
- Prioritize questions that unblock other work

### Personal (if relevant)
- [Only if there are active personal items in the vault]
```

## Rules

- Lead with work — Jonas is a full-stack developer with sprint commitments.
- Max 3 priorities. If there are more, pick the 3 that unblock the most.
- Flag carry-over items that have appeared in "Tomorrow" for 3+ consecutive days with ⚠️.
- Keep it to one screen — morning glance, not a report.
- Don't ask questions. Synthesize what the vault knows and present a plan.
- If the vault is sparse (early days), say so briefly and suggest capturing more during the day.
- The "Open Questions to Resolve" section should target decisions, blocked dependencies, or cross-team coordination — high-leverage items.
