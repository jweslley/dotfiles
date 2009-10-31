#!/bin/bash
#===============================================================================
# User
#===============================================================================

# look and feel
apt-get install compizconfig-settings-manager emerald fusion-icon

# media
apt-get install flashplugin-installer
apt-get install gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad gstreamer0.10-ffmpeg

# desktop
apt-get install tomboy gnome-do stellarium lyx abntex

# statistics
apt-get install gnuplot octave3.2 r-recommended


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
