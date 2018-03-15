local EbsModule = require "compsystem.ebs"
local ComponentsModule = require "Components"

Soldier = {}
--Soldier_mt = {__index = Soldier}

function Soldier.new(world,x,y,animationPack,hp,sightRadius,moveSpeed,attackPower,attackRange,attackSpeed,team,armament)
  --comps
  local atlas,keys,states,animSpeed = unpack(animationPack)
  local soldier = Entity.init(world)
  soldier.vector2 = Vector2.new(x,y)
  soldier.animatingSprite = AnimatingSprite.new(atlas,keys,states,animSpeed)
  soldier.health = Health.new(hp)
  soldier.sentient = Sentient.new(sightRadius)
  soldier.movement = Movement.new(moveSpeed)
  soldier.offensive = Offensive.new(attackPower, attackRange, attackSpeed)
  soldier.teamtag = TeamTag.new(team)
  soldier.state = State.new("idle")
  soldier.armament = Armament.new(armament)
  return soldier
end

Weapon = {}

function Weapon.new(world,parentId,animationPack,name,modifiers)
  local atlas,keys,states = unpack(animationPack)
  local weapon = Entity.init(world)
  weapon.vector2 = Vector2.new(0,0)
  weapon.parentEntity = ParentEntity.new(parentId)
  weapon.animatingSprite = AnimatingSprite.new(atlas, keys, states)
  weapon.equipment = Equipment.new(name, modifiers)
  return weapon
end
