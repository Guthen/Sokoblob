SettingsScene = Scene()

function SettingsScene:load()
    local w, h = love.graphics.getDimensions()

    --  > Create UI
    local separator = Label( "Sounds", w / 2, h * .15 )
    separator.x = separator.x - separator.w / 2

    local sound_volume = Slider( "Sound Volume", w / 2, separator.y + separator.h + h * .025 )
    sound_volume.x = sound_volume.x - sound_volume.w / 2
    sound_volume.slider_x = Game.SoundVolume * sound_volume.w
    function sound_volume:onSlide()
        Game.SoundVolume = self.value
    end

    local music_volume = Slider( "Music Volume", w / 2, sound_volume.y + sound_volume.h + h * .025 )
    music_volume.x = music_volume.x - music_volume.w / 2
    music_volume.slider_x = Game.MusicVolume * music_volume.w
    function music_volume:onSlide()
        Game.MusicVolume = self.value
        Game.Music:setVolume( self.value )
    end

    Entities:call( "init" )
end

function SettingsScene:mousepressed( x, y, mouse_button )
    Entities:call( "mousepress", x, y, mouse_button )
end

function SettingsScene:keypressed( key )
    if key == "escape" then
        Game:setScene( MenuScene )
        return
    end

    Entities:call( "keypress", key )
end

function SettingsScene:update( dt )
    Entities:call( "think", dt )
end

function SettingsScene:draw()
    Entities:call( "draw" )

    self:drawCredits()
    self:drawTitle( "Settings" )
end