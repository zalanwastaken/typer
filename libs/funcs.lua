function getnewlines(array, offset)
    tmp = {}
    tmp[1] = 0
    tmp[2] = offset
    while true do
        tmp[1] = tmp[1] + 1
        if array[tmp[1]] == "\n" then
            tmp[2] = tmp[2] + 1
        elseif array[tmp[1]] == nil then
            return tmp[2]
        end
    end
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
end
function error(errordef, recovery)
    print("error: "..errordef)
    love.filesystem.write("verification_log.log", love.filesystem.read("verification_log.log").."\n".."Events\n".."Error: "..errordef)
    local errpng = love.graphics.newImage("data/err.png")
    local fnt = love.graphics.newFont(20)
    local fnt_2 = love.graphics.newFont(16)
    function love.draw()
        love.graphics.setBackgroundColor(0, 0, 1)
        love.graphics.draw(errpng, 0, 0, 0, 2, 2)
        love.graphics.setFont(fnt)
        love.graphics.printf("Error: "..errordef, 0, errpng:getWidth() * 2, love.graphics.getWidth())
        love.graphics.print("You can close this program now \nDont worry all your data is saved.", 0, (errpng:getWidth() * 2) + 45)
        love.graphics.setFont(fnt_2)
        if recovery then
            love.graphics.print("Press R to attempt recovery")
            if love.keyboard.isDown("r") then
                tmp = love.window.showMessageBox("Recovery", "This will start TYPER in recovery mode. \nContinue ?", {"Yes", "No"}, "warning")
                if tmp == 1 then
                    require("../main")
                end
            end
        else
            love.graphics.print("Recovery not possible")
        end
        --love.graphics.print("OwO ??? Looks like we made a fuckey wukey", 0, love.graphics.getHeight() - 16) -- seek and you shall find ;)
    end
    function love.update(dt)
        -- do nothing
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
end
