# shell behavior

shopt -s cdspell
shopt -s extglob
shopt -s checkwinsize
 
export PAGER="less"
export EDITOR="vi"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
