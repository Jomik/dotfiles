#!/usr/bin/env bash

battery=(
  script="$PLUGIN_DIR/battery.sh"
  icon.font="$FONT:Regular:19.0"
  padding_right=3
  padding_left=0
  label.drawing=off
  update_freq=120
  updates=on
  icon.font.size=15
  update_freq=120
  script="$PLUGIN_DIR/battery.sh"
)
sketchybar --add item battery right \
  --set battery "${battery[@]}" \
  --subscribe battery power_source_change system_woke
