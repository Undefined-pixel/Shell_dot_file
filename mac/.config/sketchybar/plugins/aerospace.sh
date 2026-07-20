#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

FOCUSED_WORKSPACE=$(/opt/homebrew/bin/aerospace list-workspaces --focused)

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  # Aktiver Workspace — helles Highlight
  /opt/homebrew/bin/sketchybar --set space.$1 \
    background.color=0xff444444 \
    background.drawing=on \
    background.border_color=0xffaaaaaa \
    background.border_width=1 \
    background.corner_radius=5 \
    icon.color=0xffffffff \
    label.color=0xffffffff
else
  # Inaktiver Workspace — transparent
  /opt/homebrew/bin/sketchybar --set space.$1 \
    background.color=0x00000000 \
    background.drawing=off \
    background.border_width=0 \
    icon.color=0xffaaaaaa \
    label.color=0xffaaaaaa
fi
