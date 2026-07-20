#!/bin/sh

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

front_app=(
  label.font="$FONT:Black:12.0"
  icon.background.drawing=off
  display=all
  script="$PLUGIN_DIR/front_app.sh"
  click_script="open -a 'Mission Control'"
  background.drawing=on
  background.color=0xff3b3b3b
  background.border_width=1
  background.border_color=0xff666666
  background.corner_radius=5
  padding_left=8
  padding_right=8
)
/opt/homebrew/bin/sketchybar --add item front_app left         \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched

