local pc_os = {
    ["Windows"] = true,
    ["OS X"] = true,
    ["Linux"] = true,
}

Game = {
    Scores = {},
    IsPC = pc_os[love.system.getOS()],
    SoundVolume = .5,
    MusicVolume = .35,
    Vibration = true,
}
Game.Version = "2.0.2"
Game.Author = ( "By %s" ):format( Game.IsPC and "Guthen" or "Guthen & Nogitsu" )

if not Game.IsPC then
    love.window.setFullscreen( true )
end

--  > Variables
local w, h = love.graphics.getDimensions()
object_size, tile_size, button_size, ui_offset = w * .035 + h * .044, 16, w * .06 + h * .06, w * .015 + h * .015
map_id = 1

--  > Graphics settings
love.graphics.setDefaultFilter( "nearest" )
love.graphics.setBackgroundColor( 73 / 255, 170 / 255, 16 / 255 )

Game.Font = love.graphics.newFont( "fonts/SMB2.ttf", w * .01 + h * .0075 )
love.graphics.setFont( Game.Font )

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
Game.ActiveScene = MenuScene

function Game:reload()
    Doors:deleteAll()
    Crates:deleteAll()
    love.load()
end

local score_filename = "scores.sb"
function Game:loadScores()
    if not love.filesystem.getInfo( score_filename ) then return print( "Scores: failed loading" ) end

    local i = 1
    for l in love.filesystem.lines( score_filename ) do
        local map_name, score = l:match( "([%w-_]+)%:%s?(%d+)" )
        if not map_name or not score then 
            print( "Scores: failed to read line " .. i ) 
        else
            self.Scores[map_name] = tonumber( score )
        end

        i = i + 1
    end

    print( "Scores: loaded" )
end
Game:loadScores()

function Game:getHighscore( map_id, creator_score )
    local map = Maps[map_id]
    if not map then return -1 end

    local score = ( creator_score and map.level.high_score or Game.Scores[map.filename] ) or -1
    return score
end

function Game:getScoreStars( high_score, score )
    local score_stars = 0
    if score then
        if high_score >= score then 
            score_stars = 3 
        elseif high_score + high_score * .5 >= score then
            score_stars = 2
        else
            score_stars = 1
        end
    end

    return score_stars
end

function Game:setScore( map_name, score )
    print( ( "Scores: new map_name=%q score=%d" ):format( map_name, score ) )

    self.Scores[map_name] = score
    self:saveScores()
end

function Game:saveScores()
    local content = ""

    for k, v in pairs( self.Scores ) do
        content = content .. ( "%s: %d\r\n" ):format( k, v )
    end

    local success, error = love.filesystem.write( score_filename, content ) 
    if success then
        print( "Scores: saved" )
    else
        print( ( "Scores: failed to save - %q" ):format( error ) )
    end
end

function Game:setScene( scene, ... )
    local args = { ... }
    timer( 0, function()
        Entities:clear()
        self.ActiveScene = scene
        love.load( unpack( args ) )
    end )
end

function Game:playSound( filename )
    local sound = love.audio.newSource( "sounds/" .. filename, "static" )
    sound:setVolume( Game.SoundVolume )
    sound:play()
end

function Game:playMusic( filename )
    local sound = love.audio.newSource( "sounds/musics/" .. filename, "stream" )
    sound:setVolume( Game.MusicVolume )
    sound:setLooping( true )
    sound:play()

    Game.Music = sound
end

--if not love.system.hasBackgroundMusic() then
    Game:playMusic( "cool.wav" )
--end

--  > Framework
function love.load( ... )
    --  > Scene
    Game.ActiveScene:load( ... )
end

function love.update( dt )
    --  > Scene
    Game.ActiveScene:update( dt )

    --  > Timers
    for i, v in ipairs( Game.Timers ) do
        v.time = v.time - dt
        if v.time <= 0 then
            v.callback()
            table.remove( Game.Timers, i )
        end
    end
end

function love.keypressed( key )
    --  > Scene
    Game.ActiveScene:keypressed( key )
end 

function love.mousepressed( x, y, mouse_button )
    Game.ActiveScene:mousepressed( x, y, mouse_button )
end

function love.wheelmoved( x, y )
    Game.ActiveScene:wheelmoved( x, y )
end

function love.draw()
    --  > Scene
    Game.ActiveScene:draw( love.graphics.getDimensions() )

    --  > FPS
    love.graphics.setColor( 1, 1, 1 )
    if Game.IsPC then
        local limit = w * .25
        love.graphics.printf( "FPS " .. love.timer.getFPS(), love.graphics.getWidth() - limit - ui_offset, ui_offset, limit, "right" )
    end
end