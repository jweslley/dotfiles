#!/bin/sh

# backup default files
find ~ -maxdepth 1 -type f -name ".*" -exec mv {} {}.bak \;

# link my configuration files
find ~/.dotfiles/ -maxdepth 1 -name ".*"        \
  ! -path ~/.dotfiles/ ! -path ~/.dotfiles/.git \
  -exec ln -sf {} --target-directory=$HOME \;

# create basic directories
mkdir ~/{bin,code,docs,downloads,musics,videos,images,tools,.config}

# config
ln -s ~/.dotfiles/etc/{locale,youtube-dl}.conf ~/.config/

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
pushd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
popd

# asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby
# asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs
# asdf plugin-add golang https://github.com/kennyp/asdf-golang
# asdf plugin-add gohugo https://bitbucket.org/mgladdish/asdf-gohugo
# asdf plugin-add trdsql https://github.com/johnlayton/asdf-trdsql

# awesome-config
git clone git://github.com/jweslley/awesome-config ~/.config/awesome

# git-extras
mkdir ~/.dotfiles/apps
git clone https://github.com/tj/git-extras ~/.dotfiles/apps/git-extras

# tmux
mkdir ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
