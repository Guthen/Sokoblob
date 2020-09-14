--  > Spring
Spring = class( Entity )
Spring.x, Spring.y = 0, 0
Spring.image = love.graphics.newImage( "images/spring.png" )
Spring.quads, Spring.quad = tileset( Spring.image ), 1
Spring.toggled = false
Spring.z_index = 0

function Spring:construct( x, y )
    Entity.construct( self )

    self.x = x
    self.y = y
end

function Spring:jump( ent, x, y )
    if not Map:checkCollision( self.x + x, self.y + y ) then return end

    timer( .25, function()
        --  > Move
        local jump_height = -3
        if not ( x == 0 ) then
            ent.x = ent.x + x * 2  
        elseif not ( y == 0 ) then
            ent.y = ent.y + y * 2
        end
        
        --  > Jump animation
        ent.y = ent.y + jump_height
        timer( .25, function() ent.y = ent.y - jump_height end )

        --  > Spring animation
        self.toggled = true
        timer( .5, function() 
            self.toggled = false 
            ent.blocked = false
        end )

        ent.blocked = true
    end )
end

function Spring:draw()
    Door.draw( self )
end

--  > Container
SpringsContainer = class( Container )

function SpringsContainer:create( x, y )
    local spring = Spring( x, y )

    self[#self + 1] = spring
    return spring
end