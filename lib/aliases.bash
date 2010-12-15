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
alias cdw='cd ~/workspace'
alias cdr='cd ~/.m2/repository'

alias search='apt-cache search'
alias apt-install='sudo apt-get install'

alias encrypt='gpg -ac --no-options $1'
alias decrypt='gpg --no-options $1'

alias tarc='tar -czvf $1 $2' # create a tarball
alias tarx='tar -xzvf $1' # extract a tarball
alias tarl='tar -tzf $1' # ls a tarball

alias now="date +'%Y%m%d%H%M%S'"
alias today="date +'%Y%m%d'"
alias tomorrow="date -d tomorrow +'%Y%m%d'"
alias yesterday="date -d yesterday +'%Y%m%d'"

alias v='vi .'
alias p='less'
alias pcat='pygmentize -g'
alias git='git-achievements'
alias eclipse='sh -c "export GDK_NATIVE_WINDOWS=1; /usr/local/eclipse/eclipse"'
alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'

# python development
alias pyupload='python setup.py sdist upload'

# text file conversion
alias dos2unix='recode dos/CR-LF..l1'
alias unix2win='recode l1..windows-1250'
alias unix2dos='recode l1..dos/CR-LF'
