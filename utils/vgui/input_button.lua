InputButton = class( BasePanel )
InputButton.image = love.graphics.newImage( "images/screen_inputs.png" )
InputButton.z_index = 1

local quads = {}
for x = 0, InputButton.image:getWidth() - tile_size, tile_size do
    quads[#quads + 1] = love.graphics.newQuad( x, 0, tile_size, tile_size, InputButton.image:getDimensions() )
end
InputButton.quads = quads

function InputButton:construct( x, y, key, quad )
    InputButton.super.construct( self )

    self.x = x or 0
    self.y = y or 0

    self.w = button_size
    self.h = button_size

    self.key = key or "a"
    self.quad = quad or 1
end

function InputButton:mousepress( x, y, mouse_button )
    if not ( mouse_button == 1 ) then return end

    if collide( { x = x, y = y, w = 1, h = 1 }, self ) then
        Game.ActiveScene:keypressed( self.key )
    end
end

function InputButton:paint()
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.draw( self.image, self.quads[ self.quad ], self.x, self.y, 0, button_size / tile_size, button_size / tile_size )
end
