# Jonhnny Weslley's configuration shiznit that makes him productive

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#-------------------------------------------------------------------------------
# dotfiles
#-------------------------------------------------------------------------------

# Path to dotfiles directory
DOTFILES="$HOME/.dotfiles"

# Load all libraries
LIB=$(find $DOTFILES/lib/ -name *.bash | sort)
for config_file in $LIB ; do
  source $config_file
done

#-------------------------------------------------------------------------------
# PATH
#-------------------------------------------------------------------------------
JAVA_HOME=/usr
M2_HOME=/usr/local/maven
SCALA_HOME=/usr/local/scala
RUBY_GEMS=/var/lib/gems/1.8/
PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin:$SCALA_HOME/bin:$RUBY_GEMS/bin:$DOTFILES/bin:$DOTFILES/apps/git-achievements:/usr/local/sbt
export PATH JAVA_HOME
export PYTHONPATH=/usr/local/lib/python:$PYTHONPATH

CDPATH=.:~:/data:/data/workspace:/usr/local

pwd
