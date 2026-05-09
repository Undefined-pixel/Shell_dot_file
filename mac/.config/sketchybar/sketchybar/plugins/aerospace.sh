#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

#!/usr/bin/env bash
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  # Aktiver Workspace — helles Grau, dunkler Text
  sketchybar --set space.$1 \
    background.color=0xffaaaaaa \
    background.drawing=on \
    icon.color=0xff2b2b2b \
    label.color=0xff2b2b2b
else
  # Inaktiver Workspace — transparent wie die Bar
  sketchybar --set space.$1 \
    background.color=0x00000000 \
    background.drawing=off \
    icon.color=0xffaaaaaa \
    label.color=0xffaaaaaa
fi
