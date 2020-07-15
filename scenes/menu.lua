MenuScene = Scene()

function MenuScene:load()
    love.graphics.setBackgroundColor( 73 / 255, 170 / 255, 16 / 255 )

    --  > Create levels menu
    local w, h = love.graphics.getDimensions()

    local button_size, buttons_per_line, i = 120, 5, 1
    for y = 1, 3 do
        for x = 1, buttons_per_line do
            local current_id = i

            local button = Button()
            button.w = button_size
            button.h = button_size
            button.x = ( w - buttons_per_line * ( button_size + 15 ) ) / 2 + ( x - 1 ) * ( button_size + 15 )
            button.y = ( y - 1 ) * ( button_size + 15 ) + h * .2
            button.text = "Level " .. current_id
            if Maps[current_id] then 
                function button:onClick( x, y )
                    map_id = current_id
                    Game:setScene( GameScene )
                end
            else
                button.color = { .75, .75, .75 }
            end

            i = i + 1
        end
    end
end

function MenuScene:mousepressed( x, y, mouse_button )
    Entities:call( "mousepress", x, y, mouse_button )
end

function MenuScene:update( dt )
    Entities:call( "think", dt )
end

function MenuScene:draw()
    Entities:call( "draw" )

    local limit, scale = 200, 2
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.printf( "LEVELS", love.graphics.getWidth() / 2 - limit * scale / 2, love.graphics.getHeight() * .1, limit, "center", 0, scale, scale )
end