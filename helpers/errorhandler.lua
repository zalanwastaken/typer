--* error handler stuff
local utf8 = require("utf8")
local logger = require("libs/logger")
local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end
function love.errorhandler(msg)
	msg = tostring(msg)
	error_printer(msg, 2)
	if not love.window or not love.graphics or not love.event then
		return
	end
	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end
	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then 
		love.audio.stop() 
	end
	love.graphics.reset()
	local font = love.graphics.setNewFont(14)
	love.graphics.setColor(1, 1, 1)
	local trace = debug.traceback()
	love.graphics.origin()
	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)
	local err = {}
	table.insert(err, "Error\n")
	table.insert(err, sanitizedmsg)
	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end
	table.insert(err, "\n")
	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end
	local p = table.concat(err, "\n")
	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")
	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
		p = p .. "\nCopied to clipboard!"
	end
	if love.system then
		p = p .. "\n\nPress Ctrl+C or tap to copy this error"
	end
	--* My code
    local errorpng = love.graphics.newImage("data/err.png")
    local normalfont = love.graphics.newFont(14)
    local bigfont = love.graphics.newFont(19)
	if not(logger.write:isRunning()) then
		logger.write:start()
	end
	logger.datastack:push(p.."\n")
	logger.datastack:push("STOP")
	local function draw() --* the draw function
		if not(love.graphics.isActive()) then
			return --? exit if love.graphics is not active
		end
		local pos = 70
		love.graphics.clear(0, 0, 1, 1)
        love.graphics.draw(errorpng)
        love.graphics.setFont(bigfont)
        love.graphics.printf("Typer ran into an error that it cant handle !", 0, errorpng:getWidth() + 8, love.graphics.getWidth(), "left")
		love.graphics.print(__VER__, 4, love.graphics.getHeight() - 20)
        love.graphics.setFont(normalfont)
		love.graphics.printf(p, 0, errorpng:getWidth() + 27, love.graphics.getWidth(), "left")
		love.graphics.present()
	end
	return(function()
		love.event.pump()
		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
			elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
				copyToClipboard()
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				if love.system then
					buttons[3] = "Copy to clipboard"
				end
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return 1
				elseif pressed == 3 then
					copyToClipboard()
				end
			end
		end
		draw()
		if love.timer then
			love.timer.sleep(0.1)
		end
	end)
end
