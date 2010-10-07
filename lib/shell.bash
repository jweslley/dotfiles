# shell behavior

shopt -s cdspell
shopt -s extglob
shopt -s checkwinsize
 
export PAGER="less"
export EDITOR="vi"

export LESS="-R -M"
export LESSOPEN="|pygmentize -g %s"
