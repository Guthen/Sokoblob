--  > Crate
Crate = class( Entity )
Crate.x, Crate.y = 0, 0
Crate.anim_x, Crate.anim_y = 0, 0
Crate.confirmed = false
Crate.image = love.graphics.newImage( "images/box.png" )
Crate.z_index = 1

function Crate:construct( x, y )
    Entity.construct( self )

    self.x, self.anim_x = x, x
    self.y, self.anim_y = y, y
end

function Crate:move( x, y )
    --  > Uncheck last button
    if Map:getTileAt( self.x, self.y ) == TILE_BUTTON then
        Doors:uncheck()
    end

    --  > Move crate
    self.x = self.x + x
    self.y = self.y + y

    --  > Move sound
    Game:playSound( ( "box_move%02d.wav" ):format( math.random( 3 ) ) )

    --  > Confirmed crate
    self.confirmed = Map:getTileAt( self.x, self.y ) == TILE_SPOT

    --  > Check next button
    if Map:getTileAt( self.x, self.y ) == TILE_BUTTON then
        Doors:check()
    end
end

function Crate:think( dt )
    self.anim_x = approach( self.anim_x, self.x, dt * 5 )
    self.anim_y = approach( self.anim_y, self.y, dt * 5 )
end

function Crate:draw()
    love.graphics.draw( self.image, self.anim_x * object_size, self.anim_y * object_size, 0, object_size / self.image:getWidth(), object_size / self.image:getHeight() )
end

--  > Container
CratesContainer = class( Container )

function CratesContainer:create( x, y, type )
    local crate = ( type or Crate )( x, y )

    self[#self + 1] = crate
    return crate
end

function CratesContainer:checkWin()
    if #self == 0 then return false end

    local confirmed_Crates = 0
    for i, v in ipairs( self ) do
        if v.confirmed then
            confirmed_Crates = confirmed_Crates + 1
        end
    end

    return confirmed_Crates >= Map.spots
end