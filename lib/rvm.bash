#!/bin/sh
# Loads RVM into shell.
if [[ -s ~/.rvm/scripts/rvm ]]; then
  source ~/.rvm/scripts/rvm
  source ~/.rvm/scripts/completion
  rvm reload
fi
