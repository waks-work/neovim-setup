-- =========================
--  WAKS AI MODULE (Rust Backend)
-- =========================
local M = {}
local ui = require("ai.ui")
local Job = require("plenary.job")

local BACKEND_GEN = "http://127.0.0.1:11434/generate"
local BACKEND_STREAM = "http://127.0.0.1:11434/stream"

-- Chat prompt via floating input
function M.prompt()
    local input = vim.fn.input("Ask WaksAI: ")
    if input == "" then return end

    ui.append_message("user", input)

    -- Use /generate endpoint for quick reply
    Job:new({
        command = "curl",
        args = {
            "-s", "-X", "POST", BACKEND_GEN,
            "-H", "Content-Type: application/json",
            "-d", vim.fn.json_encode({
                session_id = "1",
                messages = { { role = "user", content = input } }
            })
        },
        on_exit = vim.schedule_wrap(function(j, return_val)
            local res = table.concat(j:result(), "\n")
            local decoded = vim.fn.json_decode(res)
            local reply = decoded and decoded.response or "(error) no response"
            ui.append_message("ai", reply)
        end)
    }):start()
end

-- Streaming version for real-time token display
function M.stream_prompt()
    local input = vim.fn.input("Ask WaksAI (stream): ")
    if input == "" then return end

    ui.append_message("user", input)

    Job:new({
        command = "curl",
        args = {
            "-s", "-N", "-X", "POST", BACKEND_STREAM,
            "-H", "Content-Type: application/json",
            "-d", vim.fn.json_encode({
                session_id = "1",
                messages = { { role = "user", content = input } },
                stream = true
            })
        },
        on_stdout = vim.schedule_wrap(function(_, line)
            -- SSE events start with "data: "
            local token = line:match("^data: (.+)")
            if token then
                ui.append_message("ai", token)
            end
        end)
    }):start()
end


-- Statusline indicator
function M.statusline()
    return "🤖 WaksAI"
end

-- Keymaps
function M.setup_keymaps()
    vim.keymap.set("n", "<leader>wp", M.prompt, { desc = "Prompt Waks AI" })
    vim.keymap.set("n", "<leader>ws", M.stream_prompt, { desc = "Stream Waks AI" })
end

return 


