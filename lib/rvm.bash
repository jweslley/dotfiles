#!/bin/sh
# Loads RVM into shell.

export rvm_trust_rvmrcs_flag=1

if [[ -s ~/.rvm/scripts/rvm ]]; then
  source ~/.rvm/scripts/rvm
  source ~/.rvm/scripts/completion
  rvm reload
fi

rvmit(){
  current=$(rvm-prompt)
  test -z "$current" && echo "You are not using RVM: type 'rvm ruby-1.x.y'" && exit 42
  ruby=${current%@*}
  project_name=$(basename `pwd`)
  echo "rvm $ruby@$project_name --create" > .rvmrc && cat .rvmrc
}

alias rubies='rvm list'
alias gemd='rvm gemset gemdir'
alias gemss='rvm gemset list'

alias gems='gem list'
alias gemi='gem install'
alias gemu='gem uninstall'
alias gemg='gem list | grep'

alias be='bundle exec'
alias rails='bundle exec rails'
alias rake='bundle exec rake'
