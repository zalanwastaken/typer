require("love.timer")
require("libs/funcs")
require("helpers/commons")
love.timer.sleep(1)
local registry = {}
local datain = love.thread.getChannel("phelperdatain")
local dataout = love.thread.getChannel("phelperdataout")
while true do
    if __TYPE__ ~= "DEV" then
        break
    end
    local data = datain:pop()
    while data do
        local formatted_data = split(data, "_")
        --print("Received request:", formatted_data[1])  -- Debugging output
        if formatted_data[1] == "REGISTER FILE" then
            registry[#registry + 1] = {formatted_data[2], "FILE/" .. formatted_data[2]}
            print("Registered file:", formatted_data[2])  -- Debugging output
        elseif formatted_data[1] == "REGISTER THREAD" then
            registry[#registry + 1] = {formatted_data[2], "THREAD/" .. formatted_data[2]}
            print("Registered thread:", formatted_data[2])  -- Debugging output
        elseif formatted_data[1] == "UNREGISTER" then
            for i = 1, #registry, 1 do
                if registry[i][1] == formatted_data[2] then
                    table.remove(registry, i)
                    print("Unregistered:", formatted_data[2])  -- Debugging output
                    break
                end
            end
        elseif formatted_data[1] == "POUT" then
            for i = 1, #registry, 1 do
                if registry[i][1] == formatted_data[2] then
                    io.write("[" .. registry[i][2] .. "]" .. formatted_data[3].."\n")
                    --print("[" .. registry[i][2] .. "]" .. formatted_data[3])
                    break
                end
            end
        end        
        data = datain:pop()
    end
    love.timer.sleep(0.01)  -- Shorter sleep duration
end
