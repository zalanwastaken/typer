if love.filesystem.getInfo("helpers/commons.lua") then
    require("helpers/commons")
else
    print("ERROR: helpers/commons.lua not found !")
    error("commons.lua not found")
end
-- * config func
function love.conf(t)
    t.version = __LOVEVER__ --* set the love2d version
    if __TYPE__== "DEV" then
        t.window.title = "DEV BUILD "..__VER__
        t.console = true --* set the console
    else
        t.window.title = "Typer "..__VER__ -- * set the window title
        t.console = false --* set the console
    end
    t.window.resizable = true --* make the window resizeable
    love.setDeprecationOutput(false) --! Probably not a good idea
end
