if has("gui_macvim")
    set guioptions-=T
    set guifont=Source\ Code\ Pro\ Semibold:h13
    au FocusLost * set transp=5
    au FocusGained * set transp=0
endif
