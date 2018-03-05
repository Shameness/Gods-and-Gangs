local EbsModule = require "compsystem.ebs"
local EntitiesModule = require "Entities"
local SystemsModule = require "Systems"


local LEFT_SOLDIER_COUNT = 10
local RIGT_SOLDIER_COUNT = 10

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
  myWorld.allies = {}
  myWorld.LeftTeam = {}
  myWorld.RightTeam = {}
  -- entities
--new(world,x,y,image,hp,sightRadius,moveSpeed,attackPower,attackRange,attackSpeed,team)
  for i = 1,LEFT_SOLDIER_COUNT do
    local hp = 25
    local sightRadius = 6
    local moveSpeed = math.random(20,25)
    local attackPower = math.random(3, 6)
    local attackRange = 1
    local attackSpeed = math.random()*2
    local team = "LeftTeam"
    --new instance
    local soldier = Soldier.new( myWorld, 100,(i*10)+100, soldImg, hp, sightRadius, moveSpeed,
    attackPower,attackRange,attackSpeed,team )
    -- add its position to lookup table
    table.insert(myWorld.LeftTeam, myWorld.components.Vector2[soldier])
    -- add its reference to another lookup table
    -- table.insert(LeftTeamEntities, soldier)
  end

  for i = 1,RIGT_SOLDIER_COUNT do
    local hp = 25
    local sightRadius = 6
    local moveSpeed = math.random(20,25)
    local attackPower = math.random(3, 6)
    local attackRange = 1
    local attackSpeed = math.random()*2
    local team = "RightTeam"
    local soldier = Soldier.new(myWorld, 300,(i*10)+100, soldImg,hp,sightRadius,moveSpeed,
   attackPower,attackRange,attackSpeed,team  )
     table.insert(myWorld.RightTeam, myWorld.components.Vector2[soldier])
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



end
