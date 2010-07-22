#!/usr/bin/env ruby
# [Gedit Tool]
# Name=[ruby] load into irb
# Shortcut=<Control>F5
# Languages=ruby,rubyonrails
# Applicability=all
# Output=nothing
# Input=nothing
# Save-files=document


# Saves the current file, checks its syntax and loads it into an irb shell
#  (depends on ruby, zenity)
#
# Save:   Current document
# Input:  Nothing
# Output: Nothing
#
# by Jan Lelis (mail@janlelis.de), edited by (you?)

if "Syntax OK" == syntax = `ruby -c "$GEDIT_CURRENT_DOCUMENT_PATH" 2>&1`.chomp
  `gnome-terminal --command="irb -r$GEDIT_CURRENT_DOCUMENT_NAME" --working-directory="$GEDIT_CURRENT_DOCUMENT_DIR" &`
else
  `zenity --error --title='ruby -c' --text='Syntax not OK\n\nLine #{syntax[/rb:\d+:.*$/][3..-1]}'`
end
