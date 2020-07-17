MenuScene = Scene()

local image_star = love.graphics.newImage( "images/star.png" )
local lock_map_color, unlock_star_color, lock_star_color = { .85, .85, .85 }, { 0, 0, 0 }, { .65, .65, .65 }
function MenuScene:load()
    local w, h = love.graphics.getDimensions()
    
    --  > Create levels buttons
    local map_lock = false
    local button_size, buttons_per_line, i = w * .08 + h * .07, 5, 1
    for y = 1, 3 do
        for x = 1, buttons_per_line do
            local current_id = i
            local map = Maps[current_id]

            --  > Create button
            local button = Button( "Level " .. current_id )
            button.w = button_size
            button.h = button_size
            button.x = ( w - buttons_per_line * ( button_size + 15 ) ) / 2 + ( x - 1 ) * ( button_size + 15 )
            button.y = ( y - 1 ) * ( button_size + w * .01 ) + h * .15
            if map then
                --  > Score and stars
                local score = Game.Scores[map.filename]
                local high_score = map.level.high_score or -1
                local score_stars = Game:getScoreStars( high_score, score )

                --  > Override button functions
                if not map_lock or score then
                    function button:onClick( x, y )
                        map_id = current_id
                        Game:setScene( GameScene )
                    end
                else
                   button.color = lock_map_color
                end

                function button:paint()
                    --  > Draw default
                    self:drawBackground()
                    self:drawText( nil, nil, self.h * .35 )

                    --  > Draw stars
                    local scale, stars = w * .0015 + h * .001, 3
                    local off_x = ( self.w - stars * image_star:getWidth() * scale ) / 2
                    for i = 0, stars - 1 do
                        love.graphics.setColor( score_stars > i and unlock_star_color or lock_star_color )
                        love.graphics.draw( image_star, self.x + off_x + i * image_star:getWidth() * scale, self.y + self.h / 2 - scale, 0, scale, scale )
                    end
                end

                if not score then
                    map_lock = true
                end
            else
                button.color = lock_map_color
            end

            i = i + 1
        end
    end

    --  > Map Editor scene
    if Game.IsPC then
        local button = Button( "Map Editor" )
        button.w = w / h * 130
        button.h = w / h * 35
        button.x = love.graphics.getWidth() - button.w - 15
        button.y = love.graphics.getHeight() - button.h - 15
        function button:onClick()
            Game:setScene( MapEditorScene )
        end
    end
end

function MenuScene:keypressed( key )
    if key == "escape" then
        love.event.quit()
    end
end

function MenuScene:mousepressed( x, y, mouse_button )
    Entities:call( "mousepress", x, y, mouse_button )
end

function MenuScene:update( dt )
    Entities:call( "think", dt )
end

function MenuScene:draw( w, h )
    Entities:call( "draw" )

    local limit, scale = 200, 2
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.printf( "Levels", w / 2 - limit * scale / 2, h * .045, limit, "center", 0, scale, scale )
end