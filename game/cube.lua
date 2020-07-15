Cubes = Container()
Cubes.z_index = 1

--  > Create cube
function Cubes:create( x, y )
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

        --  > Confirmed cube
        self.confirmed = Map:getTileAt( self.x, self.y ) == TILE_SPOT

        --  > Check next button
        if Map:getTileAt( self.x, self.y ) == TILE_BUTTON then
            Doors:check()
        end
    end
    
    Cubes[#Cubes + 1] = cube
    return cube
end

function Cubes:think( dt )
    for i, v in ipairs( self ) do
        v.anim_x = approach( v.anim_x, v.x, dt * 5 )
        v.anim_y = approach( v.anim_y, v.y, dt * 5 )
    end
end

local image = love.graphics.newImage( "images/box.png" )
function Cubes:draw()
    for i, v in ipairs( self ) do
        love.graphics.draw( image, v.anim_x * object_size, v.anim_y * object_size, 0, object_size / image:getWidth(), object_size / image:getHeight() )
    end
end

--[[ function Cubes:deleteAll()
    for i, v in ipairs( self ) do
        self[i] = nil
    end
end ]]

function Cubes:checkWin()
    if #self == 0 then return false end

    local confirmed_cubes = 0
    for i, v in ipairs( self ) do
        if v.confirmed then
            confirmed_cubes = confirmed_cubes + 1
        end
    end

    return confirmed_cubes >= Map.spots
end

--[[ function Cubes:getAt( x, y )
    for i, v in ipairs( Cubes ) do
        if v.x == x and v.y == y then return v end
    end
end ]]