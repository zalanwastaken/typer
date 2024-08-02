function getnewlines(array, offset)
    tmp = {}
    tmp[1] = 0
    tmp[2] = offset
    while true do
        tmp[1] = tmp[1] + 1
        if array[tmp[1]] == "\n" then
            tmp[2] = tmp[2] + 1
        elseif array[tmp[1]] == nil then
            break
        end
    end
    return tmp[2]
end
function gettnewlinesstring(str)
    local modifiedStr, count = str:gsub("\n", "")
    local newlineCount = #str - #modifiedStr
    return newlineCount
end
function initar(file, add)
    tmp = love.filesystem.read(file)
    for i = 1, #tmp, 1 do
        ar[i] = tmp:sub(i, i)
    end
    if add then
        ar[#ar + 1] = "\b"
    end
    if logger then
        logger.datastack:push("ar init from "..file.."\n") -- ! logger.lua is required for this
    end
end
function save_ar(offset)
    local tmp = ""
    for i = 1, #ar - offset, 1 do
        tmp = tmp..ar[i]
    end
    love.filesystem.write("saves/def_save.txt", tmp)
    if logger then
        logger.log("ar saved")
    end
end
--[[ --? Not needed as the new filesaving saves the saves as .txt with \n chars
function exportar(filename, data)
    local tmp = ""
    ar = {}
    initar("saves/def_save.txt", false)
    for i = 1, #ar-1, 1 do
        tmp = tmp..ar[i]
    end
    if not(love.filesystem.getInfo(filename)) then
        love.filesystem.newFile(filename)
        love.filesystem.write(filename, tmp)
        ar = {}
        print("(Export mode) Saved: "..filename)
    else
        love.window.showMessageBox("File already exists", "File already exists", "error")
    end
    logger.datastack:push("ar saved to "..filename.."\n") -- ! logger.lua required for this
end
--]]
function removeCharsKeepNumbers(str)
    local result = str:gsub("[^%d]+", "")
    return result
end
function split(input, delimiter)
    local result = {}
    local pattern = "([^"..delimiter.."]+)"
    for word in string.gmatch(input, pattern) do
        table.insert(result, word)
    end
    return result
end
function showMessageBox(title, message, buttonlist, boxtype)
    local pingsfx = love.audio.newSource("data/sounds/ping.mp3", "static")
    love.audio.play(pingsfx)
    love.timer.sleep(0.1)
    return(love.window.showMessageBox(title, message, buttonlist, boxtype))
end
function forcequit(exitcode, savearbool)
    if savearbool == nil then
        savearbool = false
    end
    if exitcode == nil then
        exitcode = 0
    end
    function love.quit()
        logger.log("Force exit init")
        if savearbool then
            save_ar(1)
        end
        logger.stop()
        return false
    end
    love.event.quit(exitcode)
end
