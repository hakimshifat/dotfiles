set number
syntax on
set relativenumber
set laststatus=2
set mouse=a
set autoindent

"Copy to clipboard
set clipboard=unnamedplus

"Pressing ii or II to exit Visual Mode
:imap ii <Esc>
:imap II <Esc>

"Finding Files usint ";" Key
map ; :Files<CR>

"Ctrl+A to Select All
nnoremap <C-S-a> ggVG

"Using CpBoosters RunTestCase
nnoremap <F9> :Test<CR>

"Setting Leader Key to Space
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

"For Compiling and Running C and C++ Files
nnoremap <C-b> :w<CR>:!g++ % -o %:r && ./%:r<CR>

"NerdTree Management
nnoremap <leader>ee :NERDTreeToggle<CR>
nnoremap <leader>ef :NERDTreeFind<CR>
nnoremap <leader>ec :NERDTreeClose<CR>
nnoremap <leader>er :NERDTreeToggle<CR>:NERDTreeToggle<CR>

"Split Management
nnoremap <leader>sv <C-w>v
nnoremap <leader>sh <C-w>s
nnoremap <leader>se <C-w>=
nnoremap <leader>sx :close<CR>

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif



"Plugins
call plug#begin()


Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jiangmiao/auto-pairs'
Plug 'tomasr/molokai'
Plug 'searleser97/cpbooster.vim'
Plug 'preservim/nerdtree'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'uiiaoo/java-syntax.vim'


call plug#end()
