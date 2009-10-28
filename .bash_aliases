# Jonhnny Weslley's configuration shiznit that makes him productive

# Functions definitions.

mkdircd () {
  mkdir -p "$@" && eval cd "\"\$$#\""; 
}

pless() {
  pcat "$1" | less -R
}

extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xjf $1 ;;
      *.tar.gz) tar xzf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) unrar x $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar xf $1 ;;
      *.tbz2) tar xjf $1 ;;
      *.tgz) tar xzf $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


# Aliases

alias l='ls -F'
alias la='ls -A'
alias ll='ls -lhF'
alias lh='ls -lahF'

alias   _='cd -'
alias  ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."

alias cdata='cd /data'
alias cdd='cd ~/Desktop'
alias cdw='cd ~/workspace'
alias cdr='cd /data/research'
alias cdrepo='cd ~/.m2/repository'

alias tarc='tar -czvf $1 $2' # create a tarball
alias tarx='tar -xzvf $1' # extract a tarball
alias tarl='tar -tzf $1' # ls a tarball

alias cls='clear'
alias pcat=pygmentize
alias gping='ping www.google.com'
alias hal-enable-polling='sudo hal-disable-polling --device /dev/scd0 --enable-polling'

# text file conversion
alias dos2unix='recode dos/CR-LF..l1'
alias unix2win='recode l1..windows-1250'
alias unix2dos='recode l1..dos/CR-LF'
