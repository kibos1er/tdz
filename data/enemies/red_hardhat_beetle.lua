local enemy = ...

function enemy:on_created()

  self:set_life(2)
  self:set_damage(2)
  self:create_sprite("enemies/red_hardhat_beetle")
  self:set_size(16, 16)
  self:set_origin(8, 13)
  self:set_push_hero_on_sword(true)
end

