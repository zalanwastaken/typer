-- Vars
local logger = {
    utils = {},
    charbuff = {}
}
-- logger funcs
function logger.log(msg)
    logger.charbuff[#logger.charbuff + 1] = msg
end
function logger.write(file, keep)
    local tmp = ""
    local success
    for i = 1, #logger.charbuff, 1 do
        tmp = tmp.."\n"..logger.charbuff[i]
    end
    if keep then
        tmp = love.filesystem.read(file)..tmp
    end
    if love.filesystem.getInfo(file) then
        success = love.filesystem.write(file, tmp)
        return(success)
    else
        love.filesystem.newFile(file)
        success = love.filesystem.write(file, tmp)
        return(success)
    end
end
function logger.clear()
    logger.charbuff = {}
end
-- logger utils
function logger.utils.line()
    logger.charbuff[#logger.charbuff + 1] = "--------------------"
end
function logger.utils.logo()
    logger.charbuff[#logger.charbuff + 1] = love.filesystem.read("data/logo.txt")
end
function logger.utils.autowrite()
    local tmp = ""
    local success
    local file = os.time()
    for i = 1, #logger.charbuff, 1 do
        tmp = tmp.."\n"..logger.charbuff[i]
    end
    if keep then
        tmp = love.filesystem.read(file)..tmp
    end
    if love.filesystem.getInfo(file) then
        success = love.filesystem.write(file, tmp)
        return(success)
    else
        love.filesystem.newFile(file)
        success = love.filesystem.write(file, tmp)
        return(success)
    end
end
return(logger)
