-- main.lua
----------------------------------------GLOBAL VARS----------------------------------------------------

----------------------------------------REQUIRES----------------------------------------------------
--Libreries and Scripts
require "Scripts.Load_Media"
require "Scripts.Menue"
-- require "Scripts.Menue"
lume = require "Scripts.lume" --https://github.com/rxi/lume --Extra usful functions


----------------------------------------LOAD----------------------------------------------------
function love.load(arg)
  
  -- Set fixed window size
  love.window.setMode(720, 950, {resizable = false}) -- Fixed window size
  love.mouse.setVisible(false) -- Hide default cursor

  -- Load media
  sounds, cursor_s = load_media()

  Menu:load()
end

----------------------------------------UPDATE----------------------------------------------------
function love.update(dt)

  --Coor of cursor
  cursor_x, cursor_y = love.mouse.getPosition()

  --Games update here
  Menu:update(dt)
end

function love.keypressed(key, scancode, isrepeat)
  
end

function love.mousepressed(x, y, button, isTouch)
  love.audio.stop(sounds.click)
  love.audio.play(sounds.click)
end


----------------------------------------DRAW----------------------------------------------------

function love.draw()

  Menu:draw()
  love.graphics.draw(cursor_s, cursor_x, cursor_y)

end
