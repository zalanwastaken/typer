print("Starting verification...")
if not(love.filesystem.getInfo("html")) then
    if love.filesystem.getInfo("html-template") then
        local template = "html-template"
        local html_template = love.filesystem.getDirectoryItems(template)
        local root = "html"
        love.filesystem.createDirectory(root)
        for i = 1, #html_template, 1 do
            if love.filesystem.isDirectory(template.."/"..html_template[i]) then
                love.filesystem.createDirectory(root.."/"..html_template[i])
                local tmp = love.filesystem.getDirectoryItems(template.."/"..html_template[i])
                for f = 1, #tmp, 1 do
                    html_template[#html_template + 1] = html_template[i].."/"..tmp[f]
                end
                table.remove(html_template, i)
            end
        end
        for i = 1, #html_template, 1 do
            local tmp = love.filesystem.read(template.."/"..html_template[i])
            print("Setting up..."..html_template[i])
            if tmp ~= nil then
                local success, two = love.filesystem.write(root.."/"..html_template[i], tmp)
                if success then
                    print("Succesfully setup..."..html_template[i])
                else
                    print(success, two)
                    error(success.."\n"..two)
                end
            else
                tmp = love.filesystem.read(html_template[i])
                local success, two = love.filesystem.write(root.."/"..html_template[i], tmp)
                if success then
                    print("Succesfully setup..."..html_template[i])
                else
                    print(success, two)
                    error(success.."\n"..two)
                end
            end
        end
    else
        error("Html template not found") --* setup a error
    end
end
local htmlverifythread = love.thread.newThread([[
    local roothtml = love.filesystem.getDirectoryItems("html-template")
    local html = love.filesystem.getDirectoryItems("html")
    if #roothtml ~= #html then
        love.filesystem.remove("html")
        local template = "html-template"
            local html_template = love.filesystem.getDirectoryItems(template)
            local root = "html"
            love.filesystem.createDirectory(root)
            for i = 1, #html_template, 1 do
                if love.filesystem.isDirectory(template.."/"..html_template[i]) then
                    love.filesystem.createDirectory(root.."/"..html_template[i])
                    local tmp = love.filesystem.getDirectoryItems(template.."/"..html_template[i])
                    for f = 1, #tmp, 1 do
                        html_template[#html_template + 1] = html_template[i].."/"..tmp[f]
                    end
                    table.remove(html_template, i)
                end
            end
            for i = 1, #html_template, 1 do
                local tmp = love.filesystem.read(template.."/"..html_template[i])
                print(html_template[i])
                if tmp ~= nil then
                    love.filesystem.write(root.."/"..html_template[i], tmp)
                else
                    tmp = love.filesystem.read(html_template[i])
                    --print(tmp)
                    local success, two = love.filesystem.write(root.."/"..html_template[i], tmp)
                    print(success, two)
                end
            end
    end
]])
--htmlverifythread:start() -- ? In testing
if love.filesystem.getInfo("helpers/verify/filelist.lua") then
    files = require("helpers/verify/filelist")
else
    error("Unable to fetch filelist") --* setup a error
    return 1 --? terminate the exicution of this file
end
local fnf = {} -- list of files that are not found 
for i = 1, #files, 1 do -- verify the files here
    print("Verifing..."..files[i])
    local tmp = love.filesystem.read(files[i])
    if not(love.filesystem.getInfo(files[i])) and not(tmp ~= nil) then
        print(files[i].." Not found")
        fnf[#fnf + 1] = love.filesystem.getSource().."/"..files[i] -- add the files that are not found to fnf
    else
        print("Done verified..."..files[i])
    end
end
local logger = require("libs/logger")
if #fnf > 0 then
    if love.filesystem.getInfo("logs/verification_log.log") then
        love.filesystem.newFile("logs/verification_log.log")
        love.filesystem.write("logs/verification_log.log", os.date())
    else
        love.filesystem.write("logs/verification_log.log", os.date())
    end
    for i = 1, #fnf, 1 do
        love.filesystem.write("logs/verification_log.log", love.filesystem.read("logs/verification_log.log").."\n"..fnf[i])
    end
    error("Required files not found.\nCheck: "..love.filesystem.getAppdataDirectory().."love/typer/logs/verfication_log.log")
else
    logger = require("libs/logger")
    for i = 1, #files, 1 do
        logger.datastack:push(files[i].."...OK\n")
    end
    logger.datastack:push("\nFiles verified "..#files.."\n")
    logger.datastack:push("ALL VERIFIED\n")
end
logger.datastack:push("\n--------------------")
if love.filesystem.isFused() then
    logger.datastack:push("\nInstalltion is fused: "..love.filesystem.getSource())
else
    logger.datastack:push("\nInstalltion is not fused: "..love.filesystem.getSource())
end
logger.datastack:push("\n--------------------\nOS:"..love.system.getOS().."\n")
print("Verification complete...")
files = nil
fnf = nil
