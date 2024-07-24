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
    -- Use string.gsub() to replace all occurrences of '\n' with an empty string
    local modifiedStr, count = str:gsub("\n", "")

    -- Count the number of occurrences by comparing the lengths of the original and modified strings
    local newlineCount = #str - #modifiedStr

    -- Return the count of newline characters
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
    love.window.showMessageBox(title, message, buttonlist, boxtype)
end
