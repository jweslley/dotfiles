#!/bin/sh

# ruby development

alias gems='gem list'
alias gemi='gem install'
alias gemu='gem uninstall'
alias gemg='gem list | grep'

alias be='bundle exec'
alias rails='bundle exec rails'
alias rake='bundle exec rake'

export PATH=$PATH:~/.rbenv/bin

eval "$(rbenv init -)"
