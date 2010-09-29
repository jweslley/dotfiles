# Jonhnny Weslley's configuration shiznit that makes him productive

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

CDPATH=.:~:/data:/data/workspace:/usr/local
DOTFILES="$HOME/.dotfiles"

#-----------------------------------------------------------------------------
# PATH
#-----------------------------------------------------------------------------
JAVA_HOME=/usr
M2_HOME=/usr/local/maven
SCALA_HOME=/usr/local/scala
RUBY_GEMS=/var/lib/gems/1.8/
PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin:$SCALA_HOME/bin:$RUBY_GEMS/bin:$DOTFILES/bin:$DOTFILES/apps/git-achievements:/usr/local/sbt
export PATH JAVA_HOME
export PYTHONPATH=/usr/local/lib/python:$PYTHONPATH

LS_COLORS="$LS_COLORS*.scala=01;31"
export LS_COLORS


#-----------------------------------------------------------------------------
# Terminal behavior
#-----------------------------------------------------------------------------

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

if [ "$TERM" != "dumb" ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
fi


#-----------------------------------------------------------------------------
# Optional shell behavior
#-----------------------------------------------------------------------------

shopt -s cdspell
shopt -s extglob
shopt -s checkwinsize
 
export PAGER="less"
export EDITOR="vi"

export LESS="-R -M"
export LESSOPEN="|pygmentize -g %s"

#-----------------------------------------------------------------------------
# History
#-----------------------------------------------------------------------------

shopt -s histappend
export HISTIGNORE="&:pwd:ls:ll:la"
export HISTFILESIZE=10000 # the bash history should save 10K commands
export HISTCONTROL=erasedups  # don't put duplicate lines in the history.
#export HISTTIMEFORMAT='%F %T ' # display timestamp


#-----------------------------------------------------------------------------
# Alias definitions.
#-----------------------------------------------------------------------------

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi


#-----------------------------------------------------------------------------
# Machine-specific definitions.
#-----------------------------------------------------------------------------

if [ -f ~/.bash_local ]; then
  . ~/.bash_local
fi


#-----------------------------------------------------------------------------
# Bash Completion, if available
#-----------------------------------------------------------------------------

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
  bind "set completion-ignore-case on"
fi

pwd
