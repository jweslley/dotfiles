#!/bin/sh
# [Gedit Tool]
# Name=[ruby] run rake tasks
# Shortcut=<Control><Alt>r
# Applicability=all
# Output=output-panel
# Input=nothing
# Save-files=nothing


# Shows a list with available rake tasks and executes the selected one in the bottom pane
#  (depends on ruby, zenity)
#
# Save:   Nothing
# Input:  Nothing
# Output: Display in bottom pane
#
# by GNOME wiki <http://live.gnome.org/Gedit/ExternalToolsPluginCommands#Rake>, edited by Jan Lelis (mail@janlelis.de)

rake=`rake -sT`

if [ -z "$rake" ]; then
  zenity --error --text='No Rakefile found.'
else
	cmd=`echo "$rake" | ruby -ne 'puts $1 if ~/^rake (\S*).*$/' | zenity --list --text='Select the task to run' --title='rake' --column='rake --tasks'`

  if [ ! -z "$cmd" ]; then
    echo "rake $cmd"
    rake $cmd
  fi
fi
