Settings = {
    isMusicMuted = false,
    isSoundEffectsMuted = false,
    cursor_x = 0,
    cursor_y = 0,
    cursor_s = nil  -- Add cursor image storage
}

function Settings:load()
    -- Load the cursor image
    _, self.cursor_s = load_media()
end

function Settings:update(dt)
    -- Get mouse position
    local mx, my = love.mouse.getPosition()
    self.cursor_x, self.cursor_y = mx, my
end

function Settings:draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Background
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle('fill', 0, 0, screenWidth, screenHeight)

    -- Title
    love.graphics.setColor(1, 1, 1)
    local font = love.graphics.newFont(30)
    love.graphics.setFont(font)
    love.graphics.printf("SETTINGS", 0, screenHeight/4, screenWidth, 'center')

    -- Music Button
    love.graphics.setColor(0.7, 0.7, 0.7)
    local musicButtonWidth, musicButtonHeight = 200, 50
    local musicButtonX = screenWidth/2 - musicButtonWidth/2
    local musicButtonY = screenHeight/2
    love.graphics.rectangle('fill', musicButtonX, musicButtonY, musicButtonWidth, musicButtonHeight)
    
    love.graphics.setColor(0, 0, 0)
    local musicText = "MUSIC: " .. (self.isMusicMuted and "OFF" or "ON")
    love.graphics.printf(musicText, musicButtonX, musicButtonY + musicButtonHeight/3, musicButtonWidth, 'center')

    -- Sound Effects Button
    love.graphics.setColor(0.7, 0.7, 0.7)
    local sfxButtonY = musicButtonY + musicButtonHeight + 20
    love.graphics.rectangle('fill', musicButtonX, sfxButtonY, musicButtonWidth, musicButtonHeight)
    
    love.graphics.setColor(0, 0, 0)
    local sfxText = "SOUND EFFECTS: " .. (self.isSoundEffectsMuted and "OFF" or "ON")
    love.graphics.printf(sfxText, musicButtonX, sfxButtonY + musicButtonHeight/3, musicButtonWidth, 'center')

    -- Back Button
    love.graphics.setColor(0.7, 0.7, 0.7)
    local backButtonY = sfxButtonY + musicButtonHeight + 20
    love.graphics.rectangle('fill', musicButtonX, backButtonY, musicButtonWidth, musicButtonHeight)
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("BACK", musicButtonX, backButtonY + musicButtonHeight/3, musicButtonWidth, 'center')

    -- Draw cursor
    if self.cursor_s then
        love.graphics.draw(self.cursor_s, self.cursor_x, self.cursor_y)
    end

    -- Reset color
    love.graphics.setColor(1, 1, 1)
end

function Settings:mousepressed(x, y, button)
    if button ~= 1 then return end

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    
    local buttonWidth, buttonHeight = 200, 50
    local buttonX = screenWidth/2 - buttonWidth/2

    -- Music Button
    local musicButtonY = screenHeight/2
    if x >= buttonX and x <= buttonX + buttonWidth and 
       y >= musicButtonY and y <= musicButtonY + buttonHeight then
        self.isMusicMuted = not self.isMusicMuted
        if sounds and sounds.background then
            if self.isMusicMuted then
                love.audio.pause(sounds.background)
            else
                love.audio.play(sounds.background)
            end
        end
        return true
    end

    -- Sound Effects Button
    local sfxButtonY = musicButtonY + buttonHeight + 20
    if x >= buttonX and x <= buttonX + buttonWidth and 
       y >= sfxButtonY and y <= sfxButtonY + buttonHeight then
        self.isSoundEffectsMuted = not self.isSoundEffectsMuted
        return true
    end

    -- Back Button
    local backButtonY = sfxButtonY + buttonHeight + 20
    if x >= buttonX and x <= buttonX + buttonWidth and 
       y >= backButtonY and y <= backButtonY + buttonHeight then
        game_state = "menu"
        return true
    end

    return false
end

return Settings