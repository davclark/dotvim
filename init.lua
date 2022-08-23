require 'plugins'
-- NOTE any mason settings must be set prior to calling the lsp-zero module!

local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.setup()
