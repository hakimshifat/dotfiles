set number
syntax on
set relativenumber
set laststatus=2
set mouse=a
set autoindent
:imap ii <Esc>
:imap II <Esc>
map ; :Files<CR>
nnoremap <C-a> ggVG
nnoremap <F9> :Test<CR>
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
set clipboard=unnamedplus
:autocmd BufNewFile *.cpp 0r ~/cp/template.cpp
nnoremap <C-b> :w<CR>:!g++ % -o %:r && ./%:r<CR>

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <leader>ee :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

call plug#begin()

Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jiangmiao/auto-pairs'
Plug 'tomasr/molokai'
Plug 'searleser97/cpbooster.vim'
Plug 'preservim/nerdtree'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'ycm-core/YouCompleteMe'
call plug#end()
