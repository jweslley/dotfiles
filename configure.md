## link my configuration files

```sh
find ~/.dotfiles/ -maxdepth 1 -name ".*"        \
  ! -path ~/.dotfiles/ ! -path ~/.dotfiles/.git \
  -exec ln -sf {} $HOME \;
```

## manual

- brew
- chrome
- docker
- ohmyzsh
- slack
- twingate

## brew

```sh
brew install    \
  1password-cli \
  asdf          \
  awscli        \
  fzf           \
  git-extras    \
  gpg           \
  kubectl       \
  neovim        \
  p7zip         \
  ripgrep       \
  sops          \
  syncthing     \
  tmux          \
  universal-ctags
```

## brew cask

```sh
brew install --cask \
  1password         \
  dbeaver-community \
  iterm2            \
  logseq            \
  spotify           \
  visual-studio-code 
```

## asdf

```sh
asdf plugin-add ruby
asdf plugin-add nodejs
asdf plugin-add golang
asdf plugin-add trdsql
asdf plugin-add yarn
asdf plugin-add bat
asdf plugin-add delta
asdf plugin-add gohugo https://bitbucket.org/mgladdish/asdf-gohugo
```
