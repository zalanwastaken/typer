if love.filesystem.getInfo("helpers/commons.lua") then
    --not found error will be caught by helpers/verify.lua
    require("helpers/commons")
end
--config func
function love.conf(t)
    t.console = true -- set the console
    t.version = 11.5 -- set the love2d version
    t.window.title = __VER__ -- set the window title
    t.window.resizable = true -- make the window resizeable
end
