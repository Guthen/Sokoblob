Scene, Scenes = class(), {}

function Scene:construct()
    Scenes[#Scenes + 1] = self
end

function Scene:load()
end

function Scene:update( dt )
end

function Scene:keypressed( key )
end

function Scene:mousepressed( x, y, mouse_button )
end

function Scene:draw()
end

function Scene:drawTitle( text )
    local w, h = love.graphics.getDimensions()

    local limit, scale = w * .5, 2
    love.graphics.printf( text, w / 2 - limit * scale / 2, h * .045, limit, "center", 0, scale, scale )
end