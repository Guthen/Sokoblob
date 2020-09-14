--  > Door
Door = class( Entity )
Door.x, Door.y = 0, 0
Door.toggled = false
Door.image = love.graphics.newImage( "images/door.png" )
Door.quads = tileset( Door.image )
Door.z_index = 0

function Door:construct( x, y )
    Entity.construct( self )

    self.x = x
    self.y = y
end

function Door:draw()
    love.graphics.draw( self.image, self.quads[self.toggled and 2 or 1], self.x * object_size, self.y * object_size, 0, object_size / tile_size, object_size / tile_size )
end

--  > Container
DoorsContainer = class( Container )

function DoorsContainer:init()
    self.checked_buttons = 0
end

function DoorsContainer:create( x, y )
    local door = Door( x, y )

    self[#self + 1] = door
    return door
end

function DoorsContainer:triggerDoors()
    for i, v in ipairs( self ) do
        v.toggled = not v.toggled
    end

    Game:playSound( ( "door_switch%02d.wav" ):format( math.random( 3 ) ) )
end

function DoorsContainer:check()
    self.checked_buttons = self.checked_buttons + 1

    if self.checked_buttons == 1 then
        self:triggerDoors()
    end
end

function DoorsContainer:uncheck()
    self.checked_buttons = self.checked_buttons - 1

    if self.checked_buttons == 0 then
        self:triggerDoors()
    end
end

function DoorsContainer:getClosedDoorAt( x, y )
    local door = self:getAt( x, y )
    return door and not door.toggled
end