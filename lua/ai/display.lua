-- lua/ai/display.lua
local utils = require("ai.utils")
local M = {}

M.chat_buf = nil
M.chat_win = nil
M.loading_win = nil

-- Highlights
function M.setup_highlights()
    vim.cmd("highlight ChatUserBubble guibg=#3a3a4a guifg=#ffffff")
    vim.cmd("highlight ChatAIBubble guibg=#1a1b26 guifg=#ffffff")
    vim.cmd("highlight ChatCode guibg=#1a1b26")
    vim.cmd("highlight ChatKeyword guifg=#c678dd")
    vim.cmd("highlight ChatFunction guifg=#61afef")
    vim.cmd("highlight ChatString guifg=#98c379")
    vim.cmd("highlight ChatNumber guifg=#d19a66")
    vim.cmd("highlight ChatComment guifg=#5c6370")
end

-- Open chat window
function M.open_chat_win(current_model)
    if M.chat_buf and vim.api.nvim_buf_is_valid(M.chat_buf) then
        return M.chat_buf
    end

    vim.cmd("enew")
    local buf = vim.api.nvim_get_current_buf()
    local width, height = utils.calculate_width(), utils.calculate_height()

    local opts = {
        style="minimal",
        relative="editor",
        width=width,
        height=height,
        row=2,
        col=math.floor((vim.o.columns - width)/2),
        border="rounded",
    }
    local win = vim.api.nvim_open_win(buf, true, opts)
    M.chat_buf, M.chat_win = buf, win

    vim.api.nvim_buf_set_option(buf,"buftype","nofile")
    vim.api.nvim_buf_set_option(buf,"bufhidden","hide")
    vim.api.nvim_buf_set_option(buf,"swapfile",false)
    vim.api.nvim_buf_set_option(buf,"modifiable",true)
    vim.api.nvim_win_set_option(win,"wrap",true)

    M.setup_highlights()

    -- Header
    local header = "╭" .. string.rep("─", width-2) .. "╮"
    local title_text = "DeepSeek AI ("..current_model..")"
    local title = "│ "..title_text..string.rep(" ", width-4-#title_text).."│"
    local footer = "╰"..string.rep("─", width-2).."╯"
    vim.api.nvim_buf_set_lines(buf,0,-1,false,{header, title, footer,""})

    return buf
end

-- Format code block
function M.format_code_block(code, lang)
    code = utils.format_ai_code(code)
    lang = lang or ""
    local width = utils.calculate_width() - 4
    local lines = {"╭─ "..lang..string.rep("─", width-#lang-2).."╮"}
    for _, line in ipairs(utils.wrap_text(code, width)) do
        local padding = width - #line
        table.insert(lines, "│ "..line..string.rep(" ", padding).." │")
    end
    table.insert(lines,"╰"..string.rep("─", width).."╯")
    return lines
end

-- Append message bubble
function M.append_message(role, content, code_block)
    if not (M.chat_buf and vim.api.nvim_buf_is_valid(M.chat_buf)) then return end

    local width = utils.calculate_width()
    local inner_width = width - 2
    local lines = {}
    local prefix = role=="user" and "👤 You" or (role=="ai" and "🤖 DeepSeek" or "⚙ System")
    local hl_group = role=="user" and "ChatUserBubble" or "ChatAIBubble"

    -- Header
    table.insert(lines, "╭"..string.rep("─", inner_width).."╮")
    table.insert(lines, "│ "..prefix..string.rep(" ", inner_width - #prefix).."│")

    -- Content
    local content_lines = utils.wrap_text(content, inner_width)
    for _, line in ipairs(content_lines) do
        local padding = inner_width - #line
        table.insert(lines, "│ "..line..string.rep(" ", padding).." │")
    end

    -- Optional code block
    if code_block then
        table.insert(lines,"│"..string.rep(" ", inner_width).."│") -- spacer
        for _, cl in ipairs(M.format_code_block(code_block,"Code")) do
            table.insert(lines, cl)
        end
    end

    -- Footer
    table.insert(lines,"╰"..string.rep("─", inner_width).."╯")

    -- Insert
    local start_line = vim.api.nvim_buf_line_count(M.chat_buf)
    vim.api.nvim_buf_set_lines(M.chat_buf,-1,-1,false,lines)

    -- Highlight
    for i=0,#lines-1 do
        vim.api.nvim_buf_add_highlight(M.chat_buf,-1,hl_group,start_line+i,0,-1)
    end
    vim.api.nvim_win_set_cursor(M.chat_win,{vim.api.nvim_buf_line_count(M.chat_buf),0})
end

-- Loading animation
function M.show_loading()
    if M.loading_win and vim.api.nvim_win_is_valid(M.loading_win) then return end
    local buf = vim.api.nvim_create_buf(false,true)
    local width = 30
    local row = vim.o.lines-3
    local col = math.floor((vim.o.columns-width)/2)
    local opts = {style="minimal",relative="editor",width=width,height=1,row=row,col=col,border="rounded"}
    local win = vim.api.nvim_open_win(buf,false,opts)
    M.loading_win = win
    vim.api.nvim_buf_set_lines(buf,0,-1,false,{"🤖 DeepSeek is typing..."})
    return buf,win
end

function M.hide_loading()
    if M.loading_win and vim.api.nvim_win_is_valid(M.loading_win) then
        vim.api.nvim_win_close(M.loading_win,true)
        M.loading_win = nil
    end
end

return M

