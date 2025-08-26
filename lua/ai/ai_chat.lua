local utils = require("ai.utils")
local display = require("ai.display")
local input = require("ai.input")
local api = require("ai.api")

local M = {}
M.current_model = "deepseek-coder:1.3b"
M.models = {"deepseek-coder:1.3b","stable-code:3b-code-q4_0"}

function M.chat()
    display.open_chat_win(M.current_model)
    input.floating_input("You:", function(text)
        api.send_to_ai(text, function(resp)
            display.append_message("ai", resp)
        end, M.current_model)
    end)
end


function M.ask_visual()
    local _, ls, cs = unpack(vim.fn.getpos("'<"))
    local _, le, ce = unpack(vim.fn.getpos("'>"))
    local lines = vim.fn.getline(ls, le)
    if #lines==0 then return end
    lines[#lines] = string.sub(lines[#lines],1,ce)
    lines[1] = string.sub(lines[1],cs)
    local code = table.concat(lines,"\n")
    local prompt = "Explain this code:\n"..code

    display.open_chat_win(M.current_model)
    display.append_message("user", prompt, code)
    api.send_to_ai(prompt, function(resp)
        display.append_message("ai", resp)
    end, M.current_model)
end


function M.toggle_model()
    M.current_model = (M.current_model==M.models[1]) and M.models[2] or M.models[1]
    display.append_message("system","Model switched to "..M.current_model)
end

function M.setup_keymaps()
    vim.keymap.set("n","<leader>ac",M.chat,{desc="Open AI Chat"})
    vim.keymap.set("v","<leader>aa",M.ask_visual,{desc="Ask AI about selection"})
    vim.keymap.set("n","<leader>am",M.toggle_model,{desc="Toggle AI Model"})
end

return M



