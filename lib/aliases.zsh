# For a full list of active aliases, run `alias`.

alias j='jobs -l'
alias du='du -kh'
alias df='df -kTh'
alias show='type -a'

alias v='vim'
alias vd='vimdiff'
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

# aliases for ruby
alias b='docker-compose exec web bundle'
alias be='docker-compose exec web bundle exec'
alias bundle='docker-compose exec web bundle'
alias rails='docker-compose exec web bundle exec rails'
alias webs='docker-compose exec web bin/setup' # web Setup
alias webx='docker-compose exec web'           # web eXecute
alias websh='docker-compose exec web /bin/sh'
alias t='docker-compose exec web bundle exec rspec'
alias tx='docker-compose exec web bundle exec rspec -n'
alias tn='git number -"docker-compose exec web bundle exec rspec"'
