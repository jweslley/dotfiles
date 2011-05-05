#!/bin/sh

cd ~/.dotfiles

# link my configuration files
for f in `find -maxdepth 1 -type f -name ".*"` ; do
  ln -s `pwd`/$f ~/$f
done
ln -s `pwd`/.vim ~/.vim


# Backup files into Dropbox

if [ -d "$HOME/Dropbox" ]; then
  ln -s "$HOME/Dropbox/Empathy" "$HOME/.local/share/TpLogger/logs"
  ln -s "$HOME/Dropbox/.git-achievements.log" "$HOME/.git-achievements.log"
  ln -s "$HOME/Dropbox/.git-achievements-action.log" "$HOME/.git-achievements-action.log"
else
  echo "Install Dropbox client"
  exit 1
fi

# download all cheat sheets
for sheet in `cheat sheets`;do
  echo "downloading $sheet ..."
  cheat $sheet > /dev/null
done
