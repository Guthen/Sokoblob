local W, _, B, D, C, S = TILE_WALL_A, TILE_VOID, TILE_BUTTON, TILE_DOOR, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W, W, W, W, W, W, W, },
    { W, _, _, _, _, _, _, D, _, _, W, },
    { W, D, W, W, _, W, _, W, W, _, W, },
    { W, _, C, _, _, _, B, _, _, _, W, },
    { W, W, W, W, _, W, _, W, W, _, W, },
    { _, _, _, W, _, W, _, _, W, S, W },
    { _, _, _, W, _, W, C, _, W, W, W },
    { _, _, _, W, S, _, _, _, W, W, W },
    { _, _, _, W, W, W, W, W, W, W, W },
    spawn = {
        x = 7,
        y = 5,
    },
    options = {
        scale = .87,
    }
}