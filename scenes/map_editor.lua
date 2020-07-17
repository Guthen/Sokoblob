MapEditorScene = Scene()
MapEditorScene.camera_speed = 300

function MapEditorScene:createEditableNumber( name, x, y, value, callback )
    local w, h = love.graphics.getDimensions()
    local size = w / h * 30

    local key = name:gsub( " ", "_" ):lower()
    self[key] = value or 0

    --  > Create UI
    local value_label

    local minus_button = Button( "-", x, y )
    minus_button.w = size
    minus_button.h = size
    function minus_button.onClick()
        self[key] = self[key] - 1
        callback( self[key], "-" )

        value_label.text = self[key]
        value_label:fitToText()
    end
    
    local text_label = Label( name, x + minus_button.w + 5, y )
    text_label.y = text_label.y + text_label.h / 2 - 2.5

    value_label = Label( value, text_label.x + text_label.w / 2, y )
    value_label.text_align = "center"
    value_label.x = value_label.x - value_label.w / 2
    value_label.y = value_label.y + value_label.h * 1.5 + 2.5

    local plus_button = Button( "+", x + minus_button.w + 5 * 2 + text_label.w, y )
    plus_button.w = size
    plus_button.h = size
    function plus_button.onClick()
        self[key] = self[key] + 1
        callback( self[key], "+" )

        value_label.text = self[key]
        value_label:fitToText()
    end

    return minus_button.y, minus_button.h
end

function MapEditorScene:load()
    local w, h = love.graphics.getDimensions()

    --  > Init map
    Map = BaseMap()
    Map.images[TILE_CUBE] = BaseCubes.image
    Map.images[TILE_DOOR] = BaseDoors.image
    Map.images[TILE_DOOR_CLOSE] = BaseDoors.image
    Map.images[TILE_PLAYER] = BasePlayer.image

    if self.map then
        --  > Load previous edit map
        Map:loadMap( self.map, true )
    else
        --  > Create a basic map
        local P, W, _, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_CUBE, TILE_SPOT
        Map[#Map + 1] = { W, W, W, W, W }
        Map[#Map + 1] = { W, _, _, _, W }
        Map[#Map + 1] = { W, _, P, _, W }
        Map[#Map + 1] = { W, _, C, S, W }
        Map[#Map + 1] = { W, W, W, W, W }
        Map:computeSize()

        Camera:moveTo( Map.w / 4, Map.h / 2 )
    end

    --  > Editor variables
    self.tile_id = self.tile_id or 1
    self.tiles = {
        TILE_WALL_A,
        TILE_CUBE,
        TILE_SPOT,
        TILE_BUTTON,
        TILE_DOOR,
        TILE_DOOR_CLOSE,
        TILE_PLAYER,
    }
    
    --  > Editor UI
    local offset = w / h * 10
    local y, h = self:createEditableNumber( "Map Width", offset, offset, Map.w / object_size, function( value, op )
        if op == "+" then
            for y = 1, #Map do
                Map[y][#Map[y] + 1] = TILE_VOID
            end
        elseif op == "-" then
            for y = 1, #Map do
                Map[y][#Map[y]] = nil
            end
        end

        Map:computeSize()
    end )
    y, h = self:createEditableNumber( "Map Height", offset, offset + y + h, Map.h / object_size, function( value, op )
        if op == "+" then
            local line = {}

            for x = 1, Map.w / object_size do
                line[x] = TILE_VOID
            end

            Map[#Map + 1] = line
        elseif op == "-" then
            Map[#Map] = nil
        end

        Map:computeSize()
    end )
    y, h = self:createEditableNumber( "Tile ID", offset, offset + y + h, self.tile_id, function( value, op ) 
        if op == "+" then
            self.tile_id = value > #self.tiles and 1 or value
        elseif op == "-" then
            self.tile_id = value < 1 and #self.tiles or value
        end
    end )

    --  > Save button
    local save_button = Button( "Save", offset, offset + y + h )
    function save_button.onClick( self, filename )
        filename = type( filename ) == "string" and filename or nil

        --  > Parse table to Lua code
        local lua = "return {\n"

        for y, yv in ipairs( Map ) do
            lua = lua .. "\t{ "

            for x, xv in ipairs( yv ) do
                lua = lua .. ( "%d, " ):format( xv )
            end

            lua = lua .. "},\n"
        end

        lua = lua .. "}"

        --  > Write
        love.filesystem.createDirectory( "maps" )
        print( love.filesystem.write( "maps/" .. ( filename or os.date( "%d_%m_%Y-%H_%M_%S" ) ) .. ".lua", lua ) )
    end

    --  > Clear button
    local clear_button = Button( "Clear", save_button.x + offset + save_button.w, save_button.y )
    function clear_button:onClick()
        for y = 1, #Map do
            for x = 1, #Map[y] do
                Map[y][x] = TILE_VOID
            end
        end
    end

    --  > Load button
    y, h = self:createEditableNumber( "Map ID", offset, save_button.y + clear_button.h + offset * 2, self.map_id or 1, function( value, op ) 
        if op == "+" then
            self.map_id = value > #Maps and 1 or value
        elseif op == "-" then
            self.map_id = value < 1 and #Maps or value
        end
    end )

    local load_button = Button( "Load", offset, offset + y + h )
    function load_button.onClick()
        Map:loadMap( Maps[self.map_id], true )
    end

    local overwrite_button = Button( "Overwrite", load_button.x + offset + load_button.w, load_button.y )
    function overwrite_button.onClick()
        save_button:onClick( Maps[self.map_id].filename )
    end

    --  > Camera settings
    Camera.scale = 1

    --  > Entities init
    Entities:call( "init" )
    Entities:sort()
end

function MapEditorScene:update( dt )
    Entities:call( "think", dt )

    --  > Camera movement
    local speed = dt * self.camera_speed
    if love.keyboard.isDown( "z" ) then
        Camera.y = Camera.y - speed
    end
    if love.keyboard.isDown( "s" ) then
        Camera.y = Camera.y + speed
    end
    if love.keyboard.isDown( "q" ) then
        Camera.x = Camera.x - speed
    end
    if love.keyboard.isDown( "d" ) then
        Camera.x = Camera.x + speed
    end
end

function MapEditorScene:mousepressed( x, y, button )
    Entities:call( "mousepress", x, y, button )

    --  > Get mouse position
    local mouse_x, mouse_y = love.mouse.getPosition()
    mouse_x, mouse_y = Camera.x + mouse_x, Camera.y + mouse_y

    --  > Get tile position
    local tile_x, tile_y = math.floor( mouse_x / object_size ) + 1, math.floor( mouse_y / object_size ) + 1
    if tile_x <= 0 or tile_y <= 0 then return end

    --  > Place tile
    if button == 1 then
        if not Map[tile_y] or #Map[tile_y] < tile_x then return end
        Map[tile_y][tile_x] = self.tiles[self.tile_id]

        Map:computeSize()
    end

    --  > Remove tile
    if button == 2 then
        if Map[tile_y] then 
            Map[tile_y][tile_x] = 0
            --if #Map[tile_y] == 0 then table.remove( Map, tile_y ) end
            Map:computeSize()
        end
    end
end

function MapEditorScene:keypressed( key )
    if key == "escape" then
        self.map = Map

        BaseMap:reloadMaps()
        Game:setScene( MenuScene )
    end
end

function MapEditorScene:draw()
    --  > Entities draw
    local old_camera_x, old_camera_y = Camera.x, Camera.y
    Camera.x, Camera.y = Camera.x + object_size, Camera.y + object_size
    
    Camera:push()
    Entities:call( "draw" )
    Camera:pop()

    Camera.x, Camera.y = old_camera_x, old_camera_y

    --  > Draw current tile
    love.graphics.setColor( 1, 1, 1, .75 )
    --love.graphics.translate( ( love.graphics.getWidth() - Map.w ) / 2, ( love.graphics.getHeight() - Map.h ) / 2 )
    love.graphics.translate( -Camera.x, -Camera.y )

    local mouse_x, mouse_y = love.mouse.getPosition()
    if mouse_x >= -Camera.x and mouse_y >= -Camera.y and mouse_x <= -Camera.x + Map.w and mouse_y <= -Camera.y + Map.h then
        mouse_x, mouse_y = Camera.x + mouse_x, Camera.y + mouse_y
        Map:drawTile( self.tiles[self.tile_id], math.floor( mouse_x / object_size ) * object_size, math.floor( mouse_y / object_size ) * object_size )
    end
    love.graphics.origin()

    --  > Draw grid
    Camera:push()
    for x = 0, Map.w, object_size do
        love.graphics.line( x, 0, x, Map.h )
    end
    
    for y = 0, Map.h, object_size do
        love.graphics.line( 0, y, Map.w, y )
    end
    Camera:pop()

    local limit = 600
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.printf( "Move with 'Z', 'Q', 'S', 'D'\nPlace tile with LMB\nRemove tile with RMB\nGo to menu with 'Escape'", 20, love.graphics.getHeight() - 80, limit )
end