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

--  > Ball
Ball = class( Crate )
Ball.image = love.graphics.newImage( "images/ball.png" )
Ball.quads = tileset( Ball.image )
Ball.quad = 1
Ball.anim_time, Ball.fps = 0, 5

function Ball:think( dt )
    Crate.think( self, dt )

    if not ( self.x == self.anim_x ) or not ( self.y == self.anim_y ) then
        self.anim_time = self.anim_time + dt
        if self.anim_time >= 1 / self.fps then
            self.quad = self.quad + 1 > #self.quads and 1 or self.quad + 1
            self.anim_time = 0
        end
    end
end

function Ball:move( x, y )
    local w, h = Map.w / object_size, Map.h / object_size

    local new_pos = 0
    if not ( x == 0 ) then
        for i = self.x, x > 0 and w or 1, x > 0 and 1 or -1 do
            if Map:checkCollision( i, self.y ) then
                break
            else
                new_pos = i
            end
        end

        self.x = new_pos
    elseif not ( y == 0 ) then
        for i = self.y, y > 0 and h or 1, y > 0 and 1 or -1 do
            if Map:checkCollision( self.x, i ) then
                break
            else
                new_pos = i
            end
        end

        self.y = new_pos
    end
end

function Ball:draw()
    love.graphics.draw( self.image, self.quads[self.quad], self.anim_x * object_size, self.anim_y * object_size, 0, object_size / tile_size, object_size / tile_size )
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