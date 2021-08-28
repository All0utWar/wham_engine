function resourceLoad()
--FONTS
	defaultFont = love.graphics.newFont("resources/fonts/Biryani-Regular.ttf", 16)
	defaultFontBold = love.graphics.newFont("resources/fonts/Biryani-Bold.ttf", 16)
	defaultFontHuge = love.graphics.newFont("resources/fonts/Biryani-Regular.ttf", 96)
	defaultFontSmol = love.graphics.newFont("resources/fonts/Biryani-Regular.ttf", 10)
	love.graphics.setFont(defaultFont)
--CURSORS
	default_cursor = love.mouse.newCursor("resources/textures/ui/cursors/cursor_default.png", 0, 0)
	selection_cursor = love.mouse.newCursor("resources/textures/ui/cursors/cursor_selection.png", 0, 0)
	draw_cursor = love.mouse.newCursor("resources/textures/ui/cursors/cursor_draw.png", 0, 0)
	eraser_cursor = love.mouse.newCursor("resources/textures/ui/cursors/cursor_eraser.png", 0, 0)
	dropper_cursor = love.mouse.newCursor("resources/textures/ui/cursors/cursor_dropper.png", 0, 0)
--TEXTURES
	--Images
	block_all_IMG = love.graphics.newImage("resources/textures/block/block_sheet.png")
	ui_buttons_all_IMG = love.graphics.newImage("resources/textures/ui/button_sheet.png")
	ui_panels_all_IMG = love.graphics.newImage("resources/textures/ui/panel_sheet.png")
	--SpriteBatches
	block_SB = love.graphics.newSpriteBatch(block_all_IMG)
	button_SB = love.graphics.newSpriteBatch(ui_buttons_all_IMG)
	panel_SB = love.graphics.newSpriteBatch(ui_panels_all_IMG)
	--Quads
	--*blockQDs
	ground_block_QD = love.graphics.newQuad(0, 0, 32, 32, block_all_IMG:getDimensions())
	air_block_QD = love.graphics.newQuad(32, 0, 32, 32, block_all_IMG:getDimensions())
	item_block_QD = love.graphics.newQuad(0, 32, 32, 32, block_all_IMG:getDimensions())
	highlight_block_QD = love.graphics.newQuad(32, 32, 32, 32, block_all_IMG:getDimensions())
	grass_block_QD = love.graphics.newQuad(64, 0, 32, 32, block_all_IMG:getDimensions())
	grass_block_r_QD = love.graphics.newQuad(96, 0, 32, 32, block_all_IMG:getDimensions())
	grass_block_l_QD = love.graphics.newQuad(64, 32, 32, 32, block_all_IMG:getDimensions())
	wooden_plat_QD = love.graphics.newQuad(96, 32, 32, 32, block_all_IMG:getDimensions())
	player_spawn_QD = love.graphics.newQuad(0, 96, 32, 32, block_all_IMG:getDimensions())
	--*buttonQDS
	--**Long buttons
	resume_button_QD = love.graphics.newQuad(0, 0, 194, 49, ui_buttons_all_IMG:getDimensions())
	resume_button_QD_2 = love.graphics.newQuad(0, 49, 194, 49, ui_buttons_all_IMG:getDimensions())
	save_level_button_QD = love.graphics.newQuad(0, 98, 194, 49, ui_buttons_all_IMG:getDimensions())
	save_level_button_QD_2 = love.graphics.newQuad(0, 147, 194, 49, ui_buttons_all_IMG:getDimensions())
	load_level_button_QD = love.graphics.newQuad(0, 196, 194, 49, ui_buttons_all_IMG:getDimensions())
	load_level_button_QD_2 = love.graphics.newQuad(0, 245, 194, 49, ui_buttons_all_IMG:getDimensions())
	options_button_QD = love.graphics.newQuad(0, 294, 194, 49, ui_buttons_all_IMG:getDimensions())
	options_button_QD_2 = love.graphics.newQuad(0, 343, 194, 49, ui_buttons_all_IMG:getDimensions())
	quit_sesh_button_QD = love.graphics.newQuad(0, 392, 194, 49, ui_buttons_all_IMG:getDimensions())
	quit_sesh_button_QD_2 = love.graphics.newQuad(0, 441, 194, 49, ui_buttons_all_IMG:getDimensions())
	--**Small buttons
	select_button_QD = love.graphics.newQuad(194, 0, 50, 50, ui_buttons_all_IMG:getDimensions())
	select_button_QD_2 = love.graphics.newQuad(194, 50, 50, 50, ui_buttons_all_IMG:getDimensions())
	draw_button_QD = love.graphics.newQuad(194, 100, 50, 50, ui_buttons_all_IMG:getDimensions())
	draw_button_QD_2 = love.graphics.newQuad(194, 150, 50, 50, ui_buttons_all_IMG:getDimensions())
	eraser_button_QD = love.graphics.newQuad(194, 200, 50, 50, ui_buttons_all_IMG:getDimensions())
	eraser_button_QD_2 = love.graphics.newQuad(194, 250, 50, 50, ui_buttons_all_IMG:getDimensions())
	dropper_button_QD = love.graphics.newQuad(194, 300, 50, 50, ui_buttons_all_IMG:getDimensions())
	dropper_button_QD_2 = love.graphics.newQuad(194, 350, 50, 50, ui_buttons_all_IMG:getDimensions())
	--*panelQDS
	--**Saving/Loading
	saving_panel_QD = love.graphics.newQuad(0, 0, 298, 98, ui_panels_all_IMG:getDimensions())
	loading_panel_QD = love.graphics.newQuad(0, 98, 298, 98, ui_panels_all_IMG:getDimensions())
	browse_button_QD = love.graphics.newQuad(268.5, 400, 74.5, 24.5, ui_panels_all_IMG:getDimensions())
	browse_button_QD_2 = love.graphics.newQuad(268.5, 424.5, 74.5, 24.5, ui_panels_all_IMG:getDimensions())
	save_button_QD = love.graphics.newQuad(194, 400, 74.5, 24.5, ui_panels_all_IMG:getDimensions())
	save_button_QD_2 = love.graphics.newQuad(194, 424.5, 74.5, 24.5, ui_panels_all_IMG:getDimensions())
	load_button_QD = love.graphics.newQuad(194, 449, 74.5, 24.5, ui_panels_all_IMG:getDimensions())
	load_button_QD_2 = love.graphics.newQuad(194, 473.5, 74.5, 24.5, ui_panels_all_IMG:getDimensions())
	back_button_QD = love.graphics.newQuad(268.5, 449, 74.5, 24.5, ui_panels_all_IMG:getDimensions())
	back_button_QD_2 = love.graphics.newQuad(268.5, 473.5, 74.5, 24.5, ui_panels_all_IMG:getDimensions())
--ANIMATIONS
	--must initialize each animation table before adding indices to it
	player_idle = {}
	player_run = {}
	player_jump = {}
	player_front_flip = {}
	player_fall = {}
	--Animation Tables
	player_idle[1] = love.graphics.newImage("resources/textures/player/idle/1.png")
		player_idle[2] = love.graphics.newImage("resources/textures/player/idle/2.png")
		player_idle[3] = love.graphics.newImage("resources/textures/player/idle/3.png")
		player_idle[4] = love.graphics.newImage("resources/textures/player/idle/4.png")
		player_idle[5] = love.graphics.newImage("resources/textures/player/idle/5.png")
		player_idle[6] = love.graphics.newImage("resources/textures/player/idle/6.png")
		player_idle[7] = love.graphics.newImage("resources/textures/player/idle/7.png")
	player_run[1] = love.graphics.newImage("resources/textures/player/run/1.png")
		player_run[2] = love.graphics.newImage("resources/textures/player/run/2.png")
		player_run[3] = love.graphics.newImage("resources/textures/player/run/3.png")
		player_run[4] = love.graphics.newImage("resources/textures/player/run/4.png")
		player_run[5] = love.graphics.newImage("resources/textures/player/run/5.png")
		player_run[6] = love.graphics.newImage("resources/textures/player/run/6.png")
		player_run[7] = love.graphics.newImage("resources/textures/player/run/7.png")
		player_run[8] = love.graphics.newImage("resources/textures/player/run/8.png")
	player_jump[1] = love.graphics.newImage("resources/textures/player/jump/1.png")
		player_jump[2] = love.graphics.newImage("resources/textures/player/jump/2.png")
		player_jump[3] = love.graphics.newImage("resources/textures/player/jump/3.png")
	player_front_flip[1] = love.graphics.newImage("resources/textures/player/front_flip/1.png")
		player_front_flip[2] = love.graphics.newImage("resources/textures/player/front_flip/2.png")
		player_front_flip[3] = love.graphics.newImage("resources/textures/player/front_flip/3.png")
		player_front_flip[4] = love.graphics.newImage("resources/textures/player/front_flip/4.png")
		player_front_flip[5] = love.graphics.newImage("resources/textures/player/front_flip/5.png")
		player_front_flip[6] = love.graphics.newImage("resources/textures/player/front_flip/6.png")
		player_front_flip[7] = love.graphics.newImage("resources/textures/player/front_flip/7.png")
		player_front_flip[8] = love.graphics.newImage("resources/textures/player/front_flip/8.png")
		player_front_flip[9] = love.graphics.newImage("resources/textures/player/front_flip/9.png")
		player_front_flip[10] = love.graphics.newImage("resources/textures/player/front_flip/10.png")
		player_front_flip[11] = love.graphics.newImage("resources/textures/player/front_flip/11.png")
		player_front_flip[12] = love.graphics.newImage("resources/textures/player/front_flip/12.png")
		player_front_flip[13] = love.graphics.newImage("resources/textures/player/front_flip/13.png")
	player_fall[1] = love.graphics.newImage("resources/textures/player/jump_fall/1.png")
--SOUNDS
	masterVolume = 1.0
	soundsVolume = 1.0
	--heartPickup = love.audio.newSource("resources/sounds/score.ogg", "static")
	--heartPickup:setVolume(masterVolume * soundsVolume)
end