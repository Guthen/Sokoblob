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

function Scene:wheelmoved( x, y )
end

function Scene:draw( w, h )
end

function Scene:drawTitle( text )
    local w, h = love.graphics.getDimensions()

    local limit, scale = w * .5, 2
    love.graphics.printf( text, w / 2 - limit * scale / 2, h * .045, limit, "center", 0, scale, scale )
end

function Scene:drawCredits()
    love.graphics.setColor( 1, 1, 1 )

    local x, y = ui_offset, love.graphics.getHeight() - Game.Font:getHeight() / 2 - ui_offset
    love.graphics.print( "v" .. Game.Version, x, y )

    local limit = love.graphics.getWidth() * .5
    love.graphics.printf( Game.Author, love.graphics.getWidth() - limit - ui_offset, y, limit, "right" )
end