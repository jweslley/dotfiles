#!/bin/sh

cd ~/.dotfiles

# link my configuration files
for f in `find -type f -name ".*"` ; do
  ln -s `pwd`/$f ~/$f
done
ln -s `pwd`/.vim ~/.vim

# install my scripts under bin directory
for f in `ls bin/` ; do
  ln -s `pwd`/bin/$f /usr/local/bin/$f
done
