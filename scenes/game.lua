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
    end

    --  > Reload map
    if key == "r" then
        print( "Game: retry" )
        Entities:clear()
        Game:reload()
        return
    end

    --  > Next map
    if win then
        map_id = map_id + 1 > #Maps and 1 or map_id + 1
        Entities:clear()
        Game:reload()
        return
    end

    --  > Entities hook
    Entities:call( "keypress", key )
end

function GameScene:draw()
    --  > Objects draw
    Camera:push()
    Entities:call( "draw" )
    Camera:pop()

    --  > Win message
    if win then
        local limit = 500
        love.graphics.setColor( 1, 1, 1 )
        love.graphics.printf( "You won!\nPress any key to get to the next map", love.graphics.getWidth() / 2 - limit / 2, 20, limit, "center" )

        --  > Game end message
        if map_id == #Maps then
            local limit, scale = 600, 1.25
            love.graphics.printf( "Congratulations, you finished the game!", love.graphics.getWidth() / 2 - limit * scale / 2, love.graphics.getHeight() / 2, limit, "center", 0, scale, scale )
            scale = .85
            love.graphics.printf( "It wasn't hard, right?", love.graphics.getWidth() / 2 - limit * scale / 2, love.graphics.getHeight() / 2 + 20, limit, "center", 0, scale, scale )
        end
    end
end