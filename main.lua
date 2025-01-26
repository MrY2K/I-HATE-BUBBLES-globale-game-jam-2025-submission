-- main.lua
----------------------------------------GLOBAL VARS----------------------------------------------------
game_state = "menu" -- Game state

-- Declare muteButton globally
muteButton = {
  x = 660,  -- Adjusted for 720 width window
  y = 20,
  size = 40,
  hover = false,
  muted = false
}

----------------------------------------REQUIRES----------------------------------------------------
--Libreries and Scripts
require "Scripts.Load_Media"
require "Scripts.menu"
require "Scripts.player"
require "Scripts.bubbles"
require "Scripts.settings"
lume = require "Scripts.lume" --https://github.com/rxi/lume --Extra usful functions

----------------------------------------LOAD----------------------------------------------------
function love.load(arg)
  -- Set fixed window size
  love.window.setMode(720, 950, {resizable = false}) -- Fixed window size
  love.mouse.setVisible(false) -- Hide default cursor

  -- Load media
  sounds, cursor_s = load_media()

  Menu:load()
  Player:load()
  Bubbles:load()

  -- Initialize audio
  sounds = {
      background = love.audio.newSource("Media/Music/music.mp3", "stream"),
      click = love.audio.newSource("Media/Sound/fart_quick.wav", "static")
  }
  
  -- Configure background music
  sounds.background:setLooping(true)
  sounds.background:setVolume(0.3)  -- 30% volume
  love.audio.play(sounds.background)

  -- Update mute button position
  muteButton.x = love.graphics.getWidth() - muteButton.size - 20
end

----------------------------------------UPDATE----------------------------------------------------
function love.update(dt)
  -- Only update based on game state
  if game_state == "menu" then
    Menu:update(dt)
  elseif game_state == "settings" then
    Settings:update(dt)
  elseif game_state == "game" then
    -- Get mouse position
    local mx, my = love.mouse.getPosition()
    
    -- Check mute button hover state
    muteButton.hover = (mx > muteButton.x and mx < muteButton.x + muteButton.size) and
                          (my > muteButton.y and my < muteButton.y + muteButton.size)

    --Coor of cursor
    cursor_x, cursor_y = love.mouse.getPosition()

    --Games update here
    Player:update(dt)
    Bubbles:update(dt)
  end
end

function love.keypressed(key, scancode, isrepeat)
  -- Add any key press handling specific to game state
end

function love.mousepressed(x, y, button, isTouch)
  if game_state == "menu" then
    if game_state == "settings" then
        Settings:mousepressed(x, y, button)
    end
    -- Handle menu interactions
    local menuInteraction = Menu:mousepressed(x, y, button)
    if menuInteraction then
      -- If a menu button was pressed, update game state
      game_state = Menu.state
    end
  elseif game_state == "game" then
    if button == 1 then  -- Only handle left clicks
      love.audio.stop(sounds.click)
      -- Only play sound if player has ammo
      if Player.currentAmmo > 0 then
          love.audio.play(sounds.click)
      end
    end

    -- Check mute button click
    if button == 1 and muteButton.hover then
      muteButton.muted = not muteButton.muted
      if muteButton.muted then
          love.audio.pause(sounds.background)
      else
          love.audio.play(sounds.background)
      end
    end
  end
end

----------------------------------------DRAW----------------------------------------------------
function love.draw()
  if game_state == "menu" then
    Menu:draw()
elseif game_state == "settings" then
    Settings:draw()
    love.graphics.draw(cursor_s, love.mouse.getX(), love.mouse.getY())

  elseif game_state == "game" then
    Player:draw()
    Bubbles:draw()

    --Draw Cursur
    love.graphics.draw(cursor_s, cursor_x, cursor_y)

    love.graphics.setColor(0.2, 0.2, 0.2, 0.7)  -- Dark gray with transparency
    love.graphics.circle('fill', muteButton.x + muteButton.size/2, 
                        muteButton.y + muteButton.size/2, 
                        muteButton.size/2)
    
    -- Draw speaker icon
    love.graphics.setColor(1, 1, 1)
    if muteButton.muted then
        -- Muted icon (speaker with X)
        love.graphics.line(
            muteButton.x + 15, muteButton.y + 15,
            muteButton.x + 25, muteButton.y + 25
        )
        love.graphics.line(
            muteButton.x + 25, muteButton.y + 15,
            muteButton.x + 15, muteButton.y + 25
        )
    else
        -- Speaker icon
        love.graphics.polygon('fill',
            muteButton.x + 15, muteButton.y + 15,
            muteButton.x + 30, muteButton.y + 15,
            muteButton.x + 30, muteButton.y + 30,
            muteButton.x + 15, muteButton.y + 30
        )
        love.graphics.line(
            muteButton.x + 30, muteButton.y + 20,
            muteButton.x + 35, muteButton.y + 15
        )
        love.graphics.line(
            muteButton.x + 35, muteButton.y + 15,
            muteButton.x + 35, muteButton.y + 30
        )
    end
    
    -- Hover effect
    if muteButton.hover then
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.circle('fill', muteButton.x + muteButton.size/2, 
                            muteButton.y + muteButton.size/2, 
                            muteButton.size/2)
    end
  end
end