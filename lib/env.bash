# Environment variables

CDPATH=.:$HOME:$HOME/code

export PATH=$HOME/bin:$PATH

export HOSTFILE=$HOME/.hosts

export UID=$(id -u) 2> /dev/null
export GID=$(id -g)
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"
export BROWSER="chromium"
export LESS="-R -M"
export LESSCHARSET='latin1'
export SSL_CERT_FILE=/etc/ssl/cert.pem
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
