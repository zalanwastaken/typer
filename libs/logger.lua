local logger = {
    datastack = love.thread.getChannel("datalogger"),
    write = love.thread.newThread([[
        require("love.timer")
        require("helpers/commons") -- for __TYPE__ var
        if not(love.filesystem.getInfo("logs")) then
            love.filesystem.createDirectory("logs")
        end
        local datastack = love.thread.getChannel("datalogger")
        local file = "logs/log_"..os.time()..".log"
        if not(love.filesystem.getInfo(file)) then
            love.filesystem.newFile(file)
            love.filesystem.write(file, os.date())
        end
        while true do
            if __TYPE__ == "FR-NO-LOG" then
                while true do
                    local tmp = datastack:pop()
                    if tmp == nil then
                        break
                    end
                end
                break
            end
            local data = datastack:pop()
            local tmp
            if data ~= nil and data ~= "STOP" then
                tmp = love.filesystem.read(file)
                love.filesystem.write(file, tmp..data)
                print(data)
            elseif data == "STOP" then
                break
            else
                love.timer.sleep(0.1)
            end
        end
    ]])
}
return(logger)
