# Colors

color_off=$'\e[0m'
reset_color=$'\e[39m'

# normal
black=$'\e[0;30m'
red=$'\e[0;31m'
green=$'\e[0;32m'
yellow=$'\e[0;33m'
blue=$'\e[0;34m'
purple=$'\e[0;35m'
cyan=$'\e[0;36m'
white=$'\e[0;37m'

# bold (prefix b)
bblack=$'\e[1;30m'
bred=$'\e[1;31m'
bgreen=$'\e[1;32m'
byellow=$'\e[1;33m'
bblue=$'\e[1;34m'
bpurple=$'\e[1;35m'
bcyan=$'\e[1;36m'
bwhite=$'\e[1;37m'

# underline (prefix u)
ublack=$'\e[4;30m'
ured=$'\e[4;31m'
ugreen=$'\e[4;32m'
uyellow=$'\e[4;33m'
ublue=$'\e[4;34m'
upurple=$'\e[4;35m'
ucyan=$'\e[4;36m'
uwhite=$'\e[4;37m'

# background (prefix bg)
bgblack=$'\e[40m'
bgred=$'\e[41m'
bggreen=$'\e[42m'
bgyellow=$'\e[43m'
bgblue=$'\e[44m'
bgpurple=$'\e[45m'
bgcyan=$'\e[46m'
bgwhite=$'\e[47m'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'

  alias diff='colordiff'
fi
