#!/bin/bash
#===============================================================================
# User
#===============================================================================

# look and feel
apt-get install compizconfig-settings-manager emerald fusion-icon

# screensaver
apt-get install electricsheep

# media
#apt-get install flashplugin-installer
apt-get install mozilla-plugin-gnash # flash player
apt-get install vlc gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad gstreamer0.10-ffmpeg
# apt-get install xine-ui mplayer mencoder gstreamer0.10-plugins-good

# dvd playback
apt-get install libdvdread4
/usr/share/doc/libdvdread4/install-css.sh

# install adiumxtra support
chmod +x /usr/local/bin/adiumxtra-install
gconftool-2 -t string -s /desktop/gnome/url-handlers/adiumxtra/command "/usr/local/bin/adiumxtra-install %s"
gconftool-2 -t bool -s /desktop/gnome/url-handlers/adiumxtra/enabled true
gconftool-2 -t bool -s /desktop/gnome/url-handlers/adiumxtra/needs_terminal false

# desktop
apt-get install tomboy gnome-do stellarium lyx abntex

# games
apt-get install fretsonfire nexuiz

# learning
apt-get install gbrainy gnaural mnemosyne anki 

# statistics
apt-get install gnuplot octave3.2 r-recommended revolution-r r-cran-car

# compression
apt-get install unace rar unrar zip unzip p7zip-full p7zip-rar sharutils aish uudeview mpack lha arj cabextract file-roller zoo lzop

#===============================================================================
# Development
#===============================================================================

# git
apt-get install git git-core git-doc git-svn gitk

# shell
apt-get install ack-grep xclip terminator htop

# vim
apt-get install vim vim-doc vim-scripts ctags gedit-plugins

# project management
apt-get install planner dia

# git-sh: A customized bash environment suitable for git work.
# URL: http://github.com/rtomayko/git-sh

# tagfs: Fuse tag file system edit
# URL: http://github.com/marook/tagfs

# install my scripts under bin directory
cp bin/* /usr/local/bin
