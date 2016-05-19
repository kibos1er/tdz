local map = ...
local game = map:get_game()

local nb_spawn = 0
local id_wave = 1
local nb_out = 0

local wtype = ""
local wnumber = 0
local wspeed = 0
local wwait = 0
local wlife = 0
local wrupees = 0
local nb_targets = 0

local hero_meta = sol.main.get_metatable("hero") 

function hero_meta:on_position_changed(x, y, layer)
  local map = self:get_map()
  local direction = self:get_direction()
  if direction == 0 then
    x = x
  elseif direction == 1 then
    y = y
  elseif direction == 2 then
    x = x
  elseif direction == 3 then
    y = y
  end
  x = (x + 4) - (x + 4) % 16
  y = (y - 1) - (y - 1) % 16

  map.cursor_x = x
  map.cursor_y = y
end

local function walk(enemy)
  local m = sol.movement.create("target")
  local tar = map:get_entity("target_" .. enemy.target)
  m:set_target(tar)
  m:set_speed(enemy.wspeed)
  m:start(enemy)
end

local function repeat_spawner()

  local lx, ly = map:get_entity("target_0"):get_position()

	wtype = waves[id_wave + 1][1]
	wnumber = waves[id_wave + 1][2]
	wspeed = waves[id_wave + 1][3]
	wwait = waves[id_wave + 1][4]
	wlife = waves[id_wave + 1][5]
	wrupees = waves[id_wave + 1][6]

  local en = map:create_enemy{
    name = "toto" .. nb_spawn,
    breed = wtype,
    layer = 0,
    x = lx,
		y = ly,
    direction = 3,
    treasure_name = "rupee",
    treasure_variant = wrupees
  }

  en:set_obstacle_behavior("flying")
  en.wspeed = wspeed
  en.target = 0
  en.total_life = wlife
  en:set_life(wlife)
  walk(en)

	nb_spawn = nb_spawn + 1
	if nb_spawn < wnumber then
    sol.timer.start(wwait, repeat_spawner)
	else
		if id_wave < #waves - 1 then
			nb_spawn = 0
      id_wave = id_wave + 2
      sol.timer.start(waves[id_wave], repeat_spawner)
		end
  end
end

function map:on_started()

  game.nb_towers = 0

  game:initialize_hud()

  function game:on_command_pressed(command)
    if command == "item_1" and self.pressed then
      return false
    end
    if command == "item_1" then
      self.pressed = true
      return true
    end
    if command == "item_2" then
      self.tower_item = self.tower_item + 1
      if self.tower_item > 2 then
        self.tower_item = 1
      end
      return false
    end
    return false
  end

  function game:on_command_released(command)
    if command == "item_1" and self.pressed then
      game:simulate_command_pressed("item_1")
      self.pressed = false
      return true
    end
    return false
  end

  self.pressed = false
  self.cursor_sprite = sol.sprite.create("hud/cursor")
  self.circle_sprite = sol.sprite.create("circle")
  self.cursor_x = 0
  self.cursor_y = 0

  game:set_ability("sword", 1)
  game:set_ability("sword_knowledge", 0)
  game:set_ability("tunic", 1)
  game:set_ability("shield", 0)
  game:set_ability("lift", 1)
  game:set_ability("swim", 0)
  game:set_ability("run", 0)
  game:set_ability("detect_weak_walls", 0)
  game:set_life(20)
  game:set_money(money)

  game.tower_item = 1

  local rupee_bag = game:get_item("rupee_bag")
  rupee_bag:set_variant(2)

  local cane = game:get_item("cane_of_somaria")
  cane:set_variant(1)
  game:set_item_assigned(1, cane)

  local t = 0
  while map:get_entity("target_" .. t) ~= nil do
    t = t + 1
  end
  nb_targets = t - 1

  local enemy_meta = sol.main.get_metatable("enemy") 

  function enemy_meta:on_restarted()
    local lname = self:get_name()
    if lname ~= nil and lname:sub(1, 4) == "toto" then
      	if self.target ~= nil then
   			walk(self)
	   	end
      if self.life_bar_sprite == nil then
        self.life_bar_sprite = sol.sprite.create("life_bar")
      end
    end
  end

  function enemy_meta:on_post_draw()
    local lname = self:get_name()
    if lname ~= nil and lname:sub(1, 4) == "toto" then
      local w = self:get_life() / self.total_life * 16
      local ox, oy = self:get_origin()

      if w >= 0 and self.life_bar_sprite ~= nil then
        self.life_bar_sprite:set_frame(w)
        local map = self:get_map()
        local x, y = self:get_position()
        map:draw_sprite(self.life_bar_sprite, x - ox, y - oy - 3)
      end
    end
  end

  function enemy_meta:on_movement_finished(movement)
    local lname = self:get_name()
    if lname ~= nil and lname:sub(1, 4) == "toto" then
      self.target = self.target + 1
      if self.target > nb_targets then
        sol.audio.play_sound("wrong")
	      self:remove()
			  nb_out = nb_out + 1
		  else
        walk(self)
		  end
    end
	end

  function map:on_draw(destination_surface)
    local color = {255, 0, 0}
    if nb_out == 0 then
      color = {0, 255, 0}
    end

    local lx, ly, lw, lh = map:get_entity("target_" .. nb_targets):get_bounding_box()
    local cx, cy = map:get_camera():get_position()

    local surf = sol.text_surface.create({
          text = nb_out,
          font = "minecraftia",
          font_size = 7,
          color = color,
          horizontal_alignment = "center",
          vertical_alignment = "middle"})

    surf:draw(destination_surface, lx + lw / 2 - cx, ly + lh / 2 - cy)
  
    if self:get_game().pressed then
      self:draw_sprite(self.cursor_sprite, self.cursor_x, self.cursor_y)
      self:draw_sprite(self.circle_sprite, self.cursor_x, self.cursor_y)
    end
  end

  sol.timer.start(waves[1], repeat_spawner)
end
