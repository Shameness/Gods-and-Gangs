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
  animator.componenttypes = {"Vector2", "AnimatingSprite","State","TeamTag","Armament"}
  return setmetatable(animator, Animator_mt)
end

function Animator.process(world, components)
  for comps in coroutine.wrap(components) do
    local vector2, animSprite, state, teamTag, armament = unpack(comps)
    if state.currentState ~= state.previousState then
      animSprite.currentFrame = 1
    end

    animSprite.delta = animSprite.delta + love.timer.getDelta()
    if animSprite.delta > animSprite.speed then
      animSprite.delta = animSprite.delta - animSprite.speed
      animSprite.currentFrame = animSprite.currentFrame + 1
    end
    local frameQuad = animSprite.keys[state.currentState][animSprite.currentFrame]


    if not frameQuad then
      animSprite.currentFrame = 1
      frameQuad = animSprite.keys[state.currentState][animSprite.currentFrame]
    end
    local flip = AI[teamTag.team]
    local trans = (flip/1) * 48
    --armament--
    for k,equipmentId in next,armament do
      local equipment = world.entityById[equipmentId]
      local key = equipment.animatingsprite.keys[state.currentState]
      local mFrameQuad = key[animSprite.currentFrame]
      local shifted = key.shifted
      local xShift, yShift = 0,0
      if shifted  then xShift = key.xShift ;yShift = key.yShift end
      love.graphics.draw(equipment.animatingsprite.atlas,
       mFrameQuad, vector2.x+(xShift*-flip), vector2.y+yShift,0,flip,1,trans+16)
    end
    love.graphics.draw(animSprite.atlas, frameQuad, vector2.x, vector2.y,0,flip,1,trans+16)

  end
end

-------- TotalAI --------
AI = {LeftTeam = 1, RightTeam = -1}
AI_mt = {__index = AI}

function AI.new()
  local ai = {}
  ai.is_applicator = true
  ai.componenttypes = {"Vector2", "Sentient", "Health", "Movement", "Offensive", "TeamTag","State","Armament"}
  return setmetatable(ai, AI_mt)
end


function AI.inRange(pos, v, radius)
  local direction = pos - v
  return radius >= direction:length()
end

--[[
Decision Tree for all entities that has corresponding components(see AI.new for componenttypes)
Utilizes 'goto countinue' to skip rest of decision tree for current etity
vvv= Decision tree steps, one step occurs one at a time (for now :) =vvv
  -- step 1 -- decide whether flee or not to
  -- step 2 -- ::checkHasTarget::
    -- step 2.1 -- ::checkAttackRange::
    -- step 2.2 -- ::walkToTarget::
  -- step 3  -- ::checkSightRange::
^^^=                                                                =^^^

]]
function AI.process(world, components)
  world:sort()
  for comps in coroutine.wrap(components) do
    local vector2, sentient, health, movement, offensive, teamTag, state, armament = unpack(comps)
    --a small ducttape b/c sometimes the coroutine countinues to read dead entities's aged comps
    if #comps == 0 then
      goto continue --Ducth Tape
    end

    --local variables for look and find, needs to be defined before any goto statement
    local falledin = false;
    local searchResult = nil

    -- step 1 -- decide whether flee or not to
    if sentient.canFlee and health.hp < 100 then
      if sentient.target ~= nil and world.entityById[sentient.target].health.hp > 100 then
        --Flee
        vector2.x = vector2.x + (love.timer.getDelta() * (AI[teamTag.team]* -1 * movement.moveSpeed))
        state:set("walking")
        goto continue
      end
    end

    -- step 2 --
    --::checkHasTarget::
    if sentient.targetId and world.entityById[sentient.targetId] then
          local target = world.entityById[sentient.targetId]
          local targetPos = target.vector2
          -- step 2.1 --
          --::checkAttackRange::
          if AI.inRange(vector2,targetPos,offensive.attackRange) then
            local weaponType = world.entityById[armament.weapon].equipment.name
            state:set( world.attackType[weaponType])
            targetKilled = world:damageEntity(target, offensive.attackPower*offensive.attackSpeed)

            if targetKilled then
              sentient.targetId = nil
              target = nil
            end
          else
          -- step 2.2 --
          --::walkToTarget::
            state:set("walking")
            res = vector2 + ((targetPos - vector2):normalize() * movement.moveSpeed * love.timer.getDelta())
            vector2.x = res.x
            vector2.y = res.y


          end
    else

    -- step 3  --
    --::checkSightRange::--
    --below fast checks sightRadius, after fastcheck is successful its falls to next step of detalied lookup
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
      --Just walk forward if there is no close enemy
      else
        state:set("walking")
        --::GO FORWARD::--
        vector2.x = vector2.x + (love.timer.getDelta() * (AI[teamTag.team] * movement.moveSpeed))
        --goto continue -- Important
      end
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
