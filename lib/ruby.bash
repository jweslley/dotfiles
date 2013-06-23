#!/bin/sh

# ruby development

alias b='bundle'
alias be='bundle exec'

export PATH=$PATH:~/.rbenv/bin

eval "$(rbenv init -)"

# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
