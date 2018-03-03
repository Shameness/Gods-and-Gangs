local EbsModule = require "compsystem.ebs"

-------- Drawer --------
Drawer = {}
Drawer_mt = {__index = Drawer}

function Drawer.new()
  local drawer = {}
  drawer.is_applicator = true
  drawer.componenttypes = {"Vector2", "Sprite"}
  return setmetatable(drawer, Drawer_mt)
end

function Drawer.process(world, components)
  for comps in coroutine.wrap(components) do
    local vector2, sprite = unpack(comps)
    love.graphics.draw((sprite.image), vector2.x, vector2.y)
    -- print(sprite.image, vector2.x, vector2.y)
  end
end


-------- TotalAI --------
AI = {}
AI_mt = {__index = AI}

function AI.new()
  local ai = {}
  ai.is_applicator = true
  ai.componenttypes = {"Vector2", "Sentient", "Health", "Movement", "Offensive", "TeamTag"}
  ai.LeftTeam = 1
  ai.RightTeam = -1
  return setmetatable(ai, AI_mt)
end


function AI.inRange(pos, v, radius)
  return radius >= math.sqrt((math.pow(pos.x-v.x, 2) + math.pow(pos.y - v.x, 2))
end

function AI.process(world, components)
  for comps in coroutine.wrap(components) do
    local vector2, sentient, health, movement, offensive, teamTag = unpack(comps)

    -- step 1 --
    if health.hp < 20 then
      --==TO:DO==-- Flee
      goto continue
    end

    -- step 2 --
    --::checkHasTarget::
    if sentient.target ~= nil then
      --step3 or step 4 ?
      goto checkAttackRange
    end

    -- step 3 a --
    --::checkSightRange::
    local falledin = false;

    for k,v in next,world.enemies[team] do

      if not falledin do

        if math.abs(pos.x - v.x) <= radius then
          if AI.inRange(pos, v, radius) then
             res = world.entitiesLookup[v]
             break
           end
          falledin = true
        else
          res = nil
          break
        end

      elseif AI.inRange(pos, v, radius) then
        res = world.entitiesLookup[v]
        break
      end
    end

    if res ~= nil then
      --update it as target
      sentient.target = res
    else
      --==TO:DO==-- go forward
      sentient.state = "goForward"
      vector2.x = vector2.x + (love.timer.getDelta() * (ai[team] * movement.moveSpeed))
    end

    -- step 3 b --
    ::checkAttackRange::
    local targetPos = world:getComp(target, "Vector2")

    if AI.inRange(Vector2, targetPos, offensive.attackRange) then
      --==TO:DO==-- Attack

    else
      --==TO:DO==-- Move to Target
      sentient.state = "goToTarget"
    end
    ::continue::
  end -- for loop

end


-------- Sequencer --------

-- Sequencer = {}
-- Sequencer_mt = {__index = Sequencer}
--
-- function Sequencer.new()
--   local sequencer = {}
--   sequencer.is_applicator = true
--   sequencer.componenttypes = {"Vector2", "Sentient","Movement", "TeamTag"}
--   sequencer.LeftTeam = 1
--   sequencer.RightTeam = -1
--   return setmetatable(ai, Sequencer_mt)
-- end
--
-- Sequencer.goForward = (pos, team, speed,_)
--   pos.x = pos.x + (love.timer.getDelta() * (sequencer[team] * speed))
-- end
--
-- Sequencer.
-- function Sequencer.process(world, components)
--   for comps in coroutine.wrap(components) do
--     local vector2, sentient, movement, teamTag = unpack(comps)
--
--   end
-- end
