" :term bash para ejecutar una terminal
set nocompatible              " required
filetype off                  " required
"Configuraciones CD
set ignorecase
set mouse=a
"set number relativenumber nos muestra en vez del 0 en la linea actual el
"numero de la linea en el archivo
set number relativenumber
"fix splitting
set splitbelow splitright
"set hls is
"set rnu
set cursorline
set cursorcolumn
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
highlight CursorLine ctermbg=LightBlue cterm=bold guibg=#2b2b2b
highlight CursorColumn ctermbg=LightBlue cterm=bold guibg=#2b2b2b
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
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'pprovost/vim-ps1'
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
syntax on
filetype indent plugin on
set hls is
if has("autocmd")
	filetype plugin indent on
endif
" CD
map <S-Tab> :tabn<CR>
map <leader>h :sp<CR><S-a>
map <leader>v :vs<CR><S-a>
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
nnoremap <Tab> %
"------------NERDTREE-----------"
map <C-o> :NERDTreeToggle<CR>
"--------------------FZF--------------------"
"inoremap <C-f> <Esc><Esc>:BLines!<CR>
"map <C-l> <Esc><Esc>:Files!<CR>
map <S-a> <Esc><Esc>:Files! ~<CR>
map <S-f> <Esc><Esc>:BLines!<CR>
map <leader>a :Ag<CR>
"EASYMOTION
map <leader><leader>. <Plug>(easymotion-repeat)
map <leader><leader>f <Plug>(easymotion-overwin-f)
map <leader><leader>j <Plug>(easymotion-overwin-line)
map <leader><leader>k <Plug>(easymotion-overwin-line)
map <leader><leader>w <Plug>(easymotion-overwin-w)
map <leader><leader>s <Plug>(easymotion-s2)
map <leader><leader>t <Plug>(easymotion-t2)
" easymotion highlight colors
hi link EasyMotionTarget Search
hi link EasyMotionTarget2First Search
hi link EasyMotionTarget2Second Search
hi link EasyMotionShade Comment
"EASYMOTION
au! BufNewFile,BufReadPost *.{yaml,yml,tf} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
au! BufNewFile,BufReadPost *.{ps1} set filetype=p1 
autocmd FileType p1 setlocal expandtab tabstop=2 shiftwidth=2 autoindent 
au! BufNewFile,BufReadPost *.{sh,bash} set filetype=bash foldmethod=indent
autocmd FileType bash setlocal ts=2 sts=2 sw=2 expandtab
augroup exe_code
	autocmd!
	autocmd FileType p1 nnoremap <buffer> <localleader>r
				\ :sp<CR> :term powershell %<CR> :startinsert<CR>
augroup END
