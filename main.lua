--  > Entity class
object_size = 64
map_id = 1
local entities = {}

Entity = {}
setmetatable( Entity, {
    __call = function( self, constructor )
        local ent = setmetatable( constructor or {
            x = 0,
            y = 0,
            w = object_size,
            h = object_size,
            color = { 1, 1, 1 }
        }, {
            __index = self
        } )

        entities[#entities + 1] = ent
        return ent
    end,
} )

function Entity:init() end
function Entity:think( dt ) end
function Entity:keypress( key ) end
function Entity:draw()
    love.graphics.rectangle( "fill", self.x * self.w, self.y * self.w, self.w, self.h )
end

--  > Util
function approach( a, b, t )
    t = math.abs( t )

    if a < b then
        return math.min( a + t, b )
    elseif a > b then
        return math.max( a - t, b )
    end

    return b
end

--  > Game loop
love.graphics.setDefaultFilter( "nearest" )
love.graphics.setBackgroundColor( 73 / 255, 170 / 255, 16 / 255 )

love.graphics.setFont( love.graphics.newFont( "fonts/SMB2.ttf" ) )

local function include( path )
    require( path )
    package.loaded[path] = nil -- allow reload of the file (used for 'R' key)
end

require( "camera" )
function love.load()
    include( "map" )
    include( "player" )
    include( "cube" )

    --  > Init entities
    for i, v in ipairs( entities ) do
        v:init()
    end
end

local win = false
function love.update( dt )
    --  > Think entities
    for i, v in ipairs( entities ) do
        v:think( dt )
    end

    --  > Get game win
    win = Cubes:checkWin()
end

function love.keypressed( key )
    --  > Reload map
    if key == "r" then
        entities = {}
        love.load()
        return
    end

    --  > Next map
    if win then
        map_id = map_id + 1 > #maps and 1 or map_id + 1
        Cubes:deleteAll()
        Map:init()
        Player:init()
        return
    end

    --  > Entities hook
    for i, v in ipairs( entities ) do
        v:keypress( key )
    end 
end 

function love.draw()
    --  > Objects draw
    Camera:push()
    for i, v in ipairs( entities ) do
        if v.color then love.graphics.setColor( v.color ) end
        v:draw()
    end
    Camera:pop()

    --  > Win message
    if win then
        local limit = 500
        love.graphics.setColor( 1, 1, 1 )
        love.graphics.printf( "You won!\nPress any key to get to the next map", love.graphics.getWidth() / 2 - limit / 2, 20, limit, "center" )
    
        --  > Game end message
        if map_id == #maps then
            local limit, scale = 600, 1.25
            love.graphics.printf( "Congratulations, you finished the game!", love.graphics.getWidth() / 2 - limit * scale / 2, love.graphics.getHeight() / 2, limit, "center", 0, scale, scale )
            scale = .85
            love.graphics.printf( "It wasn't hard, right?", love.graphics.getWidth() / 2 - limit * scale / 2, love.graphics.getHeight() / 2 + 20, limit, "center", 0, scale, scale )
        end
    end

    --  > FPS
    local limit = 200
    love.graphics.printf( "FPS " .. love.timer.getFPS(), love.graphics.getWidth() - limit / 2, 20, limit )
end 