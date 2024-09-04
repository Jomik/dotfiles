#!/usr/bin/env bash

front_app=(
  label.font="$FONT:Black:14.0"
  icon.background.drawing=on
  icon.font="sketchybar-app-font:Regular:16.0"
  display=active
  script="$PLUGIN_DIR/front_app.sh"
)
sketchybar --add item front_app left \
  --set front_app "${front_app[@]}" \
  --subscribe front_app front_app_switched
