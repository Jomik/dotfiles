#!/usr/bin/env bash

# shellcheck source=../colors.sh
source "$CONFIG_DIR"/colors.sh

reload_workspace_icon() {
  apps=$(aerospace list-windows --workspace "$1" | cut -f 2 -d "|")

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app; do
      icon_strip+=" $("$CONFIG_DIR"/icon_map.sh "$app")"
    done <<<"${apps}"
  else
    icon_strip=" —"
  fi

  sketchybar --animate sin 10 --set space."$1" label="$icon_strip"
}

# current workspace space border color
sketchybar --set space."$FOCUSED_WORKSPACE" icon.highlight=true \
  label.highlight=true \
  background.drawing=true
# background.border_color=$GREY

# prev workspace space border color
sketchybar --set space."$PREVIOUS_WORKSPACE" icon.highlight=false \
  label.highlight=false \
  background.drawing=false
# background.border_color=$BACKGROUND_2

# PERF: Consider doing this once in items/spaces.sh and then just updating the
# focused and previous workspaces here
for wid in $(aerospace list-workspaces --all); do
  reload_workspace_icon "$wid"
done
