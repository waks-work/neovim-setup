-- plugins/treesitter.lua
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "python", "rust", "javascript", "html", "css", "c" },
  highlight = { enable = true },
  indent = { enable = true },
})

