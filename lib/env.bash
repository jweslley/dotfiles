# Environment variables

CDPATH=.:$HOME:$HOME/code:/data:/usr/local

JAVA_HOME=/usr
M2_HOME=/usr/local/maven
SCALA_HOME=/usr/local/scala
PYTHONPATH=/usr/local/lib/python:$PYTHONPATH
export JAVA_HOME PYTHONPATH

export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:$M2_HOME/bin:$SCALA_HOME/bin

export HOSTFILE=$HOME/.hosts

export EDITOR="vi"
export PAGER="less"
export BROWSER="chromium-browser"
export LESS="-R -M"
export LESSCHARSET='latin1'
export GREP_OPTIONS='-R'
