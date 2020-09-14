require( "utils/entity" )

Container = class( Entity )

function Container:create( x, y ) end
function Container:draw() end

function Container:deleteAll()
    for i, v in ipairs( self ) do
        self[i] = nil
    end
end

function Container:getAt( x, y )
    for i, v in ipairs( self ) do
        if v.x == x and v.y == y then return v end
    end
end