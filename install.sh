#!/bin/bash
#===============================================================================
# User
#===============================================================================

# look and feel
apt-get install compizconfig-settings-manager emerald fusion-icon

# media
apt-get install flashplugin-installer vlc
apt-get install gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad gstreamer0.10-ffmpeg
# apt-get install mencoder gstreamer0.10-plugins-good

# desktop
apt-get install tomboy gnome-do stellarium lyx abntex

# statistics
apt-get install gnuplot octave3.2 r-recommended

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
apt-get install vim vim-doc vim-scripts ctags

# project management
apt-get install planner dia

# git-sh: A customized bash environment suitable for git work.
# URL: http://github.com/rtomayko/git-sh

# tagfs: Fuse tag file system edit
# URL: http://github.com/marook/tagfs

# install my scripts under bin directory
cp bin/* /usr/local/bin
apt-get install xine-ui mplayer

# install adiumxtra support
chmod +x /usr/local/bin/adiumxtra-install
gconftool-2 -t string -s /desktop/gnome/url-handlers/adiumxtra/command "/usr/local/bin/adiumxtra-install %s"
gconftool-2 -t bool -s /desktop/gnome/url-handlers/adiumxtra/enabled true
gconftool-2 -t bool -s /desktop/gnome/url-handlers/adiumxtra/needs_terminal false
