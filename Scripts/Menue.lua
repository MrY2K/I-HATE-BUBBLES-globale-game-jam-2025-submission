Menu = {}

----------------------------------------VARS----------------------------------------------------

----------------------------------------LOAD----------------------------------------------------

function Menu:load()

	-- love.graphics.setFont(font)
    self.title = "JUMPING MAN" -- Title of the menu
    self.buttons = {
        -- Start button
        {
            text = "Start", 
            x = 200, 
            y = 300, 
            width = 150, 
            height = 50, 
            action = function() 
                gameState = "playing" -- Switch to the game
            end
        },
        -- Quit button
        {
            text = "Quit", 
            x = 200, 
            y = 400, 
            width = 150, 
            height = 50, 
            action = function() 
                love.event.quit() -- Quit the game
            end
        },
    }
    self.font = love.graphics.newFont(24) -- Set font size for buttons
end

---------------------------------------UPDATE----------------------------------------------------
function Menu:update(dt)
    -- Handle button hover/click
    local mx, my = love.mouse.getPosition()

    for _, button in ipairs(self.buttons) do
        button.isHovered = mx > button.x and mx < button.x + button.width and
                           my > button.y and my < button.y + button.height
    end
end

function Menu:mousepressed(x, y, button)
    if button == 1 then -- Left mouse button
        for _, btn in ipairs(self.buttons) do
            if btn.isHovered and btn.action then
                btn.action() -- Trigger the button's action
            end
        end
    end
end

---------------------------------------DRAW----------------------------------------------------

function Menu:draw()
    -- Draw the title
    -- love.graphics.setFont(player_font)
    love.graphics.printf(self.title, 0, 100, love.graphics.getWidth(), "center")

    -- Draw buttons
    for _, button in ipairs(self.buttons) do
        if button.isHovered then
            love.graphics.setColor(0.7, 0.7, 0.7) -- Highlight hovered button
        else
            love.graphics.setColor(1, 1, 1) -- Normal button color
        end
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)

        -- Draw button text
        love.graphics.setColor(0, 0, 0) -- Text color
        love.graphics.printf(button.text, button.x, button.y + button.height / 6, button.width, "center")
    end

    love.graphics.setColor(1, 1, 1) -- Reset color
    -- Draw instructions
    local instructions = ">Use LEFT and RIGHT arrow keys to move.\n>Press 'R' to restart when playing.\n>you can pass throw the edges"
    love.graphics.printf(instructions, 0, 700, love.graphics.getWidth(), "center")


end

return Menu
