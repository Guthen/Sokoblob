Player = Entity()
Player.image = love.graphics.newImage( "images/blob.png" )
Player.z_index = 1

--  > Create animations quads
local quads = {}
for x = 0, Player.image:getWidth() - tile_size, tile_size do
    quads[#quads + 1] = love.graphics.newQuad( x, 0, tile_size, tile_size, Player.image:getDimensions() )
end
Player.quads = quads
Player.current_quad = 1

--  > Init player
function Player:init()
    Player.moves = 0
    Player.anim_x = Player.x
    Player.anim_y = Player.y
end

local time, next_frame_time = 0, .5
function Player:think( dt )
    --  > Animation
    time = time + dt
    if time > next_frame_time then
        time = 0
        self.current_quad = self.current_quad + 1 > #self.quads and 1 or self.current_quad + 1
    end

    --  > Movement animation
    self.anim_x = approach( self.anim_x, self.x, dt * 5 )
    self.anim_y = approach( self.anim_y, self.y, dt * 5 )
end

--  > Movement
function Player:move( x, y )
    if not Map:checkCollision( self.x + x, self.y + y ) then
        local cube = Cubes:getAt( self.x + x, self.y + y )
        if cube then
            --  > Collision with cubes 
            if Map:checkCollision( cube.x + x, cube.y + y ) or Cubes:getAt( cube.x + x, cube.y + y ) then return end

            --  > Collision with closed doors
            if Doors:getClosedDoorAt( cube.x + x, cube.y + y ) then return end

            --  > Move cube
            cube:move( x, y )
        end

        if Doors:getClosedDoorAt( self.x + x, self.y + y ) then return end

        self.x = self.x + x
        self.y = self.y + y
        self.moves = self.moves + 1
    end
end

--  > Get direction from key
local directions = {
    ["z"] = {
        x = 0,
        y = -1,
    },
    ["s"] = {
        x = 0,
        y = 1,
    },
    ["q"] = {
        x = -1,
        y = 0,
    },
    ["d"] = {
        x = 1,
        y = 0,
    },
}
function Player:keypress( key )
    local dir = directions[key]
    if not dir then return end

    self:move( dir.x, dir.y )
end

function Player:draw()
    love.graphics.draw( self.image, self.quads[self.current_quad], self.anim_x * object_size, self.anim_y * object_size, 0, object_size / tile_size, object_size / tile_size )

    local limit = 400
    love.graphics.push()
    love.graphics.origin()

    --  > Moves
    love.graphics.printf( self.moves .. " moves", love.graphics.getWidth() / 2 - limit / 2, 60, limit, "center" )
    --  > Keys
    love.graphics.printf( "Move with 'Z', 'Q', 'S', 'D'\nRetry with 'R'", 20, love.graphics.getHeight() - 45, limit )
    
    love.graphics.pop()
end