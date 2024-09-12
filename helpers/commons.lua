--! This file is runned at startup in the conf.lua file to setup vars that can be accesed from anywhere in the main thread
--? manually require these as this file is runned before they are loded internally
require("love.system")
require("love.window")
require("love.event")
--? some internal stuff
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
--forceerr = false --? force a error screen in dev mode
skipname = false --? skip the splash screen
