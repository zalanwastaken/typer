--! This file is runned at startup in the conf.lua file to setup vars that can be accesed from anywhere in the main thread
--*common vars
tmp = 0 --* init tmp (tmp is a general use variable)
ar = {} --* user input array (ar = array)
mode = "run" --* current mode of the program
testedos = {"Windows", "Linux"} -- ? Tested OSes
--* config vars
__VER__ = [[2.0.1 "Munch"]] --! Version of the program
__TYPE__ = "DEV" --! Type of the build
__LOVEVER__ = 11.5 --! version of LOVE2D
__HTML__ = love.filesystem.getAppdataDirectory().."love/typer/html" --* HTML dir
forceerr = false --? force a error screen in dev mode
