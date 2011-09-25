" This was just for windows...
" For some reason... the removal of the <C-V> seems to have permanently happened
" The original map is in vim72/mswin.vim
" lmap <C-V> :normal "+gP

" Pathogen needs to be set up before syntax is set on
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" General Vim setup

" Show me some of what you know!
syntax on
set ruler

" Always allow backspae
set bs=2

" This will wrap at 80 chars
set tw=80

" Let vim pick my indentation strategy
filetype indent on
filetype plugin on
"set autoindent
"set smartindent
"set copyindent

" Because microsoft is dumb, they still put \r at the end of text files
set fileformats=unix,dos,mac

" y, d, p and co. use the system clipboard by default
" on X11, this ends up being the "selection" buffer (i.e., selected with a
" mouse) instead of the cut-buffer (i.e., selected with ctrl-x somewhere)
" If you end up caring about X11, you can set up a conditional and set to
" unnamedplus instead
set clipboard=unnamed

" Setups that vary from filetype to filetype

" Ideal for python, what else?
set ts=4
set sw=4
set expandtab
set smarttab

" But we want real tabs for makefiles!
autocmd FileType make setlocal noexpandtab

" I am generally using LaTeX if a file ends in .tex
" Currently, I use LatexBox, but I think it might not be my fave (doesn't handle
" Sweave very well, for example).
let g:tex_flavor='latex'
let g:LatexBox_viewer='/Applications/Skim.app/Contents/MacOS/Skim'
