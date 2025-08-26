-- ============================
--  PACKER BOOTSTRAP
-- =============================
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({
    "git", "clone", "--depth", "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path
  })
  vim.cmd("packadd packer.nvim")
end
vim.cmd [[packadd packer.nvim]]

-- =============================
--  LEADER KEY
-- =============================
vim.g.mapleader = " "

-- =============================
--  PLUGINS
-- =============================
require("packer").startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use { 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons' } }
  use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' } }
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use 'windwp/nvim-autopairs'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'L3MON4D3/LuaSnip'
  use 'nvim-lua/plenary.nvim'
  use "lewis6991/hover.nvim"
  use "folke/which-key.nvim"

  use { "williamboman/mason.nvim" }
  use { "williamboman/mason-lspconfig.nvim" }
end)

-- =============================
--  COMPLETION
-- =============================
local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' }, { name = 'luasnip' },
    { name = 'buffer' }, { name = 'path' }
  },
})

-- =============================
--  BASIC SETTINGS
-- =============================
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

-- =============================
--  PLUGIN SETUP
-- =============================
pcall(function()
  vim.cmd.colorscheme('tokyonight')
  require('nvim-treesitter.configs').setup {
    highlight = { enable = true },
    indent = { enable = true }
  }
  require('lualine').setup({
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch'},
      lualine_c = {'filename', require("ai.ai_chat").statusline},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    }
  })
  require("nvim-tree").setup({ disable_netrw = true, hijack_netrw = true })
  require('nvim-autopairs').setup()
end)

-- =============================
--  LSP + Mason
-- =============================
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "html", "cssls" },
}

-- =============================
--  LIGHTWEIGHT AI CHAT (WAKS AI)
-- =============================
require("ai.ai_chat").setup_keymaps()

-- Keymaps for Waks AI floating chat

-- =============================
--  LIGHTWEIGHT AI CHAT (WAKS AI)
-- =============================
require("ai.ai_chat").setup_keymaps()

local waks_ai = require("ai.waks_ai")
local waks_ui = require("ai.ui")

vim.keymap.set("n", "<leader>wo", function()
    waks_ui.open_chat()
end, { desc = "Open Waks AI Chat" })

vim.keymap.set("n", "<leader>wp", function()
    waks_ai.prompt()
end, { desc = "Prompt Waks AI" })

-- =============================
--  LOAD CUSTOM PLUGIN CONFIGS
-- =============================
-- These files are not auto-loaded — you must require them
require("plugins.telescope")     -- ✅ Add this
require("plugins.tree")          -- Optional: if you have custom NvimTree setup
require("plugins.treesitter")    -- Optional: if you want to ensure it's loaded
require("plugins.cmp")           -- If you moved cmp setup there   
require("core.keymaps")
require("plugins.lsp")
require("plugins.autopairs")
require("plugins.statusline")
require("plugins.which-key")

-- =============================
--  AVANTE KEYMAPS
-- =============================
-- vim.keymap.set("n", "<leader>ac", "<cmd>AvanteChat<CR>", { desc = "Open Avante Chat" })
-- vim.keymap.set("v", "<leader>aa", "<cmd>AvanteAsk<CR>", { desc = "Ask Avante about selection" })


