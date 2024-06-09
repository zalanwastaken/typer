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
    tmp = load(file)
    for i = 1, #tmp, 1 do
        ar[i] = tmp:sub(i, i)
    end
    for i = 1, #ar, 1 do
        if ar[i] == "/" and ar[i + 1] == "n" then
            ar[i] = "\n"
            for i = i + 2, #ar, 1 do
                ar[i - 1] = ar[i]
                if i == #ar then
                    ar[i] = nil
                end
            end
        end
    end
    if add then
        ar[#ar + 1] = "\b"
    end
    if ar[#ar - 1] == "n" then
        ar[#ar - 1] = ""
    end
    logger.datastack:push("ar init from "..file.."\n") -- ! logger.lua is required for this
end
function save_ar(offset)
    tmp = ""
    for i = 1, #ar - offset, 1 do
            if ar[i] == "\n" then
            tmp = tmp.."/n"
        else
            tmp = tmp..ar[i]
        end
    end
    save("saves/def_save.txt", tmp)
    logger.datastack:push("ar saved\n") -- ! logger.lua required for this
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
    local pattern = "([^" .. delimiter .. "]+)"
    for word in string.gmatch(input, pattern) do
        table.insert(result, word)
    end
    return result
end
