# Vim Tips

  * [Vimdiff](http://dailyvim.tumblr.com/post/1115482104/vimdiff)

# NerdTree

  * Use the natural vim navigation keys `hjkl` to navigate the files.
  * Press `o` to open the file in a new buffer or open/close directory.
  * Press `t` to open the file in a new tab.
  * Press `i` to open the file in a new horizontal split.
  * Press `s` to open the file in a new vertical split.
  * Press `p` to go to parent directory.
  * Press `r` to refresh the current directory.

# RagTag

    CTRL+X /       Close the last open HTML tag
    CTRL+X SPACE   Create open/close HTML tags from the typed word
    CTRL+X CR      The same as CTRL+X SPACE but puts a newspace in between
    CTRL+X !       Insert HTML doctype
    CTRL+X @       Insert CSS stylesheet
    CTRL+X #       Insert meta content-type meta tag
    CTRL+X $       Load JavaScript document

For the following mappings, suppose that you have typed `foo`.

    Mapping        Result
    ---------      -----------
    CTRL+X =       foo<%= | %>
    CTRL+X +       <%= foo| %>
    CTRL+X -       foo<% | %>
    CTRL+X _       <% foo| %>
    CTRL+X '       foo<%# | %>
    CTRL+X "       <%# foo| %>

# surround

Adding surroundings:

    Text              Command      New Text
    ---------------   -------      -----------
    Hello w|orld!     ysiw)        Hello (world)!
    Hello w|orld!     csw)         Hello (world)!
    fo|o              ysiwt<html>  <html>foo</html>
    foo quu|x baz     yss"         "foo quux baz"
    foo quu|x baz     ySS"         "
                                   foo quux baz
                                   "

Changing surroundings:

    Text              Command    New Text
    ---------------   -------    -----------
    "Hello |world!"   cs"'       'Hello world!'
    "Hello |world!"   cs"<q>     <q>Hello world!</q>
    (123+4|56)/2      cs)]       [123+456]/2
    (123+4|56)/2      cs)[       [ 123+456 ]/2
    <div>foo|</div>   cst<p>     <p>foo</p>
    fo|o!             csw'       'foo'!
    fo|o!             csW'       'foo!'

Deleting surroundings:

    Text              Command    New Text
    ---------------   -------    -----------
    'Hello W|orld'    ds'        Hello World
    (12|3+4*56)/2     ds(        123+4*56/2
    <div>fo|o</div>   dst        foo

Note: `|` is the position of cursor in these examples.

# Vim mark quick reference
[http://www.linux.com/archive/feature/54159]

mx tells Vim to add a mark called x.

`x tells Vim to return to the line and column for mark x.

'x tells Vim to return to the beginning of the line where mark x is set.

`. moves the cursor to the line and column where the last edit was made.

'. moves the cursor to the line where the last edit was made.

'" moves the cursor to the last position of the cursor when you exited the previous session.

:marks shows all marks set.

:marks x shows the mark named x.

:jumps shows the jumplist.

Ctrl-o moves the cursor to the last jump.

Ctrl-i moves the cursor to the previous jump.

H moves the cursor to the top of the screen or viewport.

M moves the cursor to the middle of the screen or viewport.

L moves the cursor to the bottom of the screen or viewport.


# Jumping
    nG - jump to line n ("line 5, Go")
    C-o - jump backwards ("out")
    C-i - jump forwards ("in")
    L - jump to bottom of screen ("low")
    M - jump to middle of screen ("middle")
    H - jump to top of screen ("high")
    zt - put this line at the 't'op of the screen
    zb - put this line at the 'b'ottom of the screen
    zz - put this line at the middle of the screen

[Source](http://docs.google.com/View?id=dvvc8ms_29rvt2x3sr)
http://www.howtogeek.com/115051/become-a-vi-master-by-learning-these-30-key-bindings/

Insert Mode

    * get out of insert mode, back to normal mode: Esc or Ctrl-C
    * try to autocomplete current word: Ctrl-N (select next/prev from multiple results with subsequent Ctrl-N's and Ctrl-P's)


Normal Mode
Motions
Cardinal Directions

    * Up: k 
    * Down: j
    * Left: h
    * Right: l
    * Yes, you can use the arrow keys too.


Words

    * start of next word: w
    * next end of word: e
    * back to start of previous word: b 


Line searches

    * forward to next x (stops on x): fx
    * forward to next x (stops before x): tx
    * backward to previous x (stops on x): Fx
    * backward to previous x (stops before x): Tx
    * redo last f, F, t, or T: ; (forwards) or , (backwards)


Line

    * to first character of line: ^
    * to last character of line: $


Paragraphs

    * to next paragraph: }
    * to previous paragraph: {


Other Helpful Motions

    * to start of file: gg
    * to end of file: G
    * to last line you edited: `. (that's backtick not a single quote, and then a period) 
    * to last line you edited in insert mode, and enter insert mode there: gi 
    * to next matching (), {}, or [] under or after cursor: %
    * inner block x: ix
          o works where x is one of:  '  "  (  )  {  }  [  ]  <  >
          o useful to change a string or remove a string
          o so given 'foo bar baz' with cursor anywhere inside the string, ci' gives you empty string with cursor inside, like this: '|'

Operators
Get Into Insert Mode

    * at cursor: i
    * after cursor: a
    * at beginning of line: I
    * at end of line: A
    * on new line below current line: o
    * on new line above current line: O

Delete (it's actually a cut operation)

    * character under cursor: x
    * to end of line: D
    * whole line: dd
    * to <motion>: d<motion>
          o delete a word: dw
          o delete backwards to start of word: db
    * to <motion> and enter insert mode: c<motion>
    * to end of line and enter insert mode: C
    * whole line and enter insert mode: cc


Yank and Paste (Yank is vim-ese for copy)

    * copy whole line: yy or Y
    * copy selection (in visual selection mode): y
    * paste after cursor: p
    * paste before cursor: P

Undo and Redo

    * Undo last change: u
    * Redo last change: Ctrl-r


Searches

    * to next instance of <regex>: /<regex> (then press enter) (find next match with n)
    * to previous instance of <regex>: ?<regex> (then press enter) (find next match with N)


Other Operations I Use A Lot

    *
      Save :w
    * Quit :q
    * smart indent current line: ==
    * indent line: >>
    * outdent line: <<
    * join next line with current line: J (puts a space at end of current line and moves next line up)
    * move to previous position you were at: Ctrl-O
    * move to more recent position you were at: Ctrl-I


Visual Selection Mode
The Basics

    * character selection mode: v 
          o for selecting a few words
    * line selection mode: V
          o for working with a whole line, or several lines
    * block selection mode: Ctrl-V
          o for working with any rectangular block of text; like option-drag in TextMate

Used Regularly

    * select a paragraph: ap (combine with more ap's to select more paragraphs)
    * toggle position of cursor to start/end of selection: o
    * indent selection smartly: =
    * indent selection: >
    * outdent selection: <





Other Awesome Features In Normal Mode
Multiple Clipboards

    * use register x for next operation or paste: "x
    * paste from register x: "xp


Repeat Last Change

    * repeat the last change operation, or everything typed during last insert mode: .


Macro Recording and Playback

    * start recording in register x: qx
    * end recording: q
    * perform macro in register x: @x
    * repeat last macro: @@


Reminders That There's Probably A Better Way To Do Something

    * You're touching the mouse
    * You're using the arrow keys
    * You're hitting delete a lot
    * You're repeating yourself

    http://robots.thoughtbot.com/post/27041742805/vim-you-complete-me
    http://ku1ik.com/2012/06/07/extract-variable-in-vim.html
https://sites.google.com/site/visionofarun/vim
