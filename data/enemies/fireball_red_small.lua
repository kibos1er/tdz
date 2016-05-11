local enemy = ...

local sprite = nil

function enemy:on_created()

  enemy:set_life(1)
  enemy:set_damage(0)
  enemy:set_size(8, 8)
  enemy:set_origin(4, 4)
  enemy:set_obstacle_behavior("flying")
  enemy:set_can_hurt_hero_running(false)
  enemy:set_invincible()
  enemy:set_can_attack(false)
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
end

local function go(target)

  local movement = sol.movement.create("target")
  movement:set_speed(192)
  movement:set_smooth(true)
  movement:set_target(target)

  function movement:on_obstacle_reached()
    enemy:remove()
  end

--  sprite:set_animation("walking")

  movement:start(enemy)
end


function enemy:set_target(target, damage)
  enemy.target = target
  enemy.damage = damage
  go(target)
end

function enemy:on_movement_finished(movement)
  enemy.target:remove_life(enemy.damage)
  enemy:remove()
end

function enemy:on_restarted()

end

