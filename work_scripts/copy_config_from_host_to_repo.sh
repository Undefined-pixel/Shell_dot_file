#!/bin/sh

set -xe

#reminder
# --delete → Löscht Dateien im Ziel, die im Quellverzeichnis nicht mehr existieren (perfekt für Spiegelungen)

# --dry-run prüfen ob es geht
#-a → Archivmodus (kopiert rekursiv und bewahrt Rechte, Zeiten, Symlinks usw.)
#-v → Verbose (zeigt, was passiert)

rsync -av $HOME/.config/zed/settings.json $HOME/repo/Shell_dot_file/mac/.config/zed/settings.json
rsync -av $HOME/.config/zed/keymap.json $HOME/repo/Shell_dot_file/mac/.config/zed/keymap.json
rsync -av $HOME/.config/.myshellconfig.sh $HOME/repo/Shell_dot_file/linux/.config/.myshellconfig.sh
rsync -av $HOME/.config/fastfetch $HOME/repo/Shell_dot_file/linux/.config/fastfetch/
rsync -av $HOME/.config/nvim $HOME/repo/Shell_dot_file/linux/.config/nvim/

OS=$(uname)
if [[ "$OS" == "Darwin" ]]; then
  rsync -av $HOME/.config/sketchybar $HOME/repo/Shell_dot_file/mac/.config/sketchybar/
  rsync -av $HOME/.config/borders/ $HOME/repo/Shell_dot_file/mac/.config/borders/
fi
