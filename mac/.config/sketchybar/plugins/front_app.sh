#!/bin/sh

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

if [ "$SENDER" = "front_app_switched" ]; then
  app=$(/opt/homebrew/bin/aerospace list-windows --workspace focused --format "%{app-name}" | head -1)
  if [ -z "$app" ] || [ "$app" = "" ]; then
    app="Desktop"
  fi
  /opt/homebrew/bin/sketchybar --set "$NAME" label="$app"
fi
