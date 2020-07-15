--  > Variables
object_size, tile_size = 64, 16
map_id = 6

--  > Graphics settings
love.graphics.setDefaultFilter( "nearest" )
love.graphics.setBackgroundColor( 73 / 255, 170 / 255, 16 / 255 )
love.graphics.setFont( love.graphics.newFont( "fonts/SMB2.ttf" ) )

--  > Require all files in specific folder
local function require_folder( folder )
    for i, v in ipairs( love.filesystem.getDirectoryItems( folder ) ) do
        local path = folder .. "/" .. v
        if love.filesystem.getInfo( path ).type == "directory" then
            require_folder( path )
        elseif path:find( "%.lua$" ) then
            require( path:gsub( "%.lua$", "" ) )
        end
    end
end
require_folder( "utils" )
require_folder( "game" )

--  > Game
Game = {}
function Game:reload()
    Doors:deleteAll()
    Cubes:deleteAll()
    love.load()
end

--  > Framework
function love.load()
    --  > Init entities
    for i, v in ipairs( Entities ) do
        v:init()
    end

    --  > Sort entities by ZIndex
    table.sort( Entities, function( a, b )
        return a.z_index < b.z_index
    end )
end

local win = false
function love.update( dt )
    --  > Think entities
    for i, v in ipairs( Entities ) do
        v:think( dt )
    end

    --  > Get game win
    win = Cubes:checkWin()
end

function love.keypressed( key )
    --  > Reload map
    if key == "r" then
        print( "Game: retry" )
        Game:reload()
        return
    end

    --  > Next map
    if win then
        map_id = map_id + 1 > #maps and 1 or map_id + 1
        Game:reload()
        return
    end

    --  > Entities hook
    for i, v in ipairs( Entities ) do
        v:keypress( key )
    end 
end 

function love.draw()
    --  > Objects draw
    Camera:push()
    for i, v in ipairs( Entities ) do
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