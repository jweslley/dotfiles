#!/bin/sh

cd ~/.dotfiles

# link my configuration files
for f in `find -maxdepth 1 -type f -name ".*"` ; do
  ln -s `pwd`/$f ~/$f
done
ln -s `pwd`/.vim ~/.vim
