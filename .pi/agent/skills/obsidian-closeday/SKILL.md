---
name: obsidian-closeday
description: Use when the user says "closeday", "close my day", or "end of day". End-of-day consolidation appended to today's Inbox note.
---

# Obsidian Close Day

Wrap up Jonas's day by reviewing progress and preparing tomorrow.

## Workflow

1. **Check today's captures** — Use the `bash` tool to search for recent notes: `obsidian vault=notes search:context query="YYYY-MM-DD" path="Inbox"` and `obsidian vault=notes search:context query="YYYY-MM-DD" path="Work"` (substitute today's actual date). Read any relevant files with `obsidian vault=notes read path="<path>"` to surface what's already been captured.

2. **Check for an existing daily note** by running `obsidian vault=notes daily:read`.
   - If it returns content, the note exists — proceed to step 3.
   - If it returns nothing (no captures today), the Day Close will create the file via `daily:append`.

3. **Check for carry-over** — Read the 2–3 most recent prior Inbox notes (`obsidian vault=notes search:context query="YYYY-MM-DD" path="Inbox"` for prior dates, or `obsidian vault=notes read path="Inbox/<date>.md"`). Flag any tasks appearing 3+ days in a row.
4. **Ask the user:**

   > "Anything else happen today that isn't captured? Meetings, decisions, things you figured out?"

   Also actively ask:

   > "Any decisions made today? Even small ones?"

5. **Append a "Day Close" section** to today's Inbox note using `obsidian vault=notes daily:append content="<formatted content>"`.
   - If today's note already contains a `## Day Close` section (check the output from step 2), update/merge rather than appending a duplicate. In that case, read the file, rewrite the Day Close section, and use `obsidian vault=notes create path="Inbox/YYYY-MM-DD.md" content="<full note>" overwrite`.
   - Start with a `---` separator, then use this template:

   ```markdown
   ---

   ## Day Close

   ### Completed

   - [Specific things shipped, merged, resolved]

   ### In Progress

   - [What's mid-way — include enough context to resume]

   ### Blocked / Waiting

   - [What's stuck and on whom]

   ### Decisions Made

   - [Architecture, process, or priority decisions — even small ones]
   - [Include WHO decided and WHY]

   ### Learned Today

   - [Non-obvious things: debugging insights, config gotchas, integration quirks]

   ### Tomorrow

   - [ ] [Top priority]
   - [ ] [Second priority]
   - [ ] [Third priority — max 3]

   ### Open Questions

   - [ ] [Questions raised today that aren't answered yet]
   ```

## Rules

- Be concrete. "Worked on the API" is useless. "Added pagination to equipment-service /list endpoint" is useful.
- Capture the WHY for decisions, not just what was decided.
- Flag any tasks that have been carried 3+ days (detected in step 3).
- Max 3 items in Tomorrow.
- Jonas is a full-stack developer — capture decisions explicitly, they happen in meetings and chats and don't get written down.
