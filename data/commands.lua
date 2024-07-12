--* enabled commands
local enabledcommands = {
    ["open"] = true,
    ["exit"] = true,
    ["dev"] = true,
    ["find"] = false, --? broken,
    ["pls"] = true
}
--* code for commands
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
        if args[2] == "--typer" then
            love.event.quit(0)
        else
            initar("saves/def_save.txt")
            mode = "run"
        end
    end,
    ["dev"] = function(args)
        if args[2] == "enable" then
            __TYPE__ = "DEV"
            love.window.setTitle("DEV BUILD "..__VER__)
        elseif args[2] == "disable" then
            __TYPE__ = "FR"
            love.window.setTitle("Typer "..__VER__)
        end
    end,
    ["find"] = function(args)
        local def_savedata = love.filesystem.read("saves/def_save.txt")
        def_savedata = split(def_savedata, " ")
        for i = 1, #def_savedata, 1 do
            def_savedata[i] = split(def_savedata[i], "\n")
            local tmp = def_savedata[i]
            for f = 1, #tmp, 1 do
                def_savedata[i] = tmp[f]
            end
        end
        for i = 1, #def_savedata, 1 do
            if def_savedata[i]:lower() == args[2]:lower() then
                logger.log("Found match at word "..i.." def_savedata: "..def_savedata[i].." command arg: "..args[2])
            else
                logger.log("Did not found match at word "..i.." def_savedata: "..def_savedata[i].." command arg: "..args[2])
            end
        end
    end,
    ["pls"] = function(args) --? allows force execution of command if the command is not enabled
        if commands[args[2]] ~= nil then
            local argscmd = {}
            table.remove(args, 1)
            commands[args[1]](args)
        end
    end
}
return{commands = commands, enabledcommands = enabledcommands}
