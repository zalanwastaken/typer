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
    require("libs/sav") -- save library
    require("libs/funcs") -- functions
    require("libs/jsonlib") -- json library
    --OwO u actually read comments ?
    if not(love.filesystem.getInfo("saves")) then
        love.filesystem.createDirectory("saves") -- create the saves dir
    end
    initar("saves/def_save.txt", true) -- init the ar variable (load saves/def_save.txt into ar)
    love.keyboard.setKeyRepeat(true) -- set repeat to true so user can press and hold
    set = read("data/settings.json")
    logger.datastack:push("\nSettings Config:\n"..love.filesystem.read("data/settings.json"))
    love.window.setIcon(love.image.newImageData("data/icon.png")) -- set the image and create the image data
    name = false
    timer = 0
    name_image = love.graphics.newImage("data/name.png")
    y = 0 -- the y pos of the draw array
    x = 0 -- the x pos of the draw array
    fnt = love.graphics.newFont(12) -- font for the program (create here not set)
    love.graphics.setFont(fnt) -- set the font
    ping = love.audio.newSource("data/sounds/ping.mp3", "static")
    opacity = 5
    if __TYPE__ == "DEV" then
        logger.datastack:push("WARNING: This build is configured as DEV !\n")
        love.audio.play(ping)
        love.timer.sleep(0.01) -- ? wait for the sound to play
        tmp = love.window.showMessageBox("Warning", "This build is configured as DEV\nDEV builds are only supposed to be for modders and developers\nContinue?", {"Yes", "No"}, "warning") -- message box
        if tmp == 2 then
            function love.quit() -- ? Change the quit function to always quit
                return false
            end
            love.event.quit(0) -- quit if no is pressed
        end
    end
    for i = 1, #testedos, 1 do
        if testedos[i] == love.system.getOS() then
            break
        elseif i == #testedos then
            love.window.showMessageBox("Warning", "Typer has not been tested on "..love.system.getOS(), "warning")
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
    local major, minnor, rev, codename = love.getVersion()
    logger.datastack:push("\nLOVE2D VER: "..major.."."..minnor.."."..rev.."\n".."LOVE2D CODENAME: "..codename.."\n".."VER: "..__VER__.."\n".."TYPE: "..__TYPE__.."\n")
    logger.datastack:push("\nMade by Zalan(Zalander)")
    logger.datastack:push("\n"..love.filesystem.read("data/logo.txt"))
    logger.write:start()
end
function love.update(dt)
    if mode == "run" then
        if (getnewlines(ar, 1) + 3) * 14 - math.abs(y) > love.graphics.getHeight() then
            y = y - 12
        end
        if set[6] == "true" then
            tmp = 0
            for i = 1, #ar, 1 do
                if ar[i] == "\n" then
                    tmp = 0
                else
                    tmp = tmp + 1
                end
            end
        end
        if love.keyboard.isDown("lctrl") and love.keyboard.isDown("s") then
            ar[#ar] = nil
            print("Saved "..os.time())
            save_ar(0)
            ar[#ar + 1] = "\b"
        end
    end
    if love.keyboard.isDown("lctrl") and love.keyboard.isDown("e") and love.keyboard.isDown("lalt") and __TYPE__ == "DEV" then
        logger.datastack:push("ERROR INIT BY USER NOT A BUG")
        error("Error init by user")
    end
    if love.keyboard.isDown("escape") then
        love.event.quit(0)
    end
end
function love.draw()
    love.graphics.setColor(1, 1, 1)
    if name then
        love.graphics.setColor(1, 1, 1, 1)
        if getnewlines(ar, 1) > 100 then
            if set[2] == "true" then
                love.graphics.printf(ar, x + 32, y, love.graphics.getWidth())
            else
                love.graphics.print(ar, x + 32, y)
            end
        else
            if set[2] == "true" then
                love.graphics.printf(ar, x + 20, y, love.graphics.getWidth())
            else
                love.graphics.print(ar, x + 20, y)
            end
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
            love.graphics.print("Press CTRL + s to save", 12 * 36, love.graphics.getHeight() - 20)
        elseif mode == "file opn" then
            love.graphics.print("This is load mode enter filename to be loaded", 12 * 36, love.graphics.getHeight() - 20)
            tmp = love.filesystem.getDirectoryItems("saves/")
            love.graphics.print("Files: "..love.filesystem.getAppdataDirectory(), 0, love.graphics.getHeight() / 2)
            for i = 1, #tmp, 1 do
                love.graphics.print(tmp[i], ((i - 1)* 12) * #tmp[i], (love.graphics.getHeight() / 2 )+ 12) 
            end
            love.graphics.rectangle("line", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), love.graphics.getHeight() / 2)
        elseif mode == "file sav" then
            love.graphics.print("This is save mode enter filene to be saved", 12 * 36, love.graphics.getHeight() - 20)
            tmp = love.filesystem.getDirectoryItems("saves/")
            love.graphics.print("Files: "..love.filesystem.getAppdataDirectory(), 0, love.graphics.getHeight() / 2)
            for i = 1, #tmp, 1 do
                love.graphics.print(tmp[i], ((i - 1)* 12) * #tmp[i], (love.graphics.getHeight() / 2 )+ 12) 
            end
            love.graphics.rectangle("line", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), love.graphics.getHeight() / 2)
        end
        if love.keyboard.isDown("lctrl") and mode == "run" and love.keyboard.isDown("s") then
            love.graphics.print("(saved)", love.graphics.getWidth() - 69, love.graphics.getHeight() - 20)
        end
    else
        love.graphics.setColor(1, 1, 1, opacity)
        opacity = opacity - 3.14 * love.timer.getDelta() -- 3.14 gives the smoothest transition idk why ¯\_(ツ)_/¯
        timer = timer + 10 * love.timer.getDelta()
        love.graphics.draw(name_image, (love.graphics.getWidth() / 1.5) - name_image:getWidth(), (love.graphics.getHeight() / 1.5) - name_image:getHeight())
        if __TYPE__ == "DEV" then
            local x = 0
            local y = 0
            local files = love.filesystem.getDirectoryItems("logs")
            for i = 1, #files, 1 do
                files[i] = tonumber(removeCharsKeepNumbers(files[i])) -- * get the file id
            end
            for i = 1, #files, 1 do
                if files[i] == nil then
                    logger.datastack:push("STOP")
                    logger.write:wait()
                    local tmp = love.filesystem.getDirectoryItems("logs")
                    for f = 1, #tmp, 1 do
                        love.filesystem.remove("logs/"..tmp[f])
                    end
                    logger.datastack:push("BAD FILE IN LOGS\n")
                    logger.datastack:push("LOG DATA LOST !\n")
                    logger.datastack:push("REMOVED LOG FILES:\n")
                    local formatstring = ""
                    for i = 1, #tmp, 1 do
                        formatstring = formatstring..tmp[i].."\n"
                    end
                    logger.datastack:push(formatstring)
                    logger.write:start()
                    love.timer.sleep(1)
                    files = love.filesystem.getInfo("logs")
                    for f = 1, #files, 1 do
                        files[f] = tonumber(removeCharsKeepNumbers(files[f])) -- * get the file id
                    end
                    function love.quit() -- ? setup quit for love.event.quit("restart") to immedieatly restart
                        return false
                    end
                    logger.datastack:push("Restarting LOVE\n")
                    logger.datastack:push("STOP")
                    logger.write:wait()
                    love.event.quit("restart")
                    return 1
                    --break
                end
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
        ar[#ar] = nil
        if key == "escape" and mode ~= "run" then
            mode = "run"
            ar = {}
            initar("saves/def_save.txt", false)
        end
        if key == "return" or key == "down" then
            if mode == "run" then
                --save_ar(2) -- ? save ar comes from the funcs.lua file in the libs folder
                if ar[#ar - 1] == "/" and ar[#ar] == "l" then
                    ar = {}
                    mode = "file opn"
                elseif ar[#ar - 1] == "/" and ar[#ar] == "s" then
                    ar = {}
                    mode = "file sav"
                elseif ar[#ar - 2] == "/" and ar[#ar - 1] == "h" and ar[#ar] == "/" then
                    --love.system.openURL(love.filesystem.getSource().."/html/help.html")
                    love.system.openURL(__HTML__.."/help.html")
                    for i = 1, 3, 1 do
                        ar[#ar] = nil
                    end
                else
                    ar[#ar + 1] = "\n"
                    x = 0
                end
            else
                if mode == "file opn" then
                    tmp = ""
                    for i = 1, #ar, 1 do
                        tmp = tmp..ar[i] -- move everything (ar) into tmp as a string
                    end
                    if not(love.filesystem.getInfo("saves/"..tmp)) then
                        love.window.showMessageBox("File not found", "File not found: ".."saves/"..tmp, "error")
                        ar = {}
                        initar("saves/def_save.txt", true)
                        mode = "run"
                    else
                        -- Open the file and init ar
                        print("opened: ", tmp)
                        save("saves/def_save.txt", love.filesystem.read("saves/"..tmp))
                        ar = {}
                        initar("saves/def_save.txt", true)
                        mode = "run"
                    end
                end
                if mode == "file sav" then
                    if ar[1] == "-" and ar[2] == "e" then
                        tmp = ""
                        for i = 3, #ar, 1 do
                            tmp = tmp..ar[i]
                        end
                        exportar(tmp)
                        ar = {}
                        initar("saves/def_save.txt", true)
                        mode = "run"
                    else
                        tmp = ""
                        for i = 1, #ar, 1 do
                            tmp = tmp..ar[i] -- move everything in ar into tmp as a string
                        end
                        if not(love.filesystem.getInfo("saves/"..tmp)) then
                            love.filesystem.newFile("saves/"..tmp)
                        end
                        print("saved:", tmp)
                        save("saves/"..tmp, load("saves/def_save.txt"))
                        ar = {}
                        initar("saves/def_save.txt", true)
                        mode = "run"
                    end
                end
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
            ar[#ar] = nil
        end
        ar[#ar + 1] = "\b"
    else
        logger.datastack:push("keypressed check skipped ar too short\n")
    end
end
function love.textinput(key) -- add the typed letters to ar while ignoring the modifier keys (exept Caps lock and shift and some others too)
    ar[#ar] = nil
    ar[#ar + 1] = key
    ar[#ar + 1] = "\b"
    logger.datastack:push("Placed "..key.." in ar\n")
end
function love.quit()
    logger.datastack:push("Exit init\n")
    love.audio.play(ping)
    love.timer.sleep(0.01) -- ? wait a little for the sound to play
    local usrchoise = love.window.showMessageBox("Exit", "Exit ?", {"Yes", "No"})
    if usrchoise == 1 then
        logger.datastack:push("Exited\n")
        love.audio.stop(ping)
        love.audio.play(ping)
        love.timer.sleep(0.01) -- ? wait a little for the sound to play
        usrchoise = love.window.showMessageBox("Save", "Save ?", {"Yes", "No"})
        if usrchoise == 1 then
            logger.datastack:push("Saved ar\n")
            save_ar(1)
        else
            logger.datastack:push("Aborted saving ar\n")
        end
        logger.datastack:push("STOP")
        logger.write:wait() -- ? wait for the logger to stop
        return false
    else
        logger.datastack:push("Exit aboorted\n")
        return true
    end
end
--[[
    * Made by Zalan(Zalander) aka zalanwastaken with LÖVE and some 🎔
    ! BTW dont steal my code because that would be bad :( (You can use it but pls mention that it was modified and dont claim to be the owner of Typer)
    ? Fun fact Typer was never ment to be Open sourse heck it wasent even ment to be public
    ? Oh and i used to write these massages as comments at the end of the main.lua file when i was really new to coding
--]]
