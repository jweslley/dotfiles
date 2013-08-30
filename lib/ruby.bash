#!/bin/sh

# ruby development

alias b='bundle'
alias be='bundle exec'

export PATH=~/.rbenv/bin:$PATH

eval "$(rbenv init -)"

# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
