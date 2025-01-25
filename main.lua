-- main.lua
----------------------------------------GLOBAL VARS----------------------------------------------------
game_state = "menu" -- Game state

local muteButton = {
  x = love.graphics.getWidth() - 60,  -- 20px from right edge
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

end

----------------------------------------UPDATE----------------------------------------------------
function love.update(dt)


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

function love.keypressed(key, scancode, isrepeat)
  
end



function love.mousepressed(x, y, button, isTouch)
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
----------------------------------------DRAW----------------------------------------------------

function love.draw()

  Menu:draw()
  Player:draw()
  
  --Bubles
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
