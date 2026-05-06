#!/opt/homebrew/bin/bash
set -euo pipefail

export PATH="/opt/homebrew/bin:$HOME/.local/bin:/usr/bin:/bin:$PATH"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
DEFAULT_SESSION="$CONFIG_DIR/default.kitty-session"
SCRATCHPAD_SESSION="$CONFIG_DIR/sessions/scratchpad.kitty-session"
NOTES_SESSION="$CONFIG_DIR/sessions/notes.kitty-session"
PROJECTS_ROOT="$HOME/projects"
SESSION_DIR="/tmp/kitty-sessions"

SEARCH_PATHS=("$PROJECTS_ROOT/private:2" "$PROJECTS_ROOT/work:2")

mkdir -p "$SESSION_DIR"

find_repos() {
    for entry in "${SEARCH_PATHS[@]}"; do
        path="${entry%%:*}"
        depth="${entry##*:}"
        [[ -d "$path" ]] && fd -H -t d -d "$depth" '^\.(git|jj)$' "$path" --format '{//}'
    done | sort -uf
}
# Get active CWDs from kitty
declare -A active_cwds
while IFS= read -r cwd; do
    active_cwds["$cwd"]=1
done < <(kitten @ ls 2>/dev/null | python3 -c "
import json, sys
data = json.load(sys.stdin)
for w in data:
    for t in w.get('tabs', []):
        for win in t.get('windows', []):
            c = win.get('cwd', '')
            if c: print(c)
" | sort -u)

# Build fzf input: display\tsession_file\trepo_path
active_input=""
inactive_input=""

# Scratchpad always at top — use a copy so it's not the startup_session file
scratchpad_file="$SESSION_DIR/scratchpad.kitty-session"
cp -f "$SCRATCHPAD_SESSION" "$scratchpad_file"
active_input+="  scratchpad"$'\t'"$scratchpad_file"$'\t'$'\n'

# Notes session
notes_file="$SESSION_DIR/notes.kitty-session"
cp -f "$NOTES_SESSION" "$notes_file"
active_input+="  notes"$'\t'"$notes_file"$'\t'$'\n'

# All repos
while IFS= read -r repo; do
    [[ -z "$repo" ]] && continue
    rel="${repo#$PROJECTS_ROOT/}"
    group="${rel%%/*}"
    name="${rel#*/}"
    session_file="$SESSION_DIR/${group}--${name}.kitty-session"
    if [[ -n "${active_cwds[$repo]+_}" ]]; then
        active_input+="▶ [$group] $name"$'\t'"$session_file"$'\t'"$repo"$'\n'
    else
        inactive_input+="  [$group] $name"$'\t'"$session_file"$'\t'"$repo"$'\n'
    fi
done < <(find_repos)

fzf_input="${active_input}${inactive_input}"

# fzf selection
selected=$(printf "%s" "$fzf_input" | fzf \
    --prompt 'Project > ' \
    --delimiter $'\t' \
    --with-nth 1 \
    || exit 0)
[[ -z "$selected" ]] && exit 0

IFS=$'\t' read -r _ session_file repo_path <<< "$selected"

# Generate session from template (always fresh)
if [[ -n "$repo_path" ]]; then
    project_name=$(basename "$repo_path")
    sed -e "s|@@session-path@@|$repo_path|g" -e "s|@@session@@|$project_name|g" "$DEFAULT_SESSION" > "$session_file"
fi

kitten @ action goto_session "$session_file"
