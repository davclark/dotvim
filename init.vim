" This was just for windows...
" For some reason... the removal of the <C-V> seems to have permanently happened
" The original map is in vim72/mswin.vim
" lmap <C-V> :normal "+gP

"" TOC

"" 1 - Enable Plug / declare plugins
"" 2 - Vim Settings
"" 3 - Macros, commands, and things


" Leave python2 unavailable
let g:loaded_python_provider = 1

" We set this exxplicitly to ensure we always have the neovim package
" Still thinking about how to integrate the windows and debuntu branches...
let s:conda_dir="~/Miniconda3/python3"
let s:system_py_dir="/usr/bin/python3"
if filereadable(s:conda_dir)
    let g:python3_host_prog=s:conda_dir
elseif filereadable(s:system_py_dir)
    let g:python3_host_prog=s:system_py_dir
    " let g:python3_host_prog="C:/Python36/python.exe"
endif

"" 1 - Plug

" Also jack up Clojure support: https://juxt.pro/blog/posts/vim-1.html
" and/or http://blog.venanti.us/clojure-vim/
" Also airline or powerline (also does bash)

call plug#begin('~/.config/nvim/plugged')

" start moving to LSP?
" Plug 'neovim/nvim-lspconfig'

" Make sure you use single quotes

Plug 'godlygeek/tabular'
if !exists("g:gui_oni")
    Plug 'tomtom/tcomment_vim'
endif

Plug 'michaeljsmith/vim-indent-object'
" XXX maybe useful for missing languages?
" Plug 'sheerun/vim-polyglot'
Plug 'kana/vim-textobj-user'

Plug 'ervandew/supertab'
" Close help after leaving insert mode (i.e., after done typing)
let g:SuperTabClosePreviewOnPopupClose = 1

if has('nvim')
    " Not using deoplete in Oni
    " I chose this over nvim-completion-manager, as it seems more supported
    " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    " let g:deoplete#enable_at_startup = 1

    " Use <TAB> for everything (except utilisnips?)
    autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
    " Not using ultisnips right now
    " let g:UltiSnipsExpandTrigger="<C-j>"
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

    " Uncomment once you're back into NPM development + deoplete
    " Plug 'pbogut/deoplete-elm', { 'do': 'npm install -g elm-oracle' }
    " Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install -g tern' }
    " Plug 'clojure-vim/async-clj-omni'
    " conda or pip install jedi
    " Plug 'zchee/deoplete-jedi'

    " XXX also disabling neomake for now to avoid conflict with Oni
    " Then, Neomake stuff
    " Plug 'neomake/neomake'
    " Run NeoMake on read and write operations
    " autocmd! BufReadPost,BufWritePost * Neomake
    " let g:neomake_serialize = 1
    " let g:neomake_serialize_abort_on_error = 1
end

" Not currently used
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Whoa tpope! Thanks!
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'idanarye/vim-merginal'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-ragtag'
"
" neovim is trying to be sensible by default... but note that we lose some
" things I like from here... they are marbled in below
" cf. https://github.com/neovim/neovim/issues/2676
if !has('nvim')
    Plug 'tpope/vim-sensible'
endif

Plug 'tpope/vim-surround'
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

Plug 'junegunn/rainbow_parentheses.vim'
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END

" Color schemes will be unavailable until completing vundle init, so we set
" colorscheme further below.
" Plugin 'altercation/vim-colors-solarized'
" For OS X terminal, there are matching terminal theme
" https://github.com/tomislav/osx-lion-terminal.app-colors-solarized
Plug 'MichaelMalick/vim-colors-bluedrake'
" The repo for bluedrake also has OS X terminal themes
Plug 'nice/sweater'
" I can't get this working right in the terminal... base16-shell seems borked
Plug 'chriskempson/base16-vim'

" neovim broke sudo
Plug 'lambdalisue/suda.vim'

" Initialize plugin system
call plug#end()

" colorschemes now available!

if exists("g:gui_oni")
    set background=light
    colorscheme bluedrake
elseif has('gui_vimr')
    " In general, colorscheme setting doesn't work for some themes in the
    " init.vim for neovim. Seems to work for smyck for some reason...
    set termguicolors
    set title
    colorscheme sweater
else
    " base16-shell seems not working on standard macOS terminal.app
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
set tw=120

" Ideal for python, what else? rails mode overrides this (I think)
set ts=4
set sw=4
set expandtab

autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2

" y, d, p and co. use the system clipboard by default
" on X11, this ends up being the "selection" buffer (i.e., selected with a
" mouse) instead of the cut-buffer (i.e., selected with ctrl-x somewhere)
" I had disabled for use inside Oni, which has it's own clipboard logic
" neovim needs a clipboard plugin to function anyway...
" but now I'm using terminal vim on Linux again
if has('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

" Search more cool, can also make case sensitive with \c (opposite of \i)
set ignorecase
set smartcase
set incsearch
set hlsearch

" Copied from vim-sensible, as this was rejected for the neovim defaults
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

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

" Lifted these from an old version of sensible
if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
    let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
endif

" More suited to contemporary Windows development, we default to unix line
" endings *always*. We still retain the old mac format, ending in single
" character carriage-return
set fileformats=unix,dos,mac

" HUD for typed commands, position (these were in sensible)
" XXX Don't think these do anything on Oni
set showcmd
set ruler

set mouse=a
set number


"" 3 - Macros, scripts, &c.

" Elevate permission on write
" neovim broke sudo
" cmap w!! w !sudo tee % > /dev/null
" So we do this instead
cmap w!! w suda://%


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

" lua << EOC
" require'lspconfig'.svelte.setup{}
" require'lspconfig'.tsserver.setup{}
" EOC
