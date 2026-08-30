---
name: using-jira
description: Use when interacting with Jira — viewing, searching, creating, editing, or linking issues via the Jira REST API.
---

# Using Jira

## Field names for `view_jira_issue`

Pass as the `fields` parameter to filter output. Omit for all defaults.

| Field name | Maps to |
|-----------|---------|
| `key` | Issue key |
| `summary` | Summary |
| `status` | Status name |
| `type` | Issue type name |
| `parent` | Parent key + summary |
| `description` | Description (ADF) |
| `acceptance_criteria` | customfield_10400 |
| `assignee` | Assignee display name |
| `attachment` | Attachment list (id, filename, size, mimeType) |
| Any other string | Raw `.fields.<name>` |

## JQL patterns

```
project = PLMA AND status = "In Progress"
parent = PLMA-100
assignee = currentUser() AND status != Done
sprint in openSprints()
issuetype = Story AND project = PLMA ORDER BY rank
```

## ADF (Atlassian Document Format)

Description, acceptance criteria, and comment bodies use ADF. Use this structure for `create_jira_issue` and `edit_jira_issue`:

```json
{
  "type": "doc",
  "version": 1,
  "content": [
    {
      "type": "paragraph",
      "content": [{ "type": "text", "text": "Paragraph text" }]
    }
  ]
}
```

Common node types:
- `paragraph` — block with inline content
- `heading` — `{ "type": "heading", "attrs": { "level": 2 }, "content": [...] }`
- `bulletList` / `orderedList` — contain `listItem` nodes
- `listItem` — contains `paragraph` nodes
- `codeBlock` — `{ "type": "codeBlock", "attrs": { "language": "typescript" }, "content": [{ "type": "text", "text": "..." }] }`

Inline marks: `{ "type": "text", "text": "bold", "marks": [{ "type": "strong" }] }`

## Custom fields

| Field | ID | Notes |
|-------|-----|-------|
| Acceptance Criteria | `customfield_10400` | ADF format |

## Create issue payload

```json
{
  "fields": {
    "project": { "key": "PLMA" },
    "summary": "Issue title",
    "issuetype": { "name": "Story" },
    "parent": { "key": "PLMA-100" },
    "description": { "type": "doc", "version": 1, "content": [...] },
    "customfield_10400": { "type": "doc", "version": 1, "content": [...] }
  }
}
```

Issue types: `Epic`, `Story`, `Task`, `Sub-task`, `Bug`

## Edit issue payload

Only include fields being changed:

```json
{
  "fields": {
    "summary": "Updated title",
    "description": { "type": "doc", "version": 1, "content": [...] }
  }
}
```

## Workflows

**Create story under epic:** create issue with `parent` field set, then optionally add a split link from the epic.

**Split a story:** create new stories, then `create_jira_split_link` from original to each new one.

**View full context:** `view_jira_issue` for details, `list_jira_issue_links` for relationships, `list_jira_comments` for discussion history.

**Attachments:** list with `view_jira_issue` using the `attachment` field. Download with `download_jira_attachments` (`jira-attachments.sh KEY [PATTERN]`), which saves to `/tmp/pi-jira-attachments/KEY/` and prints each downloaded path. With no `PATTERN` it downloads all attachments; `PATTERN` is a case-insensitive substring match on the filename.
