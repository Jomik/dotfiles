#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   jira-attachments.sh KEY             Download all attachments
#   jira-attachments.sh KEY PATTERN     Download attachments whose filename matches PATTERN
#
# To list attachments without downloading, use: jira-view.sh KEY attachment
#
# PATTERN is a case-insensitive substring match against the filename.
# Files are saved to /tmp/pi-jira-attachments/KEY (created if missing).
# Downloaded file paths are printed, one per line.

if [[ $# -lt 1 ]]; then
  echo "Usage: jira-attachments.sh KEY [PATTERN]" >&2
  echo "  (list attachments with: jira-view.sh KEY attachment)" >&2
  exit 1
fi

KEY="$1"
SELECTOR="${2:-}"
DEST_DIR="/tmp/pi-jira-attachments/${KEY}"

if [[ -z "${ATLASSIAN_TOKEN:-}" ]]; then
  echo "Error: ATLASSIAN_TOKEN is not set" >&2
  exit 1
fi
if [[ -z "${JIRA_SERVER:-}" ]]; then
  echo "Error: JIRA_SERVER is not set" >&2
  exit 1
fi

URL="https://${JIRA_SERVER}/rest/api/3/issue/${KEY}?fields=attachment"
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

COUNT=$(jq '.fields.attachment | length' "$TMPFILE")
if [[ "$COUNT" -eq 0 ]]; then
  echo "No attachments on $KEY."
  exit 0
fi

mkdir -p "$DEST_DIR"

# Emit id<TAB>filename<TAB>content_url per attachment.
jq -r '.fields.attachment[] | [.id, .filename, .content] | @tsv' "$TMPFILE" \
| while IFS=$'\t' read -r ID FILENAME CONTENT_URL; do
  if [[ -n "$SELECTOR" ]]; then
    # Case-insensitive substring match on filename.
    shopt -s nocasematch
    [[ "$FILENAME" == *"$SELECTOR"* ]] || continue
  fi

  SAFE_NAME="${FILENAME//\//_}"
  OUT="${DEST_DIR}/${SAFE_NAME}"
  [[ -e "$OUT" ]] && OUT="${DEST_DIR}/${ID}-${SAFE_NAME}"

  DL_STATUS=$(curl -s -L -o "$OUT" -w "%{http_code}" \
    -H "Authorization: Basic $ATLASSIAN_TOKEN" \
    "$CONTENT_URL")

  if [[ "$DL_STATUS" -ne 200 ]]; then
    echo "Error: HTTP $DL_STATUS downloading $FILENAME (id $ID)" >&2
    rm -f "$OUT"
    continue
  fi

  echo "$OUT"
done

# Summary (recomputed; the loop above runs in a pipe subshell).
if [[ -z "$SELECTOR" ]]; then
  echo "Downloaded $COUNT attachment(s) to $DEST_DIR"
else
  N=$(jq -r --arg p "$SELECTOR" '
    [.fields.attachment[] | select(.filename | ascii_downcase | contains($p | ascii_downcase))] | length
  ' "$TMPFILE")
  if [[ "$N" -eq 0 ]]; then
    echo "No attachments on $KEY matched: $SELECTOR" >&2
    exit 1
  fi
  echo "Downloaded $N attachment(s) matching '$SELECTOR' to $DEST_DIR"
fi
