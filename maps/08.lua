local W, _, B, D, C, S = TILE_WALL_A, TILE_VOID, TILE_BUTTON, TILE_DOOR, TILE_CUBE, TILE_SPOT

return {
    { _, _, W, W, W, W, W, },
    { _, _, W, _, _, _, W, },
    { _, _, W, _, B, _, W, },
    { _, _, W, _, C, _, W, },
    { W, W, W, _, _, _, W, },
    { W, S, D, _, C, _, W, },
    { W, W, W, _, _, _, W, },
    { W, W, W, W, W, W, W, },
    spawn = {
        x = 5,
        y = 5,
    }
}