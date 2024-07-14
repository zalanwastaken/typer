--* enabled commands
local enabledcommands = {
    ["open"] = true,
    ["exit"] = true,
    ["dev"] = false, --? Dont allow dev mode to be enabled this easily >:D
    ["find"] = false, --? broken,
    ["pls"] = true,
    ["alias"] = true
}
--* code for commands
local commands = {
    ["open"] = function(args)
        if love.filesystem.getInfo("saves/"..args[2]) then
            initar("saves/"..args[2])
            mode = "run"
            return({
                exitcode = 0
            })
        else
            return({
                exitcode = 1,
                message = "File not found"
            })
        end
    end,
    ["exit"] = function(args)
        if args[2] == "--typer" then
            love.event.quit(0)
        else
            initar("saves/def_save.txt")
            mode = "run"
        end
        return({
            exitcode = 0
        })
    end,
    ["dev"] = function(args)
        if args[2] == "enable" then
            __TYPE__ = "DEV"
            love.window.setTitle("DEV BUILD "..__VER__)
        elseif args[2] == "disable" then
            __TYPE__ = "FR"
            love.window.setTitle("Typer "..__VER__)
        end
        return({
            exitcode = 0
        })
    end,
    ["find"] = function(args) --? broken
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
        return({
            exitcode = 0
        })
    end,
    ["pls"] = function(args) --? allows force execution of command even if the command is not enabled(kinda OP)
        if commands[args[2]] ~= nil then
            local argscmd = {}
            table.remove(args, 1)
            return(commands[args[1]](args))
        else
            return({
                exitcode = 1,
                message = "Command not found"
            })
        end
    end,
    ["alias"] = function(args) --? Pretty inefficient
        if commands[args[2]] ~= nil then
            if not(#args < 5 and #args ~= 5) then
                return({
                    exitcode = 2,
                    message = "Not implimented"
                })
            else
                commands[args[3]] = commands[args[2]]
                if args[4] == "--disable" then
                    enabledcommands[args[3]] = false
                else
                    enabledcommands[args[3]] = true
                end
            end
            return({
                exitcode = 0
            })
        else
            return({
                exitcode = 1,
                message = "Command not found"
            })
        end
    end,
    ["help"] = function(args)
        love.system.openURL("https://devzalanwastaken.neocities.org/help-typer")
        love.timer.sleep(1)
        return({
            exitcode = 0
        })
    end
}
return({commands = commands, enabledcommands = enabledcommands}) --? Looks stupid I know but... it works so dont touch it !
--[[
! EXIT CODES
* 0 == exited successfully
* 1 == general error
* 2 == not impliemnted
--]]
