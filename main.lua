local worldModule = require "myWorld"

function love.load()
  loadWorld()
end

function love.update(dt)
  
end

function love.draw()
  myWorld:process()
end
