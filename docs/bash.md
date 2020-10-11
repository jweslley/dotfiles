# Bash Shortcut Keys

  * Ctrl + A: Go to the beginning of the line you are currently typing on
  * Ctrl + E: Go to the end of the line you are currently typing on
  * Ctrl + L: Clears the Screen, similar to the clear command
  * Ctrl + U: Clears the line before the cursor position. If you are at the endd of the line, clears the entire line.
  * Ctrl + H: Same as backspace
  * Ctrl + R: Let’s you search through previously used commands
  * Ctrl + C: Kill whatever you are running
  * Ctrl + D: Exit the current shell
  * Ctrl + P: Display the previous command, press enter to execute it
  * Ctrl + Z: Puts whatever you are running into a suspended background process. fg restores it.
  * Ctrl + W: Delete the word before the cursor
  * Ctrl + K: Clear the line after the cursor
  * Ctrl + T: Swap the last two characters before the cursor
  * Esc + T: Swap the last two words before the cursor
  * Alt + F: Move cursor forward one word on the current line
  * Alt + B: Move cursor backward one word on the current line
  * Tab: Auto-complete files and folder names
  * Ctrl + b: Move back one character.
  * Alt-b: Move back one word.
  * Ctrl-f: Move forward one characterser.
  * Alt-f: Move forward one word.
  * Ctrl-] x: Where x is any character, moves the cursor forward to the next occurance of x.
  * Alt-Ctrl-] x: Where x is any character, moves the cursor backwards to the previous occurance of x.
  * Ctrl-u: Delete from the cursor to the beginning of the line.
  * Ctrl-k: Delete from the cursor to the end of the line.
  * Ctrl-w: Delete from the cursor to the start of the word.
  * Esc-Del: Delete previous word (movesay not work, instead try Esc followed by Backspace)
  * Ctrl-y: Pastes text from the clipboard.
  * Alt-r: Undo all changes to the line.
  * Alt-Ctrl-e: Expand change command line.
  * Ctrl-r: Incremental reverse search of history.
  * Alt-p Non-Altincremental reverse search of history.


## History

`!!` Execute last command in history
`!abc` Execute last command in history beginning with abc
`!abc:p` Print last command in history beginning with abc
`!?foo` will repeat the most recent command that contained the string 'foo'
`!n` Execute nth command commandin history
`!$` Last argument of last command
`!$` First argument of Last command
`^abc^xyz` Replace first occurance of abc with xyz in last commandand and execute it 


### References:

  * http://blog.sanctum.geek.nz/bash-history-expansion/
