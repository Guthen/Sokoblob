Maps = Maps or {}
BaseMap = class( Entity )
BaseMap.z_index = 0
BaseMap.spots = 0

--  > Tile enums
enum( "TILE_", {
    PLAYER = -1,
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
function BaseMap:reloadMaps()
    Maps = {}

    for i, v in ipairs( love.filesystem.getDirectoryItems( "maps" ) ) do
        Maps[#Maps + 1] = {
            level = love.filesystem.load( "maps/" .. v )(),
            filename = v:gsub( "%.lua$", "" ),
        }
    end

    print( ( "Maps: load %d maps" ):format( #Maps ) )
end
BaseMap:reloadMaps()

function BaseMap:construct()
    self.super.construct( self, {} )
end

function BaseMap:loadMap( id, not_playable )
    --print( "Level: id=" .. id )

    local map = type( id ) == "table" and id or Maps[id]
    --print( "Level: " .. ( map and "found" or "not found" ) )
    if not map then return end

    map = map.level or map
    --print( ( "Level: bounds w=%d h=%d" ):format( #map[1], #map ) )

    --  > Delete previous map
    for i, v in ipairs( self ) do
        self[i] = nil
    end
    
    --  > Set new map
    for y, yv in ipairs( map ) do
        self[y] = {}
        for x, xv in ipairs( yv ) do
            --  > Smooth walls
            if not not_playable then
                if xv == TILE_WALL_A then
                    local bottom_tile = map[y + 1] and map[y + 1][x]
                    if not ( bottom_tile == TILE_WALL_A ) --[[ and not ( bottom_tile == TILE_DOOR )  ]] then
                        xv = TILE_WALL_B
                    end
                elseif xv == TILE_SPOT then
                    self.spots = self.spots + 1                
                elseif xv == TILE_PLAYER then
                    map.spawn = map.spawn or {}
                    map.spawn.x = x
                    map.spawn.y = y
                    xv = TILE_VOID
                end
            end

            self[y][x] = xv
            --print( ( "Level: set x=%d y=%d to tile=%d (%s)" ):format( x, y, xv, self[y][x] and "success" or "failed" ) )
        end
    end

    --  > Map size
    self:computeSize()

    --  > Create entities
    if not not_playable then
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
    end

    --  > Camera
    if not not_playable then
        Camera.scale = map.options and map.options.scale or 1
        Camera:moveTo( self.w / 2 + object_size, self.h / 2 + object_size )
    end

    --  > Set player pos to spawn
    if not map.spawn or not_playable then return end
    Player.x = map.spawn.x
    Player.y = map.spawn.y
end

function BaseMap:init()
    self.spots = 0
end

function BaseMap:computeSize()
    self.w = 0
    for y = 1, #self do
        self.w = math.max( self.w, #( self[y] or {} ) * object_size )
    end

    self.h = #self * object_size
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

--  > Tile BaseMap.images
BaseMap.images = {}
BaseMap.images[TILE_WALL_A] = love.graphics.newImage( "images/wall_a.png" )
BaseMap.images[TILE_SPOT] = love.graphics.newImage( "images/spot.png" )
BaseMap.images[TILE_WALL_B] = love.graphics.newImage( "images/wall_b.png" )
BaseMap.images[TILE_BUTTON] = love.graphics.newImage( "images/button.png" )

function BaseMap:draw()
    --  > Draw map
    for y = 1, #self do
        for x = 1, #( self[y] or {} ) do
            self:drawTile( self[y][x], x * object_size, y * object_size )
        end
    end
end

function BaseMap:drawTile( tile, x, y )
    local image = self.images[tile]
    if image then
        love.graphics.draw( image, x, y, 0, object_size / image:getWidth(), object_size / image:getHeight() )
    end 
end