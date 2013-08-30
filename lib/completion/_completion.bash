# Load Bash Completion, if available

if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

# complete aliases
# git
complete -o default -o nospace -F _git g

# bundle
complete -o default -F _bundle b
complete -o default -F _bundle_exec be

# tmux
complete -o default -F _tmux t
