-- A tower that shots fireballs.

local entity = ...

local children = {}

function entity:on_created()

  entity.damage = 1
  entity.distance = 100
  entity.delay = 500
  entity.price = 10

  entity:set_shooting(true)
  entity:start()
end

function entity:start()

  local map = entity:get_map()
  sol.timer.start(self, self.delay, function()
    if not entity.shooting then
      print("not shooting")
      return true
    end

    local ifound = nil
    local mdist = 99999
 
    for i in self:get_map():get_entities() do
      if i:get_type() == "enemy" then
        local lname = i:get_name()
        if lname ~= nil and lname:sub(1, 4) == "toto" then
          if i:get_life() > 0 then
            local dist = self:get_distance(i)
            print("dist = " .. dist)
            if dist < mdist then
              mdist = dist
              ifound = i
            end
          end
        end
      end
    end

    x, y, layer = self:get_position()
    if mdist < self.distance and ifound ~= nil then
      if not map.medusa_recent_sound then
        sol.audio.play_sound("bow")
        -- Avoid loudy simultaneous sounds if there are several medusa.
        map.medusa_recent_sound = true
        sol.timer.start(map, 200, function()
          map.medusa_recent_sound = nil
        end)
      end

      children[#children + 1] = map:create_enemy({
        breed = "fireball_red_small",
        x = x,
        y = y,
        layer = layer,
        direction = 1
      })
      children[#children]:set_target(ifound, entity.damage)
    end
    return true  -- Repeat the timer.
  end)
end

-- Suspends or restores shooting fireballs.
function entity:set_shooting(shooting)
  entity.shooting = shooting
end

local previous_on_removed = entity.on_removed
function entity:on_removed()

  if previous_on_removed then
    previous_on_removed(entity)
  end

  for _, child in ipairs(children) do
    child:remove()
  end
end
