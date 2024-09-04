#!/usr/bin/env bash

WIDTH=100

show_slider() {
  sketchybar --animate tanh 30 --set volume slider.width=$WIDTH
}

hide_slider() {
  sketchybar --animate tanh 30 --set volume slider.width=0
}

toggle_slider() {
  INITIAL_WIDTH=$(sketchybar --query volume | jq -r ".slider.width")
  if [ "$INITIAL_WIDTH" -eq "0" ]; then
    show_slider
  else
    hide_slider
  fi
}

toggle_slider
