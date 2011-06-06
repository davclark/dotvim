" I think this was just for windows...
" For some reason... the removal of the <C-V> seems to have permanently happened
" The original map is in vim72/mswin.vim
" lmap <C-V> :normal "+gP

" Show me some of what you know!
syntax on
set ruler

" Ideal for python, what else?
set ts=4
set sw=4
set expandtab
set smarttab

" But not good for makefiles!
autocmd FileType make setlocal noexpandtab

" I pretty much am using LaTeX if a file ends in .tex
let g:tex_flavor='latex'

" Always allow backspae
set bs=2

" This will wrap at 80 chars
set tw=80

" Let vim pick my indentation strategy
filetype indent on
"set autoindent
"set smartindent
"set copyindent
