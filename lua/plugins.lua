local fn = vim.fn

local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system {'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path}
  print 'Installing packer! Close and re-open Neovim.'
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

return packer.startup(function(use)
  -- My plugins here
  use 'wbthomason/packer.nvim'
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'}, -- Required
      {'hrsh7th/cmp-path'}, -- Required
      {'saadparwaiz1/cmp_luasnip'}, -- Required
      {'hrsh7th/cmp-nvim-lsp'}, -- Required
      {'hrsh7th/cmp-nvim-lua'}, -- Required

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

