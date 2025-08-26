return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  -- Mason + LSP
  -- Mason (LSP installer/manager)
  use {
    "williamboman/mason.nvim",
    run = ":MasonUpdate" -- optional, update registry on install
  }

  use {
    "williamboman/mason-lspconfig.nvim",
    requires = { "neovim/nvim-lspconfig" }
  }

  use "neovim/nvim-lspconfig"

  -- waksAI
  use("~/path/to/nvim/waksAI")
  
  -- use "github/copilot.vim" 

  -- Completion
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
   }
  }
  use "rafamadriz/friendly-snippets" -- friendly snippets

  use { "lewis6991/hover.nvim", config = function()
    require("hover").setup {
      init = function()
        require("hover.providers.lsp")
      end,
      preview_opts = { border = "single" },
      title = true,
      mouse_providers = { "LSP" },
      mouse_delay = 1000,
    }
    vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
    vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
    vim.o.mousemoveevent = true
  end }   

  -- Colors & Effects
  use "folke/tokyonight.nvim"              -- Base theme
  use "nvim-tree/nvim-web-devicons"        -- Dev icons
  use "nvim-lualine/lualine.nvim"          -- Statusline
  use "norcalli/nvim-colorizer.lua"        -- Color preview
  use "HiPhish/rainbow-delimiters.nvim"    -- Colorful brackets
  use "xiyaowong/transparent.nvim"         -- Transparent background

  -- Syntax Highlighting
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- File Explorer
  use "nvim-tree/nvim-tree.lua"

  -- Telescope
  use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } }
  use {
    'isak102/telescope-git-file-history.nvim',
    requires = {
      'nvim-telescope/telescope.nvim',
      'tpope/vim-fugitive'
    },
    config = function()
      require('telescope').load_extension('git_file_history')
    end
  }   

  -- Autopairs
  use "windwp/nvim-autopairs"
  -- use {
    -- "yetone/avante.nvim", -- replace with actual repo
    -- config = function()
      -- require("avante").setup({})
    -- end
  -- }

  -- Emmet
  use 'mattn/emmet-vim'

  -- Autopairs + autotag
  use {
    'windwp/nvim-autopairs',
    config = function() require("nvim-autopairs").setup {} end
  }
 
  use {
    'windwp/nvim-ts-autotag',
    config = function() require('nvim-ts-autotag').setup() end
  }

  use { "folke/which-key.nvim", config = function()
    require("which-key").setup {
      triggers_blacklist = {
        i = { "j", "k" },
        v = { "j", "k" },
      }
    }
  end }   
end)

