# terminal behavior

# Change the window title of X terminals
case "$TERM" in
xterm*|rxvt*)
  PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
  ;;
*)
  ;;
esac

# Do not set PS1 for dumb terminals
if [ "$TERM" != 'dumb' ] && [ -n "$BASH" ]; then
  PS1='$>'
fi

# Don't check mail when opening terminal
unset MAILCHECK
