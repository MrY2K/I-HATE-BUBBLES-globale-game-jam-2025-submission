function load_media()
  local Sounds={}
  -- Sounds.colision = love.audio.newSource("Media/Sound/02.wav", "static")
  Sounds.click = love.audio.newSource("Media/Sound/fart_quick.wav", "static")
  local cursor_s = love.graphics.newImage("Media/Image/cursor.png")



  return Sounds, cursor_s
end
