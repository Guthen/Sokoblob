BaseDoors = class( Container )
BaseDoors.z_index = 0

function BaseDoors:init()
    self.checked_buttons = 0
end

function BaseDoors:create( x, y )
    local door = {}
    door.x = x
    door.y = y
    door.toggled = false

    self[#self + 1] = door
    return door
end

function BaseDoors:triggerDoors()
    for i, v in ipairs( self ) do
        v.toggled = not v.toggled
    end

    Game:playSound( ( "door_switch%02d.wav" ):format( math.random( 3 ) ) )
end

function BaseDoors:check()
    self.checked_buttons = self.checked_buttons + 1

    if self.checked_buttons == 1 then
        self:triggerDoors()
    end
end

function BaseDoors:uncheck()
    self.checked_buttons = self.checked_buttons - 1

    if self.checked_buttons == 0 then
        self:triggerDoors()
    end
end

function BaseDoors:getClosedDoorAt( x, y )
    local door = self:getAt( x, y )
    return door and not door.toggled
end

BaseDoors.image, BaseDoors.quads = love.graphics.newImage( "images/door.png" ), {}
for x = 0, BaseDoors.image:getWidth() - tile_size, tile_size do
    BaseDoors.quads[#BaseDoors.quads + 1] = love.graphics.newQuad( x, 0, tile_size, tile_size, BaseDoors.image:getDimensions() )
end

function BaseDoors:draw()
    for i, v in ipairs( self ) do
        love.graphics.draw( self.image, self.quads[v.toggled and 2 or 1], v.x * object_size, v.y * object_size, 0, object_size / tile_size, object_size / tile_size )
    end
end