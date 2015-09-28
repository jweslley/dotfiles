# Tmux

## Session management

  * creates a new tmux session named `session_name`

        tmux new -s session_name

  * attaches to an existing tmux session named `session_name`

        tmux attach -t session_name

  * switches to an existing session named `session_name`

        tmux switch -t session_name

  * lists existing tmux sessions

        tmux list-sessions

  * detach the currently attached session

        tmux detach (prefix + d)


## Windows

  * create a new window

        tmux new-window (prefix + c)

  * move to the window based on index

        tmux select-window -t :0-9 (prefix + 0-9)

  * rename the current window

        tmux rename-window (prefix + ,)

## Panes

  * splits the window into two vertical panes

        tmux split-window (prefix + ")

  * splits the window into two horizontal panes

        tmux split-window -h (prefix + %)

  * swaps pane with another in the specified direction

        tmux swap-pane -[UDLR] (prefix + { or })

  * selects the next pane in the specified direction

        tmux select-pane -[UDLR]

  * selects the next pane in numerical order

        tmux select-pane -t :.+

## Helpful tmux commands

  * lists out every bound key and the tmux command it runs

        tmux list-keys

  * lists out every tmux command and its arguments

        tmux list-commands

  * lists out every session, window, pane, its pid, etc.

        tmux info

  * reloads the current tmux configuration (based on a default tmux config)

        tmux source-file ~/.tmux.conf

## Tmux plugins

### tmux-copycat

- `prefix + /` - regex search (strings work too)
- `prefix + ctrl-f` - simple *f*ile search
- `prefix + ctrl-g` - jumping over *g*it status files (best used after `git status` command)
- `prefix + alt-h` - jumping over SHA-1 hashes (best used after `git log` command)
- `prefix + ctrl-u` - *u*rl search (http, ftp and git urls)
- `prefix + ctrl-d` - number search (mnemonic d, as digit)
- `prefix + alt-i` - *i*p address search

### tmux-yank

- `y` - copy selection to system clipboard
- `Y` (shift-y) - "put" selection - equivalent to copying a selection, and pasting it to the command line.

### tmux-open

- `o` - "open" a highlighted selection with the system default program. `open` for OS X or `xdg-open` for Linux.
