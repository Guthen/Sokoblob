Entity, Entities = class(), {}

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
function Entity:draw()
    love.graphics.rectangle( "fill", self.x * object_size, self.y * object_size, object_size, object_size )
end