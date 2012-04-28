#!/bin/sh

# link my configuration files
find ~/.dotfiles/ -maxdepth 1 -name ".*"        \
  ! -path ~/.dotfiles/ ! -path ~/.dotfiles/.git \
  -exec ln -sf {} --target-directory=$HOME \;

# Install terminator config
mkdir -p $HOME/.config/terminator
cp ~/.dotfiles/etc/terminator/config $HOME/.config/terminator

# Install rbenv
curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
rbenv bootstrap-ubuntu-11-10
rbenv install 1.9.3-p125
rbenv global 1.9.3-p125
rbenv bootstrap
