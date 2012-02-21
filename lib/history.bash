# History

shopt -s cmdhist
shopt -s lithist
shopt -s histappend histreedit histverify

export HISTIGNORE="&:pwd:ls:sl:l:ll:la:lh:h:history"
export HISTFILESIZE=10000       # the bash history should save 10K commands
export HISTCONTROL=erasedups    # don't put duplicate lines in the history.
export HISTTIMEFORMAT='%F %T '  # display timestamp
