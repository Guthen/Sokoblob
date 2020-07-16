GameScene = Scene()

function GameScene:load()
    love.graphics.setBackgroundColor( 73 / 255, 170 / 255, 16 / 255 )

    Map = BaseMap( {} )
    Player = BasePlayer()
    Doors = BaseDoors()
    Cubes = BaseCubes()

    Entities:call( "init" )
    Entities:sort()
end

local win = false
function GameScene:update( dt )
    Entities:call( "think", dt )

    --  > Get game win
    win = Cubes:checkWin()
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
        local map_name = Maps[map_id].filename
        local last_score = Game.Scores[map_name]
        if not last_score or last_score > Player.moves then
            Game:setScore( map_name, Player.moves )
        end

        --  > Next map
        map_id = map_id + 1 > #Maps and 1 or map_id + 1
        Entities:clear()
        Game:reload()
        return
    end

    --  > Entities hook
    Entities:call( "keypress", key )
end

local image_star = love.graphics.newImage( "images/star.png" )
local unlock_star_color, lock_star_color = { 1, 1, 1 }, { .75, .75, .75 }
function GameScene:draw()
    --  > Objects draw
    Camera:push()
    Entities:call( "draw" )
    Camera:pop()

    --  > Win message
    if win then
        local limit = 600
        love.graphics.setColor( 1, 1, 1 )
        love.graphics.printf( "You won!\nMove to get to the next map and save your score", love.graphics.getWidth() / 2 - limit / 2, love.graphics.getHeight() * .15, limit, "center" )

        --  > Better score than the creator one
        if Player.moves < ( Maps[map_id].level.high_score or - 1 ) then
            local limit, r, g, b = 500, hsl( ( love.timer.getTime() * 250 ) % 360, 200, 100 )
            love.graphics.setColor( r / 255, g / 255, b / 255 )
            love.graphics.printf( "You beat the creator's highscore!\nYou're a fookin legend!", love.graphics.getWidth() / 2, love.graphics.getHeight() * .35, limit, "center", math.cos( love.timer.getTime() * 3 ) / 10, 1, 1, limit / 2 )
        end

        --  > Stars score
        local score_stars = Game:getScoreStars( Game:getHighscore( map_id, true ), Player.moves )
        local scale, stars = 4, 3
        local off_x = ( love.graphics.getWidth() - stars * image_star:getWidth() * scale ) / 2
        for i = 0, stars - 1 do
            love.graphics.setColor( score_stars > i and unlock_star_color or lock_star_color )
            love.graphics.draw( image_star, off_x + i * image_star:getWidth() * scale, love.graphics.getHeight() * .2, 0, scale, scale )
        end

        --  > Game end message
        if map_id == #Maps then
            local limit, scale = 600, 1.25
            love.graphics.setColor( 1, 1, 1 )
            love.graphics.printf( "Congratulations, you finished the game!", love.graphics.getWidth() / 2 - limit * scale / 2, love.graphics.getHeight() / 2, limit, "center", 0, scale, scale )
            scale = .85
            love.graphics.printf( "It wasn't hard, right?", love.graphics.getWidth() / 2 - limit * scale / 2, love.graphics.getHeight() / 2 + 20, limit, "center", 0, scale, scale )
        end
    end
end