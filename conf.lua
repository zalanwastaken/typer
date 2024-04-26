if love.filesystem.getInfo("helpers/commons.lua") then
    --not found error will be caught by helpers/verify.lua
    require("helpers/commons")
else
    print("ERROR: helpers/commons.lua not found !")
end
--config func
function love.conf(t)
    t.console = true -- set the console
    t.version = __LOVEVER__ -- set the love2d version
    t.window.title = __VER__ -- set the window title
    t.window.resizable = true -- make the window resizeable
    love.setDeprecationOutput(false) -- because no
end
