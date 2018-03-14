--local EbsModule = require "assets.ebs"

local soldierAtlas = love.graphics.newImage("assets/animationTemplate.png")
local soldierFrames = {}
local frameWidth = 32
local frameHeight = 64
local atlashWidth, atlasHeight = soldierAtlas:getDimensions() local soldierStates = {"idle","walking","attackUpperCut"}
local speed = 0.15
for i=0, 32 do
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

  }
}
function SoldierAnimPack()
  return {soldierAtlas,soldierKeys,soldierStates,speed}
end


--Sword--

--cutdown swords are shifted 16 pixel to the left
local swordAtlas = love.graphics.newImage("assets/weaponExtended.png")

local swordFrames = {}
frameWidth = 64 -- importent
local frameHeight = 64
local atlashWidth, atlasHeight = swordAtlas:getDimensions()
local swordStates = {"idle","walking","attackUpperCut"}
-- local speed = 0.15
for i=0, 32 do
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
