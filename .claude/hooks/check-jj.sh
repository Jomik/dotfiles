#!/bin/bash
# VCS permission hook for jj repositories.
# - Auto-allows jj commands (workaround for anthropics/claude-code#38017)
# - Blocks git commands in jj repositories
# Reads tool input from stdin (JSON with .tool_input.command).

CMD=$(jq -r '.tool_input.command')

# TODO: Remove this workaround once anthropics/claude-code#38017 is closed
if [[ "$CMD" =~ ^jj\  ]]; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"auto-allowed jj command"}}'
  exit 0
fi

STRIPPED=$(echo "$CMD" | sed 's/jj git//g')

if echo "$STRIPPED" | grep -qE '(^|[;&|() ])git( |$)'; then
  if jj root >/dev/null 2>&1; then
    echo '{"decision":"block","reason":"This is a jj repository. Do not use git commands. Invoke the using-jj skill and use jj equivalents instead."}'
  fi
fi
