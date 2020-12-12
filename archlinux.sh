#!/bin/sh

# Xorg
pacman --noconfirm -S xorg-server xorg-server-utils xorg-apps xorg-xinit xscreensaver

pacman --noconfirm -S xf86-video-fbdev xf86-video-modesetting
# pacman --noconfirm -S xf86-video-DRIVER (lspci | grep -e VGA)
# pacman --noconfirm -S mesa
# pacman --noconfirm -S xf86-video-vesa

# notebook
# pacman --noconfirm -S xf86-input-synaptics laptop-mode-tools

# window manager
pacman --noconfirm -S awesome

# toolbox
pacman --noconfirm -S rxvt-unicode openssh git bash-completion ttf-ubuntu-font-family net-tools ctags xsel unrar unzip lesspipe ripgrep youtube-dl dosfstools colordiff sudo tmux htop vim gdb cgdb fzf jq

# media
pacman --noconfirm -S vlc pulseaudio-alsa pulseaudio
pacman --noconfirm -S gstreamer0.10-base-plugins gstreamer0.10-good-plugins gstreamer0.10-bad-plugins gstreamer0.10-ugly-plugins gstreamer0.10-ffmpeg

# desktop
pacman --noconfirm -S firefox chromium scrot simplescreenrecorder

# containers
pacman --noconfirm -S docker docker-compose

# virtualization host
# pacman --noconfirm -S virtualbox virtualbox-host-dkms

# virtualization guest
# pacman --noconfirm -S virtualbox-guest-modules virtualbox-guest-utils
# modprobe -a vboxguest vboxsf vboxvideo
# echo vboxguest >> /etc/modules-load.d/virtualbox.conf
# echo vboxsf >> /etc/modules-load.d/virtualbox.conf
# echo vboxvideo >> /etc/modules-load.d/virtualbox.conf

# Users
useradd -m -g users -G wheel,storage,power -s /bin/bash jweslley
passwd jweslley
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel

# R
pacman --noconfirm -S r

