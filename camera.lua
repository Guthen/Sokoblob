Camera = {
    x = 0,
    y = 0,
    scale = 1,
}

--  > Center camera to position
function Camera:moveTo( x, y )
    self.x = x - love.graphics.getWidth() / 2
    self.y = y - love.graphics.getHeight() / 2
end

function Camera:push()
    love.graphics.push()
    --  > Scale
    love.graphics.scale( self.scale )
    --  > Translate for scale from screen center 
    love.graphics.translate( -( ( love.graphics.getWidth() / 2 ) - ( love.graphics.getWidth() / 2 ) / self.scale ), -( ( love.graphics.getHeight() / 2 ) - ( love.graphics.getHeight() / 2 ) / self.scale ) )
    --  > Actual camera position
    love.graphics.translate( -self.x, -self.y )
end

function Camera:pop()
    love.graphics.pop()
end