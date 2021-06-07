#!/bin/sh

export FZF_DEFAULT_COMMAND='rg --files --follow'
export FZF_DEFAULT_OPTS='--no-height --no-reverse'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
