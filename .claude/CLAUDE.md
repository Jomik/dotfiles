# Global Rules

## Implementation guard

Do not use Edit, Write, or NotebookEdit on source code files unless you were dispatched with an implementation plan to execute. Specs, plans, and documentation are fine — this rule applies only to code.

## Bash commands

Run Bash commands directly. Do not print `echo $?` or add `2>/dev/null` / `2>&1` — the Bash tool already captures both exit codes and stderr.

## jj usage

Do NOT run `jj` commands directly without first invoking the `using-jj` skill. This applies to all agents.

## Context7 usage

Do NOT call `mcp__plugin_context7_context7__resolve-library-id` or `mcp__plugin_context7_context7__query-docs` directly. Always invoke the `using-context7` skill first, which will guide proper usage of the context7 MCP tools. This applies to all agents.
