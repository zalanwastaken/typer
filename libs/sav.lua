require("libs/funcs") --NOTE: edited for this project
--TODO replace love file operations with io file operations
function save(filename, data)
    if love.filesystem.getInfo(filename) then
        love.filesystem.write(filename, data)
    else
        local tmp = love.filesystem.newFile(filename)
        if not(tmp) then
            error("Unable to create file")
        end
        tmp, err = love.filesystem.write(filename, data)
        if not(tmp) then
            error("Unable to write file\n"..err)
        end
    end
end
function load(filename)
    if love.filesystem.getInfo(filename) then
        local tmp = love.filesystem.read(filename)
        if not(tmp) then
            error("Unable to read file")
        else
            return(tmp)
        end
    else
        -- else is edited for this project
        local tmp = love.filesystem.newFile(filename)
        if not(tmp) then
            error("Unable to create file")
        end
        tmp, err = love.filesystem.write(filename, "Hello world !\nThis is Typer "..__VER__)
        if not(tmp) then
            error("Unable to write file\n"..err)
        end
        tmp = love.filesystem.read(filename)
        if not(tmp) then
            error("Unable to read file")
        else
            return(tmp)
        end
    end
end
