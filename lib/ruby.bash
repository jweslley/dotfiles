#!/bin/sh

# ruby development

alias b='docker-compose run --rm web bundle'
alias be='docker-compose run --rm web bundle exec'
alias rails='docker-compose run --rm web bundle exec rails'
alias webs='docker-compose run --rm web bin/setup' # web Setup
alias webx='docker-compose run --rm web'           # web eXecute

