# History

shopt -s histappend # append to the history file, don't overwrite it

export HISTIGNORE="&:pwd:ls:sl:l:ll:la:lh"
export HISTFILESIZE=10000       # the bash history should save 10K commands
export HISTCONTROL=erasedups    # don't put duplicate lines in the history.
#export HISTTIMEFORMAT='%F %T ' # display timestamp
