--[[

DONE generate bubbles randomly in diffrent posision y 

DONE make them float up wigling  

todo collition

  todo burst animation if they thouch the player poop -- make them satisfaing 
  add sound

--]]


Bubbles = {
  list = {}, -- Stores all active bubbles
  spawnCooldown = 0.5, -- Time in seconds between each bubble spawn (adjust as needed)
  timeSinceLastSpawn = 0, -- Timer to track time since the last spawn
}

----------------------------------------VAR----------------------------------------------------

Bubbles.sprite = love.graphics.newImage("Media/Image/1.png")-- Capture the third returned value

----------------------------------------LOAD----------------------------------------------------

function Bubbles:load()
  
end
----------------------------------------UPDATE----------------------------------------------------

function Bubbles:update(dt)

  -- Update the time since the last spawn
  self.timeSinceLastSpawn = self.timeSinceLastSpawn + dt

  -- Loop through all bubbles and update their positions
  for i, bubble in ipairs(self.list) do
    bubble.y = bubble.y - bubble.speed * dt -- Make the bubble float up
    bubble.x = bubble.x + math.sin(bubble.timer * 2) * bubble.wiggle_amplitude -- Wiggle left and right
    bubble.timer = bubble.timer + dt -- Update wiggle timer

    -- Remove the bubble if it goes off the screen
    if bubble.y + bubble.size < 0 then
      table.remove(self.list, i)
    end
  end

  -- Spawn new bubble if enough time has passed since the last spawn
  if self.timeSinceLastSpawn >= self.spawnCooldown then
    self:spawnBubble()
    self.timeSinceLastSpawn = 0 -- Reset the spawn timer
  end

end

----------------------------------------DRAW----------------------------------------------------

function Bubbles:draw()

  -- Draw all active bubbles
  for _, bubble in ipairs(self.list) do
    love.graphics.draw(self.sprite, bubble.x, bubble.y, 0, bubble.size, bubble.size)
  end

end

----------------------------------------SPAWN BUBBLES------------------------------------------

function Bubbles:spawnBubble()
  -- Create a new bubble with random properties
  local bubble = {
    x = math.random(0, love.graphics.getWidth() - 0), -- Random x position 
    y = love.graphics.getHeight() + 0, -- Start slightly offscreen at the bottom
    size = math.random(0, 2) * 0.5, -- Random size scaling
    speed = math.random(70, 100), -- Random float speed
    wiggle_amplitude = math.random(1, 2), -- Random wiggle amplitude
    timer = 0 -- Timer for wiggle movement
  }
  table.insert(self.list, bubble) -- Add the bubble to the list
end