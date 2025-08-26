
-- plugins/tree.lua
-- Disable netrw before loading nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left", -- or "right"
  },
  renderer = {
    group_empty = true,
  },
  -- 🔥 Critical: hijack netrw to make NvimTree the default file opener
  hijack_netrw = true,
  -- Optional: sync with current file
  update_focused_file = {
    enable = true,
    update_root = true,
  },
})   

