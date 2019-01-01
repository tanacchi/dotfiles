" setting

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Color settings
NeoBundle 'jacoborus/tender.vim'
NeoBundle 'freeo/vim-kalisi'

" Comment out tool
NeoBundle 'scrooloose/nerdcommenter'

" C++ syntax highlighting
NeoBundle 'vim-jp/vim-cpp'

" MarkDown preview
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'kannokanno/previm'

" For easy comment out
" <leader>c<Space>
NeoBundle 'scrooloose/nerdcommenter'

" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

"文字コードをUFT-8に設定
set fenc=utf-8

" バックアップファイルを作らない
set nobackup

" スワップファイルを作らない
set noswapfile

" 編集中のファイルが変更されたら自動で読み直す
set autoread

" バッファが編集中でもその他のファイルを開けるように
set hidden

" 入力中のコマンドをステータスに表示する
set showcmd


" 見た目系
" 行番号を表示
set number

" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore

" インデントはスマートインデント
set autoindent

" ビープ音を可視化
set visualbell

" 括弧入力時の対応する括弧を表示
set showmatch

" ステータスラインを常に表示
set laststatus=2

" コマンドラインの補完
set wildmode=list:longest

" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk

" 色設定
" If you have vim >=8.0 or Neovim >= 0.1.5
" if (has("termguicolors"))
"   set termguicolors
" endif
" " For Neovim 0.1.3 and 0.1.4
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" 
" " Theme
" syntax enable
" colorscheme tender

" colorscheme kalisi
" set background=dark
colorscheme elflord

hi LineNr term=NONE cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" Tab系
" Tab文字を半角スペースにする
set expandtab

" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2

" 行頭でのTab文字の表示幅
set shiftwidth=2


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" 検索語をハイライト表示
set hlsearch

" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" ビープの動作を無効化
set visualbell t_vb=
set noerrorbells

" Previm 
" Space-p で MarkDown のプレビュー

autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown

let g:previm_open_cmd = ''
nnoremap [previm] <Nop>
nmap <Space>p [previm]
nnoremap <silent> [previm] :<C-u>PrevimOpen<CR>
