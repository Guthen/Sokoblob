Entity, Entities = class(), {}

--  > Entities
function Entities:call( key, ... )
    for i, v in ipairs( self ) do
        v[key]( v, ... )
    end
end

--  > Sort entities by Z-Index
function Entities:sort()
    table.sort( self, function( a, b )
        return a.z_index < b.z_index
    end )
end

--  > Destroy each entity
function Entities:clear()
    for i, v in ipairs( self ) do
        self[i] = nil
    end
end

--  > Entity
function Entity:construct( tbl )
    if not tbl then
        self.x = 0
        self.y = 0
        self.color = { 1, 1, 1 }
    end
    self.z_index = 0

    Entities[#Entities + 1] = self
end

function Entity:init() end
function Entity:think( dt ) end
function Entity:keypress( key ) end
function Entity:mousepress( x, y, mouse_button ) end
function Entity:draw()
    love.graphics.rectangle( "fill", self.x * object_size, self.y * object_size, object_size, object_size )
end