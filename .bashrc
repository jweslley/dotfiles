# Jonhnny Weslley's configuration shiznit that makes him productive

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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
