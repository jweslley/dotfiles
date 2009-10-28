" Vim Compiler File
" Compiler:	maven2
" Maintainer:	Ronald Tschalär <ronald@innovation.ch>
" Last Change:	Tue, 18 Apr 2006 03:08:12 PDT

if exists("current_compiler")
    finish
endif
let current_compiler = "maven2"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=mvn

CompilerSet errorformat=
    \%-G[%\\(WARNING]%\\)%\\@!%.%#,
    \%A%[%^[]%\\@=%f:[%l\\,%v]\ %m,
    \%W[WARNING]\ %f:[%l\\,%v]\ %m,
    \%-Z\ %#,
    \%-Clocation\ %#:%.%#,
    \%C%[%^:]%#%m,
    \%-G%.%#

" CompilerSet errorformat=
"    \%-G[%\\(WARNING]%\\)%\\@!%.%#,
"    \%E[WARNING]\ %f:%l:\ error:\ %m,
"    \%W[WARNING]\ %f:%l:\ warning:\ %m,
"    \%A%[%^[]%\\@=%f:%l:\ %s:\ %m,
"    \%C[WARNING]\ %p^,
"    \%C[WARNING]\ %m,
"    \%-G%.%#

