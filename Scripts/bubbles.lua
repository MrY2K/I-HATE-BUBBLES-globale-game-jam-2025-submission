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
  for i = #self.list, 1, -1 do
      local bubble = self.list[i]
      bubble.y = bubble.y - bubble.speed * dt -- Make the bubble float up
      bubble.x = bubble.x + math.sin(bubble.timer * 2) * bubble.wiggle_amplitude -- Wiggle left and right
      bubble.timer = bubble.timer + dt -- Update wiggle timer

      -- Remove the bubble if it goes off the top of the screen
      local bubbleHeight = self.sprite:getHeight() * bubble.size
      if bubble.y + bubbleHeight < 0 then
          table.remove(self.list, i)
      end
  end

  -- Check collisions between bullets and bubbles
  for i = #Player.bullets, 1, -1 do
      local bullet = Player.bullets[i]
      for j = #self.list, 1, -1 do
          local bubble = self.list[j]
          
          -- Calculate bubble's actual dimensions and position
          local bubbleWidth = self.sprite:getWidth() * bubble.size
          local bubbleHeight = self.sprite:getHeight() * bubble.size
          local bubbleCenterX = bubble.x + bubbleWidth/2
          local bubbleCenterY = bubble.y + bubbleHeight/2
          
          -- Calculate distance between bullet and bubble center
          local dx = bullet.x - bubbleCenterX
          local dy = bullet.y - bubbleCenterY
          local distanceSquared = dx*dx + dy*dy
          
          -- Calculate collision radius (bubble radius + bullet radius)
          local collisionRadius = (math.max(bubbleWidth, bubbleHeight)/2) + 3
          local collisionRadiusSquared = collisionRadius * collisionRadius
          
          -- Check collision and remove both if they intersect
          if distanceSquared < collisionRadiusSquared then
              table.remove(Player.bullets, i)
              table.remove(self.list, j)
              break -- Only hit one bubble per bullet
          end
      end
  end

  -- Spawn new bubble if enough time has passed since the last spawn
  if self.timeSinceLastSpawn >= self.spawnCooldown then
      self:spawnBubble()
      self.timeSinceLastSpawn = 0 -- Reset the spawn timer
  end

-- Check collisions between bubbles and player
  for i = #self.list, 1, -1 do
    local bubble = self.list[i]
    
    -- Calculate bubble collision area
    local bubbleWidth = self.sprite:getWidth() * bubble.size
    local bubbleHeight = self.sprite:getHeight() * bubble.size
    local bubbleCenterX = bubble.x + bubbleWidth/2
    local bubbleCenterY = bubble.y + bubbleHeight/2
    
    -- Calculate player collision area (assuming 50x50 rectangle)
    local playerSize = 25  -- Half of 50px rectangle
    local playerCenterX = character.x
    local playerCenterY = character.y
    
    -- Check collision using circle approximation
    local dx = bubbleCenterX - playerCenterX
    local dy = bubbleCenterY - playerCenterY
    local distance = math.sqrt(dx*dx + dy*dy)
    local collisionDistance = playerSize + (math.max(bubbleWidth, bubbleHeight)/2)
    
    if distance < collisionDistance and not Player.gameOver then
        table.remove(self.list, i)
        Player.hearts = Player.hearts - 1
        
        if Player.hearts <= 0 then
            Player.gameOver = true
            -- You could add game over sound here
        end
    end
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