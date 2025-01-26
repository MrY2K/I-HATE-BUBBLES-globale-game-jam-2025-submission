Menu = {
    state = "main",
    buttons = {},
    cursor_s = nil,
    cursor_x = 0,
    cursor_y = 0,
    isMuted = false
}

function Menu:load()
    -- Load background and name images
    background = love.graphics.newImage("Media/Image/menu_back.png")
    name = love.graphics.newImage("Media/Image/name.png")
    
    -- Calculate screen dimensions and scaling
    nw = love.graphics.getWidth(name)
    nh = love.graphics.getHeight(name)
    bg_width = background:getWidth()
    bg_height = background:getHeight()
    
    scale_x = love.graphics.getWidth() / bg_width
    scale_y = love.graphics.getHeight() / bg_height
    scale = math.max(scale_x, scale_y)
    
    -- Initialize buttons
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    
    self.buttons = {
        main = {
            {
                text = "PLAY", 
                x = screenWidth/2 - 100, 
                y = screenHeight/2, 
                width = 200, 
                height = 50,
                action = function() 
                    -- Transition to game state
                    return "game" 
                end
            },
            {
                text = "SETTINGS", 
                x = screenWidth/2 - 100, 
                y = screenHeight/2 + 70, 
                width = 200, 
                height = 50,
                action = function() 
                    return "settings" 
                end
            },
            {
                text = "QUIT", 
                x = screenWidth/2 - 100, 
                y = screenHeight/2 + 140, 
                width = 200, 
                height = 50,
                action = function() 
                    love.event.quit() 
                end
            }
        },
        settings = {
            {
                text = "SOUND", 
                x = screenWidth/2 - 100, 
                y = screenHeight/2, 
                width = 200, 
                height = 50,
                action = function(self) 
                    self.isMuted = not self.isMuted
                    -- Add logic to mute/unmute game sounds
                    return "settings" 
                end
            },
            {
                text = "BACK", 
                x = screenWidth/2 - 100, 
                y = screenHeight/2 + 70, 
                width = 200, 
                height = 50,
                action = function() 
                    return "main" 
                end
            }
        }
    }
    
    -- Load cursor image
    _, self.cursor_s = load_media()
end

function Menu:update(dt)
    -- Get mouse position
    local mx, my = love.mouse.getPosition()
    self.cursor_x, self.cursor_y = mx, my
end

function Menu:draw()
    -- Draw background image scaled to fill window
    love.graphics.draw(background, 0, 0, 0, scale, scale)
    
    -- Draw game name
    love.graphics.draw(name, bg_width/2 - (nw/5), bg_height/5)
    
    -- Draw current menu buttons
    local currentButtons = self.buttons[self.state]
    for _, button in ipairs(currentButtons) do
        -- Draw button background
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.rectangle('fill', button.x, button.y, button.width, button.height)
        
        -- Draw button outline
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('line', button.x, button.y, button.width, button.height)
        
        -- Draw button text
        love.graphics.printf(button.text, button.x, button.y + button.height/3, button.width, 'center')
    end
    
    -- Reset color
    love.graphics.setColor(1, 1, 1)
    
    -- Draw cursor
    if self.cursor_s then
        love.graphics.draw(self.cursor_s, self.cursor_x, self.cursor_y)
    end
end

function Menu:mousepressed(x, y, button)
    if button ~= 1 then return end  -- Only handle left mouse button
    
    local currentButtons = self.buttons[self.state]
    for _, btn in ipairs(currentButtons) do
        if x >= btn.x and x <= btn.x + btn.width and 
           y >= btn.y and y <= btn.y + btn.height then
            local newState = btn.action(self)
            if newState then
                self.state = newState
            end
            return true
        end
    end
    return false
end

return Menu