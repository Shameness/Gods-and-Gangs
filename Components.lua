--local EbsModule = require "compsystem.ebs"

------- Vector2 -------
Vector2 = {__class = "Vector2"}
Vector2_mt = {__index = Vector2}

function Vector2.new(x,y)
  local vector2 = {}
  vector2.x = x
  vector2.y = y
  return setmetatable(vector2, Vector2_mt)
end

function Vector2_mt.__add(a, b)
  return Vector2.new(a.x + b.x, a.y + b.y)
end

function Vector2_mt.__sub(a, b)
  return Vector2.new(a.x-b.x,a.y-b.y)
end

function Vector2_mt.__mul(a, b)
  return Vector2.new(a.x*b,a.y*b)
end

function Vector2:length()
  return (self.x^2 + self.y^2 )^0.5
end

function Vector2:normalize()
  local len = self:length()
  local x = self.x / len
  local y = self.y / len
  return Vector2.new(x,y)
end

------- ParentEntity -------
ParentEntity = {__class= "ParentEntity"}
ParentEntity_mt = {__index = ParentEntity}

function ParentEntity.new(parentId)
  local parentEntity = {}
  parentEntity.parentId = parentId
  return setmetatable(parentEntity, ParentEntity_mt)
end

------- Health -------
Health = {__class = "Health"}
Health_mt = {__index = Health}

function Health.new(hp)
  local health = {}
  health.hp = hp
  return setmetatable(health, Health_mt)
end


------- Sprite -------
Sprite = {__class = "Sprite"}
Sprite_mt = {__index = Sprite}

function Sprite.new(image)
  local sprite = {}
  sprite.image = image
  return setmetatable(sprite, Sprite_mt)
end

------- AnimatingSprite -------
AnimatingSprite = {__class = "AnimatingSprite"}
AnimatingSprite_mt = {__index = AnimatingSprite}
--[[
keys protocol:
keys is table that has
 "String" keys
 "table" values
example: keys.idle = {0}
example: keys.walk = {1,2,3,4,5,6}
values are table that have
index as keys
int as values which are frame index(ex) in the atlas
atlas= holds all images in one image. now we use it to hold frames
frame= one of the image of animation

states are the name of the table keys in the keys (sorry for bad naming)
]]
function AnimatingSprite.new(atlas,keys,states,speed)
  local animSprite = {}
  animSprite.atlas = atlas
  animSprite.keys = keys
  animSprite.states = states
  animSprite.currentFrame = 1
  animSprite.currentState = states[1]
  animSprite.delta = 0
  animSprite.speed =speed
  return setmetatable(animSprite, AnimatingSprite_mt)
end

------ State -------
State = {__class = "State"}
State_mt = {__index = State}

function State.new(mState)
  local state = {}
  state.currentState = mState
  state.previousState = mState
  return setmetatable(state, State_mt)
end

function State:set(state)
  self.previousState = self.currentState
  self.currentState = state
end


------- Armament --------
--[[
Represent Equipments
]]
Armament = {__class = "Armament"}
Armament_mt = {__index = Armament }

function Armament.new(arms)
  armament = {}
  -- armament.top = top
  -- armament.bottom =
  return setmetatable(armament, Armament_mt)
end

------- Equipment -------
Equipment = {__class = "Equipment"}
Equipment_mt = {__index = Equipment}

function Equipment.new(name,modifiers,style)
  local equipment = {}
  equipment.name = name
  equipment.modifiers = modifiers
  equipment.style = style
  return setmetatable(equipment, Equipment_mt)
end

------- Sentient -------
Sentient = {__class = "Sentient"}
Sentient_mt = {__index = Sentient, __mode = "v"}

function Sentient.new(sightRadius)
  local sentient = {}
  sentient.sightRadius = sightRadius
  sentient.targetId = nil
  sentient.canFlee = (math.random(1, 10) == math.random(1, 10))
  sentient.state = ""
  return setmetatable(sentient, Sentient_mt)
end


------- Movement -------
Movement = {__class= "Movement"}
Movement_mt = {__index = Movement}

function Movement.new(moveSpeed)
  local movement = {}
  movement.moveSpeed = moveSpeed
  return setmetatable(movement, Movement_mt)
end


------- Offensive -------
Offensive = {__class= "Offensive"}
Offensive_mt = {__index = Offensive}

function Offensive.new(attackPower, attackRange, attackSpeed)
  local offensive = {}
  offensive.attackPower = attackPower
  offensive.attackRange = attackRange
  offensive.attackSpeed = attackSpeed
  return setmetatable(offensive, Offensive_mt)
end

------- TeamTag -------
TeamTag = {__class= "TeamTag"}
TeamTag_mt = {__index = TeamTag}

function TeamTag.new(team)
  local teamTag = {}
  teamTag.isLeftTeam = (team == 'LeftTeam') --not used
  teamTag.team = team
  return setmetatable(teamTag, TeamTag_mt)
end







--hi
