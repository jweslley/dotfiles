# Load Bash Completion, if available

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
  bind "set completion-ignore-case on"
fi

# complete aliases
# git
complete -o default -o nospace -F _git g

# bundle
complete -o default -F _bundle b
complete -o default -F _bundle_exec be
