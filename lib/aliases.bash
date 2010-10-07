# Aliases

alias sl=ls
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

alias search='apt-cache search'
alias apt-install='sudo apt-get install'

alias encrypt='gpg -ac --no-options $1'
alias decrypt='gpg --no-options $1'

alias tarc='tar -czvf $1 $2' # create a tarball
alias tarx='tar -xzvf $1' # extract a tarball
alias tarl='tar -tzf $1' # ls a tarball

alias c='clear'
alias v='vi .'
alias pcat='pygmentize -g'
alias git='git-achievements'
alias glog="git log --pretty=oneline --topo-order --graph --abbrev-commit"
alias eclipse='sh -c "export GDK_NATIVE_WINDOWS=1; /usr/local/eclipse/eclipse"'
alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'

# text file conversion
alias dos2unix='recode dos/CR-LF..l1'
alias unix2win='recode l1..windows-1250'
alias unix2dos='recode l1..dos/CR-LF'
