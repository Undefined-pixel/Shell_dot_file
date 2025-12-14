#!/bin/sh

rsync -av $HOME/repo/Shell_dot_file/linux/.config/.myshellconfig.sh $HOME/repo/Shell_dot_file/mac/.config/.myshellconfig.sh
rsync -av $HOME/repo/Shell_dot_file/linux/.config/fastfetch/ $HOME/repo/Shell_dot_file/mac/.config/fastfetch/
rsync -av $HOME/repo/Shell_dot_file/linux/.config/zed/ $HOME/repo/Shell_dot_file/mac/.config/zed/
rsync -av $HOME/repo/Shell_dot_file/linux/.config/kitty/ $HOME/repo/Shell_dot_file/mac/.config/kitty/
rsync -av $HOME/repo/Shell_dot_file/linux/.config/nvim/ $HOME/repo/Shell_dot_file/mac/.config/nvim/
