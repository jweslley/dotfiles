#!/bin/sh

cd ~/.dotfiles

# link my configuration files
for f in `find -maxdepth 1 -type f -name ".*"` ; do
  ln -s `pwd`/$f ~/$f
done
ln -s `pwd`/.vim ~/.vim


# Backup files into Dropbox

if [ -d "$HOME/Dropbox" ]; then
  ln -s "$HOME/Dropbox/data/Empathy" "$HOME/.local/share/TpLogger/logs"
else
  echo "Install Dropbox client"
  exit 1
fi
