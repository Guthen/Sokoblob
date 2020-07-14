Player = Entity()
Player.image = love.graphics.newImage( "images/blob.png" )

--  > Create animations quads
local quads, tile_size = {}, 16
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
function Player:keypress( key )
    if key == "z" and not Map:checkCollision( self.x, self.y - 1 ) then
        local cube = Cubes:getAtPosition( self.x, self.y - 1 )
        if cube then
            --  > Collision with cubes
            if Map:checkCollision( cube.x, cube.y - 1 ) or Cubes:getAtPosition( cube.x, cube.y - 1 ) then
                return
            end

            --  > Move cube
            cube:move( 0, -1 )
        end

        self.y = self.y - 1
        self.moves = self.moves + 1
    elseif key == "s" and not Map:checkCollision( self.x, self.y + 1 ) then
        local cube = Cubes:getAtPosition( self.x, self.y + 1 )
        if cube then
            --  > Collision with cubes
            if Map:checkCollision( cube.x, cube.y + 1 ) or Cubes:getAtPosition( cube.x, cube.y + 1 )  then
                return
            end

            --  > Move cube
            cube:move( 0, 1 )
        end

        self.y = self.y + 1
        self.moves = self.moves + 1
    elseif key == "q" and not Map:checkCollision( self.x - 1, self.y ) then
        local cube = Cubes:getAtPosition( self.x - 1, self.y )
        if cube then
            --  > Collision with cubes
            if Map:checkCollision( cube.x - 1, cube.y ) or Cubes:getAtPosition( cube.x - 1, cube.y ) then
                return
            end

            --  > Move cube
            cube:move( -1, 0 )
        end

        self.x = self.x - 1
        self.moves = self.moves + 1
    elseif key == "d" and not Map:checkCollision( self.x + 1, self.y ) then
        local cube = Cubes:getAtPosition( self.x + 1, self.y )
        if cube then
            --  > Collision with cubes
            if Map:checkCollision( cube.x + 1, cube.y ) or Cubes:getAtPosition( cube.x + 1, cube.y ) then
                return
            end

            --  > Move cube
            cube:move( 1, 0 )
        end

        self.x = self.x + 1
        self.moves = self.moves + 1
    end
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