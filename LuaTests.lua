currentPoss = {}
for i = 0, 10 do
  res = i * 32
  table.insert(currentPoss,res)
end

targetPoss = {}
for i = 0,10 do
  res = i * 64
  table.insert(targetPoss,res)
end

trans = {}
for i = 1, 7 do
  res = targetPoss[i] - currentPoss[i]
  table.insert(trans,res)
  print(i,res)
end
