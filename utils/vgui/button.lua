require( "utils/vgui/label" )

Button = class( Label )
Button.text_color = { 0, 0, 0 }
Button.text_align = "center"
Button.disabled_color = { .85, .85, .85 }

function Button:construct( text, x, y )
    self.super.construct( self, text, x, y )

    self.w = self.w + 10
    self.h = self.h + 10

    self.disabled = false
end

function Button:mousepress( x, y, mouse_button )
    if not ( mouse_button == 1 ) then return end
    if self.disabled then return end

    if not Game.IsPC then
        if collide( { x = x, y = y, w = 1, h = 1 }, self ) then
            self:onClick( x - self.x, y - self.y )
        end
    else
        if self.hovered then
            self:onClick( x - self.x, y - self.y )
        end
    end
end

function Button:think( dt )
    if not Game.IsPC then return end -- Avoid useless calculs
    
    local mouse_x, mouse_y = love.mouse.getPosition()
    self.hovered = collide( { x = mouse_x, y = mouse_y, w = 1, h = 1 }, self )
end

function Button:onClick( x, y )
end

local hovered_amount = .1
local old_draw = Button.draw
function Button:paint()
    --  > Draw background
    self:drawBackground()

    --  > Draw text
    if self.text then
        self:drawText()
    end
end

function Button:drawBackground()
    local color = self.disabled and self.disabled_color or self.color

    --  > Draw background
    love.graphics.setColor( self.hovered and get_hovered_color( color ) or color )
    love.graphics.rectangle( "fill", self.x, self.y, self.w, self.h )
end
