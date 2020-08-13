set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tmhedberg/SimpylFold'
Plugin 'scrooloose/nerdtree'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'Valloric/YouCompleteMe'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'easymotion/vim-easymotion'
" " add all your plugins here (note older versions of Vundle
" " used Bundle instead of Plugin)
"
" " ...
"
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"
"set number
set rnu
syntax on
filetype indent plugin on
set hls is
if has("autocmd")
        filetype plugin indent on
endif
" CD
map <S-Tab> :tabn<CR>
if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
nnoremap <Tab> %
"------------NERDTREE-----------"
map <C-o> :NERDTreeToggle<CR>
"--------------------FZF--------------------"
"inoremap <C-f> <Esc><Esc>:BLines!<CR>
"map <C-l> <Esc><Esc>:Files!<CR>
map <S-a> <Esc><Esc>:Files!<CR>
map <S-f> <Esc><Esc>:BLines!<CR>
"EASYMOTION
map <leader><leader>. <Plug>(easymotion-repeat)
map <leader><leader>f <Plug>(easymotion-overwin-f)
map <leader><leader>j <Plug>(easymotion-overwin-line)
map <leader><leader>k <Plug>(easymotion-overwin-line)
map <leader><leader>w <Plug>(easymotion-overwin-w)
