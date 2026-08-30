#!/usr/bin/env bash
set -euo pipefail

# Usage: jira-create.sh JSON_BODY
# Create a new Jira issue.

if [[ $# -lt 1 ]]; then
  echo "Usage: jira-create.sh JSON_BODY" >&2
  exit 1
fi

BODY="$1"

if [[ -z "${ATLASSIAN_TOKEN:-}" ]]; then
  echo "Error: ATLASSIAN_TOKEN is not set" >&2
  exit 1
fi
if [[ -z "${JIRA_SERVER:-}" ]]; then
  echo "Error: JIRA_SERVER is not set" >&2
  exit 1
fi

URL="https://${JIRA_SERVER}/rest/api/3/issue"
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

HTTP_STATUS=$(curl -s -o "$TMPFILE" -w "%{http_code}" \
  -X POST \
  -H "Authorization: Basic $ATLASSIAN_TOKEN" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d "$BODY" \
  "$URL")

if [[ "$HTTP_STATUS" -ne 201 ]]; then
  echo "Error: HTTP $HTTP_STATUS" >&2
  cat "$TMPFILE" >&2
  exit 1
fi

jq --arg server "$JIRA_SERVER" '{
  key: .key,
  url: ("https://" + $server + "/browse/" + .key)
}' "$TMPFILE"
