#-------------------------------------------------------------------------------
# dotfiles
#-------------------------------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path to dotfiles directory
export DOTFILES="$HOME/.dotfiles"

# Load all libraries
LIBS=$(find $DOTFILES/lib/ -name *.bash | env LC_ALL=C sort)
for lib in $LIBS ; do
  source $lib
done

# Load local configuration
if [ -f ~/.localrc ]; then
  . ~/.localrc
fi
