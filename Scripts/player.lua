Player = {}

function Player:load()
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
        gravity = 200  -- Increased gravity for faster movement
    }
end

function Player:update(dt)
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
end

function Player:draw()

    -- love.graphics.setColor(150/255, 75/255, 0)
    love.graphics.line(anchor.x, anchor.y, character.x, character.y)
    
    -- love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', anchor.x, anchor.y, 5)
    
    -- love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', character.x - 25, character.y - 25, 50, 50)
end