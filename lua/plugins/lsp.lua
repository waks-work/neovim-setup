
-- ======================
-- LSP and Mason Setup
-- ======================

local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Mason setup
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()

mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",        -- use ts_ls instead of tsserver
    "pyright",
    "rust_analyzer",
    "clangd",
    "html",
    "cssls",
    "jsonls",
  },
})

-- Enhanced capabilities
local capabilities = cmp_nvim_lsp.default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- Common on_attach function
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Buffer-local keymaps
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<leader>fm", function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)

  -- Highlight symbol under cursor
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
      group = "lsp_document_highlight",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
      group = "lsp_document_highlight",
    })
  end
end -- End of on_attach

-- Setup ts_ls with custom settings
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
  settings = {
    completions = {
      completeFunctionCalls = true,
    },
  },
})

-- Setup other LSP servers
local servers = { "pyright", "rust_analyzer", "clangd", "html", "cssls", "jsonls" }
for _, server in ipairs(servers) do
  lspconfig[server].setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- Diagnostics configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
  },
})

-- Global diagnostic keymaps (use different leader keys to avoid conflicts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostics in location list" })   


