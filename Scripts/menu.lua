Menu = {}
function Menu:load()
    background = love.graphics.newImage("Media/Image/menu_back.png")  -- Replace with your image path
    -- Load background image
    
    -- Store original image dimensions
    bg_width = background:getWidth()
    bg_height = background:getHeight()
    
    -- Calculate scaling factors
    scale_x = love.graphics.getWidth() / bg_width
    scale_y = love.graphics.getHeight() / bg_height
    
    -- Choose the scaling factor that fills the entire window
    scale = math.max(scale_x, scale_y)
end

function Menu:draw()
    -- Draw background image scaled to fill window
    love.graphics.draw(background, 
        0, 0,  -- Position at top-left corner
        0,     -- No rotation
        scale, scale)  -- Scale to fill window
end
return Menu