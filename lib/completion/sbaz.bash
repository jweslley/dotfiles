#!/bin/bash

_sbaz_complete() {
  local cur commands

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}

  commands='available compact help install installed keycreate keyforget keyknown keyremember keyremoteknown keyrevoke pack remove retract setuniverse setup share show showuniverse update packages upgrade'
  cur=`echo $cur | sed 's/\\\\//g'`

  COMPREPLY=($(compgen -W "${commands}" ${cur} | sed 's/\\\\//g') )
}

complete -F _sbaz_complete -o filenames sbaz
