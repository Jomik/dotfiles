#!/usr/bin/env bash
set -euo pipefail

# Usage: jira-comments.sh KEY
# List comments on a Jira issue (newest last).
# Output: author, created timestamp, and body text for each comment.

if [[ $# -lt 1 ]]; then
  echo "Usage: jira-comments.sh KEY" >&2
  exit 1
fi

KEY="$1"

if [[ -z "${ATLASSIAN_TOKEN:-}" ]]; then
  echo "Error: ATLASSIAN_TOKEN is not set" >&2
  exit 1
fi
if [[ -z "${JIRA_SERVER:-}" ]]; then
  echo "Error: JIRA_SERVER is not set" >&2
  exit 1
fi

URL="https://${JIRA_SERVER}/rest/api/3/issue/${KEY}/comment?orderBy=created"
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

# Extract plain text from ADF body recursively
JQ_FILTER='
def extract_text:
  if type == "object" then
    if .type == "text" then .text // ""
    else (.content // []) | map(extract_text) | join("")
    end
  elif type == "array" then map(extract_text) | join("")
  else ""
  end;

.comments[] | {
  author: .author.displayName,
  created: (.created | split(".")[0] | sub("T"; " ")),
  body: (.body | extract_text)
}'

RESULT=$(jq -r "$JQ_FILTER" "$TMPFILE" 2>/dev/null)

if [[ -z "$RESULT" ]]; then
  echo "No comments."
else
  # Pretty-print each comment
  jq -r '
    "--- \(.author) [\(.created)] ---",
    .body,
    ""
  ' <<< "$(jq -c '
def extract_text:
  if type == "object" then
    if .type == "text" then .text // ""
    else (.content // []) | map(extract_text) | join("")
    end
  elif type == "array" then map(extract_text) | join("")
  else ""
  end;

.comments[] | {
  author: .author.displayName,
  created: (.created | split(".")[0] | sub("T"; " ")),
  body: (.body | extract_text)
}' "$TMPFILE")"
fi
