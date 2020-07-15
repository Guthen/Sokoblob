local W, _, B, D, DC, C, S = TILE_WALL_A, TILE_VOID, TILE_BUTTON, TILE_DOOR, TILE_DOOR_CLOSE, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W, W, W, W, W, W, W, W, W, },
    { W, _, _, _, _, _, S, _, _, _, _, _, W, },
    { W, _, W, W, W, W, _, W, W, W, W, _, W, },
    { W, _, W, _, _, _, D, _, C, _, W, _, W, },
    { W, _, W, C, _, _, _, _, _, _, W, _, W, },
    { W, _, W, _, _, W, _, W, _, _, W, _, W, },
    { W, S, _,DC, _, _, B, _, _,DC, _, S, W, },
    { W, _, W, _, _, W, _, W, _, _, W, _, W, },
    { W, _, W, _, _, _, _, _, _, C, W, _, W, },
    { W, _, W, _, C, _, D, _, _, _, W, _, W, },
    { W, _, W, W, W, W, _, W, W, W, W, _, W, },
    { W, _, _, _, _, _, S, _, _, _, _, _, W, },
    { W, W, W, W, W, W, W, W, W, W, W, W, W, },
    spawn = {
        x = 2,
        y = 2,
    },
    options = {
        scale = .65,
    },
}