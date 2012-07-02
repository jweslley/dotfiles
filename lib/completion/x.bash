#!/bin/bash

_x_complete() {
  local cur commands

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}

  commands=`x`
  cur=`echo $cur | sed 's/\\\\//g'`

  COMPREPLY=($(compgen -W "${commands}" ${cur} | sed 's/\\\\//g') )
}

complete -o default -o nospace -F _x_complete x
