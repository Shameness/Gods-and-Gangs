local EbsModule = require "compsystem.ebs"
local ComponentsModule = require "Components"

Soldier = {}
--Soldier_mt = {__index = Soldier}

function Soldier.new(world,x,y,image)
  --comps
  local soldier = Entity.init(world)
  soldier.vector2 = Vector2.new(x,y)
  soldier.sprite = Sprite.new(image)
  return soldier
end
