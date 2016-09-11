" This was just for windows...
" For some reason... the removal of the <C-V> seems to have permanently happened
" The original map is in vim72/mswin.vim
" lmap <C-V> :normal "+gP

"" TOC

"" 1 - Enable Vundle / declare plugins
"" 2 - Vim Settings
"" 3 - Macros, commands, and things

"" 1 - Vundle

" Brief help for Vungle
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
"
" Or learn more about Vundle here:
" https://github.com/VundleVim/Vundle.vim#quick-start

" These are necessary for Vundle to work, so forgive redundancy!
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Other Plugin's

Plugin 'scrooloose/nerdtree'

" Make this less typing
command NT NERDTree

" Mostly for NERDtree, but a general setting
set splitright

Plugin 'scrooloose/syntastic'

" I installed the html5 version of tidy: `brew install tidy-html5`
" Homebrew just calls it tidy, not tidy5
" let g:syntastic_html_tidy_exec = 'tidy5'

" Warning signs are annoying, can still check with :Error
let g:syntastic_quiet_messages = {'level': 'warnings'}

Plugin 'godlygeek/tabular'
Plugin 'tomtom/tcomment_vim'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'sheerun/vim-polyglot'
Plugin 'kana/vim-textobj-user'

Plugin 'JamshedVesuna/vim-markdown-preview'
" Also `brew install grip`
let vim_markdown_preview_github=1

Plugin 'Valloric/YouCompleteMe'
" Note you need to install cmake, then run install.py from the bundled dir.
" I also installed node with homebrew and used `--tern-completer` with
" install.py

" Whoa tpope! Thanks!
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'

" Color schemes will be unavailable until completing vundle init, so we set
" colorscheme further below.
Plugin 'altercation/vim-colors-solarized'
" For OS X terminal, there are matching terminal theme
" https://github.com/tomislav/osx-lion-terminal.app-colors-solarized
Plugin 'michaelmalick/vim-colors-bluedrake'
" The repo for bluedrake also has OS X terminal themes
Plugin 'nice/sweater'
" I can't get this working right in the terminal... base16-shell seems borked
Plugin 'chriskempson/base16-vim'

" ARCHIVE for configuring currently unused plugins

" Previous complicated stuff for LatexBox
" Enable synctex in a mac-specific way
" map <silent> <Leader>ls :silent !/Applications/Skim.app/Contents/SharedSupport/displayline
"     \ <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>" "%:p" <CR>

" Get nice latex-box completion by default with supertab
" Commenting out for now - you lose too much other groovy stuff
" au FileType tex call SuperTabSetDefaultCompletionType("<c-x><c-o>")

" xmledit stuff (I think)
" let g:xml_syntax_folding=1
" au FileType xml setlocal foldmethod=syntax
" let g:xml_use_html=1 " Don't complete/double up tags like <br>

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" colorschemes now available!

if has('gui_running')
    colorscheme bluedrake
    set background=light
else
    " base16-shell seems not working on El Capitan for me
    " let base16colorspace=256
    colorscheme smyck
endif

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

" You didn't want the old meaning of Q anyway!
nmap Q gqap
vmap Q gq

set colorcolumn=+1

if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
    let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
endif

"" 3 - Macros, scripts, &c.

" rails mode used this (back when I used rails mode...), maybe other things
" will as well
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

  " Restore previous position in file from .viminfo
  au BufReadPost * call RestoreCursorPos()
endif

noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &linebreak
    echo "Soft wrap OFF"
    " I actualy like 'wrap' set all the time by default
    " setlocal nowrap
    setlocal nolinebreak list
    set virtualedit=all
    setlocal tw=79
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Soft wrap ON"
    " setlocal wrap
    setlocal linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    setlocal tw=0
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> 0 g0
    noremap  <buffer> <silent> $ g$
  endif
endfunction
