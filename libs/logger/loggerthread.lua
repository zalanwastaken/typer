require("love.timer")
require("libs/funcs")
require("helpers/commons") --? for __TYPE__ var
local function printlogger(str)
    print("[THREAD/LOGGER]["..os.time().."] "..str)
end
printlogger("Starting logger...")
local __VER__ = [[TYPER-NO-FR-LOGGER]]
local datastack = love.thread.getChannel("datalogger") --? the datastack to get data from the main thread
if not(love.filesystem.getInfo("logs")) then
    love.filesystem.createDirectory("logs")
end
--* Create the log file
printlogger("Creating new log file")
local file = "logs/log_"..os.time()..".log"
if not(love.filesystem.getInfo(file)) then
    love.filesystem.newFile(file)
    love.filesystem.write(file, "LOGGER VER: "..__VER__.."\n")
end
--* Clean old log files
if #love.filesystem.getDirectoryItems("logs") >= 12 then
    printlogger("Cleaning old logs")
    local filetmp = love.filesystem.getDirectoryItems("logs")
    local minval = 1
    for i = 1, #filetmp, 1 do
        if filetmp[i] == "verification_log.log" then
            minval = minval + 1
        end
    end
    for i = 1, #filetmp-minval, 1 do
        if filetmp[i] ~= nil then
            love.filesystem.remove("logs/"..filetmp[i])
        else
            break
        end
    end
end
if love.filesystem.getInfo("logs/verification_log.log") then
    love.filesystem.remove("logs/verification_log.log")
end
--* Main logging loop
while true do
    local data = datastack:pop()
    local tmp, size
    if data ~= nil and data ~= "STOP" then
        tmp, size = love.filesystem.read(file)
        if tmp ~= nil then
            love.filesystem.write(file, tmp.."["..(os.date()).."] "..data)
            printlogger(data)
        else
            error("UNABLE TO READ FILE\nLOGGER ERROR")
        end
        if size >= 500000 then --? 500000Bytes = 4 MB
            printlogger("Warning: file is large, read write speed reduced")
        end
    elseif data == "STOP" then
        break
    else
        love.timer.sleep(0.1)
    end
end
love.filesystem.write(file, love.filesystem.read(file).."\n["..os.date().."] Logger stopped...")
printlogger("Logger stopped...")
