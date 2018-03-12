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
  end
end

-------- Animator --------
Animator = {}
Animator_mt = {__index = Animator}

function Animator.new()
  local animator = {}
  animator.is_applicator = true
  animator.componenttypes = {"Vector2", "AnimatingSprite"}
  return setmetatable(animator, Animator_mt)
end

function Animator.process(world, components)
  for comps in coroutine.wrap(components) do
    local vector2, animSprite unpack(comps)
    love.graphics.draw()
  end
end

-------- TotalAI --------
AI = {LeftTeam = 1, RightTeam = -1}
AI_mt = {__index = AI}

function AI.new()
  local ai = {}
  ai.is_applicator = true
  ai.componenttypes = {"Vector2", "Sentient", "Health", "Movement", "Offensive", "TeamTag"}
  return setmetatable(ai, AI_mt)
end


function AI.inRange(pos, v, radius)
  local direction = pos - v
  return radius >= direction:length()
end

local errorcount = 0
local killeyCount = 0
local neturalCount = 0
function AI.process(world, components)
  world:sort()
  for comps in coroutine.wrap(components) do
    local vector2, sentient, health, movement, offensive, teamTag = unpack(comps)
    if #comps == 0 then
      goto continue
    end
    local falledin = false;
    local searchResult = nil
    -- step 1 --
    if health.hp == 2000 then
      --==TO:DO==-- Flee
      goto continue
    end

    -- step 2 --
    --::checkHasTarget::
    if sentient.targetId and world.entityById[sentient.targetId] then
          local target = world.entityById[sentient.targetId]
          local targetPos = target.vector2

          if AI.inRange(vector2,targetPos,offensive.attackRange) then

            targetKilled = world:damageEntity(target, offensive.attackPower)

            if targetKilled then
              killeyCount = killeyCount + 1
              sentient.targetId = nil
              target = nil
            end
          else
            --sentient.state = "goToTarget"
            res = vector2 + ((targetPos - vector2):normalize() * movement.moveSpeed * love.timer.getDelta())
            vector2.x = res.x
            vector2.y = res.y


          end
    else

    -- step 3 a --
    --::checkSightRange::--
      for k,v in next,world.enemies[teamTag.team] do
        if not falledin then
          if math.abs(vector2.x - v.x) <= sentient.sightRadius then
            if AI.inRange(vector2, v, sentient.sightRadius) then
               searchResult = world.entitiesLookup[v]
               break
             end
            falledin = true--no break:)
          else
            searchResult = nil
            break
          end

        elseif AI.inRange(vector2, v, sentient.sightRadius) then
          searchResult = world.entitiesLookup[v]
          break
        end
      end

      if searchResult ~= nil then
        --update targetId with result
        sentient.targetId = searchResult

      else
        --sentient.state = "goForward"
        --::GO FORWARD::--
        vector2.x = vector2.x + (love.timer.getDelta() * (AI[teamTag.team] * movement.moveSpeed))
        --goto continue -- Important
      end
    end
    -- step 3 b --
    --::checkAttackRange::

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
