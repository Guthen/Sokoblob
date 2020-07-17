GameScene = Scene()

function GameScene:load()
    --  > Create entities
    Map = BaseMap()
    Player = BasePlayer()
    Doors = BaseDoors()
    Cubes = BaseCubes()

    --  > Init
    Map:init()
    Map:loadMap( map_id )
    Player:init()
    Doors:init()
    Cubes:init()

    --  > Sort
    if not Game.IsPC then
        local offset = love.graphics.getHeight() * .02
        InputButton( offset, offset * 3, "escape", 5 )
        InputButton( love.graphics.getWidth() - button_size - offset, offset * 3, "r", 6 )
    end

    Entities:sort()
end

local win, vibrated = false, false
function GameScene:update( dt )
    Entities:call( "think", dt )

    --  > Get game win
    win = Cubes:checkWin()

    if win and not vibrated then
        vibrated = true

        love.system.vibrate( 0.2 )
    end
end

local function next_map()
    local map_name = Maps[map_id].filename
    local last_score = Game.Scores[map_name]
    if not last_score or last_score > Player.moves then
        Game:setScore( map_name, Player.moves )
    end

    --  > Next map
    map_id = map_id + 1 > #Maps and 1 or map_id + 1
    Entities:clear()
    Game:reload()
end

function GameScene:mousepressed( x, y, mouse_button )
    --  > Score and next map
    if win then
        --  > Score
        next_map()
        return
    end

    Entities:call( "mousepress", x, y, mouse_button )
end

function GameScene:keypressed( key )
    --  > Echap
    if key == "escape" then
        Game:setScene( MenuScene )
        return
    end

    --  > Reload map
    if key == "r" then
        print( "Game: retry" )
        Entities:clear()
        Game:reload()
        return
    end

    --  > Score and next map
    if win then
        --  > Score
        next_map()
        return
    end

    --  > Entities hook
    Entities:call( "keypress", key )
end

local image_star = love.graphics.newImage( "images/star.png" )
local unlock_star_color, lock_star_color = { 1, 1, 1 }, { .75, .75, .75 }
function GameScene:draw( w, h )
    --  > Objects draw
    Camera:push()
    Entities:call( "draw" )
    Camera:pop()

    --  > Level
    love.graphics.print( "Level " .. map_id, h * .02, h * .02 )

    --  > Win message
    if win then
        local limit = w * .8
        love.graphics.setColor( 1, 1, 1 )
        love.graphics.printf( "You won!\nMove to get to the next map and save your highscore", w / 2 - limit / 2, h * .15, limit, "center" )

        --  > Stars score
        local score_stars = Game:getScoreStars( Game:getHighscore( map_id, true ), Player.moves )
        local scale, stars = w * .005 + h * .005, 3
        local off_x = ( w - stars * image_star:getWidth() * scale ) / 2
        for i = 0, stars - 1 do
            love.graphics.setColor( score_stars > i and unlock_star_color or lock_star_color )
            love.graphics.draw( image_star, off_x + i * image_star:getWidth() * scale, h * .2, 0, scale, scale )
        end

        --  > Better score than the creator one
        if Player.moves < ( Maps[map_id].level.high_score or - 1 ) then
            local limit, r, g, b = 500, hsl( ( love.timer.getTime() * 250 ) % 360, 200, 100 )
            love.graphics.setColor( r / 255, g / 255, b / 255 )
            love.graphics.printf( "You beat the creator's highscore!\nYou're a fookin legend!", w / 2, h * .22 + image_star:getWidth() * scale + 10, limit, "center", math.cos( love.timer.getTime() * 3 ) / 10, 1, 1, limit / 2 )
        end

        --  > Game end message
        if map_id == #Maps then
            local limit, scale = 600, 1.25
            love.graphics.setColor( 1, 1, 1 )
            love.graphics.printf( "Congratulations, you finished the game!", w / 2 - limit * scale / 2, h / 2, limit, "center", 0, scale, scale )
            scale = .85
            love.graphics.printf( "It wasn't hard, right?", w / 2 - limit * scale / 2, h / 2 + 20, limit, "center", 0, scale, scale )
        end
    end
end