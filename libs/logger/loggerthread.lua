require("love.timer")
require("libs/funcs")
print("Starting logger...")
local __VER__ = [[TYPER-NO-FR-LOGGER]]
require("helpers/commons") -- for __TYPE__ var
if not(love.filesystem.getInfo("logs")) then
    love.filesystem.createDirectory("logs")
end
local datastack = love.thread.getChannel("datalogger")
local file = "logs/log_"..os.time()..".log"
if not(love.filesystem.getInfo(file)) then
    love.filesystem.newFile(file)
    love.filesystem.write(file, os.date().."\n")
end
if #love.filesystem.getDirectoryItems("logs") >= 12 then
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
love.filesystem.write(file, love.filesystem.read(file).."\nLOGGER VER: "..__VER__.."\n")
while true do
    local data = datastack:pop()
    local tmp, size
    if data ~= nil and data ~= "STOP" then
        tmp, size = love.filesystem.read(file)
        if tmp ~= nil then
            love.filesystem.write(file, tmp.."["..(os.date()).."] "..data)
        else
            error("UNABLE TO READ FILE\nLOGGER ERROR")
        end
        if size >= 500000 then --? 500000Bytes = 4 MB
            print("Warning: file is large, read write speed reduced")
        end
    elseif data == "STOP" then
        love.filesystem.write(file, love.filesystem.read(file).."\nLogger stopped")
        print("Logger stopped...")
        break
    else
        love.timer.sleep(0.1)
    end
end
