local o = vim.opt
local fn = vim.fn
local api = vim.api

require 'plugins'

-- The default of auto makes diagnostic gutters "pop up" and move the whole editor
o.signcolumn = 'yes'

-- May need to check for equivalent of vimscript `if has('termguicolors')`
if fn.has('termguicolors') then
    o.termguicolors = true
end
o.background = 'dark'

vim.cmd('colorscheme everforest')

-- lsp-zero
-- NOTE any mason settings must be set prior to calling the lsp-zero module!

local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.nvim_workspace()
lsp.setup()

-- Settings

if fn.has('unnamedplus') then
  o.clipboard = 'unnamedplus'
else
  o.clipboard = 'unnamed'
end

o.textwidth = 100
o.tabstop = 2
o.shiftwidth = 2
api.nvim_create_autocmd(
  'FileType',
  {pattern = '*.py',
   -- This is still vimscript, which is fine for now
   command = 'setlocal tabstop=4 shiftwidth=4'}
)

 -- go to last loc when opening a buffer
 api.nvim_create_autocmd(
   "BufReadPost",
   { command =
     [[if !(bufname("%") =~ '\(COMMIT_EDITMSG\)') && line("'\"") > 1 && line("'\"") <= line("$")
         execute "normal! g`\""
       endif]] }
 )
o.expandtab = true
o.backspace = 'indent,eol,start'
o.mouse = 'a'
o.fileformats = 'unix,dos,mac'
o.colorcolumn = '+1'
o.list = true

-- Search
o.ignorecase = true
o.smartcase = true


-- Neovim now has a useful notion for Q (most recent macro), but you can also do that with @@
api.nvim_set_keymap('n', 'Q', 'gqap', {})
api.nvim_set_keymap('v', 'Q', 'gq', {})

-- Get into normal mode in the terminal without remembering C-\,C-n
api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
-- TODO leader space, local is comma

-- Write read-only files
api.nvim_set_keymap('c', 'w!!', 'w suda://%', {})
