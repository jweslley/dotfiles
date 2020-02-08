#!/bin/sh

# ruby development

alias b='docker-compose run --rm web bundle'
alias be='docker-compose run --rm web bundle exec'
alias rails='docker-compose run --rm web bundle exec rails'
alias webi='docker-compose run --rm web bin/setup'   # web Install
alias webu='docker-compose run --rm web bin/update'  # web Update
alias webx='docker-compose run --rm web' # web eXecute
alias webr='docker-compose run --rm web bundle exec rails restart'
alias webc='docker-compose run --rm web bundle exec rails console'

