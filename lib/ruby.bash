#!/bin/sh

# ruby development

alias gems='gem list'
alias gemi='gem install'
alias gemu='gem uninstall'
alias gemg='gem list | grep'

export PATH=$PATH:~/.rbenv/bin

eval "$(rbenv init -)"

export RUBYOPT="-r`noexec`"
