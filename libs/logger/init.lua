if love.thread == nil then
    require("love.thread")
end
local logger = {
    datastack = love.thread.getChannel("datalogger"),
    write = love.thread.newThread("libs/logger/loggerthread.lua"),
    --* log function
    log = function(str)
        local loggerdata = love.thread.getChannel("datalogger")
        if type(str):lower() ~= "string" then
            error("Log can only push strings !")
        else
            loggerdata:push(str.."\n")
        end
    end,
    stop = function()
        logger.datastack:push("STOP")
        logger.write:wait()
    end,
    start = function()
        logger.write:start()
    end
}
return(logger)
