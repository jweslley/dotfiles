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


" Fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" colorscheme
Plug 'altercation/vim-colors-solarized'

" syntax checker
Plug 'w0rp/ale'

" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'airblade/vim-gitgutter'

" shell
Plug 'tpope/vim-dispatch'
Plug 'Shougo/vimproc.vim', {'do': 'make'}

" editing
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'kana/vim-smartinput'
Plug 'godlygeek/tabular'
Plug 'bronson/vim-trailing-whitespace'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree'
Plug 'mileszs/ack.vim'
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --all' }

" vim-session
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

" snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" programming languages
" go
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}

" javascript
Plug 'jelera/vim-javascript-syntax'

" python
Plug 'davidhalter/jedi-vim'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

" ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-ragtag'

" scala
Plug 'derekwyatt/vim-scala'

" file types
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

set relativenumber
set number
set showcmd
set showmode
set showmatch
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
set ttyfast
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

" Enable hidden buffers
set hidden

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
silent! colorscheme solarized

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
set wildmode=list:longest,list:full
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


" Mappings  ====================================================================

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

" session management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

" ale
let g:ale_linters = {
\  "go": ['golint', 'go vet'],
\ }

" ack
let g:ackprg="ack --with-filename --nocolor --nogroup --nopager --column --no-log"
nnoremap <leader>a :Ack
" search for word under cursor
nnoremap K :Ack "\b<C-R><C-W>\b"<CR>:cw<CR>"

" dispatch
nnoremap <F6> :Dispatch<CR>

" NerdTree
" let g:NERDTreeMinimalUI=1
let g:NERDTreeChDirMode=2
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"
let g:NERDTreeIgnore=['\~$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '__pycache__', '\.pyc$']
nnoremap <silent> <F9> :NERDTreeToggle<CR>
nnoremap <silent> <F10> :NERDTreeFind<CR>

" snippets
let g:UltiSnipsExpandTrigger="<c-space>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

" YouCompleteMe
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_max_num_candidates = 20
let g:ycm_max_num_identifier_candidates = 10
let g:ycm_semantic_triggers =  {
\ 'ruby,rust': ['.', '::'],
\ }

" fzf
let $FZF_DEFAULT_COMMAND = 'ack -f'

" maps fzf
map <Leader>fo :Files<CR>
map <Leader>fb :Buffers<CR>
map <Leader>fw :Windows<CR>
map <Leader>ft :BTags<CR>
map <Leader>fs :Ag<CR>

command! -bang -nargs=* Ag
  \ call fzf#vim#grep('ack -f'.shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview(),
  \ <bang>0)

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

" ragtag
let g:ragtag_global_maps = 1

" javascript
let g:javascript_enable_domhtmlcss = 1

" jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "0"
" let g:jedi#completions_command = "<C-Space>"
let g:jedi#smart_auto_mappings = 0

" ruby
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" golang
" let g:go_bin_path = expand("~/bin")
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_dispatch_enabled = 1

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 1



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


" Autocmd rules ================================================================

" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

augroup templates
  autocmd BufNewFile *_controller.rb 0r ~/.vim/templates/rails_controller.rb
augroup END


au BufRead,BufNewFile,BufWrite nginx.*    setf nginx
au BufRead,BufNewFile,BufWrite *.json     setf javascript
au BufRead,BufNewFile,BufWrite afiedt.buf setf sql
au BufRead,BufNewFile,BufWrite .dir_colors,.dircolors,/etc/DIR_COLORS setf dircolors
au BufRead,BufNewFile,BufWrite {*.json,,*.py,*.coffee,*.yaml,*.yml} set foldmethod=indent

augroup ruby
  autocmd!
  autocmd BufNewFile,BufRead *.rb,*.rake,*.gemspec,Gemfile,Rakefile,config.ru setlocal filetype=ruby
  autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab softtabstop=2
augroup END

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" Golang
augroup go
  au!
  au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

  au FileType go nmap <Leader>dd <Plug>(go-def-vertical)
  au FileType go nmap <Leader>dv <Plug>(go-doc-vertical)
  au FileType go nmap <Leader>db <Plug>(go-doc-browser)

  au FileType go nmap <leader>r  <Plug>(go-run)
  au FileType go nmap <leader>t  <Plug>(go-test)
  au FileType go nmap <Leader>gt <Plug>(go-coverage-toggle)
  au FileType go nmap <Leader>i <Plug>(go-info)
  au FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)
  au FileType go nmap <C-g> :GoDecls<cr>
  au FileType go nmap <leader>dr :GoDeclsDir<cr>
  au FileType go imap <C-g> <esc>:<C-u>GoDecls<cr>
  au FileType go imap <leader>dr <esc>:<C-u>GoDeclsDir<cr>
  au FileType go nmap <leader>rb :<C-u>call <SID>build_go_files()<CR>

  au BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
augroup END


" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
