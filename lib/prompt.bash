# prompt decorators

if [ -f /usr/share/git/completion/git-prompt.sh ]; then
  source /usr/share/git/completion/git-prompt.sh
fi

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
#GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1='$(__git_ps1 "(%s)")'

PROMPT_CLOCK="\[\033[s\]\[\033[1;\$((COLUMNS-4))f\]\$(date +%H:%M)\[\033[u\]"
STATUS_COLOR='$([[ $EXIT_CODE = 0 ]] && echo -ne "\[$color_off\]" || echo -ne "\[$bred\]")'

# the prompt
PS1="\[$green\]\W\[$yellow\]$GIT_PS1$STATUS_COLOR»\[$color_off\] "

# the window title of X terminals
PROMPT_COMMAND='EXIT_CODE=$?;echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~} \007"'
