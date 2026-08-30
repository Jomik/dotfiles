#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   jira-link.sh KEY_A KEY_B                 — Create link: A blocks B
#   jira-link.sh --split KEY_A KEY_B         — Create link: A split to B
#   jira-link.sh --list KEY                  — List all links on an issue
#   jira-link.sh --delete KEY_A KEY_B        — Delete "blocks" link between A and B
#   jira-link.sh --delete --split KEY_A KEY_B — Delete "split to" link between A and B

if [[ $# -lt 1 ]]; then
  echo "Usage:" >&2
  echo "  jira-link.sh KEY_A KEY_B                  — A blocks B" >&2
  echo "  jira-link.sh --split KEY_A KEY_B          — A split to B" >&2
  echo "  jira-link.sh --list KEY                   — List links" >&2
  echo "  jira-link.sh --delete KEY_A KEY_B         — Delete blocks link" >&2
  echo "  jira-link.sh --delete --split KEY_A KEY_B — Delete split link" >&2
  exit 1
fi

if [[ -z "${ATLASSIAN_TOKEN:-}" ]]; then
  echo "Error: ATLASSIAN_TOKEN is not set" >&2
  exit 1
fi
if [[ -z "${JIRA_SERVER:-}" ]]; then
  echo "Error: JIRA_SERVER is not set" >&2
  exit 1
fi

MODE="create"
LINK_TYPE="Blocks"
LINK_VERB="blocks"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list) MODE="list"; shift ;;
    --delete) MODE="delete"; shift ;;
    --split) LINK_TYPE="Work item split"; LINK_VERB="split to"; shift ;;
    *) break ;;
  esac
done

case "$MODE" in
  create)
    if [[ $# -lt 2 ]]; then
      echo "Usage: jira-link.sh KEY_A KEY_B" >&2
      exit 1
    fi
    KEY_A="$1"
    KEY_B="$2"

    # Jira API: inwardIssue = source (A), outwardIssue = target (B)
    TMPFILE=$(mktemp)
    trap 'rm -f "$TMPFILE"' EXIT

    HTTP_STATUS=$(curl -s -o "$TMPFILE" -w "%{http_code}" \
      -H "Authorization: Basic $ATLASSIAN_TOKEN" \
      -X POST "https://${JIRA_SERVER}/rest/api/3/issueLink" \
      -H "Content-Type: application/json" \
      -d "{\"type\":{\"name\":\"${LINK_TYPE}\"},\"inwardIssue\":{\"key\":\"${KEY_A}\"},\"outwardIssue\":{\"key\":\"${KEY_B}\"}}")

    if [[ "$HTTP_STATUS" -ne 201 ]]; then
      echo "Error: HTTP $HTTP_STATUS" >&2
      cat "$TMPFILE" >&2
      exit 1
    fi
    echo "Linked: $KEY_A $LINK_VERB $KEY_B"
    ;;

  list)
    if [[ $# -lt 1 ]]; then
      echo "Usage: jira-link.sh --list KEY" >&2
      exit 1
    fi
    KEY="$1"
    TMPFILE=$(mktemp)
    trap 'rm -f "$TMPFILE"' EXIT

    HTTP_STATUS=$(curl -s -o "$TMPFILE" -w "%{http_code}" \
      -H "Authorization: Basic $ATLASSIAN_TOKEN" \
      -H "Accept: application/json" \
      "https://${JIRA_SERVER}/rest/api/3/issue/${KEY}?fields=issuelinks")

    if [[ "$HTTP_STATUS" -ne 200 ]]; then
      echo "Error: HTTP $HTTP_STATUS" >&2
      cat "$TMPFILE" >&2
      exit 1
    fi

    jq '[.fields.issuelinks[] | {
      type: .type.name,
      direction: (if .inwardIssue then "inward" else "outward" end),
      description: (if .inwardIssue then .type.inward else .type.outward end),
      issue: (if .inwardIssue then .inwardIssue else .outwardIssue end | {
        key: .key,
        summary: .fields.summary,
        status: .fields.status.name
      })
    }]' "$TMPFILE"
    ;;

  delete)
    if [[ $# -lt 2 ]]; then
      echo "Usage: jira-link.sh --delete KEY_A KEY_B" >&2
      exit 1
    fi
    KEY_A="$1"
    KEY_B="$2"

    # First, find the link ID by fetching A's links
    TMPFILE=$(mktemp)
    trap 'rm -f "$TMPFILE"' EXIT

    HTTP_STATUS=$(curl -s -o "$TMPFILE" -w "%{http_code}" \
      -H "Authorization: Basic $ATLASSIAN_TOKEN" \
      -H "Accept: application/json" \
      "https://${JIRA_SERVER}/rest/api/3/issue/${KEY_A}?fields=issuelinks")

    if [[ "$HTTP_STATUS" -ne 200 ]]; then
      echo "Error: HTTP $HTTP_STATUS fetching links" >&2
      cat "$TMPFILE" >&2
      exit 1
    fi

    # Find the link ID where A --LINK_TYPE--> B
    LINK_ID=$(jq -r --arg lt "$LINK_TYPE" --arg kb "$KEY_B" '.fields.issuelinks[] |
      select(.type.name == $lt and .outwardIssue.key == $kb) | .id' "$TMPFILE")

    if [[ -z "$LINK_ID" || "$LINK_ID" == "null" ]]; then
      echo "Error: No '$LINK_TYPE' link found from $KEY_A to $KEY_B" >&2
      exit 1
    fi

    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
      -H "Authorization: Basic $ATLASSIAN_TOKEN" \
      -X DELETE "https://${JIRA_SERVER}/rest/api/3/issueLink/${LINK_ID}")

    if [[ "$HTTP_STATUS" -ne 204 ]]; then
      echo "Error: HTTP $HTTP_STATUS deleting link" >&2
      exit 1
    fi
    echo "Deleted: $KEY_A $LINK_VERB $KEY_B"
    ;;
esac
