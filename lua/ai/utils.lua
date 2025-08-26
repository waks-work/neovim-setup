local M = {}

-- Wrap text for bubble width
function M.wrap_text(text, width)
    local lines = {}
    local line = ""
    for word in text:gmatch("%S+") do
        if #line + #word + 1 > width then
            table.insert(lines, line)
            line = word
        else
            if #line > 0 then
                line = line .. " " .. word
            else
                line = word
            end
        end
    end
    if #line > 0 then table.insert(lines, line) end
    return lines
end

-- Dynamic width / height
function M.calculate_width()
    local w = math.floor(vim.o.columns * 0.5)
    return math.max(30, math.min(70, w))
end

function M.calculate_height()
    local h = math.floor(vim.o.lines * 0.7)
    return math.max(10, math.min(40, h))
end

-- Escape JSON for API
function M.escape_json(str)
    str = str:gsub('\\','\\\\')
    str = str:gsub('"','\\"')
    str = str:gsub('\n','\\n')
    return str
end

-- Format AI code (remove long comments)
function M.format_ai_code(code)
    code = code:gsub("//[^\n]{80,}", "// ...")
    code = code:gsub("/%*.-%*/","/* ... */")
    return code
end

return M


