" This was just for windows...
" For some reason... the removal of the <C-V> seems to have permanently happened
" The original map is in vim72/mswin.vim
" lmap <C-V> :normal "+gP

"" TOC

"" 1 - Enable Plug / declare plugins
"" 2 - Vim Settings
"" 3 - Macros, commands, and things

"" 1 - Plug

" Look at vim-taskwarrior, vim-taskwiki
" Also jack up Clojure support: https://juxt.pro/blog/posts/vim-1.html
" and/or http://blog.venanti.us/clojure-vim/
" Also airline or powerline (also does bash)

call plug#begin('~/.config/nvim/plugged')

" Make sure you use single quotes

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Make this less typing
command NT NERDTree
" Mostly for NERDtree, but a general setting
set splitright

Plug 'godlygeek/tabular'
Plug 'tomtom/tcomment_vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'sheerun/vim-polyglot'
Plug 'kana/vim-textobj-user'

Plug 'ervandew/supertab'
" Close help after leaving insert mode (i.e., after done typing)
let g:SuperTabClosePreviewOnPopupClose = 1

if has('nvim')
    " First, deoplete stuff
    " I chose this over nvim-completion-manager, as it seems more supported
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1

    " Use <TAB> for everything except utilisnips
    autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
    let g:UltiSnipsExpandTrigger="<C-j>"
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

    Plug 'pbogut/deoplete-elm', { 'do': 'npm install -g elm-oracle' }
    " Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install -g tern' }
    " conda or pip install jedi
    Plug 'zchee/deoplete-jedi'
    " Plug 'clojure-vim/async-clj-omni'

    " Then, Neomake stuff
    Plug 'neomake/neomake'
    " Run NeoMake on read and write operations
    autocmd! BufReadPost,BufWritePost * Neomake

    let g:neomake_serialize = 1
    let g:neomake_serialize_abort_on_error = 1
end

Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'] }
" Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }
" Last I checked pangloss' version is the official rec for jsx
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Current standards just use .js for React files. Ah well!
let g:jsx_ext_required = 0

" Whoa tpope! Thanks!
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-ragtag'
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

" Plug 'elmcast/elm-vim'
" This invokes elm-format, which currently needs to be downloaded and manually
" installed as as binary: https://github.com/avh4/elm-format#installation-
" let g:elm_format_autosave = 1


" ARCHIVE for configuring currently unused plugins
" including examples for Plug

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Using a non-master branch
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
" Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
" Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

" Initialize plugin system
call plug#end()

" colorschemes now available!

if has('gui_running')
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

" Old mac format, ending in single character carriage-return
set fileformats+=mac

" HUD for typed commands, position (these were in sensible)
set showcmd
set ruler


"" 3 - Macros, scripts, &c.

" Leave python2 unavailable
let g:loaded_python_provider = 1

let g:python3_host_prog="/usr/bin/python3"

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
