#!/bin/sh
# [Gedit Tool]
# Name=[git] add/commit
# Shortcut=<Control><Alt>a
# Applicability=titled
# Output=nothing
# Input=nothing
# Save-files=all


# Saves all documents, then shows a menu with common git tasks
#  (depends on git, zenity)
#
# Save:   All documents
# Input:  Nothing
# Output: Nothing
#
# by Jan Lelis (mail@janlelis.de), edited by (you?)

commit() {
  dirty=`git status 2> /dev/null | grep 'nothing to commit (working directory clean)'`
  if [ ! -z "$dirty" ]; then
    zenity --warning --title='git commit' --text='nothing to commit (working directory clean)'
  else
    res=`git commit $1 -m "\`zenity --entry --title='git commit' --text='message:' --width=500\`"` && zenity --info --title="git commit $1" --text="$res"
  fi
}

if [ ! -z `git rev-parse --git-dir` ]; then
`git status 2> /dev/null | tail -n1 | grep "nothing to commit \(working directory clean\)"`
sel=`echo "1
add 
file
2
add
file's directory
3
add
repository
4
commit
index
5
commit
file (ignore index)
6
commit
file's directory (ignore index)
7
add & commit
repository
8
add & commit
repository (don't add new files)
9
push
(only fast forward)" | zenity --list --title="git" --text="choose action" --column="#" --column="action" --column="files" --height=320 --width=400`

case $sel in
1)
  git add $GEDIT_CURRENT_DOCUMENT_PATH &&
  zenity --info --title='git add' --text="Added\n$GEDIT_CURRENT_DOCUMENT_PATH"
  ;;
2)
  git add $GEDIT_CURRENT_DOCUMENT_DIR &&
  zenity --info --title='git add' --text="Added\n$GEDIT_CURRENT_DOCUMENT_DIR"
  ;;
3)
  dir=`dirname \`git rev-parse --git-dir\``
  git add "$dir" &&
  zenity --info --title='git add' --text="Added\n$dir"
  ;;
4)
  commit
  ;;
5)
  commit $GEDIT_CURRENT_DOCUMENT_PATH
  ;;
6)
  commit $GEDIT_CURRENT_DOCUMENT_DIR
  ;;
7)
  dir=`dirname \`git rev-parse --git-dir\``
  git add "$dir" &&
  commit
  ;;
8)
  commit -a
  ;;
9)
  params=`zenity --entry --title='git push' --text='params (cancel for none)' --entry-text='origin master'`
  res=`git push $params` &&
  zenity --info --title="git push $params" --text="$res"
  ;;
esac

else
  zenity --error --title='git' --text='Sorry, not a git repository'
fi
