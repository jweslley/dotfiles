#!/bin/sh

# backup default files
find ~ -maxdepth 1 -type f -name ".*" -exec mv {} {}.bak \;

# link my configuration files
find ~/.dotfiles/ -maxdepth 1 -name ".*"        \
  ! -path ~/.dotfiles/ ! -path ~/.dotfiles/.git \
  -exec ln -sf {} --target-directory=$HOME \;

# create basic directories
mkdir ~/{bin,code,docs,downloads,musics,videos,images,tools,.config}

# config
ln -s ~/.dotfiles/etc/{locale,youtube-dl}.conf ~/.config/

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
pushd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
popd

# awesome-config
git clone git://github.com/jweslley/awesome-config ~/.config/awesome
