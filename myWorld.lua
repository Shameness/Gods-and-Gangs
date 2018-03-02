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
  for i = 1,LEFT_SOLDIER_COUNT do
    --new instance
    local soldier = Soldier.new(myWorld, 100(i*10),100, soldImg )
    -- add its position to lookup table
    table.insert(LeftTeam, myWorld.components.Vector2[soldier])
    -- add its reference to another lookup table
    -- table.insert(LeftTeamEntities, soldier)
  end

  for i = 1,RIGT_SOLDIER_COUNT do
     local soldier = Soldier.new(myWorld, 300+(i*10),100, soldImg )
     table.insert(RightTeam, myWorld.components.Vector2[soldier])
     -- table.insert(RightTeamEntities, soldier)
  end
  --Create Easy to read lookup tables
  myWorld.enemies.LeftTeam = RightTeam
  myWorld.enemies.RightTeam = LeftTeam
  myWorld.allies.LeftTeam = LeftTeam
  myWorld.allies.RightTeam = RightTeam

  function myWorld:sort()
    table.sort(self.LeftTeam, function(a, b) return a.x > b.x end)
    table.sort(self.RightTeam, function(a, b) return a.x < b.x end)
  end

  function inRange(pos, v, radius)
    return radius >= math.sqrt((math.pow(pos.x-v.x, 2) + math.pow(pos.y - v.x, 2))
  end

  function myWorld:getComp(target, compCls)
    return self.components[compCls][target]
  end

  function myWorld:checkSightRadius(pos, radius, team)
    local falledin = false;

    for k,v in next,self.enemies[team] do

      if not falledin do

        if math.abs(pos.x - v.x) <= radius then
          if inRange(pos, v, radius) then
             return self.entitiesLookup[v]
           end
          falledin = true
        else
          return nil
        end

      elseif inRange(pos, v, radius) then
        return self.entitiesLookup[v]
      end
    end
  end




end
