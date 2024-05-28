local datain = love.thread.getChannel("phelperdatain")
local dataout = love.thread.getChannel("phelperdataout")
local phelper = {
    thread = love.thread.newThread("helpers/phelper/phelperthread.lua"),
    pout = function(file, str)
        if str == "" then
            error("STR in empty")
        end
        datain:push("POUT_"..file.."_"..str)
    end,
    registy = {
        registerfile = function(file)
            datain:push("REGISTER FILE_"..file)
        end,
        registerthread = function(file)
            datain:push("REGISTER THREAD_"..file)
        end,
        unregister = function(file)
            datain:push("UNREGISTER_"..file)
        end
    },
    getfilename = function()
        local level = 2
        local info
        while true do
            info = debug.getinfo(level, "S")
            if not info then
                --print("Reached the end of the stack without finding a main chunk.")
                break
            end
            --print("Level:", level, "Source:", info.source, "What:", info.what)  -- Debugging output
            if info.what == "Lua" or info.what == "main" then
                return info.source
            end
            level = level + 1
        end
        return nil
    end,
    stop = function()
        datain:push("STOP")
    end
}
return(phelper)
