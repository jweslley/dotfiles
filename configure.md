## link my configuration files

```sh
find ~/.dotfiles/ -maxdepth 1 -name ".*"        \
  ! -path ~/.dotfiles/ ! -path ~/.dotfiles/.git \
  -exec ln -sf {} $HOME \;
```

```sh
ln -s $HOME/.dotfiles/nvim $HOME/.config/nvim
mkdir -p ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## manual

- brew
- chrome
- docker
- ohmyzsh
- slack
- twingate
- [download](https://www.nerdfonts.com/font-downloads) and install font 'Sauce Code Pro'

## brew

```sh
brew install      \
  1password-cli   \
  asdf            \
  awscli          \
  bash            \
  fzf             \
  git-extras      \
  gawk            \
  gpg             \
  kubectl         \
  neovim          \
  p7zip           \
  ripgrep         \
  sops            \
  syncthing       \
  tmux            \
  universal-ctags
```

## brew cask

```sh
brew install --cask  \
  1password          \
  dbeaver-community  \
  logseq             \
  spotify            \
  visual-studio-code \
  wezterm
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
