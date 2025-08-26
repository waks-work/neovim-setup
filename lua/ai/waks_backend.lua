-- lua/ai/waks_backend.lua
local M = {}

-- Example: call Rust CLI or HTTP backend
function M.get_response(prompt)
  if prompt == nil or prompt == "" then return "" end

  -- Option A: If Rust backend exposes a CLI
  -- local handle = io.popen("cargo run --manifest-path=/path/to/waks_ai_backend/Cargo.toml -- " .. prompt)
  -- local result = handle:read("*a")
  -- handle:close()

  -- Option B: If backend runs a local HTTP server
  -- local http = require("socket.http")
  -- local body, code = http.request("http://localhost:3000/respond?prompt=" .. vim.fn.escape(prompt, " "))
  -- return body

  -- For now, placeholder
  local response = "Waks AI backend received: " .. prompt
  return response
end

return M

