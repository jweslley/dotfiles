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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" colorscheme
Plug 'altercation/vim-colors-solarized'

" git
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'kana/vim-smartinput'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'bogado/file-line'
Plug 'ludovicchabant/vim-gutentags'

" snippets
Plug 'honza/vim-snippets'

" programming languages
" go
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }

" python
Plug 'davidhalter/jedi-vim', { 'for': 'python' }

" rails
Plug 'tpope/vim-rails'

" css
Plug 'ap/vim-css-color', { 'for': ['css'] }

" language pack
Plug 'sheerun/vim-polyglot'

" writing
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Goyo' }


"" Include user's extra bundle
if filereadable(expand("~/.vimrc.local.bundles"))
  source ~/.vimrc.local.bundles
endif

call plug#end()

" Required: Enable detection, plugins and indenting in one step
filetype plugin indent on


" General settings =============================================================

" set relativenumber
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
set shortmess+=c
set signcolumn=yes
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

" save automatically
set updatetime=300
au CursorHold * silent! update

" Status line ==================================================================
" always a status line
set laststatus=2

hi User1 ctermbg=Black ctermfg=Green cterm=bold
hi User2 ctermbg=Black ctermfg=DarkGreen
hi User3 ctermbg=Black ctermfg=White cterm=bold
hi User4 ctermbg=Black ctermfg=Green

set statusline=

" git current branch
set statusline+=%1*\ %{FugitiveStatusline()}\ %*

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

" Move line
nnoremap <silent> <Down> @='"zdd"zp'<CR>
nnoremap <silent> <Up>   @='k"zdd"zpk'<CR>
vnoremap <silent> <Down> @='"zx"zp`[V`]'<CR>
vnoremap <silent> <Up>   @='"zxk"zP`[V`]'<CR>


" Plugins settings =============================================================

" SignColumn
highlight SignColumn ctermbg=Black

" netrw
" % new file
" d new directory
" D delete file/directory
" R rename
" -- C-f quickfix modal
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = 20
let g:netrw_list_hide='.pyc,.git/,tmp/,.bundle/,.cache/,node_modules/,.node-gyp,.yarn'

nnoremap - :Explore<CR>
noremap <Leader><space> :Lexplore<CR>


" fzf
" default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~50%' }

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history
let g:fzf_history_dir = '~/.local/share/fzf-history'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

"[Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter'

" maps fzf
map <Leader>o :Files<CR>
map <Leader>b :Buffers<CR>
map <Leader>fg :GFiles?<CR>
map <Leader>fG :GFiles<CR>
map <Leader>fl :BLines<CR>
map <Leader>fL :Lines<CR>
map <Leader>fH :History/<CR>
map <Leader>h :History<CR>
map <Leader>l :BTags<CR>
map <Leader>t :Tags<CR>
map <Leader>a :Rg<CR>

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)


" commentary
map <leader>' :Commentary<CR>

" coc
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'
let g:coc_global_extensions = ['coc-snippets', 'coc-tabnine', 'coc-solargraph', 'coc-tsserver', 'coc-eslint', 'coc-prettier', '@yaegassy/coc-tailwindcss3']
let g:coc_disable_startup_warning = 1

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-@> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>

" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>rc  <Plug>(coc-codeaction-cursor)

" Remap keys for apply code actions affect whole buffer
nmap <leader>rs  <Plug>(coc-codeaction-source)

" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Add `:OI` command for organize imports of the current buffer
command! -nargs=0 OI :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Run :Prettier to format the current buffer by coc-prettier
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


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
let g:rails_projections = {
  \ "app/components/*/component.rb": {
  \   "command": "component",
  \   "alternate": ["spec/components/{}/component_spec.rb"],
  \   "related": ["app/components/{}/component.html.slim"],
  \   "test": ["spec/components/{}/component_spec.rb"],
  \   "rubyMacro": ["process", "version"]
  \ },
  \ "app/services/*.rb": {
  \   "command": "service",
  \   "alternate": ["spec/services/{}_spec.rb"],
  \   "test": ["spec/services/{}_spec.rb"],
  \  "template": ["# frozen_string_literal: true", "", "class {camelcase|capitalize|colons} < ApplicationService", "end"],
  \   "rubyMacro": ["process", "version"]
  \ },
  \ "app/controllers/*_controller.rb": {
  \   "command": "controller",
  \   "alternate": [
  \     "spec/requests/{}_spec.rb"],
  \   "test": [
  \     "spec/requests/{}_spec.rb"
  \   ],
  \   "rubyMacro": ["process", "version"]
  \ },
  \ "spec/support/*.rb": {
  \   "command": "support"
  \ }}
" \   "alternate": [
" \     "spec/controllers/{}_controller_spec.rb"],
" \   "test": [
" \     "spec/controllers/{}_controller_spec.rb"
" \   ],
" \   "alternate": [
" \     "spec/requests/{}_spec.rb"],
" \   "test": [
" \     "spec/requests/{}_spec.rb"
" \   ],

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

" limelight

let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 120
let g:limelight_default_coefficient = 0.7
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" gutentags
let g:gutentags_add_default_project_roots = 1

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

augroup RemovingTrailingWhitespace
  autocmd!
  autocmd BufWritePre {*.rb,*.go,*.py,*.css,*.scss,*.js} %s/\s\+$//e
augroup END

augroup ShowColumn
  autocmd!
  autocmd FileType python,slim set cursorcolumn
augroup END

augroup CallInterpreter
  let b:cmd = ''

  autocmd!
  autocmd FileType go     let b:cmd = 'go %'
  autocmd FileType python let b:cmd = 'python %'
  autocmd FileType ruby   let b:cmd = 'docker-compose run --rm web bundle exec rails %'
  autocmd FileType sh     let b:cmd = 'bash %'

  nnoremap <F9>  :execute ':below terminal ++rows=10 '.b:cmd<CR>
  nnoremap <F10> :make<CR>
  nnoremap <F11> :make test<CR>
augroup END

augroup MakeQuickFix
  autocmd!
  autocmd QuickFixCmdPost * :copen
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

  au FileType go nmap <leader>gr  <Plug>(go-run)
  au FileType go nmap <leader>gt  <Plug>(go-test)
  au FileType go nmap <Leader>gt <Plug>(go-coverage-toggle)
  au FileType go nmap <Leader>gi <Plug>(go-info)
  au FileType go nmap <silent> <Leader>gl <Plug>(go-metalinter)
  au FileType go nmap <C-g> :GoDecls<cr>
  au FileType go nmap <leader>dr :GoDeclsDir<cr>
  au FileType go imap <C-g> <esc>:<C-u>GoDecls<cr>
  au FileType go imap <leader>dr <esc>:<C-u>GoDeclsDir<cr>
  au FileType go nmap <leader>rb :<C-u>call <SID>build_go_files()<CR>

  au BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
augroup END

augroup vimrc-auto-mkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir)
          \   && (a:force
          \       || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END


" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'vim']
