set guioptions-=T
if has("gui_macvim")
    set guifont=Source\ Code\ Pro\ Semibold:h13
    au FocusLost * set transp=5
    au FocusGained * set transp=0
endif
