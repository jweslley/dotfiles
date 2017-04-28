# Aliases

alias aliases='$PAGER $DOTFILES/lib/aliases.bash'

alias rm='rm -i'

alias sl='ls'
alias la='ls -A'
alias l='ls -lhF --group-directories-first'
alias ll='ls -lahF --group-directories-first'
alias lx='ll -BX' # sort by extension
alias lz='ll -rS' # sort by size
alias lt='ll -rt' # sort by date

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
alias show='type -a'
alias psids='ps -eo euser,egroup,sid,pgid,pid,ppid,args'

alias upcase="tr '[:lower:]' '[:upper:]'"
alias downcase="tr '[:upper:]' '[:lower:]'"

alias v='vim'
alias vi='vim'
alias g='git'
alias vd='vimdiff'
alias o='xdg-open'
alias grep='grep -R'
alias webshare='python3 -m http.server 8000'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias fingerprints='ls ~/.ssh/*.pub | xargs -L 1 ssh-keygen -l -f'
alias history_ranking="sed '/^#/d' ~/.bash_history | awk '{print \$1}' | sort | uniq -c | sort -nr | head -20 | cat -n"

# pacman
alias pac="sudo /usr/bin/pacman -S"         # default action  - install one or more packages
alias pacu="sudo /usr/bin/pacman -Syu"      # '[u]pdate'    - upgrade all packages to their newest version
alias pacr="sudo /usr/bin/pacman -Rs"       # '[r]emove'    - uninstall one or more packages
alias pacs="/usr/bin/pacman -Ss"            # '[s]earch'    - search for a package using one or more keywords
alias paci="/usr/bin/pacman -Si"            # '[i]nfo'      - show information about a package
alias paclo="/usr/bin/pacman -Qdt"          # '[l]ist [o]rphans'  - list all packages which are orphaned
alias pacc="sudo /usr/bin/pacman -Scc"      # '[c]lean cache' - delete all not currently installed package files
alias paclf="/usr/bin/pacman -Ql"           # '[l]ist [f]iles'  - list all files installed by a given package
alias pacexpl="/usr/bin/pacman -D --asexp"  # 'mark as [expl]icit'  - mark one or more packages as explicitly installed
alias pacimpl="/usr/bin/pacman -D --asdep"  # 'mark as [impl]icit'  - mark one or more packages as non explicitly installed

# yaourt
alias yaourtu='sudo /usr/bin/yaourt -Syu --aur' # [u]pdate yaourt packages
alias yaourtl='yaourt -Qm'                      # [l]ist yaourt installed packages

# gpg
alias encrypt='gpg -ac --no-options $1'  # Encrypt text data.
alias bencrypt='gpg -c --no-options $1' # Encrypt binary data. jpegs/gifs/vobs/etc.
alias decrypt='gpg --no-options $1'

# sound
alias volinc='amixer sset Master 10%+'
alias voldec='amixer sset Master 10%-'

# openssl
alias token='openssl rand 64 -hex'
alias base58="openssl rand 15 -base64 | tr -d '0OIl+/'"
