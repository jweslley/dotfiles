#!/usr/bin/env ruby
# [Gedit Tool]
# Name=[ruby] check syntax
# Shortcut=<Control><Alt>y
# Languages=ruby,rubyonrails
# Applicability=all
# Output=nothing
# Input=document
# Save-files=nothing


# Checks the Ruby syntax of the current file
#  (depends on ruby, zenity)
#
# Save:   Nothing
# Input:  Current document
# Output: Nothing
#
# by Jan Lelis (mail@janlelis.de), edited by (you?)

if "Syntax OK" == syntax = `ruby -c 2>&1`.chomp
  type = 'info'
else
  type = 'error'
  syntax = "Syntax not OK\n\nLine #{syntax[2..-1]}"
end

`zenity --#{type} --title='ruby -c' --text='#{syntax}'`
