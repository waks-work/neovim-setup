local utils = require("ai.utils")
local display = require("ai.display")
local M = {}

function M.send_to_ai(prompt, callback, current_model)
    display.show_loading()
    vim.fn.jobstart({
        "curl","-s","-X","POST",
        "http://localhost:11434/api/generate",
        "-H","Content-Type: application/json",
        "-d", string.format('{"model":"%s","prompt":"%s","stream":false}', current_model, utils.escape_json(prompt))
    },{
        stdout_buffered=true,
        on_stdout=function(_, data)
            display.hide_loading()
            if data then
                local ok, json = pcall(vim.fn.json_decode, table.concat(data,""))
                if ok and json and json.response then
                    callback(json.response)
                else
                    callback(table.concat(data,"\n"))
                end
            end
        end
    })
end

return M


