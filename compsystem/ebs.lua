local SetModule = require "compsystem.set"

----------- Entity -----------
Entity = {}
--setmetatable(Entity, Entity)
Entity_mt = {__index = Entity_mt}

function Entity_mt:__index(key)
  --Gets Component

  local ctype = self._world._componenttypes[key]
  assert(ctype, ( "doesn't has attribute " .. key))
  return self._world.components[ctype][self]
end

--Entity Init
function Entity.init(world)
  assert(world.__type == 'World', "world must be a World")
  local entity = {}
  entity._world = world
  entity._id = string.sub(tostring(entity), 8)
  world.entities.add(world.entities,entity)
  setmetatable(entity, Entity_mt)
  world.entityById[""..entity._id] = self --my addition for lookup table
  return entity
end


function Entity_mt.__tostring(v)
  return("<Entity: " .. v._id .. ">")
end

-- function Entity:__index(key)
--   --Gets Component
--
--   local ctype = self._world._componenttypes[key]
--   assert(ctype, (self .. "doesn't has attribute " .. key))
--   return self._world.components[ctype][self]
-- end

function Entity_mt:__newindex (key, value)
  local clstype = value.__class
  local wctypes = self._world.componenttypes(self._world)
  if wctypes[clstype] == nil then
    self._world.add_componenttype(self._world,clstype)
  end
  self._world.components[clstype][self] = value
  self._world.entitiesLookup[value] = ""..self._id --this is additional
  self._world.entityById[""..self._id] = self
end
--deletes compoenent
function Entity_mt:delComp(key)
  local ctype = self._world._componenttypes[key]
  assert(ctype, (self .. "doesn't has attribute " .. key))
  self._world.components[ctype][self] = nil
  assert(false,"Not implemented")
end

function Entity_mt:delete()
  self.world.delete(self)
end

----------- World -----------
World = {}
World_mt = {__index = World}

function World.init()
  local world = {}
  world.__type = 'World'
  world.entities = Set:new()
  world._systems = {}
  world.components = {}
  world._componenttypes = {}
  setmetatable(world, World_mt)
  return world
end

function World:componenttypes()
  local values = {}
  for k,v in next,self._componenttypes do
    table.insert(values, v)
  end
  return values
end

function World._system_is_valid(system)
  return (system.componenttypes ~= nil and
  type(system.componenttypes) == 'table' and
  system.process ~= nil and
  type(system.process) == 'function')
end

function World:combined_components(comptypes)
  local comps = self.components
  local keysets = {} --1
  local valsets = {} --2
  for k,ctype in next,comptypes do table.insert(keysets,Set:new(comps[ctype])) end--1
  for k,ctype in next,comptypes do table.insert(valsets,comps[ctype]) end         --2
  local entities = keysets[1] --3
  for k, set  in next,keysets   do entities = entities * set end --3
  return function()
    for ekey,v in next, entities do
      res = {}
      for k,component in next,valsets do table.insert(res,component[ekey]) end
      coroutine.yield(res)
    end
  end
end

function World:add_componenttype(classtype)
  if self._componenttypes[string.lower(classtype)] then return end
  self.components[classtype] = {}
  self._componenttypes[string.lower(classtype)] = classtype
end

function World:delete (entity)--(entity)
  for k,v in next,self.components do
    v[entity] = nil
  end
  self.entities:remove(entity)
end

function World:delete_entities(entities)
  assert(false,"Not implemented")
end

function World:get_components(componenttype)
  if self.components[componenttype] then
    return self.components[componenttype]
  end
  return {}
end

function World:get_entities(component)
  compset = self.components[component.__class]
  if compset == nil then return {} end
  local res = {}
  for k,e in next,compset do
    if e.__class == component.__class then
      table.insert(res,e)
    end
  end
  return res
end

function World:add_system(system)
  if not self._system_is_valid(system) then
    assert(false,"system must have componenttypes and a process method")
  end
  for k,classtype in next,system.componenttypes do
    if not self.components[classtype] then
      self:add_componenttype(classtype)
    end
  end
  table.insert(self._systems,system)
end

function World:remove_system(system)
  for k,v in pairs(self._systems) do
    if v == system then
      self._systems[k] = nil
      return
    end
  end
end

function World:process()
  local components = self.components
  for k,system in next, self._systems do
    s_process = system.process
    if system.is_applicator == true then
      local comps = self:combined_components(system.componenttypes)
      s_process(self, comps)
    else
      for k,ctype in next,system.componenttypes do
        s_process(self, components[ctype])
      end
    end
  end
end
----------- System -----------
System = {}
System_mt = {__index = System}
function System:init()
  local system = {}
  system.componenttypes = {}
  return setmetatable(system, System_mt)
end

function System:process()
  assert(false,"Not implemented")
end
