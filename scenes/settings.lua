SettingsScene = Scene()

function SettingsScene:load()
    local w, h = love.graphics.getDimensions()

    local separator
    local function create_separator( text, y )
        separator = Label( text, w / 2, y )
        separator.x = separator.x - separator.w / 2
    end

    local space = h * .025
    --  > Sounds settings
    create_separator( "Sounds", h * .15 )

    local sound_volume = Slider( "Sound Volume", w / 2, separator.y + separator.h + space )
    sound_volume.x = sound_volume.x - sound_volume.w / 2
    sound_volume.slider_x = Game.SoundVolume * sound_volume.w
    function sound_volume:onSlide()
        Game.SoundVolume = self.value
    end

    local music_volume = Slider( "Music Volume", w / 2, sound_volume.y + sound_volume.h + space )
    music_volume.x = music_volume.x - music_volume.w / 2
    music_volume.slider_x = Game.MusicVolume * music_volume.w
    function music_volume:onSlide()
        Game.MusicVolume = self.value
        Game.Music:setVolume( self.value )
    end

    --  > Mobile settings
    if not Game.IsPC then
        create_separator( "Mobile", music_volume.y + music_volume.h + space )

        local vibration_checkbox = CheckBox( "Vibration", music_volume.x, separator.y + separator.h + space )
        vibration_checkbox.toggle = Game.Vibration
        function vibration_checkbox:onCheck( toggle )
            Game.Vibration = toggle
        end
    end

    --  > Get home on mobile
    if not Game.IsPC then
        InputButton( ui_offset, ui_offset * 2, "escape", 5 )
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