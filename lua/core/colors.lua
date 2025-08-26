-- Base theme
-- vim.cmd[[colorscheme tokyonight]]

-- Load colorscheme safely
local ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
if not ok then
  vim.notify("Colorscheme 'tokyonight' not found!", vim.log.levels.WARN)
end

-- Enable color highlights for hex/rgb codes
require("colorizer").setup()

-- Enable termguicolors
vim.opt.termguicolors = true

-- Glassy effect (transparent background)
local function set_transparency()
  vim.cmd([[
    hi Normal guibg=NONE ctermbg=NONE
    hi NormalNC guibg=NONE ctermbg=NONE
    hi SignColumn guibg=NONE ctermbg=NONE
    hi VertSplit guibg=NONE ctermbg=NONE
    hi StatusLine guibg=NONE ctermbg=NONE
    hi StatusLineNC guibg=NONE ctermbg=NONE
    hi LineNr guibg=NONE ctermbg=NONE
    hi CursorLineNr guibg=NONE ctermbg=NONE
    hi EndOfBuffer guibg=NONE ctermbg=NONE
  ]])
end
set_transparency()

-- Transparent background
require("transparent").setup({
  enable = true,
  extra_groups = { "NormalFloat", "NvimTreeNormal" }
})

-- Enable color highlights for hex/rgb codes
-- require("colorizer").setup()

-- Iridescent effect: shift cursorline color dynamically
vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    local hue = math.random(0, 360)
    vim.cmd("hi CursorLine guibg=hsl(" .. hue .. ",70%,15%)")
  end
})

