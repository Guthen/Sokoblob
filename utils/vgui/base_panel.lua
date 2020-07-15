BasePanel = class( Entity )
BasePanel.w = 100
BasePanel.h = 100

function BasePanel:draw()
    love.graphics.setColor( self.color )
    love.graphics.rectangle( "fill", self.x, self.y, self.w, self.h )
end