#!/opt/homebrew/bin/bash
# Herdr project picker
# Invoked as: /opt/homebrew/bin/bash ~/.config/herdr/scripts/project-picker.sh
# Use --list to print discovered repos without invoking fzf or Herdr.
set -euo pipefail

export PATH="/opt/homebrew/bin:$HOME/.local/bin:/usr/bin:/bin:$PATH"

PRIVATE_ROOT="$HOME/projects/private"
WORK_ROOT="$HOME/projects/work"

# Discovery

discover_repos() {
    local root="$1"
    local tag="$2"
    [[ -d "$root" ]] || return 0
    fd --max-depth 2 --hidden --type d '^\.(git|jj)$' "$root" --format '{//}' \
        | sort -u \
        | while IFS= read -r abs_path; do
            local rel_path="${abs_path#"$root/"}"
            printf '%s\t%s\n' "[$tag] $rel_path" "$abs_path"
          done
}

build_rows() {
    {
        discover_repos "$PRIVATE_ROOT" "private"
        discover_repos "$WORK_ROOT" "work"
    } | sort
}

# --list mode: no fzf, no Herdr

if [[ "${1:-}" == "--list" ]]; then
    build_rows
    exit 0
fi

# Pick with fzf

rows=$(build_rows)

if [[ -z "$rows" ]]; then
    echo "No projects found." >&2
    exit 0
fi

selected=$(printf '%s\n' "$rows" \
    | fzf --delimiter $'\t' --with-nth 1 --prompt 'Project > ') || exit 0

[[ -z "$selected" ]] && exit 0

abs_path=$(printf '%s' "$selected" | cut -f2)

# Canonicalize via Python realpath
repo=$(python3 -c "import os, sys; print(os.path.realpath(sys.argv[1]))" "$abs_path")

# Reuse existing workspace
#
# herdr workspace list: .result.workspaces[] (workspace_id)
# herdr pane list --workspace ID: .result.panes[] (cwd, foreground_cwd)
#
found_workspace=$(HERDR_TARGET_REPO="$repo" python3 <<'PYEOF'
import json, os, subprocess, sys

repo = os.environ['HERDR_TARGET_REPO']

def canon(p):
    return os.path.realpath(p) if p else ''

try:
    r = subprocess.run(
        ['herdr', 'workspace', 'list'],
        capture_output=True, text=True, check=True,
    )
    workspaces = json.loads(r.stdout)['result']['workspaces']
except Exception as e:
    print(f'herdr workspace list failed: {e}', file=sys.stderr)
    sys.exit(1)

for ws in workspaces:
    ws_id = ws.get('workspace_id', '')
    if not ws_id:
        continue
    try:
        r = subprocess.run(
            ['herdr', 'pane', 'list', '--workspace', ws_id],
            capture_output=True, text=True, check=True,
        )
        panes = json.loads(r.stdout)['result']['panes']
    except Exception as e:
        print(f'herdr pane list failed for workspace {ws_id!r}: {e}', file=sys.stderr)
        continue
    for pane in panes:
        for field in ('cwd', 'foreground_cwd'):
            val = pane.get(field, '')
            if val and canon(val) == repo:
                print(ws_id)
                sys.exit(0)

sys.exit(0)
PYEOF
)

if [[ -n "$found_workspace" ]]; then
    herdr workspace focus "$found_workspace"
    exit 0
fi

# Create and focus a new workspace

create_output=$(herdr workspace create \
    --cwd "$repo" \
    --label "$(basename "$repo")" \
    --focus)

pane_id=$(HERDR_CREATE_OUTPUT="$create_output" python3 <<'PYEOF'
import json, os, sys

try:
    data = json.loads(os.environ['HERDR_CREATE_OUTPUT'])
    pane_id = data['result']['root_pane']['pane_id']
    if not pane_id:
        raise ValueError('pane_id is empty')
    print(pane_id)
except Exception as e:
    print(f'Failed to parse workspace create output: {e}', file=sys.stderr)
    sys.exit(1)
PYEOF
)

herdr pane run "$pane_id" "pi -c"
