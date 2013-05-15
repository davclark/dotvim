" This was just for windows...
" For some reason... the removal of the <C-V> seems to have permanently happened
" The original map is in vim72/mswin.vim
" lmap <C-V> :normal "+gP

"" TOC

"" 1 - Enable Pathogen / import scripts
"" 2 - Vim Settings
"" 3 - Configure scripts / packages
"" 4 - Macros, commands, and things

"" 1 - Pathogen

" Here we temporarily disable simplenote, because it's not working very well
let g:pathogen_disabled = ['simplenote']

" Pathogen needs to be set up before syntax is set on
" Just call :Helptags when you install a new file
" call pathogen#helptags()
call pathogen#infect()

"" 2 - General Vim settings

" Let vim / plugins pick my indentation strategy, etc.
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
" Makes more info available under your buffer
set cmdheight=2
" Some vim users think this is unaesthetic, but I like it
set laststatus=2

" Seems to be necessary for colors in terminal mode (not GUI)
syntax on

" Always allow backspae
set bs=2

" This will wrap at 80 chars
set tw=80

" Ideal for python, what else? rails mode overrides this (I think)
set ts=4
set sw=4
set expandtab
set smarttab


" Because microsoft is dumb, they still put \r at the end of text files on a mac
" So, despite it's otherwise dead-ness, we need mac
set fileformats=unix,dos,mac

" y, d, p and co. use the system clipboard by default
" on X11, this ends up being the "selection" buffer (i.e., selected with a
" mouse) instead of the cut-buffer (i.e., selected with ctrl-x somewhere)
if has('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

" Search more cool, can also make case sensitive with \c (opposite of \i)
set ignorecase
set smartcase
set incsearch


" I also really don't like automatic code folding - just use zM if you want
" I set this because of pymode
set foldlevel=100

" Open an existing tab if the buffer is already displayed somewhere
set switchbuf=usetab

" Mostly for NERDtree
set splitright

"" 3 - Configure scripts / packages

" Make this less typing
command NT NERDTree

" Syntax / style checking is generally handled by Syntastic
" Thus, disable from pymode
let g:pymode_lint = 0

" And these kinds of things should be done by hand (see help for inspiration,
" though)
let g:pymode_options = 0

" And I'd rather use ipython
let g:pymode_run = 0

" And I'd rather not unintentionally create mixed diffs w/ whitespace removals
let g:pymode_utils_whitespaces = 0

" This is supposedly "Highly Experimental" but really helpful (for me)
let g:csv_autocmd_arrange = 1

" Warning signs are annoying, can still check with :Error
let g:syntastic_quiet_warnings=1


" I like marking space errors - this is available for most major languages
" These don't however seem to do anything, currently using solarized_hitrail
" And for python, pyflakes does a pretty good job
" let ruby_space_errors = 1
" let python_space_errors = 1

"" solarized / color stuff
" For OS X, be sure to install the matching terminal theme
" https://github.com/tomislav/osx-lion-terminal.app-colors-solarized

" This needs to be set before `colorscheme solarized`
let solarized_hitrail = 1

colorscheme solarized
if has('gui_running')
    set background=light
else
    set background=dark
endif


" I am generally using LaTeX if a file ends in .tex
" Currently, I use LatexBox, but I think it might not be my fave (doesn't handle
" Sweave very well, for example).
let g:tex_flavor='latex'
" Doesn't work, I think because of a <leader> conflict
let g:LatexBox_viewer='open -a skim'

let g:LatexBox_Folding=1
" Enable synctex?
map <silent> <Leader>ls :silent !/Applications/Skim.app/Contents/SharedSupport/displayline
    \ <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>" "%:p" <CR>

"" 4 - Macros, scripts, &c.

" rails mode uses this, maybe other things will as well
command -bar -nargs=1 OpenURL :!open <args> 

" Elevate permission on write
cmap w!! w !sudo tee % > /dev/null

" Generally only useful when called from the autocmd below
function! RestoreCursorPos()
    if !(bufname("%") =~ '\(COMMIT_EDITMSG\)') && line("'\"") > 1 && 
         \ line("'\"") <= line("$") 
        exe "normal! g`\"" 
    endif
endfunction

if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  " We want real tabs for makefiles!
  " Markdown is not a single standard, and underscore matching drives me nuts
  " This is not actually turning syntax off, just changing the filetype for
  " syntax
  "" autocmd FileType markdown ownsyntax off
  " I think this is a little more appropriate
  au FileType markdown syntax clear

  " Restore previous position in file from .viminfo
  au BufReadPost * call RestoreCursorPos()

  " I'm now using the csv vim scripts
  " no text wrapping on csv files
  " au BufNewFile,BufRead *.csv setf csv
  " autocmd FileType csv setlocal tw=0 
endif
