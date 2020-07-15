Scene, Scenes = class(), {}

function Scene:construct()
    Scenes[#Scenes + 1] = self
end

function Scene:load()
end

function Scene:update( dt )
end

function Scene:keypressed( key )
end

function Scene:mousepressed( x, y, mouse_button )
end

function Scene:draw()
end