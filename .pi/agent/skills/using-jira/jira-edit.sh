#!/usr/bin/env bash
set -euo pipefail

# Usage: jira-edit.sh KEY JSON_BODY
# Update fields on an existing Jira issue.

if [[ $# -lt 2 ]]; then
  echo "Usage: jira-edit.sh KEY JSON_BODY" >&2
  exit 1
fi

KEY="$1"
BODY="$2"

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
  -X PUT \
  -H "Authorization: Basic $ATLASSIAN_TOKEN" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d "$BODY" \
  "$URL")

if [[ "$HTTP_STATUS" -ne 204 ]]; then
  echo "Error: HTTP $HTTP_STATUS" >&2
  cat "$TMPFILE" >&2
  exit 1
fi

echo "Updated $KEY"
