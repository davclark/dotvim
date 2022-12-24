local o = vim.o
local wo = vim.wo
local fn = vim.fn
local api = vim.api

require 'plugins'

-- Automatically source and re-compile packer whenever you save this init.lua
-- This would make more sense in plugins, but I need to understand the usage of return better...
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})


-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable break indent
o.breakindent = true

-- Save undo history
o.undofile = true

-- Decrease update time
o.updatetime = 250

-- Set completeopt to have a better completion experience
o.completeopt = 'menuone,noselect'

-- The default of auto makes diagnostic gutters "pop up" and move the whole editor
wo.signcolumn = 'yes'

-- May need to check for equivalent of vimscript `if has('termguicolors')`
if fn.has('termguicolors') then
    o.termguicolors = true
end
o.background = 'dark'

vim.cmd [[colorscheme everforest]]

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


-- [[ Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Neovim now has a useful notion for Q (most recent macro), but you can also do that with @@
api.nvim_set_keymap('n', 'Q', 'gqap', {})
api.nvim_set_keymap('v', 'Q', 'gq', {})

-- Get into normal mode in the terminal without remembering C-\,C-n
api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})

-- Write read-only files
api.nvim_set_keymap('c', 'w!!', 'w suda://%', {})

-- TODO got as far as line 137 in https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

-- [[ lsp-zero ]]
-- NOTE any mason settings must be set prior to calling the lsp-zero module!

local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.nvim_workspace()
lsp.setup()

