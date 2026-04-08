## Implementation

The primary agent MUST NOT write implementation code. All code changes --
features, fixes, refactors -- go through the `implementing` skill. No
exceptions, regardless of how small the change appears.

The `implementing` skill accepts a plan from `.opencode/plans/` or an approved plan
in the current conversation context. Either source is valid. Other skills
(debugging, design) produce plans; the implementing skill executes them.

## Debugging

When the user reports a bug, test failure, or unexpected behavior -- or when
you encounter one yourself -- load the `systematic-debugging` skill BEFORE
proposing any fixes. Do not skip this even if the fix seems obvious.

## Version Control

Some projects use jj (Jujutsu) instead of git. At the start of a session,
run `jj root` to check. If it exits 0, this is a jj repo -- load the
`using-jj` skill and follow its instructions for ALL version control
operations. If it exits non-zero, use standard git commands.
