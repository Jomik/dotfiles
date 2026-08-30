#!/usr/bin/env bash
set -euo pipefail

# Usage: jira-view.sh KEY [field1 field2 ...]
# View a Jira issue. Default output: key, summary, status, type, parent, description, acceptance_criteria.
# If field names are given, only those are shown.

if [[ $# -lt 1 ]]; then
  echo "Usage: jira-view.sh KEY [field1 field2 ...]" >&2
  exit 1
fi

KEY="$1"
shift
FIELDS=("$@")

if [[ -z "${ATLASSIAN_TOKEN:-}" ]]; then
  echo "Error: ATLASSIAN_TOKEN is not set" >&2
  exit 1
fi
if [[ -z "${JIRA_SERVER:-}" ]]; then
  echo "Error: JIRA_SERVER is not set" >&2
  exit 1
fi

URL="https://${JIRA_SERVER}/rest/api/3/issue/${KEY}"
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

HTTP_STATUS=$(curl -s -o "$TMPFILE" -w "%{http_code}" \
  -H "Authorization: Basic $ATLASSIAN_TOKEN" \
  -H "Accept: application/json" \
  "$URL")

if [[ "$HTTP_STATUS" -ne 200 ]]; then
  echo "Error: HTTP $HTTP_STATUS" >&2
  cat "$TMPFILE" >&2
  exit 1
fi

DEFAULT_FILTER='
{
  key: .key,
  summary: .fields.summary,
  status: .fields.status.name,
  type: .fields.issuetype.name,
  parent: (.fields.parent // null | if . then .key + " - " + .fields.summary else null end),
  description: .fields.description,
  acceptance_criteria: .fields.customfield_10400
}'

if [[ ${#FIELDS[@]} -eq 0 ]]; then
  jq "$DEFAULT_FILTER" "$TMPFILE"
else
  # Build a dynamic jq filter from requested fields
  FILTER="{"
  for f in "${FIELDS[@]}"; do
    case "$f" in
      key)                  FILTER+="key: .key," ;;
      summary)              FILTER+="summary: .fields.summary," ;;
      status)               FILTER+="status: .fields.status.name," ;;
      type)                 FILTER+="type: .fields.issuetype.name," ;;
      parent)               FILTER+="parent: (.fields.parent // null | if . then .key + \" - \" + .fields.summary else null end)," ;;
      description)          FILTER+="description: .fields.description," ;;
      acceptance_criteria)  FILTER+="acceptance_criteria: .fields.customfield_10400," ;;
      assignee)             FILTER+="assignee: .fields.assignee.displayName," ;;
      attachment|attachments) FILTER+="attachments: [(.fields.attachment // [])[] | {id: .id, filename: .filename, size: .size, mimeType: .mimeType}]," ;;
      *)                    FILTER+="\"$f\": .fields.\"$f\"," ;;
    esac
  done
  FILTER="${FILTER%,}}"
  jq "$FILTER" "$TMPFILE"
fi
