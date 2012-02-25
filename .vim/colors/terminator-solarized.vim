" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Jonhnny Weslley <jw@jonhnnyweslley.net>
" Last Change:	2012 Feb 24
" http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
" http://www.devdaily.com/linux/vi-vim-editor-color-scheme-syntax

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "terminator-solarized"

hi  Normal     ctermfg=white    ctermbg=black
hi  ErrorMsg   ctermfg=red      ctermbg=black
hi  Visual     ctermfg=black    ctermbg=white
hi  VisualNOS  ctermfg=black    ctermbg=white
hi  Todo       ctermfg=magenta  ctermbg=black   term=bold  cterm=bold
hi  Search     ctermfg=black    ctermbg=yellow
hi  IncSearch  ctermfg=red      ctermbg=black

hi  StatusLine    ctermfg=Black  ctermbg=White  cterm=none  term=none
hi  StatusLineNC  ctermfg=Black  ctermbg=Gray   cterm=none  term=none
hi  VertSplit     ctermfg=Black  ctermbg=Gray   cterm=none  term=none

hi  Folded      ctermfg=darkgray  ctermbg=black  cterm=bold  term=bold
hi  FoldColumn  ctermfg=darkgray  ctermbg=black  cterm=bold  term=bold
hi  LineNr      ctermfg=darkgray  ctermbg=black  cterm=none  term=none

hi  DiffAdd     ctermfg=green   ctermbg=black  cterm=underline  term=underline
hi  DiffChange  ctermfg=yellow  ctermbg=black  cterm=none
hi  DiffDelete  ctermfg=red     ctermbg=black  cterm=underline  term=underline
hi  DiffText    ctermfg=blue    ctermbg=black  cterm=none

hi  Cursor   ctermfg=black  ctermbg=yellow
hi  lCursor  ctermfg=black  ctermbg=white

hi  SpecialKey  ctermfg=darkcyan
hi  Directory   ctermfg=blue
hi  Title       ctermfg=red        cterm=bold
hi  WarningMsg  ctermfg=red        ctermbg=black      cterm=bold  term=bold
hi  WildMenu    ctermfg=yellow     ctermbg=black      cterm=none  term=none
hi  ModeMsg     ctermfg=blue       cterm=none         term=none
hi  MoreMsg     ctermfg=darkgreen  ctermfg=darkgreen
hi  Question    ctermfg=green      cterm=none
hi  NonText     ctermfg=darkblue

hi  Comment     ctermfg=DarkGray  ctermbg=black
hi  Constant    ctermfg=cyan      cterm=none
hi  Identifier  ctermfg=blue      cterm=none
hi  Statement   ctermfg=green     cterm=none
hi  PreProc     ctermfg=white     cterm=bold
hi  Type        ctermfg=green     cterm=none
hi  Special     ctermfg=red       cterm=none
hi  Ignore      ctermfg=bg
hi  Underlined  cterm=underline   term=underline
