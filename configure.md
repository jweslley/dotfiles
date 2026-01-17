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
- ohmyzsh
- slack
- twingate
- [voiceink](https://tryvoiceink.com/?atp=y7Qj6t)
- [tailscale](https://pkgs.tailscale.com/stable/#macos)

## brew

```sh
brew install      \
  1password-cli   \
  awscli          \
  bash            \
  colima          \
  cspell          \
  difftastic      \
  docker          \
  docker-compose  \
  fzf             \
  gawk            \
  git-extras      \
  gpg             \
  kubectl         \
  languagetool-rust \
  mise            \
  neovim          \
  p7zip           \
  ripgrep         \
  sops            \
  tmux            \
  universal-ctags
```

## brew cask

```sh
brew install --cask  \
  1password          \
  dbeaver-community  \
  font-sauce-code-pro-nerd-font \
  imageoptim         \
  logseq             \
  netnewswire        \
  spotify            \
  visual-studio-code \
  wezterm
```
