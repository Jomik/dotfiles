#!/usr/bin/env bash
set -euo pipefail

# Usage: jira-list.sh JQL [MAX_RESULTS]
# Search Jira issues via JQL.

if [[ $# -lt 1 ]]; then
  echo "Usage: jira-list.sh JQL [MAX_RESULTS]" >&2
  exit 1
fi

JQL="$1"
MAX_RESULTS="${2:-50}"

if [[ -z "${ATLASSIAN_TOKEN:-}" ]]; then
  echo "Error: ATLASSIAN_TOKEN is not set" >&2
  exit 1
fi
if [[ -z "${JIRA_SERVER:-}" ]]; then
  echo "Error: JIRA_SERVER is not set" >&2
  exit 1
fi

URL="https://${JIRA_SERVER}/rest/api/3/search/jql"
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

BODY=$(jq -n --arg jql "$JQL" --argjson max "$MAX_RESULTS" '{
  jql: $jql,
  maxResults: $max,
  fields: ["summary", "status", "issuetype", "assignee"]
}')

HTTP_STATUS=$(curl -s -o "$TMPFILE" -w "%{http_code}" \
  -X POST \
  -H "Authorization: Basic $ATLASSIAN_TOKEN" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d "$BODY" \
  "$URL")

if [[ "$HTTP_STATUS" -ne 200 ]]; then
  echo "Error: HTTP $HTTP_STATUS" >&2
  cat "$TMPFILE" >&2
  exit 1
fi

jq '[.issues[] | {
  key: .key,
  summary: .fields.summary,
  status: .fields.status.name,
  type: .fields.issuetype.name,
  assignee: (.fields.assignee // null | if . then .displayName else null end)
}]' "$TMPFILE"
