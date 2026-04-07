#!/bin/bash

# Bereinigt verschachtelte Duplikat-Ordner in ~/.config
# z.B. kitty/kitty/kitty/... → nur kitty/

for dir in "$HOME/.config"/*/; do
  name=$(basename "$dir")
  if [ -d "$dir$name" ]; then
    echo "Removing nested: $dir$name"
    rm -rf "$dir$name"
  fi
done

echo "Config cleanup done."
