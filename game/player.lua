BasePlayer = class( Entity )
BasePlayer.image = love.graphics.newImage( "images/blob.png" )
BasePlayer.z_index = 1

--  > Create animations quads
local quads = {}
for x = 0, BasePlayer.image:getWidth() - tile_size, tile_size do
    quads[#quads + 1] = love.graphics.newQuad( x, 0, tile_size, tile_size, BasePlayer.image:getDimensions() )
end
BasePlayer.quads = quads
BasePlayer.current_quad = 1

--  > Init player
function BasePlayer:init()
    self.moves = 0
    self.anim_x = self.x
    self.anim_y = self.y

    if love.system.getOS() == "Android" then
        InputButton( button_size + 25, love.graphics.getHeight() - button_size * 2 - 25, "z", 2 )
        InputButton( 20, love.graphics.getHeight() - button_size - 20, "q", 3 )
        InputButton( button_size + 25, love.graphics.getHeight() - button_size - 20, "s", 4 )
        InputButton( button_size * 2 + 30, love.graphics.getHeight() - button_size - 20, "d", 1 )
    end
end

local time, next_frame_time = 0, .5
function BasePlayer:think( dt )
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
function BasePlayer:move( x, y )
    --  > Tile collision
    if not Map:checkCollision( self.x + x, self.y + y ) then
        --  > Moving cube
        local cube = Cubes:getAt( self.x + x, self.y + y )
        if cube then
            --  > Collision with cubes 
            if Map:checkCollision( cube.x + x, cube.y + y ) or Cubes:getAt( cube.x + x, cube.y + y ) then return end

            --  > Collision with closed doors
            if Doors:getClosedDoorAt( cube.x + x, cube.y + y ) then return end

            --  > Move cube
            cube:move( x, y )
        end

        --  > Collision with closed doors
        if Doors:getClosedDoorAt( self.x + x, self.y + y ) then return end

        --  > Movement
        self.x = self.x + x
        self.y = self.y + y

        --  > Score
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
function BasePlayer:keypress( key )
    local dir = directions[key]
    if not dir then return end

    self:move( dir.x, dir.y )
end

function BasePlayer:draw()
    love.graphics.draw( self.image, self.quads[self.current_quad], self.anim_x * object_size, self.anim_y * object_size, 0, object_size / tile_size, object_size / tile_size )

    local limit = 400
    love.graphics.push()
    love.graphics.origin()

    --  > Moves
    love.graphics.printf( self.moves .. " moves", love.graphics.getWidth() / 2 - limit / 2, 20, limit, "center" )
    --  > Keys
    if love.system.getOS() ~= "Android" then
        love.graphics.printf( "Move with 'Z', 'Q', 'S', 'D'\nRetry with 'R'\nGo to menu with 'Escape'", 20, love.graphics.getHeight() - 65, limit )
    end
    
    love.graphics.pop()
end