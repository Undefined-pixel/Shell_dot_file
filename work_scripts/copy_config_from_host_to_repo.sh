#!/bin/bash

set -xe

#reminder
# --delete → Löscht Dateien im Ziel, die im Quellverzeichnis nicht mehr existieren (perfekt für Spiegelungen)

# --dry-run prüfen ob es geht
#-a → Archivmodus (kopiert rekursiv und bewahrt Rechte, Zeiten, Symlinks usw.)
#-v → Verbose (zeigt, was passiert)

rsync -av $HOME/.config/.myshellconfig.sh $HOME/repo/Shell_dot_file/linux/.config/.myshellconfig.sh
rsync -av --delete $HOME/.config/fastfetch/ $HOME/repo/Shell_dot_file/linux/.config/fastfetch/
rsync -av --delete $HOME/.config/nvim/ $HOME/repo/Shell_dot_file/linux/.config/nvim/
rsync -av --delete $HOME/.config/kitty/ $HOME/repo/Shell_dot_file/linux/.config/kitty/
rsync -av --delete $HOME/.config/wezterm/ $HOME/repo/Shell_dot_file/linux/.config/wezterm/
rsync -av --delete $HOME/.config/i3/ $HOME/repo/Shell_dot_file/linux/.config/i3/
rsync -av --delete $HOME/.config/tmux/ $HOME/repo/Shell_dot_file/linux/.config/tmux/

OS=$(uname)
if [[ "$OS" == "Darwin" ]]; then
  rsync -av $HOME/.config/zed/settings.json $HOME/repo/Shell_dot_file/mac/.config/zed/settings.json
  rsync -av $HOME/.config/zed/keymap.json $HOME/repo/Shell_dot_file/mac/.config/zed/keymap.json
  rsync -av --delete $HOME/.config/sketchybar/ $HOME/repo/Shell_dot_file/mac/.config/sketchybar/
  rsync -av --delete $HOME/.config/borders/ $HOME/repo/Shell_dot_file/mac/.config/borders/
  rsync -av $HOME/.aerospace.toml $HOME/repo/Shell_dot_file/mac/.aerospace.toml
else
  rsync -av $HOME/.config/zed/settings.json $HOME/repo/Shell_dot_file/linux/.config/zed/settings.json
  rsync -av $HOME/.config/zed/keymap.json $HOME/repo/Shell_dot_file/linux/.config/zed/keymap.json
fi
