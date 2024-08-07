if love.thread == nil then
    require("love.thread")
end
local logger = {
    datastack = love.thread.getChannel("datalogger"),
    write = love.thread.newThread("libs/logger/loggerthread.lua"),
    --* log function
    log = function(str)
        logger.datastack:push(str.."\n")
    end,
    stop = function()
        logger.datastack:push("STOP")
    end
}
return(logger)
