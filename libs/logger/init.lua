local logger = {
    datastack = love.thread.getChannel("datalogger"),
    write = love.thread.newThread("libs/logger/loggerthread.lua")
}
return(logger)
