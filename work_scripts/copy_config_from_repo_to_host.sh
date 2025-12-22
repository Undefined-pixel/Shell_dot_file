#!/bin/bash

rsync -av $HOME/repo/Shell_dot_file/linux/.config/zed/settings.json $HOME/.config/zed/settings.json
rsync -av $HOME/repo/Shell_dot_file/linux/.config/zed/keymap.json $HOME/.config/zed/keymap.json
rsync -av $HOME/repo/Shell_dot_file/linux/.config/.myshellconfig.sh $HOME/.config/.myshellconfig.sh
rsync -av $HOME/repo/Shell_dot_file/linux/.config/fastfetch/ $HOME/.config/fastfetch
rsync -av $HOME/repo/Shell_dot_file/linux/.config/nvim/ $HOME/.config/nvim
rsync -av $HOME/repo/Shell_dot_file/linux/.config/kitty/ $HOME/.config/kitty

OS=$(uname)
if [[ "$OS" == "Darwin" ]]; then
  rsync -av $HOME/repo/Shell_dot_file/mac/.config/sketchybar/ $HOME/.config/sketchybar
  rsync -av $HOME/repo/Shell_dot_file/mac/.config/borders/ $HOME/.config/borders

fi

ZSHRC="$HOME/.zshrc"
LINE='source ~/.config/.myshellconfig.sh'

# Create the file if it doesn't exist
if [ ! -f "$ZSHRC" ]; then
  echo "✅ $ZSHRC does not exist – creating it."
  touch "$ZSHRC"
fi

# Add the line only if it doesn't already exist
if grep -qxF "$LINE" "$ZSHRC"; then
  echo "ℹ️ Line already exists."
else
  echo "$LINE" >>"$ZSHRC"
  echo "✅ Line added to $ZSHRC"
fi
