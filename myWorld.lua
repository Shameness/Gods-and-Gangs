local EbsModule = require "compsystem.ebs"
local EntitiesModule = require "Entities"
local SystemsModule = require "Systems"
local AnimationsModule = require "Animations"

local COLUMN_SIZE = 28
local LEFT_SOLDIER_COUNT = COLUMN_SIZE*5
local RIGHT_SOLDIER_COUNT = COLUMN_SIZE*5
--local ROW_SIZE = COLUMN_SIZE
local Y_GAP = 20
local X_GAP = 30
function loadWorld()
  -- ebs variables --
  -- world
  myWorld = World.init()


  -- systems
  myWorld:add_system(AI.new())
  myWorld:add_system(Drawer.new())
  myWorld:add_system(Animator.new())

  -- images
  local soldAnim = SoldierAnimPack()




  --lookup tables
  -- myWorld.LeftTeamEntities = {}
  -- myWorld.RightTeamEntities = {}
  myWorld.entitiesLookup = {}
  myWorld.entityById = {}
  myWorld.enemies = {}
  myWorld.allies = {} --not used
  myWorld.LeftTeam = {}
  myWorld.RightTeam = {}

  -- entities
  local soldierComptypes = {"Vector2","AnimatingSprite","Health","Sentient","Movement","Offensive","TeamTag","State"}

  myWorld.testshit = nil
  for i = 0,LEFT_SOLDIER_COUNT-1 do
    local hp = 25
    local sightRadius = 100
    local moveSpeed = math.random(20,30)
    local attackPower = math.random()
    local attackRange = 1
    local attackSpeed = math.random()*2
    local team = "LeftTeam"
    local x =100+(math.floor(i/COLUMN_SIZE)*X_GAP)
    local y = ((i%COLUMN_SIZE)*Y_GAP)
    print(x,y)
    --new instance
    local soldier = Soldier.new( myWorld,x,y,
     soldAnim, hp, sightRadius, moveSpeed,
    attackPower,attackRange,attackSpeed,team )
    -- add its position to lookup table
    if i == 1 then myWorld.testshit = soldier end
    table.insert(myWorld.LeftTeam, soldier.vector2)
    -- add its reference to another lookup table
    -- table.insert(LeftTeamEntities, soldier)
  end


  for i = 0,RIGHT_SOLDIER_COUNT-1 do
    local hp = 25
    local sightRadius = 100
    local moveSpeed = math.random(20,30)
    local attackPower = math.random()
    local attackRange = 1
    local attackSpeed = math.random()*2
    local team = "RightTeam"
    local x = 680-(math.floor(i/COLUMN_SIZE)*X_GAP)
    local y = ((i%COLUMN_SIZE)*Y_GAP)
    local soldier = Soldier.new(myWorld,x,y,
    soldAnim,hp,sightRadius,moveSpeed,
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
    self.entityById[entity._id] = nil
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
    local targetIsKilled = false
    health.hp = health.hp - damage
    if health.hp <= 0 then
      self:killEntity(entity)
      targetIsKilled = true
    end
    return targetIsKilled
  end



end
