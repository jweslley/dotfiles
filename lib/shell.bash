# shell behavior
# http://wiki.bash-hackers.org/internals/shell_options

#set -o vi

shopt -s autocd
shopt -s cdspell
shopt -s checkhash
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s no_empty_cmd_completion
shopt -u huponexit # make sure backgrounded jobs don't get killed when the parent shell exits

# Don't check mail when opening terminal
shopt -u mailwarn
unset MAILCHECK

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
