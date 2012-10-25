# Aliases

alias aliases='$PAGER $DOTFILES/lib/aliases.bash'

alias sl='ls'
alias la='ls -A'
alias l='ls -lhF --group-directories-first'
alias ll='ls -lahF --group-directories-first'

alias d='dirs -v'
alias p='popd'
alias cd='pushd'

alias 1='cd +1'
alias 2='cd +2'
alias 3='cd +3'
alias 4='cd +4'
alias 5='cd +5'

alias   _='builtin cd -'
alias  ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

alias gcd='cd "`git rev-parse --show-toplevel`"'

alias now="date +'%Y%m%d%H%M%S'"
alias today="date +'%Y%m%d'"
alias tomorrow="date -d tomorrow +'%Y%m%d'"
alias yesterday="date -d yesterday +'%Y%m%d'"

alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias h='history'
alias j='jobs -l'
alias k='kill -9'
alias du='du -kh'
alias df='df -kTh'
alias ps='ps aux'
alias show='type -a'
alias rm='rm -rfi'

alias upcase="tr '[:lower:]' '[:upper:]'"
alias downcase="tr '[:upper:]' '[:lower:]'"

alias v='vim +NERDTree'
alias g='git'
alias vd='vimdiff'
alias r='R -q --no-save'
alias o='gnome-open'
alias pcat='pygmentize -g'
alias eclipse='sh -c "export GDK_NATIVE_WINDOWS=1; /usr/local/eclipse/eclipse"'
alias webshare='python -m SimpleHTTPServer'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias fingerprints='ls ~/.ssh/*.pub | xargs -L 1 ssh-keygen -l -f'
alias history_ranking="sed '/^#/d' ~/.bash_history | awk '{print \$1}' | sort | uniq -c | sort -nr | head -20 | cat -n"

# apt
alias apt-show='apt-cache show'
alias apt-search='apt-cache search'
alias apt-install='sudo apt-get install'
alias apt-remove='sudo apt-get remove'
alias apt-installed='dpkg --get-selections'

# gpg
alias encrypt='gpg -ac --no-options $1'  # Encrypt text data.
alias bencrypt='gpg -c --no-options $1' # Encrypt binary data. jpegs/gifs/vobs/etc.
alias decrypt='gpg --no-options $1'

# generate password
alias pass-gen='openssl rand 15 -base64'

# python development
alias pyregister='python setup.py register'
alias pyupload='python setup.py sdist upload'

# gae development
alias gae-server='/usr/local/google_appengine/dev_appserver.py .'
alias gae-update='/usr/local/google_appengine/appcfg.py --email=jonhnnyweslley@gmail.com update .'
alias gae-cron='/usr/local/google_appengine/appcfg.py --email=jonhnnyweslley@gmail.com update_cron .'
alias gae-indexes='/usr/local/google_appengine/appcfg.py --email=jonhnnyweslley@gmail.com update_indexes .'
