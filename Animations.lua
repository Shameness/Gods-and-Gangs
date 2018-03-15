--local EbsModule = require "assets.ebs"

local soldierAtlas = love.graphics.newImage("assets/animationTemplate.png")
local soldierFrames = {}
local frameWidth = 32
local frameHeight = 64
local atlashWidth, atlasHeight = soldierAtlas:getDimensions() local soldierStates = {"idle","walking","attackUpperCut"}
local speed = 0.15
for i=0, 70 do
  local x = i*frameWidth % atlashWidth
  local y = frameHeight * math.floor(i * frameWidth/atlashWidth)
  soldierFrames[i] = love.graphics.newQuad(x, y, frameWidth, frameHeight, soldierAtlas:getDimensions())
end
local soldierKeys = {}
soldierKeys =
{
idle=
  {
    soldierFrames[0]
  },
walking=
  {
    soldierFrames[1],
    soldierFrames[2],
    soldierFrames[3],
    soldierFrames[4],
    soldierFrames[5],
    soldierFrames[6]
  },
attackUpperCut=
  {
    soldierFrames[20],
    soldierFrames[21],
    soldierFrames[22],
    soldierFrames[23]

  },
  attack2hUpperCut=
  {
    soldierFrames[61],
    soldierFrames[62],
    soldierFrames[63],
    soldierFrames[64]
  },
  attackShootArrow=
  {
    soldierFrames[65],
    soldierFrames[66],
    soldierFrames[67],
    soldierFrames[68],
    soldierFrames[69],
  }
}
function SoldierAnimPack()
  return {soldierAtlas,soldierKeys,soldierStates,speed}
end


-------- Sword ----------

--cutdown swords are shifted 16 pixel to the left
local swordAtlas = love.graphics.newImage("assets/weaponExtended.png")

local swordFrames = {}
local frameWidth = 64 -- importent
local frameHeight = 64
local atlashWidth, atlasHeight = swordAtlas:getDimensions()
local swordStates = {"idle","walking","attackUpperCut"}
-- local speed = 0.15
for i=0, 70 do
  local x = i*frameWidth % atlashWidth
  local y = frameHeight * math.floor(i * frameWidth/atlashWidth)

  swordFrames[i] = love.graphics.newQuad(x, y, frameWidth, frameHeight, swordAtlas:getDimensions())
end
local swordKeys = {}
swordKeys = {
  idle=
    {
      swordFrames[0]
    },
  walking=
    {
      swordFrames[1],
      swordFrames[2],
      swordFrames[3],
      swordFrames[4],
      swordFrames[5],
      swordFrames[6]
    },
  attackUpperCut=
    {
      swordFrames[20],
      swordFrames[21],
      swordFrames[22],
      swordFrames[23],
      shifted = true,
      xShift = 16,
      yShift = 0
    }
}
function SwordAnimPack()
  return {swordAtlas,swordKeys,swordStates,speed}
end


-------- atomicSword ----------

local atomicSwordAtlas = love.graphics.newImage("assets/AtmoiacSwordAnim.png")
local frameWidth = 64+16 -- 80
local frameHeight = 64
atomicSwordFrames = {}
function atomicSwordFrames.__index(table,arg)
  local x = frameWidth  * (arg%10)
  local y = frameHeight * (math.floor(arg/10))

  return love.graphics.newQuad(x,y,frameWidth,frameHeight,atomicSwordAtlas:getDimensions())
end
setmetatable(atomicSwordFrames, atomicSwordFrames)



local atomicSwordKeys = {
  idle = swordKeys.idle,      ---  TO:DO change this with new atomicSwordFrames
  walking = swordKeys.walking,---
  attack2hUpperCut={
    atomicSwordFrames[60],
    atomicSwordFrames[61],
    atomicSwordFrames[62],
    atomicSwordFrames[63],
    shifted = true,
    xShift = 22,
    yShift = -8
  }
}
local atomicSwordStates = {"idle","walking","attack2hUpperCut"}
function AtomicSwordAnimPack()
  return {atomicSwordAtlas,atomicSwordKeys,atomicSwordStates,speed}
end


-------- CompoundBow ----------

local compoundBowAtlas = love.graphics.newImage("assets/CompoundBowAnim.png")
local frameWidth = 64 -- 80
local frameHeight = 64
CompoundBowFrames = {}
function CompoundBowFrames.__index(table,arg)
  local x = frameWidth  * (arg%10)
  local y = frameHeight * (math.floor(arg/10))

  return love.graphics.newQuad(x,y,frameWidth,frameHeight,compoundBowAtlas:getDimensions())
end
setmetatable(CompoundBowFrames, CompoundBowFrames)



local compoundBowKeys = {
  idle = swordKeys.idle,      ---  TO:DO change this with new atomicSwordFrames
  walking ={
    CompoundBowFrames[1],
    CompoundBowFrames[2],
    CompoundBowFrames[3],
    CompoundBowFrames[4],
    CompoundBowFrames[5],
    CompoundBowFrames[6],
    shifted = true,
    xShift = 3,
    yShift = 0
  },
  attackShootArrow={
    CompoundBowFrames[65],
    CompoundBowFrames[66],
    CompoundBowFrames[67],
    CompoundBowFrames[68],
    CompoundBowFrames[69]
  }
}
local compoundBowStates = {"idle","walking","attackShootArrow"}
function CompoundBowAnimPack()
  return {compoundBowAtlas,compoundBowKeys,compoundBowStates,speed}
end
