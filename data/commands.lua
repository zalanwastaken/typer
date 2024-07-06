local commands = {
    ["open"] = function(args)
        if love.filesystem.getInfo("saves/"..args[2]) then
            initar("saves/"..args[2])
            mode = "run"
        else
            love.window.showMessageBox("File not found", "File not found", "info")
        end
    end,
    ["exit"] = function(args)
        if args[2] == "-typer" then
            love.event.quit(0)
        else
            initar("saves/def_save.txt")
            mode = "run"
        end
    end,
    ["dev"] = function(args)
        --TODO
        local cmds = {
            ["enable"] = function()
            end
        }
    end
}
return(commands)
