" Disable vi-compatibility
set nocompatible

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc', { 'build': {
      \ 'windows': 'make -f make_mingw32.mak',
      \ 'cygwin': 'make -f make_cygwin.mak',
      \ 'mac': 'make -f make_mac.mak',
      \ 'unix': 'make -f make_unix.mak',
      \ } }

" Fuzzy search
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'mileszs/ack.vim'

" colorscheme
NeoBundle 'altercation/vim-colors-solarized'

" Comments
NeoBundle 'scrooloose/nerdcommenter'

" File browsing
NeoBundle 'scrooloose/nerdtree'

" Syntax checker
NeoBundle 'scrooloose/syntastic'

" Git
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-git'
NeoBundle 'airblade/vim-gitgutter'

" Shell
NeoBundle 'tpope/vim-dispatch'

" Editing
NeoBundle 'ervandew/supertab'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tsaleh/vim-matchit'
NeoBundle 'kana/vim-smartinput'
NeoBundle 'godlygeek/tabular'

" Tags
NeoBundle 'vim-scripts/AutoTag'
NeoBundle 'majutsushi/tagbar'

" Snippets
NeoBundle 'tomtom/tlib_vim'
NeoBundle 'MarcWeber/vim-addon-mw-utils'
NeoBundle 'garbas/vim-snipmate'
NeoBundle 'honza/vim-snippets'

" Programming languages
NeoBundle 'Blackrush/vim-gocode'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-bundler'
NeoBundle 'tpope/vim-ragtag'

" File types
NeoBundle 'tpope/vim-markdown'
NeoBundle 'ajf/puppet-vim'
NeoBundle 'derekwyatt/vim-scala'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'kchmck/vim-coffee-script'


" Enable detection, plugins and indenting in one step
filetype plugin indent on

" Brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

" Installation check.
NeoBundleCheck


" Editing behaviour
set showmode                    " always show what mode we're currently editing in
set showbreak=...               " show break
set wrap linebreak              " wrap lines
"set colorcolumn=81              " make a red line down the 81st column
set tabstop=2                   " a tab is two spaces
set softtabstop=2               " when hitting <BS>, pretend like a tab is removed, even if spaces
set expandtab                   " expand tabs by default (overloadable per file type later)
set shiftwidth=2                " number of spaces to use for autoindenting
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent                  " always set autoindenting on
set autoread                    " Set to auto read when a file is changed from the outside
set autowriteall                " Set to auto write file
set copyindent                  " copy the previous indentation on autoindenting
set number                      " always show line numbers
set showmatch                   " set show matching parenthesis
set smarttab                    " insert tabs on the start of a line according to
                                "    shiftwidth, not tabstop
set scrolloff=10                " keep 10 lines off the edges of the screen when scrolling
set sidescrolloff=7
set sidescroll=1
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

set nolist                      " don't show invisible characters by default,
                                " but it is enabled for some file types (see later)
set pastetoggle=<F2>            " when in insert mode, press <F2> to go to
                                "    paste mode, where you can paste mass data
                                "    that won't be autoindented
set mouse=a                     " enable using the mouse if terminal emulator
                                "    supports it (xterm does)
set fileformats="unix,dos,mac"
set formatoptions+=1            " When wrapping paragraphs, don't end lines
                                "    with 1-letter words (looks stupid)
set formatoptions-=o            " dont continue comments when pushing o/O
set splitbelow
set splitright
set nrformats-=octal

set ttimeout
set ttimeoutlen=50

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Folding
set foldmethod=indent
set foldnestmax=1
set foldlevel=0
set foldcolumn=0
set foldlevelstart=99
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo " which commands trigger auto-unfold

" Editor layout
set encoding=utf-8
set termencoding=utf-8
set lazyredraw    " don't update the display while executing macros
set linespace=4   " add some line space for easy reading

" Auto complete setting
set completeopt=longest,menuone
set wildmode=list:longest,full
set wildmenu
set wildignore=*~,*.o,*.a,*.obj,*.bak,*.pyc,*.class
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*/.rbenv/**
set wildignore+=.git,.hg,.svn
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.png,*.jpg,*.gif,*.ico,*.bmp

" Vim behaviour {{{
  " Allow changing buffer without saving it first
  set hidden

  set switchbuf=useopen           " reveal already opened files from the
                                  " quickfix window instead of opening new
                                  " buffers
  set history=10000               " remember more commands and search history
  set undolevels=1000             " use many muchos levels of undo
  if v:version >= 730
    set undofile                  " keep a persistent backup file
    set undodir=~/tmp,/tmp
  endif
  set nobackup                    " do not keep backup files, it's 70's style cluttering
  set noswapfile                  " do not write annoying intermediate swap files,
                                  "    who did ever restore from swap files anyway?
  set directory=~/tmp,/tmp        " store swap files in one of these directories
                                  "    (in case swapfile is ever turned on)
  set viminfo='20,\"80            " read/write a .viminfo file, don't store more
                                  "    than 80 lines of registers


  set title                       " change the terminal's title
  set novisualbell                " don't beep
  set noerrorbells                " don't beep
  set showcmd                     " show (partial) command in the last line of the screen
                                  "    this also shows visual selection info
  set nomodeline                  " disable mode lines (security measure)
  "set ttyfast                     " always use a fast terminal
  "set cursorline                  " underline the current line, for quick orientation
  set tags+=gems.tags

  " Tame the quickfix window (open/close using F12)
  nmap <silent> <F12> :QFix<CR>

  command! -bang -nargs=? QFix call QFixToggle(<bang>0)
  function! QFixToggle(forced)
    if exists("g:qfix_win") && a:forced == 0
      cclose
      unlet g:qfix_win
    else
      copen 10
      let g:qfix_win = bufnr("$")
    endif
  endfunction

  " Restore cursor position
  if has("autocmd")
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
  endif
" }}}

" Highlighting
syntax on
set background=dark
set t_Co=16
let g:solarized_termtrans = 1
let g:solarized_termcolors = 16
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized

" Shortcuts
" Since I never use the ; key anyway, this is a real optimization for almost
" all Vim commands, since we don't have to press that annoying Shift key that
" slows the commands down
nnoremap ; :

" Avoid accidental hits of <F1> while aiming for <Esc>
map! <F1> <Esc>

" Quickly get out of insert mode without your fingers having to leave the home row
inoremap jj <Esc>

" Use Q for formatting the current paragraph (or visual selection)
vmap Q gq
nmap Q gqap

" Make possible to navigate within lines of wrapped lines
nnoremap j gj
nnoremap k gk
set fo=l

" Speed up scrolling of the viewport slightly
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nnoremap <leader>w <C-w>v<C-w>l

" Open file under cursor
map <leader>o :vertical wincmd f<CR>

" Complete whole filenames/lines with a quicker shortcut key in insert mode
imap <C-f> <C-x><C-f>
imap <C-l> <C-x><C-l>

" Quick yanking to the end of the line
nmap Y y$

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Clears the search register
nmap <silent> <leader>/ :nohlsearch<CR>

" Quick alignment of text
nmap <leader>al :left<CR>
nmap <leader>ar :right<CR>
nmap <leader>ac :center<CR>

" Pull word under cursor into LHS of a substitute (for quick search and replace)
nmap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

" Inserts the path of the currently edited file into a command
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

" Folding
nnoremap <Space> za
vnoremap <Space> za

" Reselect text that was just pasted with ,v
nnoremap <leader>v V`]

" Quickly close the current window
nnoremap <leader>q :q<CR>

" Index ctags from any project
map <Leader>ct :!ctags -R .<CR>

" tabedit shortcuts like firefox
map <leader>0 :tablast<CR>
map <leader>1 1gt
map <leader>2 2gt
map <leader>3 3gt
map <leader>4 4gt
map <leader>5 5gt
map <leader>6 6gt
map <leader>7 7gt
map <leader>8 8gt
map <leader>9 9gt
map <C-o> :tabonly<CR>
map <C-Right> <ESC>:tabnext<CR>
map <C-Left> <ESC>:tabprev<CR>
map <C-t> <ESC>:tabnew<CR>

" Status line
" always a status line
set laststatus=2

hi User1 ctermbg=Black ctermfg=Green cterm=bold
hi User2 ctermbg=Black ctermfg=DarkYellow
hi User3 ctermbg=Black ctermfg=White cterm=bold
hi User4 ctermbg=Black ctermfg=Green

set statusline=

" git current branch
set statusline+=%1*\ %{fugitive#head()}\ %*

" tail of the filename
set statusline+=%2*\ %f\ %*

" flags
set statusline+=%3*
set statusline+=%H  " help file flag
set statusline+=%M  " modified flag
set statusline+=%R  " read only flag
set statusline+=\ %*

" syntastic error sign
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" left/right separator
set statusline+=%2*%=

set statusline+=%4*
set statusline+=\ %4*
set statusline+=%{strlen(&fenc)?&fenc:&enc} " encoding
set statusline+=\ \|\ %4*
set statusline+=%{strlen(&ft)?&ft:'none'}   " filetype
set statusline+=\ \|\ %4*

" document details
set statusline+=%4*
set statusline+=%c,     " cursor column
set statusline+=%l/%L   " cursor line/total lines
set statusline+=\ %P    " percent through file
set statusline+=\ %*


" Plugins Settings
" syntastic
let g:syntastic_enable_signs=1
let g:syntastic_stl_format = ' Syntax: line:%F (%t) '

" ack
let g:ackprg="ack --with-filename --nocolor --nogroup --column --no-log"
nnoremap <leader>a :Ack

" spell check
map <leader>s :set spell<CR>
" set spelllang=en_us

" make code and open the results pane
nmap <F5> :make<CR>:copen<CR>

" dispatch
nnoremap <F6> :Dispatch<CR>

" tagbar
nnoremap <F7> :TagbarToggle<CR>

" NerdTree
"let g:NERDTreeDirArrows=0
nnoremap <F9> :NERDTreeToggle<CR>

" NerdTree commenter
map <leader>' <leader>c<space><CR>

" Ident lines
nmap <Left> <<
nmap <Right> >>
vmap <Left> <gv
vmap <Right> >gv

" Bubble single lines
nmap <Up> [e
nmap <Down> ]e

" Bubble multiple lines
vmap <Up> [egv
vmap <Down> ]egv

" supertab
let g:SuperTabDefaultCompletionType = "context"

" unite
let g:unite_source_history_yank_enable = 1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ 'tmp/',
      \ '.sass-cache',
      \ ], '\|'))

nnoremap <leader>p :Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
nnoremap <leader>f :Unite -no-split -buffer-name=files   -start-insert file<cr>
nnoremap <leader>r :Unite -no-split -buffer-name=mru     -start-insert file_mru<cr>
nnoremap <leader>o :Unite -no-split -buffer-name=outline -start-insert outline<cr>
nnoremap <leader>y :Unite -no-split -buffer-name=yank    history/yank<cr>
nnoremap <leader>b :Unite -no-split -buffer-name=buffer  buffer<cr>

" ragtag
let g:ragtag_global_maps = 1

" snippets
let g:snips_author = "Jonhnny Weslley"
let g:snips_email = "jw@jonhnnyweslley.net"

let g:gocode_gofmt_tabs = ''
let g:gocode_gofmt_tabwidth = ''

" tagbar
let g:tagbar_type_go = {
    \ 'ctagstype': 'go',
    \ 'kinds' : [
        \'p:package',
        \'c:constants:1',
        \'v:variables',
        \'t:types',
        \'f:functions'
    \]
\}


" Whitespaces
" highlight EOL whitespace with a red background except on the line you're editing
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" whitespace stripper
function! <SID>StripTrailingWhitespace()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
nmap <silent> <Leader><space> :call <SID>StripTrailingWhitespace()<CR>

" Filetypes
au BufRead,BufNewFile,BufWrite nginx.*    setf nginx
au BufRead,BufNewFile,BufWrite *.json     setf javascript
au BufRead,BufNewFile,BufWrite afiedt.buf setf sql
au BufRead,BufNewFile,BufWrite .dir_colors,.dircolors,/etc/DIR_COLORS setf dircolors
au BufRead,BufNewFile,BufWrite {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Capfile,config.ru,.caprc,.irbrc,*.rake} setf ruby
au BufRead,BufNewFile,BufWrite {*.json,,*.py,*.coffee,*.yaml,*.yml} set foldmethod=indent

" Golang
au FileType go setl noet ts=4 sw=4 tw=0 makeprg=go\ build
au BufWritePre *.go Fmt
"au BufWritePost *.go silent! !ctags -R &
