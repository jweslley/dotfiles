#!/bin/sh

# link my configuration files
find ~/.dotfiles/ -maxdepth 1 -name ".*"        \
  ! -path ~/.dotfiles/ ! -path ~/.dotfiles/.git \
  -exec ln -sf {} --target-directory=$HOME \;

# youtube-dl config
ln -s ~/.dotfiles/etc/youtube-dl.conf ~/.config/

# dotjs
crontab -e
@reboot ~/.dotfiles/bin/djsd -d

