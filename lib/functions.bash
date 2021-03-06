# Functions definitions.

vdd() {
  vimdiff $2 $1/$2
}

mkcd () { mkdir -p "$*"; cd "$*"; }

extract() {
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
      *.xz) tar xvfJ $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

ips() {
  ifconfig | grep "inet " | awk '{ print $2 }' | cut -d: -f2
}

myip() {
  curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+'
}

dog() {
  cat `which "$@"`
}

# Repeat n times command.
repeat() {
  local i max
  max=$1; shift;
  for ((i=1; i <= max ; i++)); do
    eval "$@";
  done
}

ask() {
  echo -n "$@" '[y/n] ' ; read ans
  case "$ans" in
    y*|Y*) return 0 ;;
    *) return 1 ;;
  esac
}

getpages() {
  filename="$1" # file containing urls, one per line
  wget -p --convert-links -i $filename
}

mirror() {
  website="$1"
  wget --mirror -p --convert-links $website
}

tmux_colors(){
  for i in {0..255} ; do
    printf "\x1b[38;5;${i}mcolour${i}\n"
  done
}

iwatch() {
  while inotifywait --exclude .swp -e modify -r .; do $@; done;
}

