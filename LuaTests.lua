------- Vector2 -------
Vector2 = {__class = "Vector2"}
Vector2_mt = {__index = Vector2}

function Vector2.new(x,y)
  local vector2 = {}
  vector2.x = x
  vector2.y = y
  return setmetatable(vector2, Vector2_mt)
end

function Vector2_mt.__sub(a, b)
  return Vector2.new(a.x-b.x,a.y-b.y)
end

function Vector2_mt.__mul(a, b)
  return Vector2.new(a.x*b,a.y*b)
end

function Vector2:normalize()
  local div = self.x + self.y
  local x = self.x / div
  local y = self.y / div
  return Vector2.new(x,y)
end

klm = Vector2.new(3,1)
abc = (klm*3):normalize()*3
dem = klm - abc
print(dem.x , dem.y)
print(klm.x, klm.y)
print(abc.x, abc.y)
