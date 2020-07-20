require( "scenes/settings" )

MenuScene = Scene()

local scenes = {
    {
        text = "Play",
        scene = LevelsScene,
    },
    {
        text = "Map Editor",
        scene = MapEditorScene,
        only_pc = true,
    },
    {
        text = "Settings",
        scene = SettingsScene,
    },
    {
        text = "Quit",
        func = love.event.quit,
    }
}

function MenuScene:load()
    local w, h = love.graphics.getDimensions()

    --  > Scenes buttons
    local space, y = w * .005 + h * .005, 1
    for i, v in ipairs( scenes ) do
        if v.only_pc and not Game.IsPC then goto continue end

        local button = Button( v.text )
        button.w = w * .2
        button.h = h * .075
        button.x = w / 2 - button.w / 2
        button.y = h / 4 - button.h / 2 + y * ( button.h + space )
        function button:onClick()
            if v.func then return v.func() end
            Game:setScene( v.scene )
        end

        y = y + 1

        ::continue::
    end

    --  > Player
    self.player_quad = 1

    Entities:call( "init" )
end

function MenuScene:update( dt )
    Entities:call( "think", dt )

    --  > Player animation
    local player = {
        current_quad = self.player_quad,
        quads = BasePlayer.quads,
        anim_x = 0,
        anim_y = 0,
        x = 0,
        y = 0,
    }
    BasePlayer.think( player, dt )
    self.player_quad = player.current_quad
end

function MenuScene:keypressed( key )
    if key == "escape" then
        love.event.quit()
    end
end

function MenuScene:mousepressed( x, y, mouse_button )
    Entities:call( "mousepress", x, y, mouse_button )
end

local title, title_scale, title_offset = love.window.getTitle(), 3, love.graphics.getWidth() * .02
local title_w, title_h = Game.Font:getWidth( title ) * title_scale, Game.Font:getHeight() * title_scale
local player_scale = 1.5
local player_size = object_size / tile_size * player_scale * tile_size
function MenuScene:draw( w, h )
    Entities:call( "draw" )

    --  > Player draw
    local x, y = w / 2 - ( player_size + title_offset + title_w ) / 2, h * .05
    BasePlayer.draw( {
        image = BasePlayer.image,
        quads = BasePlayer.quads,
        current_quad = self.player_quad,
        anim_x = x / object_size,
        anim_y = y / object_size,
        scale = player_scale,
        color = BasePlayer.color,
    }, true )

    --  > Title shadow
    y = y + ( self.player_quad == 2 and title_scale + player_scale or 0 )
    love.graphics.setColor( 0, 0, 0 )
    love.graphics.print( title, x + player_size + title_offset - title_scale, y + player_size / 2 - title_h / 2 + title_scale, 0, title_scale, title_scale )
    
    --  > Title text
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.print( title, x + player_size + title_offset, y + player_size / 2 - title_h / 2, 0, title_scale, title_scale )

    --  > Credits
    self:drawCredits()
end