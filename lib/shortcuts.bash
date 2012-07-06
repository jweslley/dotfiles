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

bind -x '"\C-t"':htop
bind -x '"\C-l"':clear
bind '"\e[24~":"pwd\n"' # f12

bind '"\\a":"ack-grep "'

bind '"\\S":"git show "'
bind '"\\s":"git s    \n"'
bind '"\\l":"git l    \n"'
bind '"\\d":"git diff \n"'
bind '"\\p":"git push \n"'
bind '"\\u":"git pull \n"'
bind '"\\o":"git checkout "'
bind '"\\c":"git commit -m \""'
bind '"\\v":"git vi "'

