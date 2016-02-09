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
pacman --noconfirm -S awesome vicious faenza-icon-theme

# toolbox
pacman --noconfirm -S rxvt-unicode openssh git mercurial bash-completion ttf-ubuntu-font-family net-tools ctags xclip unrar unzip pwgen lesspipe ack youtube-dl dosfstools colordiff rtorrent sudo tmux htop vim gdb cgdb
# vim+python => https://gist.github.com/MicahElliott/3048622

# media
pacman --noconfirm -S vlc pulseaudio-alsa pulseaudio
pacman --noconfirm -S gstreamer0.10-base-plugins gstreamer0.10-good-plugins gstreamer0.10-bad-plugins gstreamer0.10-ugly-plugins gstreamer0.10-ffmpeg

# desktop
pacman --noconfirm -S firefox chromium mirage scrot calibre icedtea-web flashplugin gtk-chtheme oxygen-gtk2 simplescreenrecorder tuxguitar

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

# Latex
pacman --noconfirm -S texlive-core texlive-latexextra

# R
pacman --noconfirm -S r

# yaourt
curl -O https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
tar zxvf package-query.tar.gz
cd package-query
makepkg -si
cd ..
curl -O https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
tar zxvf yaourt.tar.gz
cd yaourt
makepkg -si
cd ..

yaourt -S chromium-pepper-flash
yaourt -S dropbox
yaourt -S telegram-git
yaourt -S abntex2
yaourt -S pandoc-bin

