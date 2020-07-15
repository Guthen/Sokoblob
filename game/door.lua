Doors = Container()
Doors.z_index = 0

function Doors:init()
    self.checked_buttons = 0
end

function Doors:create( x, y )
    local door = {}
    door.x = x
    door.y = y
    door.toggled = false

    Doors[#Doors + 1] = door
    return door
end

function Doors:triggerDoors()
    for i, v in ipairs( self ) do
        v.toggled = not v.toggled
    end
end

function Doors:check()
    self.checked_buttons = self.checked_buttons + 1

    if self.checked_buttons == 1 then
        self:triggerDoors()
    end
end

function Doors:uncheck()
    self.checked_buttons = self.checked_buttons - 1

    if self.checked_buttons == 0 then
        self:triggerDoors()
    end
end

function Doors:getClosedDoorAt( x, y )
    local door = self:getAt( x, y )
    return door and not door.toggled
end

local image, quads = love.graphics.newImage( "images/door.png" ), {}
for x = 0, image:getWidth() - tile_size, tile_size do
    quads[#quads + 1] = love.graphics.newQuad( x, 0, tile_size, tile_size, image:getDimensions() )
end

function Doors:draw()
    for i, v in ipairs( self ) do
        love.graphics.draw( image, quads[v.toggled and 2 or 1], v.x * object_size, v.y * object_size, 0, object_size / tile_size, object_size / tile_size )
    end
end