# Global Rules

## Implementation guard

Do not use Edit, Write, or NotebookEdit on source code files unless you were dispatched with an implementation plan to execute. Specs, plans, and documentation are fine — this rule applies only to code.

## Context7 usage

Do NOT call `mcp__plugin_context7_context7__resolve-library-id` or `mcp__plugin_context7_context7__query-docs` directly. Always invoke the `using-context7` skill first, which will guide proper usage of the context7 MCP tools. This applies to all agents.
