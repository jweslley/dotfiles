# Load Bash Completion, if available

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
  bind "set completion-ignore-case on"
fi
