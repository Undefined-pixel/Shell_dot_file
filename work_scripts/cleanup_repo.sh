#!/bin/bash

# Bereinigt verschachtelte Duplikat-Ordner im Repo
# z.B. nvim/nvim/nvim/... → nur nvim/

REPO="$HOME/repo/Shell_dot_file"

for os_dir in "$REPO/mac/.config" "$REPO/linux/.config"; do
  [ -d "$os_dir" ] || continue
  for dir in "$os_dir"/*/; do
    name=$(basename "$dir")
    if [ -d "$dir$name" ]; then
      echo "Removing nested: $dir$name"
      rm -rf "$dir$name"
    fi
  done
done

echo "Repo cleanup done."
