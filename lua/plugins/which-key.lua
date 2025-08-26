-- lua/plugins/which-key.lua
local wk = require("which-key")

wk.register({
  ["<leader>"] = {
    f = { name = "🔍 Find" },
    g = { name = "🌐 Grep / Git" },
    b = { name = "📄 Buffers" },
    d = { name = "🩹 Diagnostics" },
    e = { name = "📂 File Explorer" },
    q = { name = "🚪 Quit / Close" },
    w = { name = "🤖 AI Chat" },
    r = { name = "🔄 Refresh" },
    c = { name = "🔧 Code / LSP" },
  }
}, { prefix = "<leader>" })   
