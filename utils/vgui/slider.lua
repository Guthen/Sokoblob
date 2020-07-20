local w, h = love.graphics.getDimensions()

Slider = class( BasePanel )
Slider.w = w * .3
Slider.h = h * .03

local space = h * .01
function Slider:construct( text, x, y )
    BasePanel.construct( self )

    self.text = text or "Slider.text"
    self.label = Label( self.text, x, y )
    
    self.x = x or self.x 
    self.y = ( y or self.y ) + self.label.h + space
    
    self.slider_x = 0
    self.hovered, self.drag = false, false
end

function Slider:onSlide()
end

function Slider:moveSlider( x )
    self.slider_x = clamp( x - self.h / 2, 0, self.w )
    self.drag = true

    self:onSlide()
end

function Slider:mousepress( x, y, mouse_button )
    if not ( mouse_button == 1 ) then return end
    if not collide( { x = x, y = y, w = 1, h = 1 }, self ) then return end

    self:moveSlider( x - self.x )
end

function Slider:think()
    --  > Label position
    self.label.x = self.x - Game.Font:getWidth( " " ) / 2
    self.label.y = self.y - self.label.h - space

    --  > Hovered
    local mouse_x, mouse_y = love.mouse.getPosition()
    local mouse, slider = { x = mouse_x, y = mouse_y, w = 1, h = 1 }, { x = self.x + self.slider_x, y = self.y, w = self.h, h = self.h }
    self.hovered = collide( mouse, slider )

    --  > Drag
    if love.mouse.isDown( 1 ) then
        if self.hovered or self.drag then
            self:moveSlider( mouse_x - self.x )
        end
    else
        self.drag = false
    end

    --  > Value
    self.value = self.slider_x / self.w
end

local line_size = math.floor( h * .005 )
function Slider:paint()
    --  > Background
    love.graphics.setColor( self.color )
    love.graphics.rectangle( "fill", self.x, self.y + self.h / 2 - line_size / 2, self.w, line_size )
    love.graphics.setColor( get_hovered_color( self.color ) )
    love.graphics.rectangle( "fill", self.x + self.slider_x, self.y + self.h / 2 - line_size / 2, self.w - self.slider_x, line_size )

    --  > Slider
    love.graphics.setColor( ( self.hovered or self.drag ) and get_hovered_color( self.color ) or self.color )
    love.graphics.rectangle( "fill", self.x + clamp( self.slider_x, 0, self.w - self.h ), self.y, self.h, self.h )

    --  > Value
    Label.drawText( {
        x = self.label.x + self.w,
        y = self.label.y,
        w = self.w * .5,
        h = self.h,
        text_align = "right",
        color = self.label.color,
    }, math.floor( self.value * 100 ) .. "%" )
end