" Vim syntax file
" Language:     Etch 
" Maintainer:   James Dixson <jadixson@cisco.com>
" URL:		http://etch.org/vim/syntax/etch.vim
" Last Change:  13 Nov 2007
"
"  Based on java.vim by Claudio Fleiner <claudio@fleiner.com>
"
" Please check :help etch.vim for comments on some of the options available.

" Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  " we define it here so that included files can test for it
  let main_syntax='etch'
endif

" don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ EtchHiLink hi link <args>
else
  command! -nargs=+ EtchHiLink hi def link <args>
endif

" some characters that cannot be in a etch idl (outside a string)
syn match etchError "[\\@`]"
syn match etchError "<<<\|\.\.\|=>\|<>\|||=\|&&=\|[^-]->\|\*\/"
syn match etchOK "\.\.\."

" use separate name so that it can be deleted in etchcc.vim
syn match   etchError2 "#\|=<"
EtchHiLink etchError2 etchError

" keyword definitions
syn keyword etchOptionAsyncReceiver pool queued none free
syn keyword etchOptionAuthorize true false 
"syn keyword etchOptionAuthorize true false <id> <integer>
syn keyword etchOptionDirection client server both
"syn keyword etchOptionExtern <id>[]
syn keyword etchOptionOneway true false
"syn keyword etchOptionTimeout <integer>
"syn keyword etchOptionToString <string>
syn keyword etchOptionUnchecked true false

syn keyword etchExternal module
syn match etchExternal "\<import\>\(\s\+static\>\)\?"
syn keyword etchConstant null
syn keyword etchType boolean byte const double enum exception extern float int long mixin object service short string struct void
syn keyword etchBoolean true false
syn keyword etchMethodDecl throws
syn match   etchAnnotation      "@[_$a-zA-Z][_$a-zA-Z0-9_]*\>"

if exists("etch_space_errors")
  if !exists("etch_no_trail_space_error")
    syn match   etchSpaceError  "\s\+$"
  endif
  if !exists("etch_no_tab_space_error")
    syn match   etchSpaceError  " \+\t"me=e-1
  endif
endif

syn region  etchLabelRegion     transparent matchgroup=etchLabel start="\<case\>" matchgroup=NONE end=":" contains=etchNumber,etchCharacter
syn match   etchUserLabel       "^\s*[_$a-zA-Z][_$a-zA-Z0-9_]*\s*:"he=e-1 contains=etchLabel
syn keyword etchLabel		default

" The following cluster contains all etch groups except the contained ones
syn cluster etchTop add=etchError,etchError2,etchOptionAsyncReceiver,etchOptionDirection,etchExternal,etchConstant,etchType,etchBoolean,etchMethodDecl,etchAnnotation

" Comments
syn keyword etchTodo		 contained TODO FIXME XXX
if exists("etch_comment_strings")
  syn region  etchCommentString    contained start=+"+ end=+"+ end=+$+ end=+\*/+me=s-1,he=s-1 contains=etchSpecial,etchCommentStar,etchSpecialChar,@Spell
  syn region  etchComment2String   contained start=+"+  end=+$\|"+  contains=etchSpecial,etchSpecialChar,@Spell
  syn match   etchCommentCharacter contained "'\\[^']\{1,6\}'" contains=etchSpecialChar
  syn match   etchCommentCharacter contained "'\\''" contains=etchSpecialChar
  syn match   etchCommentCharacter contained "'[^\\]'"
  syn cluster etchCommentSpecial add=etchCommentString,etchCommentCharacter,etchNumber
  syn cluster etchCommentSpecial2 add=etchComment2String,etchCommentCharacter,etchNumber
endif
syn region  etchComment		 start="/\*"  end="\*/" contains=@etchCommentSpecial,etchTodo,@Spell
syn match   etchCommentStar      contained "^\s*\*[^/]"me=e-1
syn match   etchCommentStar      contained "^\s*\*$"
syn match   etchLineComment      "//.*" contains=@etchCommentSpecial2,etchTodo,@Spell
EtchHiLink etchCommentString etchString
EtchHiLink etchComment2String etchString
EtchHiLink etchCommentCharacter etchCharacter

syn cluster etchTop add=etchComment,etchLineComment

if !exists("etch_ignore_javadoc") 
  syntax case ignore
  " syntax coloring for javadoc comments (HTML)
  syntax include @etchHtml <sfile>:p:h/html.vim
  unlet b:current_syntax
  syn region  etchDocComment    start="/\*\*"  end="\*/" keepend contains=etchCommentTitle,@etchHtml,etchDocTags,etchDocSeeTag,etchTodo,@Spell
  syn region  etchCommentTitle  contained matchgroup=etchDocComment start="/\*\*"   matchgroup=etchCommentTitle keepend end="\.$" end="\.[ \t\r<&]"me=e-1 end="[^{]@"me=s-2,he=s-1 end="\*/"me=s-1,he=s-1 contains=@etchHtml,etchCommentStar,etchTodo,@Spell,etchDocTags,etchDocSeeTag

  syn region etchDocTags         contained start="{@\(link\|linkplain\|inherit[Dd]oc\|doc[rR]oot\|value\)" end="}"
  syn match  etchDocTags         contained "@\(param\|exception\|throws\|since\)\s\+\S\+" contains=etchDocParam
  syn match  etchDocParam        contained "\s\S\+"
  syn match  etchDocTags         contained "@\(version\|author\|return\|deprecated\|serial\|serialField\|serialData\)\>"
  syn region etchDocSeeTag       contained matchgroup=etchDocTags start="@see\s\+" matchgroup=NONE end="\_."re=e-1 contains=etchDocSeeTagParam
  syn match  etchDocSeeTagParam  contained @"\_[^"]\+"\|<a\s\+\_.\{-}</a>\|\(\k\|\.\)*\(#\k\+\((\_[^)]\+)\)\=\)\=@ extend
  syntax case match
endif

" match the special comment /**/
syn match   etchComment		 "/\*\*/"

" Strings and constants
syn match   etchSpecialError     contained "\\."
syn match   etchSpecialCharError contained "[^']"
syn match   etchSpecialChar      contained "\\\([4-9]\d\|[0-3]\d\d\|[\"\\'ntbrf]\|u\x\{4\}\)"
syn region  etchString		start=+"+ end=+"+ end=+$+ contains=etchSpecialChar,etchSpecialError,@Spell
" next line disabled, it can cause a crash for a long line
"syn match   etchStringError	  +"\([^"\\]\|\\.\)*$+
syn match   etchCharacter	 "'[^']*'" contains=etchSpecialChar,etchSpecialCharError
syn match   etchCharacter	 "'\\''" contains=etchSpecialChar
syn match   etchCharacter	 "'[^\\]'"
syn match   etchNumber		 "\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
syn match   etchNumber		 "\(\<\d\+\.\d*\|\.\d\+\)\([eE][-+]\=\d\+\)\=[fFdD]\="
syn match   etchNumber		 "\<\d\+[eE][-+]\=\d\+[fFdD]\=\>"
syn match   etchNumber		 "\<\d\+\([eE][-+]\=\d\+\)\=[fFdD]\>"

" unicode characters
syn match   etchSpecial "\\u\d\{4\}"

syn cluster etchTop add=etchString,etchCharacter,etchNumber,etchSpecial,etchStringError

if exists("etch_highlight_functions")
  if etch_highlight_functions == "indent"
    syn match  etchFuncDef "^\(\t\| \{8\}\)[_$a-zA-Z][_$a-zA-Z0-9_. \[\]]*([^-+*/()]*)" contains=etchScopeDecl,etchType,etchStorageClass,@etchClasses
    syn region etchFuncDef start=+^\(\t\| \{8\}\)[$_a-zA-Z][$_a-zA-Z0-9_. \[\]]*([^-+*/()]*,\s*+ end=+)+ contains=etchScopeDecl,etchType,etchStorageClass,@etchClasses
    syn match  etchFuncDef "^  [$_a-zA-Z][$_a-zA-Z0-9_. \[\]]*([^-+*/()]*)" contains=etchScopeDecl,etchType,etchStorageClass,@etchClasses
    syn region etchFuncDef start=+^  [$_a-zA-Z][$_a-zA-Z0-9_. \[\]]*([^-+*/()]*,\s*+ end=+)+ contains=etchScopeDecl,etchType,etchStorageClass,@etchClasses
  else
    " This line catches method declarations at any indentation>0, but it assumes
    " two things:
    "   1. class names are always capitalized (ie: Button)
    "   2. method names are never capitalized (except constructors, of course)
    syn region etchFuncDef start=+^\s\+\(\(void\|boolean\|enum\|object\|string\|byte\|short\|int\|long\|float\|double\|\([A-Za-z_][A-Za-z0-9_$]*\.\)*[A-Z][A-Za-z0-9_$]*\)\(<[^>]*>\)\=\(\[\]\)*\s\+[a-z][A-Za-z0-9_$]*\|[A-Z][A-Za-z0-9_$]*\)\s*([^0-9]+ end=+)+ contains=etchType,etchComment,etchLineComment,@etchClasses
  endif
  syn match  etchBraces  "[{}]"
  syn cluster etchTop add=etchFuncDef,etchBraces
endif

if exists("etch_highlight_debug")

  " Strings and constants
  syn match   etchDebugSpecial		contained "\\\d\d\d\|\\."
  syn region  etchDebugString		contained start=+"+  end=+"+  contains=etchDebugSpecial
  syn match   etchDebugStringError      +"\([^"\\]\|\\.\)*$+
  syn match   etchDebugCharacter	contained "'[^\\]'"
  syn match   etchDebugSpecialCharacter contained "'\\.'"
  syn match   etchDebugSpecialCharacter contained "'\\''"
  syn match   etchDebugNumber		contained "\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
  syn match   etchDebugNumber		contained "\(\<\d\+\.\d*\|\.\d\+\)\([eE][-+]\=\d\+\)\=[fFdD]\="
  syn match   etchDebugNumber		contained "\<\d\+[eE][-+]\=\d\+[fFdD]\=\>"
  syn match   etchDebugNumber		contained "\<\d\+\([eE][-+]\=\d\+\)\=[fFdD]\>"
  syn keyword etchDebugBoolean		contained true false
  syn keyword etchDebugType		contained null this super
  syn region etchDebugParen  start=+(+ end=+)+ contained contains=etchDebug.*,etchDebugParen

  " to make this work you must define the highlighting for these groups
  syn match etchDebug "\<System\.\(out\|err\)\.print\(ln\)*\s*("me=e-1 contains=etchDebug.* nextgroup=etchDebugParen
  syn match etchDebug "\<p\s*("me=e-1 contains=etchDebug.* nextgroup=etchDebugParen
  syn match etchDebug "[A-Za-z][a-zA-Z0-9_]*\.printStackTrace\s*("me=e-1 contains=etchDebug.* nextgroup=etchDebugParen
  syn match etchDebug "\<trace[SL]\=\s*("me=e-1 contains=etchDebug.* nextgroup=etchDebugParen

  syn cluster etchTop add=etchDebug

  if version >= 508 || !exists("did_c_syn_inits")
    EtchHiLink etchDebug		 Debug
    EtchHiLink etchDebugString		 DebugString
    EtchHiLink etchDebugStringError	 etchError
    EtchHiLink etchDebugType		 DebugType
    EtchHiLink etchDebugBoolean		 DebugBoolean
    EtchHiLink etchDebugNumber		 Debug
    EtchHiLink etchDebugSpecial		 DebugSpecial
    EtchHiLink etchDebugSpecialCharacter DebugSpecial
    EtchHiLink etchDebugCharacter	 DebugString
    EtchHiLink etchDebugParen		 Debug

    EtchHiLink DebugString		 String
    EtchHiLink DebugSpecial		 Special
    EtchHiLink DebugBoolean		 Boolean
    EtchHiLink DebugType		 Type
  endif
endif

if exists("etch_mark_braces_in_parens_as_errors")
  syn match etchInParen		 contained "[{}]"
  EtchHiLink etchInParen	etchError
  syn cluster etchTop add=etchInParen
endif

" catch errors caused by wrong parenthesis
syn region  etchParenT  transparent matchgroup=etchParen  start="("  end=")" contains=@etchTop,etchParenT1
syn region  etchParenT1 transparent matchgroup=etchParen1 start="(" end=")" contains=@etchTop,etchParenT2 contained
syn region  etchParenT2 transparent matchgroup=etchParen2 start="(" end=")" contains=@etchTop,etchParenT  contained
syn match   etchParenError       ")"
" catch errors caused by wrong square parenthesis
syn region  etchParenT  transparent matchgroup=etchParen  start="\["  end="\]" contains=@etchTop,etchParenT1
syn region  etchParenT1 transparent matchgroup=etchParen1 start="\[" end="\]" contains=@etchTop,etchParenT2 contained
syn region  etchParenT2 transparent matchgroup=etchParen2 start="\[" end="\]" contains=@etchTop,etchParenT  contained
syn match   etchParenError       "\]"

EtchHiLink etchParenError       etchError

if !exists("etch_minlines")
  let etch_minlines = 10
endif
exec "syn sync ccomment etchComment minlines=" . etch_minlines

" The default highlighting.
if version >= 508 || !exists("did_etch_syn_inits")
  if version < 508
    let did_etch_syn_inits = 1
  endif
  EtchHiLink etchFuncDef		Function
  EtchHiLink etchVarArg                 Function
  EtchHiLink etchBraces			Function
  EtchHiLink etchBranch			Conditional
  EtchHiLink etchUserLabelRef		etchUserLabel
  EtchHiLink etchLabel			Label
  EtchHiLink etchUserLabel		Label
  EtchHiLink etchExceptions		Exception
  EtchHiLink etchMethodDecl		etchStorageClass
  EtchHiLink etchBoolean		Boolean
  EtchHiLink etchSpecial		Special
  EtchHiLink etchSpecialError		Error
  EtchHiLink etchSpecialCharError	Error
  EtchHiLink etchString			String
  EtchHiLink etchCharacter		Character
  EtchHiLink etchSpecialChar		SpecialChar
  EtchHiLink etchNumber			Number
  EtchHiLink etchError			Error
  EtchHiLink etchStringError		Error
  EtchHiLink etchStatement		Statement
  EtchHiLink etchOperator		Operator
  EtchHiLink etchComment		Comment
  EtchHiLink etchDocComment		Comment
  EtchHiLink etchLineComment		Comment
  EtchHiLink etchConstant		Constant
  EtchHiLink etchTypedef		Typedef
  EtchHiLink etchTodo			Todo
  EtchHiLink etchAnnotation             PreProc

  EtchHiLink etchCommentTitle		SpecialComment
  EtchHiLink etchDocTags		Special
  EtchHiLink etchDocParam		Function
  EtchHiLink etchDocSeeTagParam		Function
  EtchHiLink etchCommentStar		etchComment

  EtchHiLink etchType			Type
  EtchHiLink etchExternal		Include

  EtchHiLink htmlComment		Special
  EtchHiLink htmlCommentPart		Special
  EtchHiLink etchSpaceError		Error
endif

delcommand EtchHiLink

let b:current_syntax = "etch"

if main_syntax == 'etch'
  unlet main_syntax
endif

let b:spell_options="contained"

" vim: ts=8
