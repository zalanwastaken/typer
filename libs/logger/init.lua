if love.thread == nil then
    require("love.thread")
end
local logger = {
    datastack = love.thread.getChannel("datalogger"),
    write = love.thread.newThread("libs/logger/loggerthread.lua")
}
return(logger)
