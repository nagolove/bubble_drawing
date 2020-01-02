local lg = love.graphics
local img

function love.filedropped(file)
    local ok, errmsg = pcall(function() img = lg.newImage(file) end)
end

function love.keypressed(_, k)
    if k == "escape" then
        love.event.quit()
    end
end

local _once = false

function love.draw()
    if img then
        local w, h = lg.getDimensions()
        -- нужно уместить изображение в окне те сжать его минимум по вертикали
        -- или горизонтали. Как выбрать по какой стороге сжимать?
        local imgw, imgh = img:getDimensions()
        local sx, sy = w / imgw, h / imgh
        local mins = math.min(sx, sy)
        if not _once then
            print("sx, sy", sx, sy)
            _once = true
        end
        lg.draw(img, 0, 0, 0, mins, mins)
    end
end
