-- A tower that shots fireballs.

local entity = ...
local towers = require("towers")

local children = {}
local tower_id = nil

function entity:on_created()

  self.sound_lock = self:get_map().towa01_lock
  tower_id = 2

  self.damage = towers[tower_id][3]
  self.distance = towers[tower_id][4]
  self.delay = towers[tower_id][5]
  self.price = towers[tower_id][6]
  self.sound_name = towers[tower_id][7]
  self.bullet = towers[tower_id][8]
  self.waiting_animation = towers[tower_id][9]
  self.firing_animation = towers[tower_id][10]

  self:get_sprite():set_animation(self.waiting_animation)

  self:start()
end

function entity:start()

  sol.timer.start(self, self.delay, function()

    closest_enemy, distance = self:find_closest_enemy()

    if distance < self.distance and closest_enemy ~= nil then
      self:get_sprite():set_animation(self.firing_animation)
      self:shoot_enemy(closest_enemy)
    else
      self:get_sprite():set_animation(self.waiting_animation)
    end

    return true  -- Repeat the timer.
  end)
end

function entity:find_closest_enemy()

  local map = self:get_map()

  local ifound = nil
  local mdist = 99999
 
  for i in self:get_map():get_entities() do
    if i:get_type() == "enemy" then
      local lname = i:get_name()
      if lname ~= nil and lname:sub(1, 4) == "toto" then
        if i:get_life() > 0 then
          local dist = self:get_distance(i)

          if dist < mdist then
            mdist = dist
            ifound = i
          end
        end
      end
    end
  end

  return ifound, mdist
end



function entity:shoot_enemy(target)

  local map = self:get_map()
  local x, y, layer = self:get_position()

  if not self.sound_lock then
    sol.audio.play_sound(self.sound_name)
    -- Avoid loudy simultaneous sounds if there are several medusa.
    self.sound_lock = true
    sol.timer.start(map, 200, function()
      self.sound_lock = nil
      end)
  end

  children[#children + 1] = map:create_enemy({
                                               breed = self.bullet,
                                               x = x,
                                               y = y,
                                               layer = layer,
                                               direction = 1
                                              })
  children[#children]:set_target(target, self.damage)
end

local previous_on_removed = entity.on_removed

function entity:on_removed()

  if previous_on_removed then
    previous_on_removed(self)
  end

  for _, child in ipairs(children) do
    child:remove()
  end
end
