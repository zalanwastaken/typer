print("Starting verification...")
function error(errdef)
    local fnt = love.graphics.newFont(20)
    function love.draw()
        love.graphics.setFont(fnt)
        love.graphics.setBackgroundColor(1, 0, 0)
        love.graphics.printf(errdef, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
    function love.update(dt)
        -- do nothing
    end
end
local files = { -- list/arraay of files 
    "main.lua",
    "conf.lua",
    "libs/sav.lua",
    "libs/funcs.lua",
    "data/icon.png",
    "data/name.png",
    "html/index.html",
    "html/images/love.ico",
    "html/data/love2d-license.txt",
    "html/info.html",
    "html/images/icon.png",
    "html/help.html",
    "libs/jsonlib.lua",
    "data/settings.json",
    "licence.txt"
}
local fnf = {} -- list of files that are not found 
for i = 1, #files, 1 do -- verify the files here
    print("Verifing..."..files[i])
    if not(love.filesystem.getInfo(files[i])) then
        print(files[i].." Not found")
        fnf[#fnf + 1] = love.filesystem.getSource().."/"..files[i] -- add the files that are not found to fnf
    else
        print("Done verified..."..files[i])
    end
end
if love.filesystem.getInfo("verification_log.log") == nil then
    love.filesystem.newFile("verification_log.log")
    love.filesystem.write("verification_log.log", "First Boot ?\n")
    local msg = love.window.showMessageBox("First boot", "This is the first boot \nWould you like to read the manuel ?", {"Yes", "No"}, "info")
    if msg == 1 then
        love.system.openURL(love.filesystem.getSource().."/html/help.html")
    end
else
    love.filesystem.write("verification_log.log", "") -- clean the log
end
if #fnf > 0 then
    love.filesystem.write("verification_log.log", "Files not found: \n")
    for i = 1, #fnf, 1 do -- write fnf to log
        love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."\n"..fnf[i])
    end
    print("Verification complete with errors...")
    error("Required files not found see "..love.filesystem.getAppdataDirectory().."/LOVE/typer/verification_log.log for more info.") -- error out
end
if love.filesystem.isFused() then
    love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."\nEvents:".."\nInstalltion is fused: "..love.filesystem.getSource()) -- write fused status to log
end
love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."OS: "..love.system.getOS())
print("Verification complete...")
