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

local w, h = love.graphics.getDimensions()
local title, title_scale, title_offset = love.window.getTitle(), 3, w * .02
local title_w, title_h = Game.Font:getWidth( title ) * title_scale, Game.Font:getHeight() * title_scale
local player_scale = 1.5
local player_size = object_size / tile_size * player_scale * tile_size
local title_x, title_y = w / 2 - ( player_size + title_offset + title_w ) / 2, h * .05
function MenuScene:load()
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
    self.player_color = self.player_color or BasePlayer.color

    local colors = {
        BasePlayer.color,
        { 178 / 255, 16 / 255, 48 / 255 }, --  > red
        { 113 / 255, 227 / 255, 146 / 255 }, --  > green
        { 235 / 255, 211 / 255, 32 / 255 }, --  > yellow
        { 255 / 255, 162 / 255, 0 / 255 }, --  > orange
        { 162 / 255, 113 / 255, 255 / 255 } --  > purple
    }    

    local player_button = Button( "", title_x, title_y )
    player_button.w = object_size * player_scale
    player_button.h = player_button.w
    function player_button.onClick()
        self.player_color = colors[math.random( #colors )]
    end
    function player_button.paint()
        BasePlayer.draw( {
            image = BasePlayer.image,
            quads = BasePlayer.quads,
            current_quad = self.player_quad,
            anim_x = player_button.x / object_size,
            anim_y = player_button.y / object_size,
            scale = player_scale,
            color = self.player_color,
        }, true )
    end

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

function MenuScene:draw( w, h )
    Entities:call( "draw" )

    --  > Title shadow
    local title_y = title_y + ( self.player_quad == 2 and title_scale + player_scale or 0 )
    love.graphics.setColor( 0, 0, 0 )
    love.graphics.print( title, title_x + player_size + title_offset - title_scale, title_y + player_size / 2 - title_h / 2 + title_scale, 0, title_scale, title_scale )
    
    --  > Title text
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.print( title, title_x + player_size + title_offset, title_y + player_size / 2 - title_h / 2, 0, title_scale, title_scale )

    --  > Credits
    self:drawCredits()
end