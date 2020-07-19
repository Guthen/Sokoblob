Label = class( BasePanel )

function Label:construct( text, x, y, scale )
    BasePanel.construct( self )

    self.text = text or "Label"
    self.text_align = self.text_align or "left"
    self.x = x or 0
    self.y = y or 0
    self.scale = scale or 1

    --  > Size
    self.h = love.graphics.getFont():getHeight()
    self:fitToText()
end

function Label:fitToText()
    self.w = love.graphics.getFont():getWidth( self.text )
    self.w = self.w + self.w * .06
end

function Label:paint()
    self:drawText()
end

function Label:drawText( text, off_x, off_y )
    text = text or self.text
    off_x = off_x or 0
    off_y = off_y or self.h / 2

    local limit = self.w - self.w * .05
    if self.text_align == "right" then off_x = off_x - limit end

    love.graphics.setColor( self.text_color or self.color )
    love.graphics.printf( text, self.x + off_x + self.w - limit, self.y + off_y - love.graphics.getFont():getHeight() / 2, limit, self.text_align, 0, self.scale, self.scale )
end