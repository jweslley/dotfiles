# Jonhnny Weslley's configuration shiznit that makes him productive

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#-------------------------------------------------------------------------------
# Environment variables
#-------------------------------------------------------------------------------
CDPATH=.:~:/data:/data/workspace:/usr/local

JAVA_HOME=/usr
M2_HOME=/usr/local/maven
SCALA_HOME=/usr/local/scala
SBT=/usr/local/sbt
RUBY_GEMS=/var/lib/gems/1.8
PYTHONPATH=/usr/local/lib/python:$PYTHONPATH
export JAVA_HOME PYTHONPATH

#-------------------------------------------------------------------------------
# PATH
#-------------------------------------------------------------------------------

PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin:$SCALA_HOME/bin:$RUBY_GEMS/bin:$SBT
export PATH

#-------------------------------------------------------------------------------
# dotfiles
#-------------------------------------------------------------------------------

# Path to dotfiles directory
DOTFILES="$HOME/.dotfiles"

# Load all libraries
LIBS=$(find $DOTFILES/lib/ -name *.bash | sort)
for lib in $LIBS ; do
  source $lib
done

# print current/working directory
pwd
