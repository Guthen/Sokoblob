BaseCubes = class( Container )
BaseCubes.z_index = 1
BaseCubes.image = love.graphics.newImage( "images/box.png" )

--  > Create cube
function BaseCubes:create( x, y )
    local cube = {}
    cube.x = x
    cube.y = y
    cube.anim_x = x
    cube.anim_y = y

    function cube:move( x, y )
        --  > Uncheck last button
        if Map:getTileAt( self.x, self.y ) == TILE_BUTTON then
            Doors:uncheck()
        end

        --  > Move cube
        self.x = self.x + x
        self.y = self.y + y

        --  > Move sound
        Game:playSound( ( "box_move%02d.wav" ):format( math.random( 3 ) ) )

        --  > Confirmed cube
        self.confirmed = Map:getTileAt( self.x, self.y ) == TILE_SPOT

        --  > Check next button
        if Map:getTileAt( self.x, self.y ) == TILE_BUTTON then
            Doors:check()
        end
    end
    
    self[#self + 1] = cube
    return cube
end

function BaseCubes:think( dt )
    for i, v in ipairs( self ) do
        v.anim_x = approach( v.anim_x, v.x, dt * 5 )
        v.anim_y = approach( v.anim_y, v.y, dt * 5 )
    end
end

function BaseCubes:draw()
    for i, v in ipairs( self ) do
        love.graphics.draw( self.image, v.anim_x * object_size, v.anim_y * object_size, 0, object_size / self.image:getWidth(), object_size / self.image:getHeight() )
    end
end

function BaseCubes:checkWin()
    if #self == 0 then return false end

    local confirmed_cubes = 0
    for i, v in ipairs( self ) do
        if v.confirmed then
            confirmed_cubes = confirmed_cubes + 1
        end
    end

    return confirmed_cubes >= Map.spots
end