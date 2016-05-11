local item = ...

function item:on_created()

  self:set_savegame_variable("i1109")
  self:set_assignable(true)
end

function item:on_using()
  local game = self:get_game()
  local map = self:get_map()

	local x = map.cursor_x + 8
	local y = map.cursor_y + 13

  for entity in map:get_entities_in_rectangle(x, y, 1, 1) do
    if entity ~= nil then
      if entity:get_type() == "enemy" then
        if entity:get_name() ~= nil and entity:get_name():sub(1, 4) == "towa" then
          sol.audio.play_sound("bomb")
          game:add_money(5)
          
          entity:remove()
          self:set_finished()
          return
        end
      end
    end
  end

  if game:get_money() < 10 then
    sol.audio.play_sound("wrong")
    self:set_finished()
    return
  end

  sol.audio.play_sound("ok")
  local toto = map:create_enemy{
  name = "towa" .. game.nb_towers,
  x = x,
  y = y,
  direction = 1,
  breed = "medusa",
  layer = 0
  }
  game:remove_money(10)
  game.nb_towers = game.nb_towers + 1
  self:set_finished()
end

function item:get_block_position_from_hero()

  -- Compute a position
  local hero = self:get_map():get_entity("hero")
  local x, y, layer = hero:get_position()
  local direction = hero:get_direction()
  if direction == 0 then
    x = x + 21
  elseif direction == 1 then
    y = y - 21
  elseif direction == 2 then
    x = x - 21
  elseif direction == 3 then
    y = y + 21
  end

  -- Snap the center of the block to the 8*8 grid.
  x = (x + 4) - (x + 4) % 8
  y = (y - 1) - (y - 1) % 8 + 5

  return x, y, layer
end

function item:on_obtained(variant, savegame_variable)

end

