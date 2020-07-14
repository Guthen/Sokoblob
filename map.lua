maps = maps or {}
Map = Entity( {} )

--  > Load maps
if #maps == 0 then 
    maps = {}
    for i, v in ipairs( love.filesystem.getDirectoryItems( "maps" ) ) do
        maps[#maps + 1] = require( "maps/" .. v:gsub( "%.lua", "" ) )
    end
end

function Map:loadMap( id )
    local map = maps[id]

    --  > Delete previous map
    for i, v in ipairs( self ) do
        self[i] = nil
    end

    --  > Set new map
    for y, yv in ipairs( map ) do
        self[y] = {}
        for x, xv in ipairs( yv ) do
            if xv == 1 then
                if not map[y + 1] or not ( map[y + 1][x] == 1 ) then
                    xv = 4
                end
            end

            self[y][x] = xv
        end
    end

    --  > Map size
    Map.w = #Map[1] * object_size
    Map.h = #Map * object_size

    --  > Create cubes
    for y, yv in ipairs( self ) do
        for x, xv in ipairs( yv ) do
            if xv == 3 then
                Cubes:create( x, y )
                Map[y][x] = 0
            end
        end
    end

    --  > Camera
    Camera.scale = map.options and map.options.scale or 1
    Camera:moveTo( Map.w / 2 + object_size, Map.h / 2 + object_size )

    --  > Set player pos to spawn
    if not map.spawn then return end
    Player.x = map.spawn.x
    Player.y = map.spawn.y
end

--  > Create cubes
function Map:init()
    self:loadMap( map_id )
end

function Map:getTile( x, y )
    return self[y] and self[y][x]
end

--  > Tile collision
local collision = {
    [1] = true,
    [4] = true,
}
function Map:checkCollision( x, y )
    return collision[self:getTile( x, y )]
end

--  > Tile images
local images = {}
images[1] = love.graphics.newImage( "images/wall_a.png" )
images[2] = love.graphics.newImage( "images/spot.png" )
images[4] = love.graphics.newImage( "images/wall_b.png" )

function Map:draw()
    --  > Draw map
    for y, yv in ipairs( self ) do
        for x, xv in ipairs( yv ) do
            local image = images[xv]
            if image then
                love.graphics.draw( image, x * object_size, y * object_size, 0, object_size / image:getWidth(), object_size / image:getHeight() )
            end 
        end
    end

    love.graphics.push()
    love.graphics.origin()
    
    --  > Level
    love.graphics.print( "Level " .. map_id, 20, 20 )
    
    love.graphics.pop()
end