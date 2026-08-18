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
set number
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
let g:airline_theme = 'dark'

" -------------------------------
" Indentação
" -------------------------------
set autoindent
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

" Garante que as pastas acima existam (evita fallback silencioso do Vim)
if !isdirectory(expand('~/.vim/backup'))
    call mkdir(expand('~/.vim/backup'), 'p')
endif
if !isdirectory(expand('~/.vim/swap'))
    call mkdir(expand('~/.vim/swap'), 'p')
endif
if !isdirectory(expand('~/.vim/undo'))
    call mkdir(expand('~/.vim/undo'), 'p')
endif

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
" Statusline (usando guifg/guibg pois termguicolors está ativo;
" os valores cterm* antigos não tinham efeito nesse modo)
" -------------------------------
hi StatusLine guifg=#ffffff guibg=#005fff cterm=bold gui=bold
hi StatusLineNC guifg=#bcbcbc guibg=#444444

" -------------------------------
" Cor da linha do cursor (cursorline)
" -------------------------------
highlight CursorLine cterm=NONE guibg=#3a2a2a
highlight CursorLineNr cterm=bold gui=bold guifg=#ff8787 guibg=#3a2a2a

" -------------------------------
" Abrir direto em INSERT (mantido por escolha do usuário)
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
nnoremap <C-u> :silent! undo<CR>
inoremap <C-u> <Esc>:silent! undo<CR>
nnoremap <C-y> <C-r>
inoremap <C-y> <Esc><C-r>

" limpar highlight de busca
nnoremap <leader><space> :nohlsearch<CR>

" abrir e recarregar config
nnoremap <leader>v :e ~/.vimrc<CR>
nnoremap <leader>r :source ~/.vimrc<CR>

" Formatter shell
nnoremap <C-_> :%!shfmt -i 1 -ci -sr<CR>

" Sair rápido (mantido por escolha do usuário — atenção: sobrescreve a
" gravação de macro nativa da tecla q)
map q :quit<CR>
