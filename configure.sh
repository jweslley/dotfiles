#!/bin/sh

# link my configuration files
find ~/.dotfiles/ -maxdepth 1 -name ".*"        \
  ! -path ~/.dotfiles/ ! -path ~/.dotfiles/.git \
  -exec ln -sf {} --target-directory=$HOME \;

# youtube-dl config
ln -s ~/.dotfiles/etc/youtube-dl.conf ~/.config/

# Install rbenv
curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
rbenv bootstrap-ubuntu-12-04
rbenv install 1.9.3-p286
rbenv global 1.9.3-p286
rbenv bootstrap

# dotjs
crontab -e
@reboot ~/.dotfiles/bin/djsd -d


# Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
