# dotfiles

# Reload Library
alias reload="source $HOME/.bashrc"

# define the path to dotfiles applications
DOTFILES_PATH="$DOTFILES/bin"
DOTFILES_PATH="$(find $DOTFILES/apps/ -executable -type f -exec dirname {} \; |\
        grep -v -e "\.git" -e "test" | sort | uniq | tr '\n' ':')$DOTFILES_PATH"

export PATH=$PATH:$DOTFILES_PATH
