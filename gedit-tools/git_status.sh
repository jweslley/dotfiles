#!/bin/sh
# [Gedit Tool]
# Name=[git] status
# Shortcut=<Control><Alt>s
# Applicability=titled
# Output=nothing
# Input=nothing
# Save-files=nothing


# Shows git status
#  (depends on git, ruby, zenity)
#
# Save:   Nothing
# Input:  Nothing
# Output: Nothing
#
# by Jan Lelis (mail@janlelis.de), edited by (you?)

if [ ! -z `git rev-parse --git-dir` ]; then
  git status | ruby -pe '$_.slice!(0) if ~/^#/' | zenity --text-info --width=600 --height=600 --title="git status"
else
  zenity --error --title='git status' --text='Sorry, not a git repository'
fi
