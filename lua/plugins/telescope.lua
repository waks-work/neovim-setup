
-- plugins/telescope.lua
-- ====================
-- Telescope Configuration
-- ====================

require("telescope").setup({
  defaults = {
    -- Prompt at top for better visibility
    layout_config = {
      prompt_position = "top",
    },
    -- Easier to read long lists
    sorting_strategy = "ascending",
    -- Ignore noisy directories
    file_ignore_patterns = { "node_modules", ".git/" },
    -- Mappings for insert and normal mode
    mappings = {
      i = {
        ["<Down>"] = require("telescope.actions").move_selection_next,
        ["<Up>"] = require("telescope.actions").move_selection_previous,
        ["<C-c>"] = require("telescope.actions").close,
        ["<C-n>"] = require("telescope.actions").cycle_history_next,
        ["<C-p>"] = require("telescope.actions").cycle_history_prev,
      },
      n = {
        ["<Esc>"] = require("telescope.actions").close,
        ["<CR>"] = require("telescope.actions").select_default,
        ["<C-x>"] = require("telescope.actions").select_horizontal,
        ["<C-v>"] = require("telescope.actions").select_vertical,
        ["<C-t>"] = require("telescope.actions").select_tab,
        ["gg"] = require("telescope.actions").move_to_top,
        ["G"] = require("telescope.actions").move_to_bottom,
        ["gm"] = require("telescope.actions").move_to_middle,
      },
    },
  },
  pickers = {},
  extensions = {},
})

-- ====================
-- Keymaps
-- ====================
local map = vim.keymap.set

-- Use inline options (desc only)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "📁 Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "🔍 Find text globally" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "📄 List buffers" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "🕒 Open recent files" })
map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "🔍 Search in current file" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "❓ Help tags" })
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "📊 Git status" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "📦 Git commits" })
map("n", "<leader>fd", "<cmd>Telescope find_files cwd=%:p:h<CR>", { desc = "📁 Find files here" })   



