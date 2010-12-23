#!/bin/sh

cd ~/.dotfiles

# link my configuration files
for f in `find -maxdepth 1 -type f -name ".*"` ; do
  ln -s `pwd`/$f ~/$f
done
ln -s `pwd`/.vim ~/.vim

# sudo update-alternatives --install /usr/lib/mozilla/plugins/mozilla-javaplugin.so mozilla-javaplugin.so /usr/lib/jvm/java-6-sun/jre/lib/i386/libnpjp2.so 1


# Backup files into Dropbox

if [ -d "$HOME/Dropbox" ]; then
  ln -s "$HOME/.local/share/TpLogger/logs/" "$HOME/Dropbox/Empathy"
  ln -s "$HOME/.git-achievements.log" "$HOME/Dropbox/.git-achievements.log"
  ln -s "$HOME/.git-achievements-action.log" "$HOME/Dropbox/.git-achievements-action.log"
else
  echo "Install Dropbox client"
  exit 1
fi

# download all cheat sheets
for sheet in `cheat sheets`;do
  echo "downloading $sheet ..."
  cheat $sheet > /dev/null
done
