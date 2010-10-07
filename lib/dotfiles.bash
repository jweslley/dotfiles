# dotfiles

# Reload Library
alias reload="source $HOME/.bashrc"

DOTFILES_PATH="$DOTFILES/bin"
DOTFILES_PATH=$(find $DOTFILES/apps/ -executable -type f -exec dirname {} \; | grep -v -e "\.git" -e "test" | sort | uniq | awk -v APP_PATH=$DOTFILES_PATH '{ APP_PATH=APP_PATH":"$1 } END {print APP_PATH }')
# TODO use `| tr '\n' ':'` instead of awk
