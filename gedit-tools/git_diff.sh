#!/bin/sh
# [Gedit Tool]
# Name=[git] diff
# Shortcut=<Control><Alt>i
# Applicability=titled
# Output=nothing
# Input=nothing
# Save-files=document


# Saves the current file and shows it differences from current HEAD in meld
#  (depends on git, meld, zenity)
#
# Save:   Current document
# Input:  Nothing
# Output: Nothing
#
# by Jan Lelis (mail@janlelis.de), edited by (you?)

if [ ! -z `git rev-parse --git-dir` ]; then
  diff=`git difftool -t meld $GEDIT_CURRENT_DOCUMENT_PATH` &&
  if [ -z "$diff" ]; then
    zenity --info --title="git diff" --text='File has not changed.'
  fi
else
  zenity --error --title='git diff' --text='Sorry, not a git repository'
fi

