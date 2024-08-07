function love.load()
    if love.filesystem.getInfo("helpers/verify") then
        require("helpers/verify") -- run the verification script
    else
        print("error: Unable to verify interigrity") -- if the script is not found print the error to the console
        if love.filesystem.getInfo("verification_log.log") then 
            love.filesystem.write("verification_log.log", os.time().."\nFiles not found:\n"..love.filesystem.getSource().."/helpers/verify.lua") -- write the log
        else
            love.filesystem.newFile("verification_log.log") -- create the log file if it does not exists
            love.filesystem.write("verification_log.log", os.time().."\nFiles not found:\n"..love.filesystem.getSource().."/helpers/verify.lua") -- write the log
        end
        error("We are currently unable to verify interigrity for the safety of your data this programwill now shutdown. \nYou can try reinstalling the program.\nReinstalling will not affect your data.") -- error out
    end
    logger = require("libs/logger")
    require("libs/sav") --* save library
    require("libs/funcs") --* functions
    local data = require("data/commands") --* commands and their functions
    commands = data.commands
    enabledcommands = data.enabledcommands
    --OwO u actually read comments ?
    if not(love.filesystem.getInfo("saves")) then
        love.filesystem.createDirectory("saves") -- create the saves dir
    end
    if not(love.filesystem.getInfo("saves/def_save.txt")) then
        love.filesystem.newFile("saves/def_save.txt")
        err = love.filesystem.write("saves/def_save.txt", __VER__)
        print(err)
    end
    initar("saves/def_save.txt", true) -- init the ar variable (load saves/def_save.txt into ar)
    sel = #ar
    love.keyboard.setKeyRepeat(true) -- set repeat to true so user can press and hold
    love.window.setIcon(love.image.newImageData("data/icon.png")) -- set the image and create the image data
    if not(skipname) then
        name = false
        timer = 0
        name_image = love.graphics.newImage("data/name.png")
        opacity = 5
    else
        name = true
    end
    y = 0 --* the y pos of the draw array
    x = 0 --* the x pos of the draw array
    if __TYPE__ == "DEV" then
        debuginfo = false
    end
    fnt = love.graphics.newFont(12) -- font for the program (create here not set)
    love.graphics.setFont(fnt) -- set the font
    ping = love.audio.newSource("data/sounds/ping.mp3", "static")
    if __TYPE__ == "DEV" then
        logger.datastack:push("WARNING: This build is configured as DEV !\n")
        tmp = showMessageBox("Warning", "This build is configured as DEV\nDEV builds are only supposed to be for modders and developers\nContinue?", {"Yes", "No"}, "warning")
        if tmp == 2 then
            forcequit(0)
        end
    end
    for i = 1, #testedos, 1 do
        if testedos[i] == love.system.getOS() then
            break
        elseif i == #testedos then
            showMessageBox("Warning", "Typer has not been tested on "..love.system.getOS(), "warning")
        end
    end
    tmp = 0
    for i = 1, #ar, 1 do
        if ar[i] ~= "\n" then
            tmp = tmp + 1
        else
            tmp = 0
        end
    end
    if tmp * 12 - math.abs(x * 1.5) > love.graphics.getWidth() + (love.graphics.getWidth() / 4) then
        i = 0
        while tmp * 12 - math.abs(x * 1.5) > love.graphics.getWidth() + (love.graphics.getWidth() / 4) do
            i = i + 1
            x = x - 314 * love.timer.getDelta()
        end
    end
    -- ? log some more info
    love_major, love_minnor, love_rev, love_codename = love.getVersion()
    logger.datastack:push("LOVE2D VER: "..love_major.."."..love_minnor.."."..love_rev.."\n".."LOVE2D CODENAME: "..love_codename.."\n".."VER: "..__VER__.."\n".."TYPE: "..__TYPE__.."\n")
    logger.datastack:push("Made by Zalan(Zalander)\n")
    logger.datastack:push("\n"..love.filesystem.read("data/logo.txt").."\n")
    logger.write:start()
end
function love.update(dt)
    if love.keyboard.isDown("lctrl") and love.keyboard.isDown("d") and __TYPE__ == "DEV" then
        debuginfo = true
    end
    if love.keyboard.isDown("lctrl") and love.keyboard.isDown("f") and __TYPE__ == "DEV" then
        debuginfo = false
    end
    if mode == "run" then
        if (getnewlines(ar, 1) + 3) * 14 - math.abs(y) > love.graphics.getHeight() then
            y = y - 12
        end
        if love.keyboard.isDown("lctrl") and love.keyboard.isDown("s") then
            ar[#ar] = nil
            logger.datastack:push("User saved ar\n")
            save_ar(0)
            ar[#ar + 1] = "\b"
        end
    end
    if love.keyboard.isDown("lctrl") and love.keyboard.isDown("e") and __TYPE__ == "DEV" then
        logger.datastack:push("ERROR INIT BY USER NOT A BUG\n")
        error("Error init by user")
    end
    if love.keyboard.isDown("escape") then
        love.event.quit(0)
    end
    if (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) and (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) and love.keyboard.isDown("c") and mode ~= "cmdplt" then
        logger.log("mode changed to cmdplt")
        mode = "cmdplt"
        save_ar(1)
        ar = {"\b"}
    end
end
function love.draw()
    love.graphics.setColor(1, 1, 1)
    if name then
        love.graphics.setColor(1, 1, 1, 1)
        if getnewlines(ar, 1) > 100 and mode ~= "cmdplt" then
            love.graphics.print(ar, x + 32, y)
        elseif mode ~= "cmdplt" then
            love.graphics.print(ar, x + 20, y)
        end
        for i = 0, getnewlines(ar, 1), 1 do
            love.graphics.print(i, 0, i * 14 + y)
        end
        love.graphics.rectangle("line", 0, love.graphics.getHeight() - 20, love.graphics.getWidth(), 30)
        if __TYPE__ == "DEV" then
            love.graphics.setColor(1, 0, 0)
            love.graphics.print("DEV BUILD "..__VER__, 0, love.graphics.getHeight() - 20)
            love.graphics.setColor(1, 1, 1)
        end
        if mode == "run" then
            love.graphics.print("Press CTRL + s to save", love.graphics.getWidth() - (#"Press CTRL + s to save" * 12), love.graphics.getHeight() - 20)
        elseif mode == "cmdplt" then
            love.graphics.rectangle("fill", (love.graphics.getWidth() / 2) - 90, (love.graphics.getHeight() / 2) - 50, 180, 100)
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", (love.graphics.getWidth() / 2) - 80, (love.graphics.getHeight() / 2) - 40, 160, 80)
            love.graphics.setColor(1, 1, 1)
            if #ar <= 1 then
                love.graphics.print("Command palette", (love.graphics.getWidth() / 2) - 77, (love.graphics.getHeight() / 2) - 30)
            else
                love.graphics.print(ar, (love.graphics.getWidth() / 2) - 77, (love.graphics.getHeight() / 2) - 30)
            end
            if love.keyboard.isDown("return") then
                local tmp = ""
                for i = 1, #ar-1, 1 do
                    tmp = tmp..ar[i]
                end
                local cmd = split(tmp, " ")
                tmp = nil
                if commands[cmd[1]] ~= nil and enabledcommands[cmd[1]] == true then
                    local output = commands[cmd[1]](cmd)
                    if output.exitcode ~= 0 then
                        if output.message == nil then
                            output.message = "N/A"
                        end
                        love.window.showMessageBox("Command exited unsuccessfully", [["]]..cmd[1]..[["]].." ended with exit code "..output.exitcode.."\n command output message: "..output.message)
                    end
                else
                    love.window.showMessageBox("Error", "Command not found !", "error")
                end
            end
            if (love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt")) and (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) and love.keyboard.isDown("c") then
                initar("saves/def_save.txt", true)
                mode = "run"
            end
        end
        if love.keyboard.isDown("lctrl") and mode == "run" and love.keyboard.isDown("s") then
            love.graphics.print("(saved)", love.graphics.getWidth() - 69, love.graphics.getHeight() - 20)
        end
        if __TYPE__ == "DEV" and debuginfo then
            love.graphics.setColor(1, 0, 1)
            love.graphics.print("DEBUG INFO", 0, 0)
            love.graphics.print("Array length: "..#ar, 0, 12)
            love.graphics.print("X & Y: "..x.." "..y, 0, 24)
            love.graphics.print("LOVE2D VER: "..love_major.."."..love_minnor.."."..love_rev.." "..love_codename, 0, 36)
            love.graphics.print("TYPER VER: "..__VER__.." "..__TYPE__.." Build", 0, 48)
            love.graphics.setColor(1, 1, 1)
        end
    else
        love.graphics.setColor(1, 1, 1, opacity)
        opacity = opacity - 3.14 * love.timer.getDelta() -- 3.14 gives the smoothest transition idk why ¯\_(ツ)_/¯
        timer = timer + 10 * love.timer.getDelta()
        love.graphics.draw(name_image, (love.graphics.getWidth()) - name_image:getWidth(), (love.graphics.getHeight()) - name_image:getHeight())
        if __TYPE__ == "DEV" then
            local x = 0
            local y = 0
            local files = love.filesystem.getDirectoryItems("logs")
            for i = 1, #files, 1 do
                files[i] = tonumber(removeCharsKeepNumbers(files[i])) -- * get the file id
            end
            if unpack(files) == nil then
                return
            end
            local filedata = love.filesystem.read("logs/log_"..tostring(math.max(unpack(files)))..".log")
            if (gettnewlinesstring(filedata) + 3) * 18 - math.abs(y) > love.graphics.getHeight() then
                while (gettnewlinesstring(filedata) + 3) * 14 - math.abs(y) > love.graphics.getHeight() do
                    y = y - 12
                end
            end
            love.graphics.print(filedata, x, y)
        end
        if timer > 15 or (love.keyboard.isDown("space") and name == false) then
            name = true
            -- clean variables that are no longer needed 
            opacity = nil
            timer = nil
            name_image = nil
        end
    end
end
function love.keypressed(key)
    if not(#ar-1 < 0 or #ar-1 == 0) then
        --table.remove(ar, sel)
        if key == "left" then
            local lastchar = ar[sel-1]
            sel = sel - 1
            ar[sel+1] = lastchar
            ar[sel] = "\b"
        end
        if key == "right" and sel ~= #ar then
            local lastchar = ar[sel+1]
            sel = sel + 1
            ar[sel-1] = lastchar
            ar[sel] = "\b"
        end
        logger.datastack:push("Key pressed "..key.."\n")
        tmp = 0
        for i = 1, #ar, 1 do
            if ar[i] ~= "\n" then
                tmp = tmp + 1
            else
                tmp = 0
            end
        end
        if tmp * 12 - math.abs(x * 1.5) > love.graphics.getWidth() + (love.graphics.getWidth() / 4) then
            while tmp * 12 - math.abs(x * 1.5) > love.graphics.getWidth() + (love.graphics.getWidth() / 4) do
                x = x - 314 * love.timer.getDelta()
            end
        end
        --ar[#ar] = nil
        --table.remove(ar, sel)
        --sel = sel - 1
        if key == "escape" and mode ~= "run" then
            mode = "run"
            ar = {}
            initar("saves/def_save.txt", false)
        end
        if key == "return" or key == "down" then
            if mode == "run" then
                ar[#ar + 1] = "\n"
                x = 0
            end
        end
        if key == "backspace" or key == "up" then
            logger.datastack:push(ar[#ar].." Removed from ar\n")
            if mode == "run" then
                --save_ar(0)
                tmp = 0
                for i = 1, #ar, 1 do
                    if ar[i] ~= "\n" then
                        tmp = tmp + 1
                    else
                        tmp = 0
                    end
                end
                if tmp * 12 - math.abs(x * 1.5) < love.graphics.getWidth() + (love.graphics.getWidth() / 4) then
                    if x + 314 * love.timer.getDelta() < 0 then
                        while tmp * 12 - math.abs(x * 1.5) < love.graphics.getWidth() + (love.graphics.getWidth() / 4) do
                            x = x + 314 * love.timer.getDelta()
                            if x > love.graphics.getWidth() then
                                x = 0
                                break
                            end
                        end
                    else
                        x = 0
                    end
                end
                if not(y == 0) then
                    if ar[#ar] == "\n" then 
                        if y > 0 then
                            y = 0
                        else
                            y = y + 15
                        end
                    end
                end
            end
            --ar[#ar] = nil
            --table.remove(ar, sel)
            --sel = sel - 1
            ar[sel-1] = "\b"
            ar[sel] = nil
            sel = sel - 1
        end
        --ar[#ar + 1] = "\b"
        --table.insert(ar, sel, "\b")
    elseif key == "return" then
        table.remove(ar, sel)
        table.insert(ar, sel, "\n")
        table.insert(ar, sel, "\b")
        sel = sel + 1
        --[[
        ar[#ar] = nil
        ar[#ar + 1] = "\n"
        ar[#ar + 1] = "\b"
        --]]
    else
        logger.datastack:push("keypressed check skipped ar too short\n")
    end
end
function love.textinput(key) -- add the typed letters to ar while ignoring the modifier keys (exept Caps lock and shift and some others too)
    --[[
    ar[#ar] = nil
    ar[#ar + 1] = key
    ar[#ar + 1] = "\b"
    logger.datastack:push("Placed "..key.." in ar\n")
    --]]
    ar[sel] = nil
    --[[
    if sel == #ar then
        ar[sel] = key
        sel = sel + 1
        ar[sel] = "\b"
    else
        table.insert(ar, sel, key)
        sel = sel + 1
        table.insert(ar, sel, "\b")
    end
    --]]
    table.insert(ar, sel, key)
    sel = sel + 1
    table.insert(ar, sel, "\b")
end
function love.quit()
    logger.log("Exit init")
    local usrchoise = showMessageBox("Exit", "Exit ?", {"Yes", "No"})
    if usrchoise == 1 then
        logger.log("Exited")
        if mode ~= "cmdplt" then
            usrchoise = showMessageBox("Save", "Save ? ", {"Yes", "No"})
            if usrchoise == 1 then
                logger.log("Saved ar")
                save_ar(1)
            else
                logger.log("Aborted saving ar")
            end
        end
        logger.stop()
        return false
    else
        logger.log("Exit aboorted")
        return true
    end
end
--[[
* Made by Zalan(Zalander) aka zalanwastaken with LÖVE and some 🎔
! ________  ________  ___       ________  ________   ___       __   ________  ________  _________  ________  ___  __    _______   ________      
!|\_____  \|\   __  \|\  \     |\   __  \|\   ___  \|\  \     |\  \|\   __  \|\   ____\|\___   ___\\   __  \|\  \|\  \ |\  ___ \ |\   ___  \    
! \|___/  /\ \  \|\  \ \  \    \ \  \|\  \ \  \\ \  \ \  \    \ \  \ \  \|\  \ \  \___|\|___ \  \_\ \  \|\  \ \  \/  /|\ \   __/|\ \  \\ \  \   
!     /  / /\ \   __  \ \  \    \ \   __  \ \  \\ \  \ \  \  __\ \  \ \   __  \ \_____  \   \ \  \ \ \   __  \ \   ___  \ \  \_|/_\ \  \\ \  \  
!    /  /_/__\ \  \ \  \ \  \____\ \  \ \  \ \  \\ \  \ \  \|\__\_\  \ \  \ \  \|____|\  \   \ \  \ \ \  \ \  \ \  \\ \  \ \  \_|\ \ \  \\ \  \ 
!   |\________\ \__\ \__\ \_______\ \__\ \__\ \__\\ \__\ \____________\ \__\ \__\____\_\  \   \ \__\ \ \__\ \__\ \__\\ \__\ \_______\ \__\\ \__\
!    \|_______|\|__|\|__|\|_______|\|__|\|__|\|__| \|__|\|____________|\|__|\|__|\_________\   \|__|  \|__|\|__|\|__| \|__|\|_______|\|__| \|__|
!                                                                                \|_________|                                                   
--]]
