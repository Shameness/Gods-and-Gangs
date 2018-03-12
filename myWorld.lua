local EbsModule = require "compsystem.ebs"
local EntitiesModule = require "Entities"
local SystemsModule = require "Systems"



local LEFT_SOLDIER_COUNT = 10
local RIGHT_SOLDIER_COUNT = 10

function loadWorld()
  -- ebs variables --
  -- world
  myWorld = World.init()


  -- systems
  myWorld:add_system(AI.new())
  myWorld:add_system(Drawer.new())


  -- images
  soldImg = love.graphics.newImage("dummy.png")


  --lookup tables
  -- myWorld.LeftTeamEntities = {}
  -- myWorld.RightTeamEntities = {}
  myWorld.entitiesLookup = {}
  myWorld.enemies = {}
  myWorld.allies = {} --not used
  myWorld.LeftTeam = {}
  myWorld.RightTeam = {}

  -- entities
  local soldierComptypes = {"Vector2","Sprite","Health","Sentient","Movement","Offensive","TeamTag"}

  myWorld.testshit = nil
  for i = 1,LEFT_SOLDIER_COUNT do
    local hp = 25
    local sightRadius = 25
    local moveSpeed = math.random(20,30)
    local attackPower = math.random(3, 6)
    local attackRange = 1
    local attackSpeed = math.random()*2
    local team = "LeftTeam"
    --new instance
    local soldier = Soldier.new( myWorld, 100,(i*10)+100, soldImg, hp, sightRadius, moveSpeed,
    attackPower,attackRange,attackSpeed,team )
    -- add its position to lookup table
    if i == 1 then myWorld.testshit = soldier end
    table.insert(myWorld.LeftTeam, soldier.vector2)
    -- add its reference to another lookup table
    -- table.insert(LeftTeamEntities, soldier)
  end


  for i = 1,RIGHT_SOLDIER_COUNT do
    local hp = 25
    local sightRadius = 25
    local moveSpeed = math.random(20,30)
    local attackPower = math.random(3, 6)
    local attackRange = 1
    local attackSpeed = math.random()*2
    local team = "RightTeam"
    local soldier = Soldier.new(myWorld, 300,(i*10)+100, soldImg,hp,sightRadius,moveSpeed,
   attackPower,attackRange,attackSpeed,team  )
     table.insert(myWorld.RightTeam, soldier.vector2)
     -- table.insert(RightTeamEntities, soldier)
  end
  --Create Easy to read lookup tables
  myWorld.enemies.LeftTeam = myWorld.RightTeam
  myWorld.enemies.RightTeam = myWorld.LeftTeam
  myWorld.allies.LeftTeam = myWorld.LeftTeam
  myWorld.allies.RightTeam = myWorld.RightTeam

  function myWorld:sort()

    table.sort(self.LeftTeam, function(a, b) return a.x > b.x end)
    table.sort(self.RightTeam, function(a, b) return a.x < b.x end)
  end

  function myWorld:getComp(target, compCls)
    return self.components[compCls][target]
  end


  function myWorld:killEntity (entity)
    --Remove vector2 of entity from team lookup table
    for k,v in next,self[entity.teamtag.team]do
      if v == entity.vector2 then
        table.remove(self[entity.teamtag.team],k)
        break
      end
    end
    --Remove Values from lookup table
    for k,comptype in next,soldierComptypes do
      self.entitiesLookup[self.components[comptype][entity]] = nil
    end
    --Call ebsWorld's delete to remove entity
    self:delete(entity)

  end

  function myWorld:damageEntity (entity, damage)
    local health = self:getComp(entity,"Health")
    health.hp = health.hp - damage
    if health.hp <= 0 then
      self:killEntity(entity)
      return true
    end
    return false
  end



end
