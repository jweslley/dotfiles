#!/bin/sh

# link my configuration files
find ~/.dotfiles/ -maxdepth 1 -name ".*"        \
  ! -path ~/.dotfiles/ ! -path ~/.dotfiles/.git \
  -exec echo ln -sf {} --target-directory=$HOME \;

# solarized?!
# https://gist.github.com/943715
# https://github.com/ghuntley/terminator-solarized
# https://github.com/sigurdga/gnome-terminal-colors-solarized
# https://github.com/seebi/dircolors-solarized
