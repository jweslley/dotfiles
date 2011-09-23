# shell behavior

shopt -s cdspell
shopt -s extglob
shopt -s checkwinsize

export EDITOR="vi"
export PAGER="less"
export LESS="-R -M"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

GREP_OPTIONS="--exclude-dir=\.svn --exclude-dir=log --exclude-dir=\.git"
export GREP_OPTIONS

# Don't check mail when opening terminal
unset MAILCHECK
