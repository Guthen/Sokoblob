Button = class( BasePanel )
Button.text_color = { 0, 0, 0 }

function Button:construct( x, y, text )
    Button.super.construct( self )

    self.x = x or 0
    self.y = y or 0
    self.text = text or "Text"
end

function Button:mousepress( x, y, mouse_button )
    if not ( mouse_button == 1 ) then return end

    if love.system.getOS() == "Android" then
        self:onClick( x - self.x, y - self.y )
    else
        if self.hovered then
            self:onClick( x - self.x, y - self.y )
        end
    end
end

local function collide( a, b )
    return a.x < b.x + b.w and b.x < a.x + a.w 
       and a.y < b.y + b.h and b.y < a.y + a.h
end

function Button:think( dt )
    if love.system.getOS() == "Android" then return end -- Avoid useless calculs
    
    local mouse_x, mouse_y = love.mouse.getPosition()

    self.hovered = collide( { x = mouse_x, y = mouse_y, w = 1, h = 1 }, self )
end

function Button:onClick( x, y )
end

local hovered_amount = .05
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

function Button:drawText( text, off_x, off_y )
    text = text or self.text
    off_x = off_x or 0
    off_y = off_y or self.h / 2

    local limit = self.w - self.w * .05
    love.graphics.setColor( self.text_color )
    love.graphics.printf( text, self.x + off_x + self.w - limit, self.y + off_y - love.graphics.getFont():getHeight() / 2, limit, "center" )
end