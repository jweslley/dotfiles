# prompt decorators

GIT_DIRTY='$(test -z "$(git commit --dry-run --short 2>/dev/null)" || echo "*")'
GIT_BRANCH='$(__git_ps1 "(%s)")'
RVM_RUBY_VERSION='$([[ -f "Rakefile" && ! -z `which rvm-prompt` ]] && echo "$(rvm-prompt) ")'
STATUS_COLOR='$([[ $RET = 0 ]] && echo -ne "\[$color_off\]" || echo -ne "\[$bred\]")'
PROMPT_CLOCK="\[\033[s\]\[\033[1;\$((COLUMNS-4))f\]\$(date +%H:%M)\[\033[u\]"

# the prompt
PS1="\[$bred\]$RVM_RUBY_VERSION\[$bgreen\]\W\[$byellow\]$GIT_BRANCH\[$red\]$GIT_DIRTY$STATUS_COLOR$\[$color_off\] "

# the window title of X terminals
PROMPT_COMMAND='RET=$?;echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~} $(__git_branch) \007"'
