" Vim syntax file
" Language:     OurGrid's Job Description File  (http://ourgrid.org/)
" Maintainer:   Jonhnny Weslley <jonhnnyweslley@gmail.com>
" URL:		http://github.com/jweslley/ourgrid-tool-support/blob/master/vim/syntax/ourgrid-jdf.vim
" Last Change:  2009 Oct 10

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match
syn sync minlines=50

" keywords
syn keyword jdfKeyword job label requirements task init remote final

" commands
syn keyword jdfCommand get put store

" environment variables
syn match jdfEnvVar "\$\(JOB\|TASK\|PROC\|PLAYPEN\|STORAGE\)"

" string literals with escapes
syn region jdfString start="\"[^"]" skip="\\\"" end="\"" contains=jdfStringEscape
syn match jdfStringEscape "\\u[0-9a-fA-F]\{4}" contained
syn match jdfStringEscape "\\[nrfvb\\\"]" contained
syn match jdfEmptyString "\"\""

" number literals
syn match jdfNumber "\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
syn match jdfNumber "\(\<\d\+\.\d*\|\.\d\+\)\([eE][-+]\=\d\+\)\=[fFdD]\="
syn match jdfNumber "\<\d\+[eE][-+]\=\d\+[fFdD]\=\>"
syn match jdfNumber "\<\d\+\([eE][-+]\=\d\+\)\=[fFdD]\>"

syn sync fromstart

" map JDF groups to standard groups
hi link jdfKeyword Keyword
hi link jdfCommand Function
hi link jdfEnvVar Special
hi link jdfNumber Number
hi link jdfString String
hi link jdfEmptyString String
hi link jdfStringEscape Special

let b:current_syntax = "ourgrid-jdf"

