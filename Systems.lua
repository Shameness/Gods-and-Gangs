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
  animator.componenttypes = {"Vector2", "AnimatingSprite","State","TeamTag"}
  return setmetatable(animator, Animator_mt)
end

function Animator.process(world, components)
  for comps in coroutine.wrap(components) do
    local vector2, animSprite, state,teamTag = unpack(comps)
    if state.currentState ~= state.previousState then
      animSprite.currentFrame = 1
    end
    for k,v in next, animSprite.keys do
      --print(k,v)
      for l,m in next, v do
        --print(l,m)
      end
    end
    animSprite.delta = animSprite.delta + love.timer.getDelta()
    if animSprite.delta > animSprite.speed then
      animSprite.delta = animSprite.delta - animSprite.speed
      animSprite.currentFrame = animSprite.currentFrame + 1
    end
    print(animSprite.keys[state.currentState])
    print(animSprite.currentFrame)
--    print(animSprite.keys[state.currentState][animSprite.currentFrame])
    local frameQuad = animSprite.keys[state.currentState][animSprite.currentFrame]
    if not frameQuad then
      animSprite.currentFrame = 1
      frameQuad = animSprite.keys[state.currentState][animSprite.currentFrame]
    end
    local flip = AI[teamTag.team]
    local trans = (flip/1) * 48
    love.graphics.draw(animSprite.atlas, frameQuad, vector2.x, vector2.y,0,flip,0.8,trans+16)
  end
end

-------- TotalAI --------
AI = {LeftTeam = 1, RightTeam = -1}
AI_mt = {__index = AI}

function AI.new()
  local ai = {}
  ai.is_applicator = true
  ai.componenttypes = {"Vector2", "Sentient", "Health", "Movement", "Offensive", "TeamTag","State"}
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
    local vector2, sentient, health, movement, offensive, teamTag, state = unpack(comps)
    if #comps == 0 then
      goto continue --Ducth Tape
    end
    local falledin = false;
    local searchResult = nil
    -- step 1 --
    if sentient.canFlee and health.hp > 600 then
      --Flee
      vector2.x = vector2.x + (love.timer.getDelta() * (AI[teamTag.team]* -1 * movement.moveSpeed))
      state:set("walking")
      goto continue
    end

    -- step 2 --
    --::checkHasTarget::
    if sentient.targetId and world.entityById[sentient.targetId] then
          local target = world.entityById[sentient.targetId]
          local targetPos = target.vector2

          if AI.inRange(vector2,targetPos,offensive.attackRange) then
            state:set("idle")
            targetKilled = world:damageEntity(target, offensive.attackPower*offensive.attackSpeed)

            if targetKilled then
              killeyCount = killeyCount + 1
              sentient.targetId = nil
              target = nil
            end
          else
            state:set("walking")
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
        state:set("walking")
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
