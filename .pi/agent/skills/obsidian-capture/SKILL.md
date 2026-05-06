---
name: obsidian-capture
description: Use when the user says "capture", or wants to remember, save, or note something for later.
---

# Obsidian Capture

Capture something into Jonas's Obsidian vault with minimal friction.

## Workflow

1. **Clarify if needed** — Ask at most one clarifying question, and only if the classification is genuinely ambiguous.

2. **Classify** the capture as one of:
   - `decision` — something decided (architecture, process, priority)
   - `learning` — something figured out or understood
   - `observation` — something noticed (behaviour, pattern, quirk)
   - `question` — an open or unanswered question
   - `todo` — a task, reminder, or action item

3. **Route** — decide whether this goes to a standalone note or the daily note:
   - **Standalone note** if: it's a decision with rationale, a reusable learning, an observation that might connect to others later, or a todo with context/rationale.
   - **Daily note append** if: it's a quick thought or reminder, time-bound and won't matter in 2 weeks, or too small for its own note.

4. **Show the user what will be written** — Present the formatted note and the destination, and ask for confirmation before writing.

5a. **Create standalone note** using:
   `obsidian vault=notes create name="<Title>" path="<Folder>/<Title>.md" content="<content>"`

   Folder is determined by type:
   - Work observation / decision / learning → `Work/`
   - Personal → `Personal/`
   - Quick thought that doesn't fit either → fall back to step 5b

   Standalone note format:
   ```
   # [Title]

   #[type-tag] — YYYY-MM-DD

   ## What
   [The observation, decision, or learning — stated clearly]

   ## Context
   [Why this matters, what prompted it, what was happening]

   ## Connections
   - [[Related Note]] — if any obvious links exist

   ## Open Questions
   - [ ] [What's still unknown]
   ```

5b. **Append to daily note** using:
   `obsidian vault=notes daily:append content="<note content>"`

   Daily append format:
   ```
   ### [Brief title]
   **Date:** YYYY-MM-DD  **Type:** #type
   **Context:** [Source]

   [What happened]

   **Why it matters:** [One sentence]
   ```

6. **Confirm** what was created and where. If the note connects to existing notes, mention them: "This might relate to [[X]] — worth linking?"

## Tags

Use one of: `#decision`, `#learning`, `#observation`, `#question`, `#todo`

Work-specific tags (add when relevant):
`#graphql` `#sap-bridge` `#ticket-service` `#equipment-service` `#spareparts` `#image-service` `#push-notifications` `#gateway` `#framework` `#maintainit-web` `#maintainit-mobile` `#aws` `#api-management` `#deployment` `#jira` `#sprint` `#team`

## Rules

- Don't polish. Raw is fine.
- One idea per capture.
- Open questions use `- [ ]` checkbox syntax in the note body.
- Always confirm with the user before writing.
- Capture decisions explicitly — as a full-stack developer, Jonas makes decisions in meetings and chats that don't get written down.
- When Jonas pastes meeting notes or screenshots, extract and classify the key points without asking for clarification.
- Bias toward standalone notes — these are raw material for finding patterns later.
- Always add a date.
- Keep notes short — capture is about speed, not completeness. Jonas can expand later.
- Suggest connections if obvious: "This might relate to [[X]] — worth linking?"
- For decisions, always capture the "why" and what alternatives were considered.
- If the title would be too generic (e.g., "Note"), derive a specific title from the content.
