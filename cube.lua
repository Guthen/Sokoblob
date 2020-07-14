Cubes = Entity( {
    image = love.graphics.newImage( "images/box.png" )
} )

--  > Create cube
function Cubes:create( x, y )
    local cube = {}
    cube.x = x
    cube.y = y
    cube.anim_x = x
    cube.anim_y = y

    function cube:move( x, y )
        self.x = self.x + x
        self.y = self.y + y

        self.confirmed = Map:getTile( self.x, self.y ) == 2
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

function Cubes:draw()
    for i, v in ipairs( self ) do
        love.graphics.draw( self.image, v.anim_x * object_size, v.anim_y * object_size, 0, object_size / self.image:getWidth(), object_size / self.image:getHeight() )
    end
end

function Cubes:deleteAll()
    for i, v in ipairs( self ) do
        self[i] = nil
    end
end

function Cubes:checkWin()
    if #self == 0 then return false end

    for i, v in ipairs( self ) do
        if not v.confirmed then return false end
    end

    return true
end

function Cubes:getAtPosition( x, y )
    for i, v in ipairs( Cubes ) do
        if v.x == x and v.y == y then return v end
    end
end