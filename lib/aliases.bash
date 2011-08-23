# Aliases

alias aliases='$PAGER $DOTFILES/lib/aliases.bash'

alias sl=ls
alias l='ls -CF'
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

alias apt-show='apt-cache show'
alias apt-search='apt-cache search'
alias apt-install='sudo apt-get install'
alias apt-remove='sudo apt-get remove'
alias apt-installed='dpkg --get-selections'

alias encrypt='gpg -ac --no-options $1'  # Encrypt text data.
alias bencrypt='gpg -c --no-options $1' # Encrypt binary data. jpegs/gifs/vobs/etc.
alias decrypt='gpg --no-options $1'

alias tarc='tar -czvf $1 $2' # create a tarball
alias tarx='tar -xzvf $1' # extract a tarball
alias tarl='tar -tzf $1' # ls a tarball

alias now="date +'%Y%m%d%H%M%S'"
alias today="date +'%Y%m%d'"
alias tomorrow="date -d tomorrow +'%Y%m%d'"
alias yesterday="date -d yesterday +'%Y%m%d'"

alias v='vi'
alias o='gnome-open'
alias pcat='pygmentize -g'
alias git='git-achievements'
alias eclipse='sh -c "export GDK_NATIVE_WINDOWS=1; /usr/local/eclipse/eclipse"'
alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# python development
alias pyregister='python setup.py register'
alias pyupload='python setup.py sdist upload'

# gae development
alias gae-server='/usr/local/google_appengine/dev_appserver.py .'
alias gae-update='/usr/local/google_appengine/appcfg.py --email=jonhnnyweslley@gmail.com update .'
alias gae-cron='/usr/local/google_appengine/appcfg.py --email=jonhnnyweslley@gmail.com update_cron .'
alias gae-indexes='/usr/local/google_appengine/appcfg.py --email=jonhnnyweslley@gmail.com update_indexes .'

# text file conversion
alias dos2unix='recode dos/CR-LF..l1'
alias unix2win='recode l1..windows-1250'
alias unix2dos='recode l1..dos/CR-LF'
