BasePlayer = class( Entity )
BasePlayer.image = love.graphics.newImage( "images/blob.png" )
BasePlayer.z_index = 1
BasePlayer.scale = 1
BasePlayer.color = { 97 / 255, 211 / 255, 227 / 255 }

--  > Create animations quads
local quads = {}
for x = 0, BasePlayer.image:getWidth() - tile_size, tile_size do
    quads[#quads + 1] = love.graphics.newQuad( x, 0, tile_size, tile_size, BasePlayer.image:getDimensions() )
end
BasePlayer.quads = quads
BasePlayer.current_quad = 1

function BasePlayer:construct()
    Entity.construct( self )

    self.color = MenuScene.player_color or BasePlayer.color
end

--  > Init player
function BasePlayer:init()
    self.moves = 0
    self.anim_x = self.x
    self.anim_y = self.y

    if not Game.IsPC then
        local space = 5
        InputButton( button_size + ui_offset + space, love.graphics.getHeight() - button_size * 2 - ( ui_offset + space ), "z", 2 )
        InputButton( ui_offset, love.graphics.getHeight() - button_size - ui_offset, "q", 3 )
        InputButton( button_size + ui_offset + space, love.graphics.getHeight() - button_size - ui_offset, "s", 4 )
        InputButton( button_size * 2 + ( ui_offset + space * 2 ), love.graphics.getHeight() - button_size - ui_offset, "d", 1 )
    end
end

local time, next_frame_time = 0, .5
function BasePlayer:think( dt )
    --  > Animation
    time = time + dt
    if time > next_frame_time then
        time = 0
        self.current_quad = self.current_quad + 1 > #self.quads and 1 or self.current_quad + 1
    end

    --  > Movement animation
    self.anim_x = approach( self.anim_x, self.x, dt * 5 )
    self.anim_y = approach( self.anim_y, self.y, dt * 5 )
end

--  > Movement
function BasePlayer:move( x, y )
    --  > Tile collision
    if not Map:checkCollision( self.x + x, self.y + y ) then
        --  > Moving crate
        local crate = Crates:getAt( self.x + x, self.y + y )
        if crate then
            --  > Collision with Crates 
            if Map:checkCollision( crate.x + x, crate.y + y ) or Crates:getAt( crate.x + x, crate.y + y ) then return end

            --  > Collision with closed doors
            if Doors:getClosedDoorAt( crate.x + x, crate.y + y ) then return end

            --  > Move crate
            crate:move( x, y )
        end

        --  > Collision with closed doors
        if Doors:getClosedDoorAt( self.x + x, self.y + y ) then return end

        --  > Movement
        self.x = self.x + x
        self.y = self.y + y

        --  > Score
        self.moves = self.moves + 1
    end
end

--  > Get direction from key
local directions = {
    ["z"] = {
        x = 0,
        y = -1,
    },
    ["s"] = {
        x = 0,
        y = 1,
    },
    ["q"] = {
        x = -1,
        y = 0,
    },
    ["d"] = {
        x = 1,
        y = 0,
    },
}
function BasePlayer:keypress( key )
    local dir = directions[key]
    if not dir then return end

    if GameScene.win then
        GameScene:nextMap()
        return
    end

    self:move( dir.x, dir.y )
end

local instructions = "Move with 'Z', 'Q', 'S', 'D'\nRetry with 'R'\nGo to menu with 'Escape'"
local tall = get_string_tall( instructions )
function BasePlayer:draw( only_player )
    --  > Player
    love.graphics.setColor( self.color )
    love.graphics.draw( self.image, self.quads[self.current_quad], self.anim_x * object_size, self.anim_y * object_size, 0, object_size / tile_size * self.scale, object_size / tile_size * self.scale )

    --  > Texts
    if only_player then return end

    love.graphics.push()
    love.graphics.origin()
    love.graphics.setColor( 1, 1, 1 )
    
    --  > Moves
    local limit = love.graphics.getWidth() * .5
    love.graphics.printf( self.moves .. " moves", love.graphics.getWidth() / 2 - limit / 2, ui_offset, limit, "center" )
    
    --  > Keys
    if Game.IsPC then
        love.graphics.printf( instructions, ui_offset, love.graphics.getHeight() - tall - ui_offset, limit )
    end
    
    love.graphics.pop()
end