" Modern Vim configuration for Vim 9+.
" Plugin management intentionally stays on vim-plug for Vim compatibility.

scriptencoding utf-8

if &compatible
  set nocompatible
endif

let mapleader = "\<Space>"
let maplocalleader = ","

" Bootstrap vim-plug. Plugin installation still requires network access.
let s:plug_dir = expand('~/.vim/autoload')
let s:plug_file = s:plug_dir . '/plug.vim'
let s:plug_bootstrapped = 0
if empty(glob(s:plug_file)) && !exists('g:skip_plug_bootstrap')
  silent execute '!curl -fLo ' . shellescape(s:plug_file) .
        \ ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >/dev/null 2>&1'
  let s:plug_bootstrapped = !empty(glob(s:plug_file))
endif

if !empty(glob(s:plug_file))
  call plug#begin('~/.vim/plugged')

  " Navigation and search
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " Editing primitives
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'jiangmiao/auto-pairs'
  Plug 'bronson/vim-trailing-whitespace'

  " Git and diagnostics
  Plug 'tpope/vim-fugitive'
  Plug 'dense-analysis/ale'

  " Language support
  Plug 'sheerun/vim-polyglot'
  Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'javascript', 'typescript', 'vue'] }

  " Markdown preview
  Plug 'tyru/open-browser.vim'
  Plug 'kannokanno/previm', { 'for': 'markdown' }

  " Theme
  Plug 'jacoborus/tender.vim'

  call plug#end()

  if s:plug_bootstrapped
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

filetype plugin indent on
syntax enable

" Core behavior
set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start
set hidden
set autoread
set updatetime=300
set timeoutlen=500
set history=10000
set clipboard=unnamedplus
set mouse=a
set title
set confirm
set wildmenu
set wildmode=longest:full,full
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set signcolumn=yes
set cmdheight=1
set laststatus=2
set showcmd
set showmatch

" Files and undo
set nobackup
set nowritebackup
set noswapfile
set undofile
if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p')
endif
set undodir^=~/.vim/undo//

" UI
set number
set relativenumber
set cursorline
set scrolloff=5
set sidescrolloff=8
set splitbelow
set splitright
set linebreak
set breakindent
set list
set listchars=tab:>-,trail:.,extends:>,precedes:<,nbsp:+
set visualbell
set noerrorbells

if has('termguicolors')
  set termguicolors
endif

silent! colorscheme tender

" Indentation defaults. Filetype plugins can override these.
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan

" Grep uses ripgrep when available.
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
endif

" Faster movement on wrapped lines.
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" Window navigation
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" fzf.vim
let g:fzf_layout = { 'down': '40%' }
let g:fzf_vim = get(g:, 'fzf_vim', {})
let g:fzf_vim.preview_window = ['right,50%,<70(up,40%)', 'ctrl-/']
let $FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --border'
if executable('fd')
  let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
endif

nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>F :GFiles<CR>
nnoremap <silent> <leader>g :Rg<Space>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :History<CR>
nnoremap <silent> <leader>m :Marks<CR>
nnoremap <silent> <leader>t :Tags<CR>

" ALE: lightweight diagnostics and fixer integration.
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 0
let g:ale_open_list = 0
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_delay = 500
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_linters_explicit = 0
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'javascript': ['prettier'],
      \ 'typescript': ['prettier'],
      \ 'vue': ['prettier'],
      \ 'json': ['prettier'],
      \ 'markdown': ['prettier'],
      \ 'python': ['ruff', 'black'],
      \ 'sh': ['shfmt'],
      \ }

nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gr :ALEFindReferences<CR>
nnoremap <silent> K :ALEHover<CR>
nnoremap <silent> [d :ALEPrevious<CR>
nnoremap <silent> ]d :ALENext<CR>
nnoremap <silent> <leader>d :ALEDetail<CR>
nnoremap <silent> <leader>x :ALEFix<CR>

" Markdown preview
let g:previm_open_cmd = ''
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,markdown} set filetype=markdown
nnoremap <silent> <leader>p :PrevimOpen<CR>

" Project-specific legacy filetypes.
autocmd BufRead,BufNewFile *.{launch,urdf,world,sdf} setfiletype xml

" Convenience commands
command! ReloadVimrc source $MYVIMRC
command! PlugSync PlugInstall | PlugUpdate
