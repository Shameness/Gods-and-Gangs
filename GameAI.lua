AI = {}
AI_mt = {__index = AI}

local LOW_HP = 20

local hpIsLow = false
local hasTarget = false
local targetInSightRadius = false
local targetInAttackRange = false


function AI.new(enemies, allies)
  local ai = {}
  ai.enemyList = enemies
  ai.allyList = allies
  return setmetatable(ai, AI_mt)
end

function AI:CheckHP(hp)
  if hp < LOW_HP then
    hpIsLow = true
  else
    hpIsLow = false
  end
end

function AI:checkHasTarget(target)
  if target = nil then
    hasTarget = true
  else
    hasTarget = false
  end
end

function AI:checkTargetInSightRadius(target)
  if target
end

--[[ AI TASKS
#Search - with component variable?
#Attack - to target ?
#Flee - when ?
#Defend



]]
