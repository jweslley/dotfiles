
function __git_dirty {
  test -z "$(git commit --dry-run --short 2>/dev/null)" || echo "*"
}

function __git_branch {
  __git_ps1 "(%s)"
}

function __rvm_ruby_version {
  [ -f 'Gemfile' ] && echo "$(rvm-prompt) "
}

function __rvm_ruby_version_with_gemfile_detector {
  local gemfile_path=""
  local current_dir="$PWD"
  while [[ -z "$gemfile_path" && $current_dir != '/' ]] ; do
    if [ -f "$current_dir/Gemfile" ] ; then
      gemfile_path="$current_dir"
    else
      current_dir=$(dirname $current_dir)
    fi
  done
  [ -z "$gemfile_path" ] || echo "$(rvm-prompt) $bblue$(basename $gemfile_path) "
}

# the prompt
PS1="$bred\$(__rvm_ruby_version)$byellow\$(__git_branch)$red\$(__git_dirty)$reset_color$ "

# Change the window title of X terminals
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
