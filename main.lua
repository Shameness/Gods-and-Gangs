local worldModule = require "myWorld"

function love.load()
  loadWorld()
end

function love.update(dt)

end

function love.draw()
  myWorld:process()

  love.graphics.print(love.timer.getFPS(), 100, 100)
end
