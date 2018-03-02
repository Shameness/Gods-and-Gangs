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


------- Sentient -------
Sentient = {__class = "Sentient"}
Sentient_mt = {__index = Sentient}

function Sentient.new(sightRadius)
  local sentient = {}
  sentient.sightRadius = sightRadius
  sentient.target = {}
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

function Offensive(attackPower, attackRange, attackSpeed)
  local offensive = {}
  offensive.attackPower = attackPower
  offensive.attackRange = attackRange
  offensive.attackSpeed = attackSpeed
  return setmetatable(offensive, Offensive_mt)
end

------- TeamTag -------
TeamTag = {__class= "TeamTag"}
TeamTag_mt = {__index = TeamTag}

function TeamTag(team)
  local teamTag = {}
  teamTag.isLeftTeam = (team == 'LeftTeam')
  teamTag.team = team
  return setmetatable(teamTag, TeamTag_mt)
end

for i = 1,10 do
  print(i)
end





--hi
