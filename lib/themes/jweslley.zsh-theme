PROMPT="%{$fg_bold[cyan]%}%c%{$reset_color%}"
PROMPT+='$(git_prompt_info)'
PROMPT+='%(?:%{$fg[green]%}$:%{$fg[red]%}$)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
MODE_INDICATOR="%F{white}+%f"
