#!/bin/sh

# ruby development

alias b='docker-compose run --rm web bundle'
alias be='docker-compose run --rm web bundle exec'
alias bundle='docker-compose run --rm web bundle'
alias rails='docker-compose run --rm web bundle exec rails'
alias webs='docker-compose run --rm web bin/setup' # web Setup
alias webx='docker-compose run --rm web'           # web eXecute
alias websh='docker-compose run --rm web /bin/sh'

alias t='docker-compose run --rm web bundle exec rspec'
alias tx='docker-compose run --rm web bundle exec rspec -n'
alias tn='git number -"docker-compose run --rm web bundle exec rspec"'
