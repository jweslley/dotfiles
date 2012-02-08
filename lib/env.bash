# Environment variables

CDPATH=.:$HOME:$HOME/code:/data:/usr/local

JAVA_HOME=/usr
M2_HOME=/usr/local/maven
SCALA_HOME=/usr/local/scala
RUBY_GEMS=/var/lib/gems/1.8
PYTHONPATH=/usr/local/lib/python:$PYTHONPATH
export JAVA_HOME PYTHONPATH

export PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin:$SCALA_HOME/bin:$RUBY_GEMS/bin:/usr/local/mongodb/bin/

export HOSTFILE=$HOME/.hosts

export EDITOR="vi"
export PAGER="less"
export LESS="-R -M"
export LESSCHARSET='latin1'
export GREP_OPTIONS="--exclude-dir=\.svn --exclude-dir=log --exclude-dir=\.git"
