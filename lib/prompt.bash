
function __git_dirty {
  test -z "$(git commit --dry-run --short 2>/dev/null)" || echo "*"
}

function __git_branch {
  __git_ps1 "(%s)"
}

function __rvm_ruby_version {
  [ -f 'Gemfile' ] && echo "$(rvm-prompt) "
}

# the prompt
PS1="$bred\$(__rvm_ruby_version)$byellow\$(__git_branch)$red\$(__git_dirty)$reset_color$ "

# Change the window title of X terminals
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
