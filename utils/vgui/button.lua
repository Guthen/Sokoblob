require( "utils/vgui/label" )

Button = class( Label )
Button.text_color = { 0, 0, 0 }
Button.text_align = "center"

function Button:construct( text, x, y )
    self.super.construct( self, text, x, y )

    self.w = self.w + 10
    self.h = self.h + 10
end

local function collide( a, b )
    return a.x < b.x + b.w and b.x < a.x + a.w 
       and a.y < b.y + b.h and b.y < a.y + a.h
end

function Button:mousepress( x, y, mouse_button )
    if not ( mouse_button == 1 ) then return end

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
    --  > Get color
    local color = { self.color[1], self.color[2], self.color[3] }
    if self.hovered then
        color[1] = color[1] - hovered_amount
        color[2] = color[2] - hovered_amount
        color[3] = color[3] - hovered_amount
    end

    --  > Draw background
    love.graphics.setColor( color )
    love.graphics.rectangle( "fill", self.x, self.y, self.w, self.h )
end
