print("Starting verification...")
if love.filesystem.getInfo("html") then
    if love.system.getOS():lower() == "windows" then
        os.execute("rmdir /q /s "..string.gsub(love.filesystem.getAppdataDirectory())..[[\LOVE\typer\html]], "/", "\\") --! OS specific code(windows)
    elseif love.system.getOS():lower() == "linux" then
        os.execute("rm -rf "..love.filesystem.getAppdataDirectory().."love/typer/html") --! OS specific code(linux)
    end
end
local files
if love.filesystem.getInfo("helpers/verify/filelist.lua") then
    files = require("helpers/verify/filelist")
else
    error("Unable to fetch filelist") --* this is here to not let the user get to the code below as it is in testing
    local usrchoise = love.window.showMessageBox("Unable to verify files", "Typer was unable to verify files\nWould you like to recrate the filelists from local install ?", {"Exit", "Create new filelist"}, "error")
    if usrchoise == 1 then
        error("Unable to fetch filelist") --* error out
    elseif usrchoise == 2 then
        --TODO
    end
end
local fnf = {} -- list of files that are not found 
for i = 1, #files, 1 do -- verify the files here
    print("Verifing..."..files[i])
    local tmp = love.filesystem.read(files[i])
    if not(love.filesystem.getInfo(files[i])) and not(tmp ~= nil) then
        print(files[i].." Not found")
        fnf[#fnf + 1] = love.filesystem.getSource().."/"..files[i] -- add the files that are not found to fnf
    else
        print("Done verified..."..files[i])
    end
end
local logger = require("libs/logger")
if #fnf > 0 then
    if love.filesystem.getInfo("logs/verification_log.log") then
        love.filesystem.newFile("logs/verification_log.log")
        love.filesystem.write("logs/verification_log.log", os.date())
    else
        love.filesystem.write("logs/verification_log.log", os.date())
    end
    for i = 1, #fnf, 1 do
        love.filesystem.write("logs/verification_log.log", love.filesystem.read("logs/verification_log.log").."\n"..fnf[i])
    end
    error("Required files not found.\nCheck: "..love.filesystem.getAppdataDirectory().."love/typer/logs/verfication_log.log")
else
    logger = require("libs/logger")
    for i = 1, #files, 1 do
        logger.datastack:push(files[i].."...OK\n")
    end
    logger.datastack:push("Files verified "..#files.."\n")
    logger.datastack:push("ALL VERIFIED\n")
end
logger.datastack:push("--------------------\n")
if love.filesystem.isFused() then
    --logger.datastack:push("Installtion is fused: "..love.filesystem.getSource())
    logger.log("Installtion is fused: "..love.filesystem.getSource())
else
    --logger.datastack:push("Installtion is not fused: "..love.filesystem.getSource())
    logger.log("Installtion is not fused: "..love.filesystem.getSource())
end
logger.datastack:push("--------------------\nOS:"..love.system.getOS().."\n")
logger.log("System prossor count: "..love.system.getProcessorCount())
if love.system.getProcessorCount() < 2 and love.system.getProcessorCount() ~= 2 then --? one for logger one for main thread
    error("Your pc dosent meets Typer system requirments")
end
print("Verification complete...")
--? clean vars
files = nil
fnf = nil
logger = nil
