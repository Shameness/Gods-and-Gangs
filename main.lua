local worldModule = require "myWorld"

function love.load()
  math.randomseed(os.time())
  math.random(); math.random(); math.random()
  loadWorld()
end

function love.update(dt)

end

function love.draw()
  myWorld:process()
end
