#!/bin/bash
#===============================================================================
# User
#===============================================================================

# internet
apt-get install desktop-webmail xchat

# media
apt-get install flashplugin-installer
apt-get install vlc gstreamer0.10-ffmpeg gstreamer0.10-fluendo-mp3 gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad

# dvd playback
apt-get install libdvdread4
/usr/share/doc/libdvdread4/install-css.sh

# desktop
apt-get install tomboy gnome-do stellarium lyx abntex graphviz

# games
apt-get install fretsonfire

# learning
apt-get install gbrainy gnaural mnemosyne anki 

# statistics
apt-get install r-recommended revolution-r r-cran-gplots r-cran-car r-cran-vcd r-cran-colorspace r-cran-latticeextra

# compression
apt-get install unace rar unrar zip unzip p7zip-full p7zip-rar sharutils aish uudeview mpack lha arj cabextract file-roller zoo lzop

#===============================================================================
# Development
#===============================================================================

# java
apt-get install openjdk-6-jdk openjdk-6-source icedtea6-plugin

# git
apt-get install git-core git-doc git-svn gitk

# shell
apt-get install ack-grep xclip terminator htop tree python-pygments openssh-server

# vim
apt-get install vim vim-doc vim-scripts ctags gedit-plugins

# project management
apt-get install dia

# git-sh: A customized bash environment suitable for git work.
# URL: http://github.com/rtomayko/git-sh

# tagfs: Fuse tag file system edit
# URL: http://github.com/marook/tagfs

# install adiumxtra support
chmod +x /usr/local/bin/adiumxtra-install
gconftool-2 -t string -s /desktop/gnome/url-handlers/adiumxtra/command "/usr/local/bin/adiumxtra-install %s"
gconftool-2 -t bool -s /desktop/gnome/url-handlers/adiumxtra/enabled true
gconftool-2 -t bool -s /desktop/gnome/url-handlers/adiumxtra/needs_terminal false
