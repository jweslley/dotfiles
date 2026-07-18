bindkey -s '^[f' 'rg '                 # Alt + f
bindkey -s '^[F' 'rg "$(pbpaste)"\n'   # Alt + F (search clipboard content)
bindkey -s '^[S' 'git show '           # Alt + S
bindkey -s '^[s' 'git s\n'             # Alt + s
bindkey -s '^[;' 'git l\n'             # Alt + ;
bindkey -s '^[d' 'git diff\n'          # Alt + d
bindkey -s '^[p' 'git push\n'          # Alt + p
bindkey -s '^[u' 'git up\n'            # Alt + u
bindkey -s '^[o' 'git checkout '       # Alt + o
bindkey -s '^[c' 'git commit -m \"'    # Alt + c
#bindkey -s '^['  'clear\n'             # Esc
bindkey -M vicmd e edit-command-line
