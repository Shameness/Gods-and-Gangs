local EbsModule = require "compsystem.ebs"
local EntitiesModule = require "Entities"
local SystemsModule = require "Systems"
local AnimationsModule = require "Animations"

local COLUMN_SIZE = 5
local LEFT_SOLDIER_COUNT = COLUMN_SIZE*3
local RIGHT_SOLDIER_COUNT = COLUMN_SIZE*8
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
  local swordAnim = SwordAnimPack()
  local atomicSwordAnim = AtomicSwordAnimPack()
  local bowAnim = CompoundBowAnimPack()


  --lookup tables
  -- myWorld.LeftTeamEntities = {}
  -- myWorld.RightTeamEntities = {}
  myWorld.entitiesLookup = {}
  myWorld.entityById = {}
  myWorld.enemies = {}
  myWorld.allies = {} --not used
  myWorld.LeftTeam = {}
  myWorld.RightTeam = {}
  myWorld.attackType = {Sword="attackUpperCut",AtomicSword="attack2hUpperCut",LongBow="attackShootArrow"}

  -- entities

  local soldierComptypes = {"Vector2","AnimatingSprite","Health","Sentient","Movement","Offensive","TeamTag","State","Armament"}


-- Entity Creation function ans constants --
  local hp = 200
  local sightRadius = 100

  local getMoveSpeed = function() return math.random(20,30) end
  local getAttackPower = function() return math.random() end
  local MeleeRange = 25
  local longRange = 250
  local getAttackSpeed = function() return math.random()*2 end
  local getX = function(addition,i) return addition+(math.floor(i/COLUMN_SIZE)*X_GAP) end
  local getY = function(i) return ((i%COLUMN_SIZE)*Y_GAP) end
-- Entity Creation function ans constants --

------ Left Team -----
  local team = "LeftTeam"
  --MELEE
  for i = 0,LEFT_SOLDIER_COUNT-1 do

    local weaponType = "Sword"
    local x = getX(200,i)
    local y = getY(i)
    local moveSpeed = getMoveSpeed()
    soldAnim[4] = 0.15 * moveSpeed/20
    local attackPower = getAttackPower()
    local attackSpeed = getAttackSpeed()
    local attackRange = MeleeRange


    local soldier = Soldier.new( --new instance
     myWorld,x,y,
     soldAnim, hp, sightRadius, moveSpeed,
     attackPower, attackRange, attackSpeed, team
    )

    table.insert(myWorld.LeftTeam, soldier.vector2)     -- add its position to lookup table

    --Armament--
    local mSword = Weapon.new(myWorld,soldier._id,swordAnim,weaponType,{attackPower={mul,1.5}})
    soldier.armament.weapon = mSword._id -- omg line
  end


  --ARCHERS
  for i = #myWorld.LeftTeam, #myWorld.LeftTeam+14 do
    local weaponType = "LongBow"

    local x = getX(0,i)
    local y = getY(i)
    local moveSpeed = getMoveSpeed()
    soldAnim[4] = 0.15 * moveSpeed/20
    local attackPower = getAttackPower()
    local attackSpeed = getAttackSpeed()
    local attackRange = longRange
    local mSightRadius = attackRange + 100

    local archer = Soldier.new(
      myWorld,x,y,
      soldAnim, hp, mSightRadius, moveSpeed,
      attackPower, attackRange, attackSpeed, team
    )

    table.insert(myWorld.LeftTeam, archer.vector2)

    local mBow = Weapon.new(myWorld,archer._id,bowAnim,weaponType,{attackPower={mul,1.5}})
    archer.armament.weapon = mBow._id -- omg line
  end

------ Right Team -----

local team = "RightTeam"
  for i = 0,RIGHT_SOLDIER_COUNT-1 do

    local weaponType = "AtomicSword"
    local x = getX(500,i)
    local y = getY(i)

    local moveSpeed = getMoveSpeed()
    soldAnim[4] = 0.15 * moveSpeed/20
    local attackPower = getAttackPower()
    local attackSpeed = getAttackSpeed()
    local attackRange = MeleeRange

    local soldier = Soldier.new(myWorld,x,y,
    soldAnim,hp,sightRadius,moveSpeed,
    attackPower,attackRange,attackSpeed,team)

    table.insert(myWorld.RightTeam, soldier.vector2)

     --armament--
    local mSword = Weapon.new(myWorld,soldier._id,atomicSwordAnim,weaponType,{attackPower={mul,1.5}})
    soldier.armament.weapon = mSword._id
  end

  for i = #myWorld.RightTeam, #myWorld.RightTeam+9 do
    local weaponType = "LongBow"

    local x = getX(600,i)
    local y = getY(i)
    local moveSpeed = getMoveSpeed()
    soldAnim[4] = 0.15 * moveSpeed/20
    local attackPower = getAttackPower()
    local attackSpeed = getAttackSpeed()
    local attackRange = longRange
    local mSightRadius = attackRange + 100

    local archer = Soldier.new(
      myWorld,x,y,
      soldAnim, hp, mSightRadius, moveSpeed,
      attackPower, attackRange, attackSpeed, team
    )

    table.insert(myWorld.RightTeam, archer.vector2)

    local mBow = Weapon.new(myWorld,archer._id,bowAnim,weaponType,{attackPower={mul,1.5}})
    archer.armament.weapon = mBow._id -- omg line
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
