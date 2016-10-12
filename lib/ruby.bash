#!/bin/sh

# ruby development

alias b='bundle'
alias be='bundle exec'
alias dbe='docker-compose run web bundle exec'

export PATH=~/.rbenv/bin:$PATH

eval "$(rbenv init -)"
