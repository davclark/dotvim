" This was just for windows...
" For some reason... the removal of the <C-V> seems to have permanently happened
" The original map is in vim72/mswin.vim
" lmap <C-V> :normal "+gP

" Here we temporarily disable simplenote, because it's not working very well
let g:pathogen_disabled = ['simplenote']

" Pathogen needs to be set up before syntax is set on
" Just call :Helptags when you install a new file
" call pathogen#helptags()
call pathogen#infect()

" General Vim setup

" Let vim pick my indentation strategy, etc.
filetype plugin indent on
"set autoindent
"set smartindent
"set copyindent

" Strangely, while this is a standard part of Vim 6.0+, it is not enabled by
" default. Makes e.g., Ruby block matching work. It should be clearer that
" ruby-matchit is NOT the right solution here
runtime macros/matchit.vim

" Show me some of what you know!
set ruler

" Seems to be necessary for colors in terminal mode (not GUI)
syntax on
" For OS X, be sure to install the matching terminal theme
" https://github.com/tomislav/osx-lion-terminal.app-colors-solarized
colorscheme solarized
if has('gui_running')
    set background=light
else
    set background=dark
endif

" Always allow backspae
set bs=2

" This will wrap at 80 chars
set tw=80


" Because microsoft is dumb, they still put \r at the end of text files on a mac
" So, despite it's otherwise dead-ness, we need mac
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

" Generally only useful when called from the autocmd below
function! RestoreCursorPos()
    if line("'\"") > 1 && line("'\"") <= line("$") 
        exe "normal! g`\"" 
    endif
endfunction

if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  " We want real tabs for makefiles!
  " Markdown is not a single standard, and underscore matching drives me nuts
  " This is not actually turning syntax off, just changing the filetype for
  " syntax
  autocmd FileType markdown ownsyntax off
  
  " Restore previous position in file from .viminfo
  au BufReadPost * call RestoreCursorPos()

  " I'm now using the csv vim scripts
  " no text wrapping on csv files
  " au BufNewFile,BufRead *.csv setf csv
  " autocmd FileType csv setlocal tw=0 
endif


" I am generally using LaTeX if a file ends in .tex
" Currently, I use LatexBox, but I think it might not be my fave (doesn't handle
" Sweave very well, for example).
let g:tex_flavor='latex'
let g:LatexBox_viewer='/Applications/Skim.app/Contents/MacOS/Skim'
