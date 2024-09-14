--* enabled commands
local enabledcommands = {
    ["open"] = true,
    ["exit"] = true,
    ["dev"] = false, --? Dont allow dev mode to be enabled this easily >:D
    ["find"] = false, --? broken,
    ["pls"] = true,
    ["alias"] = true,
    ["newalias"] = false, --? Still testing
    ["help"] = true,
    ["install"] = false, --? Not implimented yet
    ["new"] = true
}
--* code for commands
local commands = {
    ["open"] = function(args)
        local json = require("libs/json")
        if args[2] == nil then
            return({
                exitcode = 1,
                message = "No file name supplied"
            })
        end
        if love.filesystem.getInfo("saves/"..args[2]) then
            initar("saves/"..args[2])
            if not(love.filesystem.getInfo("saves/save_data.json")) then
                love.filesystem.newFile("saves/save_data.json")
            end
            local jsondata = json.encode({
                filename = "saves/"..args[2],
                top = os.time() --? time of open
            })
            logger.log("save_data.json: "..jsondata)
            love.filesystem.write("saves/save_data.json", jsondata)
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
        local exitcode = 0
        if args[2] == "--typer" then
            if args[3] == "--force" then
                function love.quit()
                    --? instant quit
                    --! NOTE: saving ar doesent matter as its already saved in the defsave as the cmdplt is loaded
                    return false
                end                
                if args[4] ~= nil then
                    exitcode = tonumber(args[4])
                end
            end
            love.event.quit(exitcode)
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
    ["newalias"] = function(args) --? A lot more efficient than the old alias
        if commands[args[2]] ~= nil then
            commands[args[3]] = function(args2)
                return(commands[args[2]](args2))
            end
            if args[4] == "--enable" then
                enabledcommands[args[3]] = true
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
    end,
    ["install"] = function(args)
        --TODO
        return({
            exitcode = 2,
            message = "Not impliemnted... yet !"
        })
    end,
    ["new"] = function(args)
        local json = require("libs/json")
        if not(love.filesystem.getInfo("saves/save_data.json")) then
            return({
                exitcode = 1,
                message = "Unable to find save_data.json for save data"
            })
        end
        local savedata = json.decode(love.filesystem.read("saves/save_data.json"))
        if not(love.filesystem.getInfo(savedata.filename)) then
            love.filesystem.newFile(savedata.filename)
        end
        love.filesystem.write(savedata.filename, love.filesystem.read("saves/def_save.txt"))
        love.filesystem.write("saves/def_save.txt", "")
        local jsondata = json.encode({
            filename = "saves/def_save.txt",
            top = savedata.top,
            tos = os.time()
        })
        love.filesystem.write("saves/save_data.json", jsondata)
        ar = {}
        initar("saves/def_save.txt", true)
        mode = "run"
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
