# Jonhnny Weslley's configuration shiznit that makes him productive

# Functions definitions.

mkdircd () {
  mkdir -p "$@" && eval cd "\"\$$#\""; 
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

ogg2avi() {
  FILENAME=$1
  mencoder $FILENAME -o $FILENAME.avi -ovc lavc -oac lavc
}

wav2mp3() {
  FILENAME=$1
  lame --replaygain-accurate -q 0 --vbr-new -V 3  "$FILENAME" "${FILENAME%.wav}.mp3"
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
alias cdw='cd /data/workspace'
alias cdr='cd /data/research'
alias cdrepo='cd ~/.m2/repository'

alias tarc='tar -czvf $1 $2' # create a tarball
alias tarx='tar -xzvf $1' # extract a tarball
alias tarl='tar -tzf $1' # ls a tarball

alias cls='clear'
alias pcat='pygmentize -g'
alias gping='ping www.google.com'
alias glog="git log --pretty=oneline --topo-order --graph --abbrev-commit"
alias eclipse='sh -c "export GDK_NATIVE_WINDOWS=1; /usr/local/eclipse/eclipse"'

# text file conversion
alias dos2unix='recode dos/CR-LF..l1'
alias unix2win='recode l1..windows-1250'
alias unix2dos='recode l1..dos/CR-LF'
