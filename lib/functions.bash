# Functions definitions.

mkcd () {
  mkdir -p "$*"
  cd "$*"
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
  mencoder "$FILENAME" -o "${FILENAME%.ogg}.avi" -ovc lavc -oac lavc
}

ogg2mp3() {
  FILENAME=$1
  ffmpeg -i "$FILENAME" "${FILENAME%.ogg}.mp3"
}

wav2mp3() {
  FILENAME=$1
  lame --replaygain-accurate -q 0 --vbr-new -V 3  "$FILENAME" "${FILENAME%.wav}.mp3"
}

ips() {
  ifconfig | grep "inet " | awk '{ print $2 }' | cut -d: -f2
}

myip() {
  curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+'
}

mac() {
  test -z $1 && ifconfig -a | awk '/HWaddr/ {print $1" "$5}' || ifconfig $1 | awk '/HWaddr/ {print $5}'
}

getpages() {
  filename="$1" # file containing urls, one per line
  wget -p --convert-links -i $filename
}

mirror() {
  website="$1"
  wget --mirror -p --convert-links $website
}
