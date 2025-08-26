local M = {}

local chat_buf, chat_win

-- store chat messages
M.messages = {}

function M.open_chat()
    if chat_buf and vim.api.nvim_buf_is_valid(chat_buf) then
        vim.api.nvim_set_current_buf(chat_buf)
        return
    end

    chat_buf = vim.api.nvim_create_buf(false, true)

    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.6)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    chat_win = vim.api.nvim_open_win(chat_buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded",
    })

    vim.api.nvim_buf_set_option(chat_buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(chat_buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(chat_buf, "swapfile", false)
    vim.api.nvim_buf_set_lines(chat_buf, 0, -1, false, { "🤖 Waks AI Chat" })
end

-- Append message normally
function M.append_message(role, content, code)
    code = code or ""
    if role == "ai" and M.messages[#M.messages] and M.messages[#M.messages].role == "ai" then
        -- Update existing AI message (for streaming)
        M.messages[#M.messages].content = M.messages[#M.messages].content .. content
    else
        table.insert(M.messages, { role = role, content = content, code = code })
    end
    -- Update buffer display here
    M.refresh_window()
end
return M

