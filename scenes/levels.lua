LevelsScene = Scene()

local image_star = love.graphics.newImage( "images/star.png" )
local unlock_star_color, lock_star_color = { 0, 0, 0 }, { .65, .65, .65 }
function LevelsScene:load( page )
    page = ( page or 1 ) - 1

    local w, h = love.graphics.getDimensions()
    
    --  > Create levels buttons
    local map_lock = false
    local button_size, button_space, buttons_per_line, lines, i = w * .08 + h * .07, w * .01, 5, 3, 1
    local x_offset, y_offset = ( w - buttons_per_line * ( button_size + button_space ) ) / 2, h * .15
    for y = 1, lines do
        for x = 1, buttons_per_line do
            local current_id = page * lines * buttons_per_line + i
            local map = Maps[current_id]

            --  > Create button
            local button = Button( "Level " .. current_id )
            button.w = button_size
            button.h = button_size
            button.x = x_offset + ( x - 1 ) * ( button_size + w * .01 )
            button.y = y_offset + ( y - 1 ) * ( button_size + button_space )
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
                   button.disabled = true
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
                button.disabled = true
            end

            i = i + 1
        end
    end

    --  > Pager
    local next_button = Button( "Next" )
    next_button.x = x_offset + ( buttons_per_line - 1 ) * ( button_size + button_space ) + button_size - next_button.w
    next_button.y = y_offset + lines * ( button_size + button_space )
    next_button.disabled = #Maps <= buttons_per_line * lines * ( page + 1 )
    function next_button:onClick()
        Game:setScene( LevelsScene, page + 2 )
    end

    local previous_button = Button( "Previous" )
    previous_button.x = x_offset
    previous_button.y = next_button.y
    previous_button.disabled = page <= 0
    function previous_button:onClick()
        Game:setScene( LevelsScene, page )
    end

    --  > Get home on mobile
    if not Game.IsPC then
        InputButton( ui_offset, ui_offset * 2, "escape", 5 )
    end

    --  > Map Editor scene
    --[[ if Game.IsPC then
        local button = Button( "Map Editor" )
        button.w = w / h * 130
        button.h = w / h * 35
        button.x = love.graphics.getWidth() - button.w - 15
        button.y = love.graphics.getHeight() - button.h - 15
        function button:onClick()
            Game:setScene( MapEditorScene )
        end
    end ]]
end

function LevelsScene:keypressed( key )
    if key == "escape" then
        Game:setScene( MenuScene )
    end
end

function LevelsScene:mousepressed( x, y, mouse_button )
    Entities:call( "mousepress", x, y, mouse_button )
end

function LevelsScene:update( dt )
    Entities:call( "think", dt )
end

function LevelsScene:draw( w, h )
    Entities:call( "draw" )

    self:drawCredits()
    self:drawTitle( "Levels" )
end