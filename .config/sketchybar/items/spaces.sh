#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change
#
# shellcheck source=../colors.sh
source "$CONFIG_DIR"/colors.sh

COLORS_SPACE=("$YELLOW" "$MAGENTA" "$BLUE" "$GREEN" "$RED" "$ORANGE")
for mid in $(aerospace list-monitors | cut -f 1 -d "|"); do
  declare -i i
  i=0
  for sid in $(aerospace list-workspaces --monitor "$mid"); do
    i=$((i % ${#COLORS_SPACE[@]}))
    color="${COLORS_SPACE[$i]}"
    space=(
      space="$sid"
      display="$mid"
      icon="$sid"
      icon.highlight_color="$RED"
      icon.padding_left=10
      icon.padding_right=10
      padding_left=2
      padding_right=2
      label.padding_right=20
      label.color="$GREY"
      label.highlight_color="$WHITE"
      label.font="sketchybar-app-font:Regular:16.0"
      label.y_offset=-1
      background.color="$color"
      background.border_color="$BACKGROUND_2"
      script="$PLUGIN_DIR/space.sh"
      click_script="aerospace workspace $sid"
    )

    sketchybar --add space space."$sid" left \
      --set space."$sid" "${space[@]}"
    i+=1
  done
done

sketchybar --add item space_separator left \
  --set space_separator icon="􀆊" \
  icon.padding_left=4 \
  icon.font="sketchybar-app-font:Regular:16.0" \
  label.drawing=off \
  background.drawing=off \
  script="$PLUGIN_DIR/space_windows.sh" \
  --subscribe space_separator aerospace_workspace_change
