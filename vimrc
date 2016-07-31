" This was just for windows...
" For some reason... the removal of the <C-V> seems to have permanently happened
" The original map is in vim72/mswin.vim
" lmap <C-V> :normal "+gP

"" TOC

"" 1 - Enable Vundle / declare plugins
"" 2 - Vim Settings
"" 3 - Configure scripts / packages
"" 4 - Macros, commands, and things

"" 1 - Vundle

" Learn about Vundle here: 
" https://github.com/VundleVim/Vundle.vim#quick-start

" I'm not sure how Vundle handles helptags
" Just call :Helptags when you install a new file

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Other Plugin's

Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'

" Make this less typing
command NT NERDTree

" Mostly for NERDtree, but a general setting
set splitright

Plugin 'scrooloose/syntastic'
Plugin 'godlygeek/tabular'
Plugin 'tomtom/tcomment_vim'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'sheerun/vim-polyglot'
Plugin 'kana/vim-textobj-user'

Plugin 'JamshedVesuna/vim-markdown-preview'
" Also `brew install grip`
let vim_markdown_preview_github=1

Plugin 'Valloric/YouCompleteMe'

" Whoa tpope! Thanks!
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help for Vungle
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"" 2 - General Vim settings

" Makes more info available under your buffer
set cmdheight=2

" Always allow backspae
set bs=2

" This will wrap at 80 chars
set tw=79

" Ideal for python, what else? rails mode overrides this (I think)
set ts=4
set sw=4
set expandtab


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
" Note - vim-sensible maps <C-L> to :noh - which turns hilights off
set hlsearch

" listchars is set in vim-sensible
set list

" I also really don't like automatic code folding - just use zM if you want
" But if a file is huge, I do like it
set foldlevel=5

" Open an existing tab if the buffer is already displayed somewhere
set switchbuf=usetab


nmap Q gqap
vmap Q gq

set colorcolumn=+1

" This can apparently fix some highlighting problems... just not the ones I have
" let g:sh_no_error=1

"" 3 - Configure scripts / packages


" Syntax / style checking is generally handled by Syntastic
" This would disable pymode checking
" let g:pymode_lint = 0
" This disables syntastic for python
" I was doing this after the over-eager stuff from pymode - now removed
" let g:syntastic_disabled_filetypes=['py']

" Warning signs are annoying, can still check with :Error
let g:syntastic_quiet_messages = {'level': 'warnings'}

" Need to install html5 version of tidy: `brew install tidy-html5`
" Homebrew just calls it tidy, not tidy5
" let g:syntastic_html_tidy_exec = 'tidy5'

" This was a bunch of stuff to make pymode less aggressive
" And these kinds of things should be done by hand (see help for inspiration,
" though)
" let g:pymode_options = 0

" And I'd rather use ipython
" let g:pymode_run = 0

" And I'd rather not unintentionally create mixed diffs w/ whitespace removals
" let g:pymode_utils_whitespaces = 0

" This is super-slow and blocking. Perhaps a good reason to go to NeoVim
" let g:pymode_rope_complete_on_dot = 0

" This is supposedly "Highly Experimental" but really helpful (for me)
" let g:csv_autocmd_arrange = 1


" I like marking space errors - this is available for most major languages
" These don't however seem to do anything,
" And for python, pyflakes does a pretty good job
" let ruby_space_errors = 1
" let python_space_errors = 1

"" solarized / color stuff
" For OS X, be sure to install the matching terminal theme
" https://github.com/tomislav/osx-lion-terminal.app-colors-solarized

" Special character highlighting from tpope is better than this:
" This needs to be set before `colorscheme solarized`
" let solarized_hitrail = 1

if has('gui_running')
    colorscheme solarized
    set background=light
endif


" I am generally using LaTeX if a file ends in .tex
" Currently, I use LatexBox, but I think it might not be my fave (doesn't handle
" Sweave very well, for example).
let g:tex_flavor='latex'
" Doesn't work, I think because of a <leader> conflict
let g:LatexBox_viewer='open -a skim'

let g:LatexBox_Folding=1
" Enable synctex in a mac-specific way
map <silent> <Leader>ls :silent !/Applications/Skim.app/Contents/SharedSupport/displayline
    \ <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>" "%:p" <CR>

" xmledit (I think)
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax
let g:xml_use_html=1 " Don't complete/double up tags like <br>

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
  " XXX where is this?

  " Restore previous position in file from .viminfo
  au BufReadPost * call RestoreCursorPos()

  " Get nice latex-box completion by default with supertab
  " Commenting out for now - you lose too much other groovy stuff
  " au FileType tex call SuperTabSetDefaultCompletionType("<c-x><c-o>")
endif
