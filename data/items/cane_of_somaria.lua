local item = ...

local towers = require("towers")

function item:on_created()

  self:set_savegame_variable("i1109")
  self:set_assignable(true)
end

function item:on_using()
  local game = self:get_game()
  local map = self:get_map()

	local x = map.cursor_x
	local y = map.cursor_y

  for entity in map:get_entities_in_rectangle(x, y, 1, 1) do
    if entity ~= nil then
      if entity:get_type() == "custom_entity" then
        if entity:get_name() ~= nil and entity:get_name():sub(1, 4) == "towa" then
          sol.audio.play_sound("bomb")
          game:add_money(entity.price / 2)
          
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

  local tower_item = game.tower_item

  local toto = map:create_custom_entity{
    name = towers[tower_item][1],
    x = x,
    y = y,
    direction = 1,
    sprite = towers[tower_item][2],
    model = towers[tower_item][1],
    layer = 0
  }

  game:remove_money(toto.price)
  game.nb_towers = game.nb_towers + 1
  self:set_finished()
end

function item:on_obtained(variant, savegame_variable)

end

