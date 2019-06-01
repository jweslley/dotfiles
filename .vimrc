" Vim-PLug core
let vimplug_exists=expand('~/.vim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

Plug 'Shougo/vimproc.vim', {'do': 'make'}

" Fuzzy search
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'
Plug 'mileszs/ack.vim'

" colorscheme
Plug 'altercation/vim-colors-solarized'

" whitespaces
Plug 'bronson/vim-trailing-whitespace'

" comments
Plug 'tpope/vim-commentary'

" file browsing
Plug 'scrooloose/nerdtree'

" syntax checker
Plug 'scrooloose/syntastic'

" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'airblade/vim-gitgutter'

" shell
Plug 'tpope/vim-dispatch'

" Editing
Plug 'ervandew/supertab'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'kana/vim-smartinput'
Plug 'godlygeek/tabular'

" Snippets
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" Programming languages
Plug 'fatih/vim-go'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-ragtag'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'derekwyatt/vim-scala'

" File types
Plug 'tpope/vim-markdown'
Plug 'slim-template/vim-slim'
Plug 'kchmck/vim-coffee-script'


"" Include user's extra bundle
if filereadable(expand("~/.vimrc.local.bundles"))
  source ~/.vimrc.local.bundles
endif

call plug#end()

" Required: Enable detection, plugins and indenting in one step
filetype plugin indent on


" General settings =============================================================

set number
set showcmd
set showmode
set showmatch
set hidden
set autoread
set autowriteall
set splitbelow splitright
set lazyredraw
set mouse=a
set pastetoggle=<F2>
set nrformats-=octal
set fileformats="unix,dos,mac"
set switchbuf=useopen
set history=100
set viminfo='20,\"80
set shell=/bin/bash
"set ruler
"set colorcolumn=81
"set cursorline

" Encoding
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set binary
set bomb

" Fix backspace indent
set backspace=indent,eol,start

" Tabs
set smarttab
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Turn backup off
set nobackup
set noswapfile
set nowritebackup

" Highlighting
syntax on
set background=dark
set t_Co=256
set t_ut=
let g:solarized_termtrans = 1
let g:solarized_termcolors = 16
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized

" Lower the delay of escaping out of other modes
set timeout timeoutlen=1000 ttimeoutlen=0

" Text display settings
set wrap
set showbreak=...
set linebreak
set linespace=4
set whichwrap+=h,l,<,>,[,]

" Don't show invisible characters
set nolist
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" Indenting
set autoindent
set copyindent
set shiftround

" Scrolling
set scrolloff=10
set scrolljump=3
set sidescrolloff=10
set sidescroll=1

" Folding
set foldmethod=indent
set foldnestmax=5
set foldlevel=5
set foldcolumn=0
set foldlevelstart=99
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo " which commands trigger auto-unfold

" Turn bells off
set novisualbell
set noerrorbells

" Auto complete
set completeopt=longest,menuone
set wildmode=list:longest,full
set wildmenu
set wildignore=*~,*.o,*.a,*.so,*.bak,*.pyc,*.class,*.db,*.sqlite
set wildignore+=*.gem,*.jar,*.zip,*.gz
set wildignore+=.git,.hg,.svn
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.png,*.jpg,*.gif,*.ico,*.bmp,*.pdf


" Status line ==================================================================
" always a status line
set laststatus=2

hi User1 ctermbg=Black ctermfg=Green cterm=bold
hi User2 ctermbg=Black ctermfg=DarkGreen
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


" Shortcuts ====================================================================

" Map leader to ,
" let mapleader=','

nnoremap ; :

" Avoid accidental hits of <F1> while aiming for <Esc>
map! <F1> <Esc>

" Quickly get out of insert mode without your fingers having to leave the home row
inoremap jj <Esc>

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

" Switch to previous split
nnoremap <leader>l <C-w>p

" Maximize current split
nnoremap <Leader>m <C-w>_<C-w><Bar>

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

" Folding
nnoremap <Space> za
vnoremap <Space> za

" Reselect text that was just pasted with ,v
nnoremap <leader>v V`]

" Quickly close the current window
nnoremap <leader>q :q<CR>

" Quit all, very useful in vimdiff
nnoremap Q :qa!<cr>

" Index ctags from any project
map <leader>ct :!ctags -R .<CR>

" spell check
map <leader>s :set spell<CR>
"set spelllang=en_us

" make code and open the results pane
nmap <F5> :make<CR>:copen<CR>

" tabedit shortcuts
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
map <leader>j :tabprev<CR>
map <leader>k :tabnext<CR>
map <C-t> <ESC>:tabnew<CR>
"map <C-o> :tabonly<CR>


" Plugins settings =============================================================

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_stl_format = ' Syntax: line:%F (%t) '
let g:syntastic_python_checkers = []

" ack
let g:ackprg="ack --with-filename --nocolor --nogroup --nopager --column --no-log"
nnoremap <leader>a :Ack
" search for word under cursor
nnoremap K :Ack "\b<C-R><C-W>\b"<CR>:cw<CR>"

" dispatch
nnoremap <F6> :Dispatch<CR>

" NerdTree
" let g:NERDTreeMinimalUI=1
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"
let g:NERDTreeIgnore=['\~$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
nnoremap <F9> :NERDTreeToggle<CR>
noremap <silent> <F10> :NERDTreeFind<CR>

" commentary
map <leader>' :Commentary<CR>

" Indent lines
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

" Matchit: Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

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

" golang
" let g:go_bin_path = expand("~/bin")
let g:go_fmt_command = "goimports"
let g:go_dispatch_enabled = 1


" rails
let g:rails_gem_projections = {
  \ "credishop": {
  \   "app/relatorios/*.rb": {
  \     "command": "relatorio",
  \     "alternate": "app/views/relatorios/{}.html.slim",
  \     "template": "class Relatorio < Credishop::Relatorio::Base\nend" },
  \   "app/servicos/*.rb": {
  \     "command": "servico",
  \     "alternate": "app/views/servicos/{}.html.slim",
  \     "template": "class Servico < Credishop::Servico::Base\nend" }}}



" Whitespaces ==================================================================
nmap <silent> <Leader><space> :FixWhitespace<CR>

" Quickfix window (open/close using F12) =======================================
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

" Restore cursor position ======================================================
if has("autocmd")
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup templates
    autocmd BufNewFile *_controller.rb 0r ~/.vim/templates/rails_controller.rb
  augroup END
endif

" Filetypes ====================================================================
au BufRead,BufNewFile,BufWrite nginx.*    setf nginx
au BufRead,BufNewFile,BufWrite *.json     setf javascript
au BufRead,BufNewFile,BufWrite afiedt.buf setf sql
au BufRead,BufNewFile,BufWrite .dir_colors,.dircolors,/etc/DIR_COLORS setf dircolors
au BufRead,BufNewFile,BufWrite {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Capfile,config.ru,.caprc,.irbrc,*.rake} setf ruby
au BufRead,BufNewFile,BufWrite {*.json,,*.py,*.coffee,*.yaml,*.yml} set foldmethod=indent

" Golang
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <Leader>i <Plug>(go-import)
au FileType go nmap gd <Plug>(go-def)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)

