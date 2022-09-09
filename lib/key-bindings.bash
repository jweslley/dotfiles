#
# To obtain the key sequence from a function key, use the `read` command.
# The following is an example of pressing the [F12] key:
#
#    $ read
#    ^[[24~
#
# Make sure you write the key sequence as \e[24~ rather than ^[[24~.
# This is because the ^[ sequence is equivalent to the [Esc] key,
# which is represented by \e in the shell. So, for instance,
# if the key sequence was ^[[OP the resulting bind code to use would be \e[OP.
# For a list of shell commands that you can use, examine the /etc/inputrc file.

bind -x '"\C-l"':clear
bind '"\e[24~":"pwd\n"' # f12

bind  '"\ef":"rg "'

bind '"\eS":"git show "'
bind '"\ez":"git s    \n"'
bind '"\es":"git s    \n"'
bind '"\el":"git l    \n"'
bind '"\ed":"git diff \n"'
bind '"\ep":"git push \n"'
bind '"\eu":"git up   \n"'
bind '"\eo":"git checkout "'
bind '"\ec":"git commit -S -m \""'

# https://coderwall.com/p/oqtj8w
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
