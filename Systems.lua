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
  return setmetatable(ai, AI_mt)
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
    if sentient.target == nil then
      --==TO:DO==-- step3 or step 4 ?
    end

    -- step 3 a --
    if targetInragne then    --==TO:DO==-- targetInSightRadius
      --==TO:DO==-- update it as target
    else
      --==TO:DO==-- go forward
    end

    -- step 3 b --
    if targetinrange then --==TO:DO==-- targetInAttackRange
      --==TO:DO==-- Attack
    else
      --==TO:DO==-- Move to Target
    end
    ::continue::
  end -- for loop

end
