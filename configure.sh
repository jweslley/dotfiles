#!/bin/sh

# remove default files
find ~ -maxdepth 1 -type f -name ".*" -exec rm {} \;

# link my configuration files
find ~/.dotfiles/ -maxdepth 1 -name ".*"        \
  ! -path ~/.dotfiles/ ! -path ~/.dotfiles/.git \
  -exec ln -sf {} --target-directory=$HOME \;

# create basic directories
mkdir ~/{bin,code,docs,downloads,musics,videos,images,tools,.config}

# config
ln -s ~/.dotfiles/etc/{locale,youtube-dl}.conf ~/.config/

# vim plugins
mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

# awesome-config
git clone git://github.com/jweslley/awesome-config ~/.config/awesome
