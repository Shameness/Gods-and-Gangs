--Author: wscherphof
--Soruce: github.com/wscherphof/lua-set/blob/master/src/Set/init.lua


Set = {}
Set.mt = {__index = Set}

function Set:new(values)
  local instance = {}
  local isSet if getmetatable(values) == Set.mt then isSet = true end
  if type(values) == 'table' then
    if not isSet and #values > 0 then
      for _, v in ipairs(values) do
        instance[v] = true
      end
    else
      for k,v in next,values do
        instance[k] = true
      end
    end
  elseif values ~= nil then
    instance = {[values] = true}
  end
  return setmetatable(instance, Set.mt)
end

function Set:add(e)
  if e ~= nil then
     self[e] = true
  end
  return self
end

function Set:remove(e)
  if e ~= nil then self[e] = nil end
  return self
end

function Set:len()
  local num = 0
  for _ in pairs(self) do
    num = num + 1
  end
  return num
end
--substraction
function Set.mt.__sub(a, b)
  local res, a ,b = Set:new(), Set:new(a), Set:new(b)
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = nil end
  return res
end

-- Intersection
function Set.mt.__mul (a, b)
  local res, a, b = Set:new(), Set:new(a), Set:new(b)
  for k in pairs(a) do
    res[k] = b[k]
  end
  return res
end
