
function ab (num1,num2)
  local gdc = 1
  local x = num1
  local y = num2
  i = 0
  while i < math.min(x,y) do
    i = i + 1
    for j = 2, math.min(x,y) do
      if x % j == 0 and y % j == 0 then
         gdc = gdc * j
         x = x / j
         y = y / j
         break
       end
    end

  end
  return gdc
end

print(ab(132,99))
