--[[
    TODO
    Fix this entire file you idiot
--]]
function read(filename)
    local tmp = love.filesystem.read(filename)
    local out = {}
    local values = {}
    local a = 1
    for token in string.gmatch(tmp, "[^%s]+") do
        if not(token == "," or token == "{" or token == "}" or token == ":" or token == [["]]) then -- filter out unwanted charecters
            out[a] = token
            a = a + 1
        end
    end
    tmp = nil
    i = nil
    return(out)
end
function REMOVEME() -- TODO remove this function 
    for i = 1, #tmp, 1 do
        out[i] = tmp:sub(i, i)
    end
    for i = 1, #tmp, 1 do
        if out[i] == "," or out[i] == ":" or out[i] == [["]] or out[i] == " " then
            out[i] = ""
        end
    end
end
