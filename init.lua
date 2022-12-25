local o = vim.o
local g = vim.g
local wo = vim.wo
local fn = vim.fn
local api = vim.api

require 'plugins'

-- Automatically source and re-compile packer whenever you save this init.lua
-- This would make more sense in plugins, but I need to understand the usage of return better...
local packer_group = api.nvim_create_augroup('Packer', { clear = true })
api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})


-- [[ Setting options ]]
-- See `:help vim.o`, etc.

g.splitbelow = true
g.splitright = true

-- Set highlight on search
o.hlsearch = false

-- Make line numbers default
wo.number = true

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
-- There's an active discussion about how to do this best in neovim:
-- https://github.com/neovim/neovim/issues/16339
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
g.mapleader = ' '
g.maplocalleader = ','

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap, see `:help gk`
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Neovim now has a useful notion for Q (most recent macro), but you can also do that with @@
api.nvim_set_keymap('n', 'Q', 'gqap', {})
api.nvim_set_keymap('v', 'Q', 'gq', {})

-- Get into normal mode in the terminal without remembering C-\,C-n
api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})

-- Write read-only files
api.nvim_set_keymap('c', 'w!!', 'w suda://%', {})


-- [[ lsp-zero ]]
-- NOTE any mason settings must be set prior to calling the lsp-zero module!

local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.nvim_workspace()
lsp.setup()


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    -- TODO make theme match
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}


-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })


-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help' },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
-- Already handled by lsp-zero
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- There is more LSP stuff in nvim-lua/kickstart.nvim, but maybe revisit lsp-zero first?

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
