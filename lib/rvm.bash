#!/bin/sh

# Loads RVM into shell.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" && rvm system

# RVM bash completion complete
[[ -r $rvm_path/scripts/completion ]] && source $rvm_path/scripts/completion
