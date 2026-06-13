# For a full list of active aliases, run `alias`.

alias j='jobs -l'
alias du='du -kh'
alias df='df -kTh'
alias show='type -a'

alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vd='nvim -d'
alias vs='NVIM_LISTEN_ADDRESS=./.nvim.sock nvim'

alias dc='docker compose'

alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

alias path='echo -e ${PATH//:/\\n}'
alias token='openssl rand -hex 64'
alias base58="openssl rand -base64 15 | tr -d '0OIl+/'"
alias pwgen="openssl rand -base64 15 | tr -d '0OIl+/' | pbcopy"
alias todo='rg "TODO|FIXME|DOCME|TESTME"'
alias listen='sudo lsof -PiTCP -sTCP:LISTEN'

# https://docs.docker.com/reference/cli/docker/system/prune/
alias docker-clean='docker volume prune; docker rmi $(docker images -f "dangling=true" -q)'
alias docker-clean-all='docker system prune --all --volumes'
alias docker-df='docker system df'
alias docker-clean-builder-cache='docker builder prune'

# aliases for ruby
alias b='docker compose run --rm web bundle'
alias be='docker compose run --rm web bundle exec'
alias rails='docker compose run --rm web bundle exec rails'
alias websh='docker compose run --rm web /bin/sh'

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
