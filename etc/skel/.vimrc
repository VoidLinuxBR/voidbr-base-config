" VIMRC - rápido, limpo e forte
" ===============================

set nocompatible
filetype plugin indent on
syntax on

" -------------------------------
" Interface
" -------------------------------
set nu!
set ruler
set showcmd
set showmatch
set cursorline
set title
set laststatus=2
set confirm
set showmode
" color murphy

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" Configuração do airline
let g:airline_theme = 'voidbrairline'
let g:airline_voidbrairline_showmod = 1

" -------------------------------
" Indentação
" -------------------------------
set autoindent
set incsearch
set smartindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" -------------------------------
" Busca
" -------------------------------
set ignorecase
set smartcase
set incsearch
set hlsearch

" -------------------------------
" Arquivos
" -------------------------------
set nobackup
set nowritebackup
set noswapfile
set hidden

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undofile

" -------------------------------
" Performance
" -------------------------------
set ttyfast
set lazyredraw
set updatetime=300

" -------------------------------
" Visual
" -------------------------------
set background=dark
set termguicolors
set scrolloff=5
set sidescrolloff=5

" -------------------------------
" Quebra de linha
" -------------------------------
set wrap
set linebreak
set breakindent

" -------------------------------
" Mouse e clipboard
" -------------------------------
set mouse=a
set clipboard=unnamedplus

" -------------------------------
" Encoding
" -------------------------------
set encoding=utf-8
set fileencoding=utf-8

" -------------------------------
" Color column
" -------------------------------
set colorcolumn=80,100,120
highlight ColorColumn guibg=#3a0000

" -------------------------------
" Statusline
" -------------------------------
hi StatusLine ctermfg=231 ctermbg=31 cterm=bold
hi StatusLineNC ctermfg=250 ctermbg=238

set statusline=
set statusline+=\ %f
set statusline+=\ %m
set statusline+=\ %r
set statusline+=\ %=
set statusline+=\ %y
set statusline+=\ [%{&fileencoding}]
set statusline+=\ %l:%c
set statusline+=\ %p%%

" -------------------------------
" Abrir direto em INSERT
" -------------------------------
autocmd VimEnter * startinsert
:
" -------------------------------
" Navegação em linhas longas
" -------------------------------
nnoremap j gj
nnoremap k gk

" -------------------------------
" Copiar e colar
" -------------------------------
vnoremap <C-c> "+y
nnoremap <C-v> "+p

" -------------------------------
" Atalhos principais
" -------------------------------

" buscar
nnoremap <C-w> /
inoremap <C-w> <Esc>/

" próxima ocorrência
nnoremap <C-l> n

" salvar
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" sair
nnoremap <C-q> :q<CR>
inoremap <C-q> <Esc>:q<CR>

" salvar e sair
nnoremap <C-x> :x<CR>
inoremap <C-x> <Esc>:x<CR>

" deletar linha
nnoremap <C-k> dd
inoremap <C-k> <Esc>ddi

" undo / redo
nnoremap <C-u> u
inoremap <C-u> <Esc>u
nnoremap <C-y> <C-r>

" limpar highlight de busca
nnoremap <leader><space> :nohlsearch<CR>

" abrir config
nnoremap <leader>v :e ~/.vimrc<CR>

" recarregar config
nnoremap <leader>r :source ~/.vimrc<CR>

" -------------------------------
" Formatter shell
" -------------------------------
    nnoremap <C-_> :%!shfmt -i 1 -ci -sr<CR>

    " apagar linha
nnoremap <C-k> dd
inoremap <C-k> <Esc>ddi

" desfazer (trazer linha de volta)
nnoremap <C-u> u
inoremap <C-u> <Esc>u

" re  f
nnoremap <C-y> <C-r>
inoremap <C-y> <Esc><C-r>

nnoremap <C-e> D
inoremap <C-e> <Esc>Di

map q :quit<CR>
