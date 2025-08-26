-- ======================
--  KEY MAPS
-- ======================
local map = vim.keymap.set
vim.g.mapleader = " "  -- Make sure this is early!

-- ======================
-- File Explorer (NvimTree)
-- ======================
-- Remove 'if has()' — just define mappings
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer", silent = true })
map("n", "<leader>E", "<cmd>NvimTreeFocus<CR>", { desc = "Focus File Explorer", silent = true })
map("n", "<leader>r", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh Tree", silent = true })
map("n", "<leader>f", "<cmd>NvimTreeFindFile<CR>", { desc = "Find Current File", silent = true })
map("n", "<leader>c", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse Tree", silent = true })

-- ======================
-- Telescope
-- ======================
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files", silent = true })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep", silent = true })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Open Buffers", silent = true })
map("n", "<leader>fh", "<cmd>Telescope git_file_history<CR>", { desc = "File History (Git)", silent = true })

-- ======================
-- Quick Save / Quit
-- ======================
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit Window" })

-- ======================
-- Buffer Navigation
-- ======================
map("n", "<A-right>", "<cmd>bnext<CR>", { desc = "Next Buffer", silent = true })
map("n", "<A-left>", "<cmd>bprev<CR>", { desc = "Previous Buffer", silent = true })
map("n", "<A-l>", "<cmd>ls<CR>", { desc = "List Buffers", silent = true })
map("n", "<A-c>", "<cmd>bd<CR>", { desc = "Close Buffer", silent = true })

-- ======================
-- Emmet
-- ======================
vim.g.user_emmet_expandabbr_key = '<C-e>'



