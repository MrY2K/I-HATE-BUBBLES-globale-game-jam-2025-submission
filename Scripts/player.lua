Player = {
    hearts = 3,
    gameOver = false,
    bullets = {},    -- Table to track active bullets
    maxAmmo = 20,    -- Maximum ammo capacity
    currentAmmo = 20,-- Current ammo count
    fireCooldown = 0.2, -- Time between shots
    timeSinceLastShot = 0,

    clickSound = nil,  -- We'll initialize this in load
    canPlayEmptySound = true  -- Prevents sound spamming
}

function Player:load()
    self.hearts = 3  -- Reset hearts when loading
    self.gameOver = false

 -- Add this sound initialization
 self.clickSound = love.audio.newSource("Media/Sound/fart_quick.wav", "static")

    -- Existing anchor/character initialization remains the same --
    self.currentAmmo = self.maxAmmo  -- Reset ammo when loading
    self.bullets = {}                -- Clear existing bullets
    self.timeSinceLastShot = 0

    anchor = {
        x = love.graphics.getWidth() / 2,
        y = 70
    }

    rope_length = 200
    
    character = {
        x = anchor.x,
        y = anchor.y + rope_length,
        angle = 0,
        angular_velocity = 0,
        gravity = 200,  -- Increased gravity for faster movement 
        gunAngle = 0  -- Initialize gun angle
    }

    
end

function Player:update(dt)

    if self.gameOver then return end  -- Stop all updates when dead


    local angular_acceleration = -character.gravity / rope_length * math.sin(character.angle)
    character.angular_velocity = character.angular_velocity + angular_acceleration * dt * 2  -- Faster acceleration
    
    character.angular_velocity = character.angular_velocity * 0.97  -- Reduced damping
    
    character.angle = character.angle + character.angular_velocity * dt * 2  -- Faster angle change
    
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        character.angular_velocity = character.angular_velocity - 1 * dt
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        character.angular_velocity = character.angular_velocity + 1 * dt
    end
    
    character.x = anchor.x + rope_length * math.sin(character.angle)
    character.y = anchor.y + rope_length * math.cos(character.angle)


    -- the Ass Logic 
    -- Calculate gun angle
    local mouseX, mouseY = love.mouse.getPosition()
    local dx = mouseX - character.x
    local dy = mouseY - character.y
    character.gunAngle = math.atan2(dy, dx)

    -- Update bullets
    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        -- Move bullet in its direction (600 pixels per second)
        bullet.x = bullet.x + math.cos(bullet.angle) * 600 * dt
        bullet.y = bullet.y + math.sin(bullet.angle) * 600 * dt
        
        -- Remove bullets that go off-screen
        if bullet.x < 0 or bullet.x > love.graphics.getWidth() or
           bullet.y < 0 or bullet.y > love.graphics.getHeight() then
            table.remove(self.bullets, i)
        end
    end
    
    -- Update shooting cooldown
    self.timeSinceLastShot = self.timeSinceLastShot + dt
    
    -- Shooting logic
    if love.mouse.isDown(1) and self.currentAmmo > 0 and self.timeSinceLastShot >= self.fireCooldown then
        -- Create new bullet
        table.insert(self.bullets, {
            x = character.x,
            y = character.y,
            angle = character.gunAngle
        })
        
        self.currentAmmo = self.currentAmmo - 1
        self.timeSinceLastShot = 0  -- Reset cooldown timer
        
            -- Play shoot sound (optional)
        if self.shootSound then  -- Add this sound to your Player:load
            love.audio.stop(self.shootSound)
            love.audio.play(self.shootSound)
        end
    end
    
    -- Reload with R key
    if love.keyboard.isDown('r') then
        self.currentAmmo = self.maxAmmo
    end
end

function love.mousepressed(x, y, button, isTouch)
    if button == 1 then  -- Only handle left clicks
        love.audio.stop(sounds.click)
        
        -- Only play sound if player has ammo
        if Player.currentAmmo > 0 then
            love.audio.play(sounds.click)
        end
    end
end

----------------------------------------DRAW----------------------------------------------------

function Player:draw()

    -- love.graphics.setColor(150/255, 75/255, 0)
    love.graphics.line(anchor.x, anchor.y, character.x, character.y)
    
    -- love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', anchor.x, anchor.y, 5)
    
    -- love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', character.x - 25, character.y - 25, 50, 50)

    -- Draw gun
    local gunLength = 30
    -- love.graphics.setColor(1, 1, 0) -- Yellow color for the gun
    love.graphics.line(
        character.x, 
        character.y,
        character.x + math.cos(character.gunAngle) * gunLength,
        character.y + math.sin(character.gunAngle) * gunLength
    )

    -- Draw bullets (as small white circles)
    -- love.graphics.setColor(1, 1, 1)
    for _, bullet in ipairs(self.bullets) do
        love.graphics.circle('fill', bullet.x, bullet.y, 3)
    end
    
    -- Draw ammo counter
    -- love.graphics.setColor(1, 1, 1)
    love.graphics.print("Ammo: " .. self.currentAmmo .. "/" .. self.maxAmmo, 10, 10)
    
    -- Draw gun (yellow line)
    local gunLength = 30
    -- love.graphics.setColor(1, 1, 0)
    love.graphics.line(
        character.x, 
        character.y,
        character.x + math.cos(character.gunAngle) * gunLength,
        character.y + math.sin(character.gunAngle) * gunLength
        )

    
    -- Draw reload message (red text) and reset color
    if self.currentAmmo == 0 then
        love.graphics.setColor(1, 0, 0)  -- Red color
        local text = "PRESS R TO RELOAD"
        local font = love.graphics.getFont()
        local textWidth = font:getWidth(text)
        love.graphics.print(text, 
            (love.graphics.getWidth() - textWidth) / 2,
            love.graphics.getHeight() - 50)
        love.graphics.setColor(1, 1, 1)  -- Reset to white color
    end


   -- Draw hearts in top-right corner
   local heartSpacing = 40
   love.graphics.setColor(1, 0, 0)  -- Red color
   for i = 1, 3 do
       if i <= self.hearts then
           -- Draw filled heart (simple version using rectangles)
           love.graphics.rectangle('fill', 
               love.graphics.getWidth() - (i * heartSpacing), 
               10, 
               30,  -- Width
               30   -- Height
           )
       else
           -- Draw empty heart outline
           love.graphics.setColor(0.5, 0, 0)
           love.graphics.rectangle('line', 
               love.graphics.getWidth() - (i * heartSpacing), 
               10, 
               30, 
               30
           )
           love.graphics.setColor(1, 0, 0)
       end
   end
   love.graphics.setColor(1, 1, 1)  -- Reset color

   -- Draw game over screen
   if self.gameOver then
       love.graphics.setColor(1, 0, 0)
       local text = "GAME OVER"
       local font = love.graphics.newFont(40)
       local oldFont = love.graphics.getFont()
       love.graphics.setFont(font)
       local textWidth = font:getWidth(text)
       love.graphics.print(text, 
           (love.graphics.getWidth() - textWidth)/2, 
           love.graphics.getHeight()/2 - 50
       )
       love.graphics.setFont(oldFont)
       love.graphics.setColor(1, 1, 1)
   end



end