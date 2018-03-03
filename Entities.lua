local EbsModule = require "compsystem.ebs"
local ComponentsModule = require "Components"

Soldier = {}
--Soldier_mt = {__index = Soldier}

function Soldier.new(world,x,y,image,hp,sightRadius,moveSpeed,attackPower,attackRange,attackSpeed,team)
  --comps
  local soldier = Entity.init(world)
  soldier.vector2 = Vector2.new(x,y)
  soldier.sprite = Sprite.new(image)
  soldier.health = Health.new(hp)
  soldier.sentient = Sentient.new(sightRadius)
  soldier.movement = Movement.new(moveSpeed)
  soldier.offensive = Offensive.new(attackPower, attackRange, attackSpeed)
  soldier.teamtag = TeamTag.new(team)
  return soldier
end
