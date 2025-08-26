-- lua/ai_chat.lua
local M = {}

local curl = require("plenary.curl")
local avante_ok, avante = pcall(require, "avante")
if not avante_ok then avante = nil end

M.current_buf = nil
M.current_win = nil
M.current_model = "stable-code:3b-code-q4_0"
M.log_path = vim.fn.stdpath('data') .. '/llama_history.jsonl'

vim.cmd([[
  hi AIWindow guibg=#1e1e2e guifg=#cdd6f4
  hi UserMessage guifg=#94e2d5 gui=bold
  hi AIMessage guifg=#74c7ec gui=italic
]])

-- ===== UTILITIES =====
local function wrap_text(text, width)
    local lines = {}
    local start = 1
    while start <= #text do
        table.insert(lines, text:sub(start, start + width - 1))
        start = start + width
    end
    return lines
end

local function draw_frame(sender, text, width)
    local pad = width - #sender - 5
    local top = "┌─ " .. sender .. " " .. string.rep("─", pad) .. "┐"
    local middle = {}
    for _, line in ipairs(wrap_text(text, width - 3)) do
        table.insert(middle, "│ " .. line .. string.rep(" ", width - #line - 3) .. "│")
    end
    local bottom = "└" .. string.rep("─", width - 2) .. "┘"
    local result = { top }
    vim.list_extend(result, middle)
    table.insert(result, bottom)
    return result
end

-- ===== LOGGING =====
local function log_message(sender, text)
    local file = io.open(M.log_path, "a")
    if file then
        file:write(vim.fn.json_encode({ time = os.time(), sender = sender, text = text }) .. "\n")
        file:close()
    end
end

local function load_history()
    local entries = {}
    local file = io.open(M.log_path, "r")
    if file then
        for line in file:lines() do
            local ok, decoded = pcall(vim.fn.json_decode, line)
            if ok then table.insert(entries, decoded) end
        end
        file:close()
    end
    return entries
end

-- ===== AI WINDOW =====
function M.create_window()
    if M.current_win and vim.api.nvim_win_is_valid(M.current_win) then return end
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.4)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = vim.o.lines - 2,
        col = vim.o.columns - width,
        row = 1,
        style = "minimal",
        border = "rounded",
    })
    vim.api.nvim_win_set_option(win, "winhl", "Normal:AIWindow")
    M.current_buf, M.current_win = buf, win
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "💬 AI Chat", string.rep("─", width) })
end

function M.append_message(sender, text)
    if not M.current_buf then return end
    local width = math.floor(vim.o.columns * 0.4) - 2
    for _, line in ipairs(draw_frame(sender, text, width)) do
        vim.api.nvim_buf_set_lines(M.current_buf, -1, -1, false, { line })
    end
    log_message(sender, text)
end

-- ===== SEND TO AI =====
function M.send(prompt)
    M.append_message("You", prompt)
    local model = M.current_model
    local ok, res

    if model:match("deepseek") then
        local api_key = os.getenv("DEEPSEEK_API_KEY")
        if not api_key then M.append_message("AI", "[DeepSeek API key not set]") return end
        ok, res = pcall(function()
            return curl.post("https://api.deepseek.com/v1/chat/completions", {
                headers = { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. api_key },
                body = vim.fn.json_encode({ model = model, messages = { { role = "user", content = prompt } }, max_tokens = 500, temperature = 0.7 }),
            })
        end)
        if not ok then M.append_message("AI", "[DeepSeek API request failed]") return end
        if res.status == 200 then
            local reply = vim.fn.json_decode(res.body).choices[1].message.content
            M.append_message("AI", reply)
        else M.append_message("AI", "[DeepSeek API error: " .. res.status .. "]") end
    else
        ok, res = pcall(function()
            return curl.post("http://localhost:11434/api/generate", {
                headers = { ["Content-Type"] = "application/json" },
                body = vim.fn.json_encode({ model = model, prompt = prompt, stream = false }),
            })
        end)
        if not ok then M.append_message("AI", "[Ollama API request failed]") return end
        if res.status == 200 then
            local reply = vim.fn.json_decode(res.body).response
            M.append_message("AI", reply)
        else M.append_message("AI", "[Ollama API error: " .. res.status .. "]") end
    end
end

-- ===== AVANTE MENUS =====
function M.select_history()
    if not avante then return end
    local history = load_history()
    if #history == 0 then return end
    local options = {}
    for _, entry in ipairs(history) do
        table.insert(options, os.date("%H:%M:%S", entry.time) .. " | " .. entry.sender .. ": " .. entry.text)
    end
    avante.select(options, {
        prompt = "Select prompt to resend: ",
        on_choice = function(idx)
            local selected = history[idx]
            if selected.sender == "You" then M.send(selected.text)
            else print("Cannot resend AI response") end
        end,
    })
end

function M.select_model()
    if not avante then return end
    local models = { "stable-code:3b-code-q4_0", "deepseek-chat" }
    avante.select(models, {
        prompt = "Select AI model: ",
        on_choice = function(idx)
            M.current_model = models[idx]
            print("Switched to model: " .. M.current_model)
        end,
    })
end

-- ===== KEYMAPS =====
function M.setup_keymaps()
    vim.keymap.set("n", "<leader>ac", function()
        if M.current_win and vim.api.nvim_win_is_valid(M.current_win) then
            vim.api.nvim_win_close(M.current_win, true)
            M.current_buf, M.current_win = nil, nil
        else M.create_window() end
    end, { desc = "Toggle AI Chat Window" })

    vim.keymap.set("n", "<leader>aa", function()
        if not M.current_win then M.create_window() end
        local prompt = vim.fn.input("Ask AI: ")
        if prompt ~= "" then M.send(prompt) end
    end, { desc = "Send message to AI" })

    vim.keymap.set("v", "<leader>aa", function()
        local text = table.concat(vim.fn.getline("'<", "'>"), "\n")
        if not M.current_win then M.create_window() end
        M.send(text)
    end, { desc = "Send selection to AI" })

    vim.keymap.set("n", "<leader>ah", M.select_history, { desc = "Select from chat history" })
    vim.keymap.set("n", "<leader>am", function()
        if M.current_model == "stable-code:3b-code-q4_0" then
          M.current_model = "deepseek-chat"
        else
          M.current_model = "stable-code:3b-code-q4_0"
        end
        print("AI model switched to: " .. M.current_model)
    end, { desc = "Toggle AI model" })
end

return M

