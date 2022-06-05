--External Libaries
gamera = require "resources/libraries/gamera"
bump = require "resources/libraries/bump"
require "resources/libraries/TSerial"
--My Libaries
status = require "status_text"
--Load in necessary lua files
require "utilities"
require "resources"
require "button"
require "panel"
require "block"
require "player"
require "enemy"
require "objects"

--Required to use certain character types
local utf8 = require("utf8")

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.keyboard.setTextInput(false)
	love.keyboard.setKeyRepeat(false)
	--Load our textures, sounds, etc
	resourceLoad()
	love.graphics.setFont(defaultFont)
	love.graphics.setBackgroundColor(0, 0, 0)
	gwidth, gheight = 1280, 720
	love.window.setMode(gwidth, gheight, {vsync = 0})
	--creates our camera
	cam = gamera.new(0, 0, 8000, 720)
	--sets the collisions cell space to 32...smaller values make collision more accurate
	world = bump.newWorld(32)
	LET_GRIDWORLD_CREATED = false
	--Can set this to start the game with a specific level loaded
	--LET_CURRENT_LEVEL = "dev_world"
	LET_CURRENT_LEVEL = ""
	gridColsX = 200
	gridRowsY = 30

	--initialize our 
	cam:setScale(1.25)
	cam:setWindow(0, 0, 1280, 720)
	cam:setWorld(0, 0, gridColsX * 32, 992)

--BEGIN GAME
	--initialize some 'constants' first
	LET_DEBUG_M = false
	LET_CONTROLS_M = true
	CONST_WORLD_LIMIT = 1800
	CONST_GRAVITY = 1800
	LET_FPS = 0
	LET_TIME_DILATION = 1
	LET_SKY_COLOR = {40/255, 85/255, 130/255}
	LET_CUR_GAME_STATE = ""
	LET_PREV_GAME_STATE = ""
	LET_GAME_PAUSED = false
	LET_GAME_FOCUSED = true
	LET_OPTIONS_MENU = false
	LET_BROWSE_PATH = ""
	LET_PANEL_FOCUS = false
	LET_PANEL_OPEN = ""
	LET_BUTTON_SELECTED = nil
	LET_KEYBIND_CHANGE = false
	LET_KEYBIND_BINDING = ""
	LET_CURSOR_LOCKED = false
	LET_LOCKED_CURSOR_POSITION_X, LET_LOCKED_CURSOR_POSITION_Y = 0, 0

	--switch to our menu state
	switchGameState("menu_state")

	--Editor Vars
	LET_EDITOR_TOOL = "" --initializes var, we set in next statement
	--editor_change_mode("editor_tool_draw", draw_cursor)
	editor_change_mode(LET_EDITOR_TOOL, default_cursor)
	LET_EDITOR_BLOCKTYPE_SELECTED = "dev_block"
	LET_EDITOR_BLOCKTYPE_SELECTED_INDEX = 1
	LET_EDITOR_OBJECTTYPE_SELECTED = "cog"
	LET_EDITOR_OBJECTTYPE_SELECTED_INDEX = 1

	--begins game logic
	createGridWorld()
	love.graphics.setBackgroundColor(LET_SKY_COLOR)

	--Initialize player keybindings
	moveLeft, moveRight, moveJump, moveCrouch = "a", "d", "space", "lctrl"
	keys_pressed = {}

	--[[Object Creation]]
--Panels
	panel.spawn("saving_panel_QD", "savePanel", gwidth / 2, (gheight / 2) + 25 * 2, 298, 98)
	panel.spawn("loading_panel_QD", "loadPanel", gwidth / 2, (gheight / 2) + 25 * 2, 298, 98)
	panel.spawn("options_panel_QD", "optionsPanel", gwidth / 2, (gheight / 2), 709, 509)
	panel.spawn("lvlwarn_panel_QD", "lvlwarnPanel", gwidth / 2, (gheight / 2), 350, 135)
	panel.spawn("lvlselection_panel_QD", "lvlselectionPanel", gwidth / 2, (gheight / 2), 600, 300)
	panel.spawn("dialogue_panel_QD", "dialoguePanel", gwidth / 2, 150, 1024, 298)
--Main Menu buttons
--[QUAD, ACTION, ACTIVE STATE, X, Y, WIDTH, HEIGHT, TEXT(optional)]
	button.spawn("long_button_QD", "play_game_action", "menu_state", gwidth / 2, (gheight / 2) + 25 * .5, 193, 49, "Level Selection")
	button.spawn("long_button_QD", "create_level_action", "menu_state", gwidth / 2, (gheight / 2) + 25 * 2.5, 193, 49, "Level Editor")
	button.spawn("long_button_QD", "options_action", "menu_state", gwidth / 2, (gheight / 2) + 25 * 4.5, 193, 49, "Options")
	button.spawn("long_button_QD", "quit_action", "menu_state", gwidth / 2, (gheight / 2) + 25 * 6.5, 193, 49, "Quit")
	button.spawn("long_button_QD", "quit_action", "menu_state", 193, 49, GLOBAL_W, GLOBAL_H, "TESTING")
--Pause Menu buttons
	button.spawn("long_button_QD", "resume_action", "pauseButton", gwidth / 2, (gheight / 2) + 25 * .5, 193, 49, "Resume")
	button.spawn("long_button_QD", "save_level_action", "pauseButton", gwidth / 2, (gheight / 2) + 25 * 2.5, 193, 49, "Save Level")
	button.spawn("long_button_QD", "load_level_action", "pauseButton", gwidth / 2, (gheight / 2) + 25 * 4.5, 193, 49, "Load Level")
	button.spawn("long_button_QD", "options_action", "pauseButton", gwidth / 2, (gheight / 2) + 25 * 6.5, 193, 49, "Options")
	button.spawn("long_button_QD", "exit_session_action", "pauseButton", gwidth / 2, (gheight / 2) + 25 * 8.5, 193, 49, "Exit Session")
--Editor Mode buttons
	button.spawn("select_button_QD", "tool_selection_action", "create_state", gwidth - 50, gheight / 2 -  105, 50, 50)
	button.spawn("draw_button_QD", "tool_draw_action", "create_state", gwidth - 50, gheight / 2 - 50, 50, 50)
	button.spawn("dropper_button_QD", "tool_dropper_action", "create_state", gwidth - 50, gheight / 2 + 5, 50, 50)
	button.spawn("eraser_button_QD", "tool_nuke_action", "create_state", gwidth - 50, gheight / 2 + 60, 50, 50)
--Editor Mode Warning buttons
	button.spawn("delete_button_QD", "confirmwipe_action", "lvlwarnPanel", gwidth / 2 - (33/2) - 20, gheight / 2 + (33/2), 100, 33)
	button.spawn("cancel_button_QD", "cancelwipe_action", "lvlwarnPanel", gwidth / 2 + (33*2) + 20, gheight / 2 + (33/2), 100, 33)
--Save/Load buttons
	button.spawn("back_button_QD", "back_action", "loadPanel", (gwidth / 2) + 100, (gheight / 2) + 25 * 3, 75, 25)
	button.spawn("back_button_QD", "back_action", "savePanel", (gwidth / 2) + 100, (gheight / 2) + 25 * 3, 75, 25)
	button.spawn("small_button_QD", "browse_action", "loadPanel", (gwidth / 2), (gheight / 2) + 25 * 3, 110, 28, "Browse")
	button.spawn("small_button_QD", "browse_action", "savePanel", (gwidth / 2), (gheight / 2) + 25 * 3, 110, 28, "Browse")
	button.spawn("small_button_QD", "load_action", "loadPanel", (gwidth / 2) - 100, (gheight / 2) + 25 * 3, 110, 28, "Load")
	button.spawn("small_button_QD", "save_action", "savePanel", (gwidth / 2) - 100, (gheight / 2) + 25 * 3, 110, 28, "Save")
--Options buttons
	button.spawn("keybind_button_QD", "options_keybinds_moveRight", "optionsPanel", (gwidth / 2) - 67 *  4.25, (gheight / 2) - 65, 67, 36, moveRight)
	button.spawn("keybind_button_QD", "options_keybinds_moveLeft", "optionsPanel", (gwidth / 2) - 67 *  4.25, (gheight / 2) - 20, 67, 36, moveLeft)
	button.spawn("keybind_button_QD", "options_keybinds_moveJump", "optionsPanel", (gwidth / 2) - 67 *  4.25, (gheight / 2) + 27, 67, 36, moveJump)
	button.spawn("keybind_button_QD", "options_keybinds_moveCrouch", "optionsPanel", (gwidth / 2) - 67 *  4.25, (gheight / 2) + 72, 67, 36, moveCrouch)
	button.spawn("back_button_QD", "back_action", "optionsPanel", (gwidth / 2) - 67 *  4, (gheight / 2) + 204, 67, 38)
--Level Selection buttons
	button.spawn("select_button_QD", "lvl01_action", "lvlselectionPanel", (gwidth / 2) - 250, (gheight / 2) - 60, 50, 50)
	button.spawn("select_button_QD", "lvl02_action", "lvlselectionPanel", (gwidth / 2) - 190, (gheight / 2) - 60, 50, 50)
	button.spawn("back_button_QD", "back_action", "lvlselectionPanel", (gwidth / 2), (gheight / 2) + 105, 75, 25)

end

function love.keypressed(key)
	if key == "`" then
		if LET_CUR_GAME_STATE == "play_state" or LET_CUR_GAME_STATE == "create_state" then
			if LET_DEBUG_M then
				LET_DEBUG_M = false
			else
				LET_DEBUG_M = true
			end
		end
	elseif key == "c" then
		if LET_CUR_GAME_STATE == "play_state" or LET_CUR_GAME_STATE == "create_state" then
			if LET_CONTROLS_M then
				LET_CONTROLS_M = false
			else
				LET_CONTROLS_M = true
			end
		end
	elseif key == "]" then
		panel.typeChange("dialoguePanel")
	elseif key == "escape" then
		if LET_CUR_GAME_STATE ~= "menu_state" then
			if love.keyboard.hasTextInput() or LET_OPTIONS_MENU == true then
				button.backButtonReset()
			else
				pauseGame()
			end
		end
	elseif key == "backspace" then
		deleteCharacterByte()
	elseif key == "return" then
		--Enables 'enter' key functionality for level path input
		if love.keyboard.hasTextInput() then
			if LET_PANEL_OPEN == "savePanel" then
				saveLevel(tostring(LET_BROWSE_PATH), block, enemy, object)
			elseif LET_PANEL_OPEN == "loadPanel" then
				loadEditorLevel(tostring(LET_BROWSE_PATH))
			end
		end
	end

	--Gathers any key pressed
	keys_pressed[key] = true
end

function love.keyreleased(key)
	--Resets keys pressed
	keys_pressed[key] = nil
end

function love.mousepressed(x, y, mButton)
	if not LET_GAME_PAUSED then
		block.clickAction(mButton)
	end
end

function love.mousereleased(x, y, mButton)
	button.clickAction(mButton)
end

function love.wheelmoved(x, y)
	if not LET_GAME_PAUSED then
		block.cycleSelectedBlock(y)
		block.cycleSelectedObject(y)
	end
end

function love.mousemoved(x, y, dx, dy)
	--Tries to lock cursor the spot LET_CURSOR_LOCKED is set to true at
	if LET_CURSOR_LOCKED then
		x = LET_LOCKED_CURSOR_POSITION_X
		y = LET_LOCKED_CURSOR_POSITION_Y
		dx = LET_LOCKED_CURSOR_POSITION_X
		dy = LET_LOCKED_CURSOR_POSITION_Y
	end
end

--Checks for mouse focus(lost or gained)
function love.mousefocus(focus)
	--Immediately sends all new/modified sprite data in batch to the GPU. Fixes Menu buttons turning black when sharing screen on Discord
	button_SB:flush()
end

function love.focus(focus)
	if focus then
		LET_GAME_FOCUSED = true
	else
		LET_GAME_FOCUSED = false
	end
end

function love.textinput(t)
	if LET_GAME_PAUSED then
		LET_BROWSE_PATH = LET_BROWSE_PATH .. t
	end
end

function love.filedropped(file)
	if love.keyboard.hasTextInput() then
		local dropped_file = file:getFilename()
		dropped_file, LET_BROWSE_PATH = getFileName(dropped_file)

		status.print("Dropped file: " .. LET_BROWSE_PATH .. ".lvl")
	end
end

function love.update(dt)
	--dt = .002 --slows down time
	--Grabs game FPS
	LET_FPS = love.timer.getFPS()
	mouseX, mouseY = love.mouse.getPosition()
	worldMouseX, worldMouseY = cam:toWorld(mouseX, mouseY)

	status.update(dt)
	panel.update(dt)
	button.update(dt)
	update_keybind_change()

	if LET_CUR_GAME_STATE ~= "menu_state" and not LET_GAME_PAUSED then
		player.update(dt)
		enemy.update(dt)
		block.update(dt)
		object.update(dt)
	end
end

function love.draw()
	if LET_CUR_GAME_STATE ~= "menu_state" then
		cam:draw(function()

		--Draws to worldspace
		block.draw()
		object.draw()
		player.draw()
		enemy.draw()
		debugDraw()
		end)

		--Draws to screen
		editorHUDDraw()
	end

	panel.draw()
	button.draw()
	debugMenuDraw()

	if LET_GAME_PAUSED then
		love.graphics.setColor(1, 1, 1)
		love.graphics.setFont(defaultFontHuge)
		love.graphics.printf("PAUSED", 0, (gheight / 2) - 200, gwidth, "center")
		love.graphics.setFont(defaultFont)
	end

	status.draw()
end

function createGridWorld()--called in main
	if not LET_GRIDWORLD_CREATED then
		--Begins index at 0 so that the blocks spawn at the very edges of the screen
		for i = 0, gridColsX do
			for j = 0, gridRowsY do
				block.spawn("air_block", 32 * i, 32 * j)
				LET_GRIDWORLD_CREATED = true
			end
		end
	end
end

function pauseGame()
	if LET_GAME_PAUSED then
		changeCursor()
		--close out of any previously opened panels for resume
		LET_PANEL_FOCUS = false
		LET_PANEL_OPEN = ""
		LET_GAME_PAUSED = false
	else
		LET_GAME_PAUSED = true
		--Set cursor back to default for menus
		love.mouse.setCursor(default_cursor)
	end
end

function changeCursor()
	--Resets cursor based on which editor tool is selected
	if LET_EDITOR_TOOL == "editor_tool_select" then
		love.mouse.setCursor(selection_cursor)
	elseif LET_EDITOR_TOOL == "editor_tool_draw" then
		love.mouse.setCursor(draw_cursor)
	elseif LET_EDITOR_TOOL == "editor_tool_dropper" then
		love.mouse.setCursor(dropper_cursor)
	end
end

function saveLevel(name, t1, t2, t3)
	local lower_name = string.lower(name)
	local mainTable = {}
	local blockTable = {}
	local enemyTable = {}
	local objectTable = {}

	for i = 1, #t1 do
		table.insert(blockTable, {subtype = t1[i].subtype, quad = t1[i].quad, itemInside = t1[i].itemInside})
	end
	for i = 1, #t2 do
		table.insert(enemyTable, {subtype = t2[i].subtype, x = t2[i].spawn_x, y = t2[i].spawn_y, dir = t2[i].dir})
	end
	for i = 1, #t3 do
		table.insert(objectTable, {subtype = t3[i].subtype, x = t3[i].x, y = t3[i].y})
	end

	table.insert(mainTable, blockTable)
	table.insert(mainTable, enemyTable)
	table.insert(mainTable, objectTable)

	local success, message = love.filesystem.write(lower_name  .. ".lvl", TSerial.pack(mainTable, true, true))
	if success then
		status.print("Level Saved! ('" .. lower_name .. ".lvl')")
	else
		status.print("LEVEL SAVE FAILED (Unable to write to directory)")
	end
end

function loadOfficialLevel(name)
	local lower_name = string.lower(name)
	--check through all level names
	for i = 1, #game_level_data do
		--if the provided level name exists, set it as the file and load the data
		if game_level_data[i].title == lower_name then
			file = game_level_data[i].path
			--LET_CURRENT_LEVEL = file
			--print(file .. "<- Selected")
			if file then
				--Delete everything in current level
				sterilizeLevel()

				local data = love.filesystem.read(file)
				--Unserialize string into table
				data = TSerial.unpack(data, true)
				generateData(file, data)

				status.print("Level Loaded! ('" .. LET_CURRENT_LEVEL .. ".lvl')")
			else
				file = nil
				status.print("LEVEL LOAD FAILED (Level name does not exist)")
				LET_CURRENT_LEVEL = ""
				--print(game_level_data[i].path .. "-> Not Selected")
			end
		end
	end
end

function loadEditorLevel(name)
	local lower_name = string.lower(name)
	local file = love.filesystem.getInfo(lower_name .. ".lvl")
	
	if file then
		--Delete everything in current level
		sterilizeLevel()

		--Read save file text
		local data = love.filesystem.read(lower_name .. ".lvl")
		--Unserialize string into table
		data = TSerial.unpack(data, true)
		generateData(lower_name, data)

		status.print("Level Loaded! ('" .. LET_CURRENT_LEVEL .. ".lvl')")
	else
		status.print("LEVEL LOAD FAILED (Level name does not exist)")
		LET_CURRENT_LEVEL = ""
	end
end

function generateData(name, data_string)
	if data_string ~= nil then
		--BLOCK LOADING
		if data_string[1] ~= nil then
			for i = 1, #data_string[1] do
				--Load in block data from new save table
				block.typeChange(block[i], data_string[1][i].subtype)
				block[i].itemInside = data_string[1][i].itemInside
			end
		end
		--ENEMY LOADING
		--Checks length of second data string for how many enemies to spawn in
		if data_string[2] ~= nil then
			for i = 1, #data_string[2] do
				enemy.spawn(data_string[2][i].subtype, data_string[2][i].x, data_string[2][i].y, data_string[2][i].dir)
			end
		end
		--OBJECT LOADING
		--Checks length of third data string for how many objects to spawn in
		if data_string[3] ~= nil then
			for i = 1, #data_string[3] do
				object.spawn(data_string[3][i].subtype, data_string[3][i].x, data_string[3][i].y)
			end
		end

		--**FIX for crash when deleting a loaded level's objects**
		--Reassign our  block's child correctly after indices change(TABLE DATA)
		for q,t in ipairs(block) do
			if t.itemInside then
				if t.itemInside.type == "object" then
					t.itemInside = object[t.itemInside.id]
				elseif t.itemInside.type == "enemy" then
					t.itemInside = enemy[t.itemInside.id]
				end
			end
		end

		--Initialize level stuff
		initializeLevel()

		LET_CURRENT_LEVEL = name
	end
end

function deloadLevel()
	sterilizeLevel()
	LET_CURRENT_LEVEL = ""
end

function editorHUDDraw()
	local CONST_HUD_W = 250
	local CONST_HUD_H = 250
	local CONST_HUD_X = gwidth / 2 - 125
	local CONST_HUD_Y = 0
	local CONST_CONTROL_TEXT = ""
	if LET_EDITOR_TOOL == "editor_tool_select" then
		CONST_CONTROL_TEXT = "LMB - Select\nRMB - Fill Selection\nMMB - Erase\nMouse Wheel - Change Block"
	elseif LET_EDITOR_TOOL == "editor_tool_draw" then
		CONST_CONTROL_TEXT = "LMB - Paint\nRMB - Erase\nMouse Wheel - Change Block"
	elseif LET_EDITOR_TOOL == "editor_tool_dropper" then
		CONST_CONTROL_TEXT = "LMB - Paint\nRMB - Erase\nMouse Wheel - Change Object"
	end
	local CONST_CONTROL_TEXT_2 = "Toggle Controls Menu with 'C'"
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(defaultFontSmol)
	love.graphics.printf(CONST_CONTROL_TEXT_2, CONST_HUD_X, CONST_HUD_Y, 300, "center")
	love.graphics.setFont(defaultFont)
	love.graphics.printf("Selected Block: " .. LET_EDITOR_BLOCKTYPE_SELECTED, gwidth - 157, gheight / 2 - 360, 150, "center")
	love.graphics.draw(block_all_IMG, _G[LET_EDITOR_BLOCKTYPE_SELECTED .. "_QD"], gwidth - 48, gheight / 2 - 240, 0, 2, 2, 32, 32)
	--love.graphics.print("Score: " .. player[1].score, (gwidth / 2) - 285, 25)
	if LET_CONTROLS_M then
		love.graphics.printf(CONST_CONTROL_TEXT, CONST_HUD_X, CONST_HUD_Y + 14, 300, "center")
	end
end

function debugMenuDraw()
	if LET_DEBUG_M then
		local CONST_DEBUG_W = 350
		local CONST_DEBUG_H = 280
		local CONST_DEBUG_X = 0
		local CONST_DEBUG_Y = 12
		love.graphics.setFont(defaultFont)
		love.graphics.setColor(0, 1, 0, .25)
		love.graphics.rectangle("fill", CONST_DEBUG_X, CONST_DEBUG_Y, CONST_DEBUG_W, CONST_DEBUG_H)
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf("DEBUG MENU", CONST_DEBUG_X, CONST_DEBUG_Y, CONST_DEBUG_W, "center")
		--Displays FPS benchmark
		love.graphics.printf("FPS: " .. LET_FPS, CONST_DEBUG_X, CONST_DEBUG_Y * 3, CONST_DEBUG_W, "left")
		love.graphics.printf("Game State: " .. LET_CUR_GAME_STATE, CONST_DEBUG_X, CONST_DEBUG_Y * 4.5, CONST_DEBUG_W, "left")
		love.graphics.printf("Previous Game State: " .. LET_PREV_GAME_STATE, CONST_DEBUG_X, CONST_DEBUG_Y * 6, CONST_DEBUG_W, "left")
		love.graphics.printf("Current Level: " .. LET_CURRENT_LEVEL, CONST_DEBUG_X, CONST_DEBUG_Y * 7.5, CONST_DEBUG_W, "left")
		love.graphics.printf("Current Editor Tool: " .. LET_EDITOR_TOOL, CONST_DEBUG_X, CONST_DEBUG_Y * 9, CONST_DEBUG_W, "left")
		love.graphics.printf("Selected Object: " .. LET_EDITOR_OBJECTTYPE_SELECTED, CONST_DEBUG_X, CONST_DEBUG_Y * 10.5, CONST_DEBUG_W, "left")
		love.graphics.printf("#Blocks: " .. #block, CONST_DEBUG_X, CONST_DEBUG_Y * 12, CONST_DEBUG_W, "left")
		love.graphics.printf("#Objects: " .. #object, CONST_DEBUG_X, CONST_DEBUG_Y * 13.5, CONST_DEBUG_W, "left")
		love.graphics.printf("#Enemies: " .. #enemy, CONST_DEBUG_X, CONST_DEBUG_Y * 15, CONST_DEBUG_W, "left")
		love.graphics.printf("Player State: " .. player[1].state .. "/" .. player[1].prevState, CONST_DEBUG_X, CONST_DEBUG_Y * 16.5, CONST_DEBUG_W, "left")
		love.graphics.printf("Player Frame: " .. math.floor(player[1].current_frame), CONST_DEBUG_X, CONST_DEBUG_Y * 18, CONST_DEBUG_W, "left")
		love.graphics.printf("xVel, yVel: " .. player[1].xVel .. ", " .. player[1].yVel, CONST_DEBUG_X, CONST_DEBUG_Y * 19.5, CONST_DEBUG_W, "left")
		love.graphics.printf("X, Y: " .. tostring(player[1].x) .. ", " .. tostring(player[1].y), CONST_DEBUG_X, CONST_DEBUG_Y * 21, CONST_DEBUG_W, "left")
		love.graphics.printf("DDV: " .. tostring(player[1].damageDir), CONST_DEBUG_X, CONST_DEBUG_Y * 22.5, CONST_DEBUG_W, "left")
	end
end

function debugDraw()
	if LET_DEBUG_M then
		for i,v in ipairs(player) do
			--Player Hitbox
			local x,y,w,h = world:getRect(player[1])
			love.graphics.setColor(1, 0, 1)
			love.graphics.rectangle("line", x, y, w, h)
		end

		for i,v in ipairs(enemy) do
			--Enemy Hitbox
			love.graphics.setColor(1, 0, 1)
			love.graphics.rectangle("line", v.x, v.y, v.width, v.height)

			--Hide view distance
			if (v.dir == -1) then
				love.graphics.setColor(1, 0, 0)
				love.graphics.line(v.x, v.y + 25, v.x - v.loseRange, v.y + 25)
				--love.graphics.printf("Lose Target Range", v.x - v.loseRange, v.y + 25, v.loseRange, "center")
				love.graphics.setColor(0, 1, 0)
				love.graphics.line(v.x, v.y + 50, v.x - v.searchRange, v.y + 50)
				--love.graphics.printf("Found Target Range", v.x - v.searchRange, v.y + 50, v.searchRange, "center")
			elseif (v.dir == 1) then
				love.graphics.setColor(1, 0, 0)
				love.graphics.line(v.x, v.y + 25, v.x + v.loseRange, v.y + 25)
				--love.graphics.printf("Lose Target Range", v.x, v.y + 25, v.loseRange, "center")
				love.graphics.setColor(0, 1, 0)
				love.graphics.line(v.x, v.y + 50, v.x + v.searchRange, v.y + 50)
				--love.graphics.printf("Found Target Range", v.x, v.y + 50, v.searchRange, "center")
			end
		end

		for i,v in ipairs(object) do
			--Object Hitbox
			love.graphics.setColor(1, 0, 1)
			love.graphics.rectangle("line", v.x, v.y, v.width, v.height)
		end
	end
end