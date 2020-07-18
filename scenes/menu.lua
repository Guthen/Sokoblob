MenuScene = Scene()

local scenes = {
    {
        text = "Play",
        scene = LevelsScene,
    },
    {
        text = "Map Editor",
        scene = MapEditorScene,
        only_pc = true,
    },
}

function MenuScene:load()
    local w, h = love.graphics.getDimensions()

    local space = w * .005 + h * .005
    for i, v in ipairs( scenes ) do
        if v.only_pc and not Game.IsPC then goto continue end

        local button = Button( v.text )
        button.w = w * .2
        button.h = h * .075
        button.x = w / 2 - button.w / 2
        button.y = h / 4 - button.h / 2 + i * ( button.h + space )
        function button:onClick()
            Game:setScene( v.scene )
        end

        ::continue::
    end


    Entities:call( "init" )
end

function MenuScene:update( dt )
    Entities:call( "think", dt )
end

function MenuScene:keypressed( key )
    if key == "escape" then
        love.event.quit()
    end
end

function MenuScene:mousepressed( x, y, mouse_button )
    Entities:call( "mousepress", x, y, mouse_button )
end

function MenuScene:draw( w, h )
    Entities:call( "draw" )
end