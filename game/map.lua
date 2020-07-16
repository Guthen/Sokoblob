Maps = Maps or {}
BaseMap = class( Entity )
BaseMap.z_index = 0

--  > Tile enums
enum( "TILE_", {
    VOID = 0,
    WALL_A = 1,
    SPOT = 2,
    CUBE = 3,
    WALL_B = 4,
    BUTTON = 5,
    DOOR = 6,
    DOOR_CLOSE = 7,
} )

--  > Load Maps
if #Maps == 0 then 
    Maps = {}
    for i, v in ipairs( love.filesystem.getDirectoryItems( "maps" ) ) do
        Maps[#Maps + 1] = {
            level = require( "Maps/" .. v:gsub( "%.lua", "" ) ),
            filename = v:gsub( "%.lua$", "" ),
        }
    end
end
print( ( "Maps: load %d maps" ):format( #Maps ) )

function BaseMap:loadMap( id )
    print( "Level: id=" .. id )

    local map = Maps[id]
    print( "Level: " .. ( map and "found" or "not found" ) )
    if not map then return end

    map = map.level
    print( ( "Level: bounds w=%d h=%d" ):format( #map[1], #map ) )

    --  > Delete previous map
    for i, v in ipairs( self ) do
        self[i] = nil
    end
    
    --  > Set new map
    for y, yv in ipairs( map ) do
        self[y] = {}
        for x, xv in ipairs( yv ) do
            --  > Smooth walls
            if xv == TILE_WALL_A then
                local bottom_tile = map[y + 1] and map[y + 1][x]
                if not ( bottom_tile == TILE_WALL_A ) --[[ and not ( bottom_tile == TILE_DOOR )  ]] then
                    xv = TILE_WALL_B
                end
            elseif xv == TILE_SPOT then
                self.spots = self.spots + 1                
            end

            self[y][x] = xv
            --print( ( "Level: set x=%d y=%d to tile=%d (%s)" ):format( x, y, xv, self[y][x] and "success" or "failed" ) )
        end
    end

    --  > Map size
    self.w = #self[1] * object_size
    self.h = #self * object_size

    --  > Create entities
    for y, yv in ipairs( self ) do
        for x, xv in ipairs( yv ) do
            if xv == TILE_CUBE then
                Cubes:create( x, y )
                self[y][x] = 0
            elseif xv == TILE_DOOR or xv == TILE_DOOR_CLOSE then 
                Doors:create( x, y ).toggled = xv == TILE_DOOR_CLOSE
                self[y][x] = 0
            end
        end
    end

    --  > Camera
    Camera.scale = map.options and map.options.scale or 1
    Camera:moveTo( self.w / 2 + object_size, self.h / 2 + object_size )

    --  > Set player pos to spawn
    if not map.spawn then return end
    Player.x = map.spawn.x
    Player.y = map.spawn.y
end

function BaseMap:init()
    self.spots = 0
    self:loadMap( map_id )
end

function BaseMap:getTileAt( x, y )
    return self[y] and self[y][x]
end

--  > Tile collision
local collision = {
    [TILE_WALL_A] = true,
    [TILE_WALL_B] = true,
}
function BaseMap:checkCollision( x, y )
    return collision[self:getTileAt( x, y )]
end

--  > Tile images
local images = {}
images[TILE_WALL_A] = love.graphics.newImage( "images/wall_a.png" )
images[TILE_SPOT] = love.graphics.newImage( "images/spot.png" )
images[TILE_WALL_B] = love.graphics.newImage( "images/wall_b.png" )
images[TILE_BUTTON] = love.graphics.newImage( "images/button.png" )

function BaseMap:draw()
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
