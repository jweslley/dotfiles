#!/bin/sh
# Loads RVM into shell.

export rvm_trust_rvmrcs_flag=1

if [[ -s ~/.rvm/scripts/rvm ]]; then
  source ~/.rvm/scripts/rvm
  source ~/.rvm/scripts/completion
  rvm reload
fi
