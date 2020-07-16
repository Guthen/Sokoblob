MenuScene = Scene()

local image_star = love.graphics.newImage( "images/star.png" )
local lock_map_color, unlock_star_color, lock_star_color = { .85, .85, .85 }, { 0, 0, 0 }, { .75, .75, .75 }
function MenuScene:load()
    love.graphics.setBackgroundColor( 73 / 255, 170 / 255, 16 / 255 )

    local w, h = love.graphics.getDimensions()
    
    --  > Create levels buttons
    local map_lock = false
    local button_size, buttons_per_line, i = 120, 5, 1
    for y = 1, 3 do
        for x = 1, buttons_per_line do
            local current_id = i
            local map = Maps[current_id]

            --  > Create button
            local button = Button()
            button.w = button_size
            button.h = button_size
            button.x = ( w - buttons_per_line * ( button_size + 15 ) ) / 2 + ( x - 1 ) * ( button_size + 15 )
            button.y = ( y - 1 ) * ( button_size + 15 ) + h * .2
            button.text = "Level " .. current_id
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

                function button:draw()
                    --  > Draw default
                    self:drawBackground()
                    self:drawText( nil, nil, self.h * .35 )

                    --  > Draw stars
                    local scale, stars = 2, 3
                    local off_x = ( self.w - stars * image_star:getWidth() * scale ) / 2
                    for i = 0, stars - 1 do
                        love.graphics.setColor( score_stars > i and unlock_star_color or lock_star_color )
                        love.graphics.draw( image_star, self.x + off_x + i * image_star:getWidth() * scale, self.y + self.h / 2 - image_star:getHeight() / 2, 0, scale, scale )
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