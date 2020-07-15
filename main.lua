--  > Variables
object_size, tile_size = 64, 16
map_id = 1

--  > Graphics settings
love.graphics.setDefaultFilter( "nearest" )
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
require_folder( "scenes" )
require_folder( "game" )

--  > Game
Game = {
    ActiveScene = MenuScene,
}

function Game:reload()
    Doors:deleteAll()
    Cubes:deleteAll()
    love.load()
end

function Game:setScene( scene )
    Entities:clear()
    self.ActiveScene = scene
    love.load()
end
--[[ Game:setScene( GameScene )
Game:setScene( MenuScene ) ]]

--  > Framework
function love.load()
    --  > Scene
    Game.ActiveScene:load()
end

function love.update( dt )
    --  > Scene
    Game.ActiveScene:update( dt )
end

function love.keypressed( key )
    --  > Scene
    Game.ActiveScene:keypressed( key )
end 

function love.mousepressed( x, y, mouse_button )
    Game.ActiveScene:mousepressed( x, y, mouse_button )
end

function love.draw()
    --  > Scene
    Game.ActiveScene:draw()

    --  > FPS
    local limit = 200
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.printf( "FPS " .. love.timer.getFPS(), love.graphics.getWidth() - limit / 2, 20, limit )
end 