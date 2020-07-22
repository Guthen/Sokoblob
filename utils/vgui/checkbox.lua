CheckBox = class( BasePanel )

local w, h = love.graphics.getDimensions()
function CheckBox:construct( text, x, y )
    BasePanel.construct( self )

    self.x = x or self.x
    self.y = y or self.y

    self.button = Button( "" )
    self.button.w = w * .015 + h * .015
    self.button.h = self.button.w
    function self.button.onClick()
        self.toggle = not self.toggle
        self:onCheck( self.toggle )
    end
    function self.button.paint()
        love.graphics.setColor( 1, 1, 1 )
        love.graphics.rectangle( "fill", self.button.x, self.button.y, self.button.w, self.button.h )

        local color, border = self.toggle and { .2, .75, .2 } or { .75, .2, .2 }, math.floor( h * .005 )
        love.graphics.setColor( self.button.hovered and get_hovered_color( color ) or color )
        love.graphics.rectangle( "fill", self.button.x + border, self.button.y + border, self.button.w - border * 2, self.button.h - border * 2 )
    end

    self.label = Label( text )
end

function CheckBox:think( dt )
    self.button.x = self.x
    self.button.y = self.y
    self.label.x = self.x + self.button.w + 5
    self.label.y = self.y + self.button.h / 2 - self.label.h / 2
end

function CheckBox:onCheck( toggle ) end

function CheckBox:paint() end