local display = require("ai.display")
local M = {}

function M.floating_input(prompt, callback)
    local width = math.min(60, math.floor(vim.o.columns * 0.6))
    local row = vim.o.lines - 3
    local col = math.floor((vim.o.columns - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "swapfile", false)

    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = 1,
        row = row,
        col = col,
        border = "rounded",
    }
    local win = vim.api.nvim_open_win(buf, false, opts) -- false = keep current file visible
    vim.api.nvim_win_set_option(win, "winhl", "Normal:ChatUserBubble")
    vim.fn.prompt_setprompt(buf, prompt .. " ")

    vim.fn.prompt_setcallback(buf, function(input)
        if input and input ~= "" then
            if display.chat_buf and vim.api.nvim_buf_is_valid(display.chat_buf) then
                display.append_message("user", input)
            end
            if callback then callback(input) end
        end
        vim.api.nvim_win_close(win, true)
    end)

    vim.api.nvim_set_current_win(win)
    vim.cmd("startinsert")
end

return M


