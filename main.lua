local lg = love.graphics
local lb = require "kons".new()
local img
local canvas

local screenMode = "win" -- or "fs"

function randomRange(min, max)
    return min + (max - min) * math.random()
end

function love.filedropped(file)
    local imgData
    local ok, errmsg = pcall(function() 
        imgData = love.image.newImageData(file) 
    end)
    if ok then
        local imgw, imgh = imgData:getDimensions()
        canvas = lg.newCanvas(imgw, imgh)
        if not canvas then
            lb:push(3, "Could'not create Canvas")
        end
        lg.setCanvas(canvas)
        --lg.line(0, 0, imgw, imgh)
        imgData:mapPixel(function(x, y, r, g, b, a)
            lg.setColor{r, g, b, 0.5}
            --lg.circle("fill", x + randomRange(1, 4), y + randomRange(1, 4), 10)
            if r + g + b > 1.2 then
                lg.circle("line", x, y, 10)
            end
            return r, g, b, a
            --return r, g * math.cos(x), b * math.sin(y), a
        end, 0, 0, imgData:getWidth(), imgData:getHeight())
        lg.setCanvas()
        lg.setColor{1, 1, 1}
        img = lg.newImage(imgData)
    else
        lb:push(3, errmsg)
    end
end

local drawMode = false
local _once = false

function love.keypressed(_, k)
    if k == "escape" then
        love.event.quit()
    elseif k == "1" then
        drawMode = not drawMode
    end
    if love.keyboard.isDown("ralt", "lalt") and k == "return" then
        -- код дерьмовый, но работает
        if screenMode == "fs" then
            love.window.setMode(800, 600, {fullscreen = false})
            screenMode = "win"
            dispatchWindowResize(love.graphics.getDimensions())
        else
            love.window.setMode(0, 0, {fullscreen = true,
            fullscreentype = "exclusive"})
            screenMode = "fs"
            --dispatchWindowResize(love.graphics.getDimensions())
        end
    end
    if key == "f12" then make_screenshot()
    else
        --menu:keypressed(key, scancode)
    end
end

function love.draw()
    if img then
        local w, h = lg.getDimensions()
        if not drawMode then
            local imgw, imgh = img:getDimensions()
            local sx, sy = w / imgw, h / imgh
            local mins = math.min(sx, sy)

            lg.draw(img, 0, 0, 0, mins, mins)

            lb:pushi("img")
        else
            local canvasw, canvash = canvas:getDimensions()
            local sx, sy = w / canvasw, h / canvash
            local mins = math.min(sx, sy)

            lg.draw(canvas, 0, 0, 0, mins, mins)

            lb:pushi("canvas")
        end
    end
    lb:pushi("Swith drawing mode by presssing '1' key.")
    lb:draw()
end

function love.update(dt)
    lb:update(dt)
end
