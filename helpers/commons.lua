--! This file is runned at startup in the conf.lua file to setup vars that can be accesed from anywhere in the main thread
require("love.system") --? manually require love.system as this file is runned before its loded internally
require("helpers/errorhandler") --* custom error handler
--*common vars
tmp = 0 --* init tmp (tmp is a general use variable)
ar = {} --* user input array (ar = array)
mode = "run" --* current mode of the program
testedos = {"Windows", "Linux"} -- ? Tested OSes
--* config vars
__VER__ = [[2.0.1 "Munch"]] --! Version of Typer
__TYPE__ = "DEV" --! Type of the build (DEV or FR)
__LOVEVER__ = 11.5 --! version of LOVE2D
forceerr = false --? force a error screen in dev mode
skipname = true
-- ! OS specific code
if love.system.getOS() == "Windows" then
    __HTML__ = love.filesystem.getAppdataDirectory().."/LOVE/typer/html" --* HTML dir
else
    __HTML__ = love.filesystem.getAppdataDirectory().."love/typer/html" --* HTML dir
end
