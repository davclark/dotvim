# dotvim
## Oh, yeah!

This is my third incarnation of a .vim directory. To facilitate easy sharing
(including with myself), you can find it on github here (though you probably
already knew this):

    https://github.com/davclark/dotvim

Symbolic links are needed to the home directory for vimrc, gvimrc and
(optionally) inputrc.

I’m now using Vundle, so things should be easier to understand. Start by
reading comments in the vimrc file.

## Old Notes

The below are from the previous iteration. Not sure I care anymore. I’ll almost
certainly just use RStudio for Rmd, and will probably never use rnoweb with
latex again (I'd rather use a custom style approach with Rmd).

Currently, I just have the following line in after/ftplugin/rnoweb.vim

    runtime! ftplugin/tex_latexSuite.vim


FUTURE DIRECTIONS

I think I want to switch to Latex-Suite to get (fast) section folding, and the
default usage of a distinct tex leader (which will allow easier non-conflict with
R.vim in Rnw files). I guess I'll also revisit AUCTEX

I'm also keen to try out snipMate (like TextMate snippets)

I'm curious to know if syntax regions can actually change which functions
are available. That'd be pretty sweet, but not a major problem if not.
Certainly, some things like `gn` in rnoweb.vim would be missed if I did that.

This was inspired by the following...

```{vimscript}
" one way in my after/syntax/rnoweb.vim
" also requires editing my filetype.vim to set .Rnw files to noweb
" And will just do syntax - sux!
" But interesting as an example of syntax regions

runtime! syntax/tex.vim
unlet b:current_syntax

syntax include @nowebR syntax/r.vim
syntax region nowebChunk start="^<<.*>>=" end="^@" contains=@nowebR
syntax region Sexpr  start="\\Sexpr{"  end="}" keepend
hi Sexpr gui=bold guifg=chocolate2

let b:current_syntax="noweb"
" end one way
```
