function read(filename)
    if love.filesystem.getInfo(filename) then
        local filedata = love.filesystem.read(filename)
        local process = {}
        for i = 1, #filedata, 1 do
            if filedata:sub(i, i) ~= "," or filedata:sub(i, i) ~= "{" or filedata:sub(i, i) ~= "}" or filedata:sub(i, i) ~= "," or filedata:sub(i, i) ~= ":" or filedata:sub(i, i) ~= [["]] then
                process[i] = filedata:sub(i, i)
            end
        end
        filedata = nil
        local out = ""
        for i = #process, 1 do
            out = out..process[i]
        end
        return(out)
    else
        return(nil)
    end
end
