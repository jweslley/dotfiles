# History

shopt -s histappend
export HISTIGNORE="&:pwd:ls:ll:la"
export HISTFILESIZE=10000 # the bash history should save 10K commands
export HISTCONTROL=erasedups  # don't put duplicate lines in the history.
#export HISTTIMEFORMAT='%F %T ' # display timestamp
