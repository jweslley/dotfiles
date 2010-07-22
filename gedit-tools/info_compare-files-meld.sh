#!/bin/sh
# [Gedit Tool]
# Name=[info] compare files (meld)
# Shortcut=<Control><Alt>m
# Applicability=all
# Output=nothing
# Input=nothing
# Save-files=document


# Opens meld to compare two documents
#  (depends on meld, zenity)
#
# Save:   Current document
# Input:  Nothing
# Output: Nothing
#
# by GNOME wiki <http://live.gnome.org/Gedit/ExternalToolsPluginCommands#Comparing_Files>, edited by (you?)

TITLE="Compare With..."
TEXT="Compare $GEDIT_CURRENT_DOCUMENT_NAME with:"
BROWSE=" browse..."
FILE=
while [ -z "$FILE" ]; do
  FILE=`zenity --list --title="$TITLE" --text="$TEXT" --width=640 --height=320 --column=Documents $GEDIT_DOCUMENTS_PATH "$BROWSE"`
  if [ "$FILE" = "$BROWSE" ]; then
    FILE=`zenity --file-selection --title="$TITLE" --filename="$GEDIT_CURRENT_DOCUMENT_DIR/"`
  elif [ -z "$FILE" ]; then
    exit 
  fi
done

meld "$GEDIT_CURRENT_DOCUMENT_DIR/$GEDIT_CURRENT_DOCUMENT_NAME" "$FILE" &
