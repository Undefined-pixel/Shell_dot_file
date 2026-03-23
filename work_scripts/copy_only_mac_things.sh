#!/bin/sh

set -xe
rsync -av $HOME/.config/sketchybar $HOME/repo/Shell_dot_file/mac/.config/sketchybar/
rsync -av $HOME/.config/borders/ $HOME/repo/Shell_dot_file/mac/.config/borders/
