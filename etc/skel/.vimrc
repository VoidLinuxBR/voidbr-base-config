" VIMRC - rápido, limpo e forte
" ===============================

set nocompatible
filetype plugin indent on
syntax on

" Silenciar avisos de clipboard e outros durante o boot
set shortmess+=I
set shortmess+=O

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

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" Configuração do airline
" Tente usar um tema existente. Se 'voidbrairline' for um tema customizado seu,
" verifique se o arquivo está em ~/.vim/plugged/vim-airline-themes/autoload/airline/themes/
let g:airline_theme = 'dark' 
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

" Tenta usar o clipboard, mas não reclama se falhar
if has('clipboard')
    set clipboard=unnamedplus
endif

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
" Statusline (Sobrescreve o Airline se não for desativado)
" -------------------------------
hi StatusLine ctermfg=231 ctermbg=31 cterm=bold
hi StatusLineNC ctermfg=250 ctermbg=238

" -------------------------------
" Abrir direto em INSERT
" -------------------------------
autocmd VimEnter * startinsert

" -------------------------------
" Navegação e Atalhos
" -------------------------------
nnoremap j gj
nnoremap k gk

" Copiar e colar (só funcionará se o Vim tiver suporte a clipboard)
vnoremap <C-c> "+y
nnoremap <C-v> "+p

" buscar
nnoremap <C-w> /
inoremap <C-w> <Esc>/

" salvar e sair
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
nnoremap <C-q> :q<CR>
inoremap <C-q> <Esc>:q<CR>
nnoremap <C-x> :x<CR>
inoremap <C-x> <Esc>:x<CR>

" deletar linha
nnoremap <C-k> dd
inoremap <C-k> <Esc>ddi

" undo / redo
nnoremap <C-u> u
inoremap <C-u> <Esc>u
nnoremap <C-y> <C-r>
inoremap <C-y> <Esc><C-r>

" limpar highlight de busca
nnoremap <leader><space> :nohlsearch<CR>

" abrir e recarregar config
nnoremap <leader>v :e ~/.vimrc<CR>
nnoremap <leader>r :source ~/.vimrc<CR>

" Formatter shell
nnoremap <C-_> :%!shfmt -i 1 -ci -sr<CR>

map q :quit<CR>
