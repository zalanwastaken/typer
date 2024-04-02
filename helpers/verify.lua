print("Starting verification...")
function error(errordef)
    print("Error: "..errordef)
    local fnt = love.graphics.newFont(20)
    function love.draw()
        love.graphics.setFont(fnt)
        love.graphics.setBackgroundColor(0, 0, 1)
        love.graphics.printf(errordef, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
        love.graphics.print(__VER__, 5, love.graphics.getHeight() - 20)
    end
    function love.update(dt)
        -- do nothing
    end
    function love.textinput(key)
        -- do nothing
    end
end
local files = { -- list/array of files 
    -- /dir
    "main.lua",
    "conf.lua",
    "licence.txt",
    -- /libs dir
    "libs/sav.lua",
    "libs/funcs.lua",
    "libs/jsonlib.lua",
    -- /data dir
    "data/icon.png",
    "data/name.png",
    "data/settings.json",
    "data/logo.txt",
    "data/sounds/ping.mp3",
    -- /html dir
    "html/index.html",
    "html/images/love.ico",
    "html/data/love2d-license.txt",
    "html/info.html",
    "html/images/icon.png",
    "html/help.html",
    "html/Dontopenme.html",
    "html/.troll",
    -- /helpers dir
    "helpers",
    "helpers/commons.lua"
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
    love.filesystem.write("verification_log.log", "First Boot\n"..os.time().."\n")
    local msg = love.window.showMessageBox("First boot", "This is the first boot \nWould you like to read the manuel ?", {"Yes", "No"}, "info")
    if msg == 1 then
        love.system.openURL(love.filesystem.getSource().."/html/help.html")
    end
else
    love.filesystem.write("verification_log.log", os.time()) -- clean the log
end
love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."\n--------------------")
if #fnf > 0 then
    love.filesystem.write("verification_log.log", "Files not found: \n")
    for i = 1, #fnf, 1 do -- write fnf to log
        love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."\n"..fnf[i])
    end
    print("Verification complete with errors...")
    error("Required files not found see "..love.filesystem.getAppdataDirectory().."/LOVE/typer/verification_log.log for more info.") -- error out
else
    love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."\nVerification compleated successfully")
end
love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."\n--------------------")
if love.filesystem.isFused() then
    love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."\nInstalltion is fused: "..love.filesystem.getSource()) -- write fused status to log
else
    love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."\nInstalltion is not fused: "..love.filesystem.getSource()) -- write fused status to log
end
love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."\n--------------------")
love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."\nOS: "..love.system.getOS())
print("Verification complete...")
--print text art logo to console (Idk why but its cool)
local textlogo = love.filesystem.read("data/logo.txt")
print(textlogo)
textlogo = nil
