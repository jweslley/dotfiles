#!/bin/sh

cd ~/.dotfiles

# link my configuration files
for f in `find -type f -name ".*"` ; do
  ln -s `pwd`/$f ~/$f
done
ln -s `pwd`/.vim ~/.vim

# install gedit tools
for f in `ls gedit-tools/` ; do
  ln -s `pwd`/gedit-tools/$f ~/.gnome2/gedit/tools/$f
done

# install my scripts under bin directory
for f in `ls bin/` ; do
  ln -s `pwd`/bin/$f /usr/local/bin/$f
done

rails-footnotes-linux-configure

# sudo update-alternatives --install /usr/lib/mozilla/plugins/mozilla-javaplugin.so mozilla-javaplugin.so /usr/lib/jvm/java-6-sun/jre/lib/i386/libnpjp2.so 1
