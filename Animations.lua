--local EbsModule = require "assets.ebs"

local soldierFrames = {}
local soldierAtlas = love.graphics.newImage("assets/animationTemplate.png")
local soldierStates = {"idle","walking"}
local speed = 0.15
for i=0, 10 do
  soldierFrames[i] = love.graphics.newQuad(0+i*32, 0, 32, 64, soldierAtlas:getDimensions())
end
soldierKeys = {}
local soldierKeys =
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
  }
}
function SoldierAnimPack()
  return {soldierAtlas,soldierKeys,soldierStates,speed}
end
