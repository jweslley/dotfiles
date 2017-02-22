#!/bin/sh

# ruby development

alias b='bundle'
alias be='bundle exec'
alias webi='docker-compose run web bin/setup'   # web Install
alias webu='docker-compose run web bin/update'  # web Update
alias webx='docker-compose run web bundle exec' # web eXecute
alias webr='docker-compose run web bundle exec rails restart'
alias webc='docker-compose run web bundle exec rails console'

export PATH=~/.rbenv/bin:$PATH

eval "$(rbenv init -)"
