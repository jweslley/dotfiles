#!/bin/sh

# link my configuration files
find ~/.dotfiles/ -maxdepth 1 -name ".*"        \
  ! -path ~/.dotfiles/ ! -path ~/.dotfiles/.git \
  -exec ln -sf {} --target-directory=$HOME \;

# create basic directories
mkdir ~/{bin,code,docs,musics,videos,images,tools}

# youtube-dl config
mkdir -p ~/.config
ln -s ~/.dotfiles/etc/youtube-dl.conf ~/.config/
