local W, _, B, D, C, S = TILE_WALL_A, TILE_VOID, TILE_BUTTON, TILE_DOOR, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W, W, W },
    { W, _, _, _, W, W, W },
    { W, _, C, _, D, S, W },
    { W, _, _, _, W, W, W },
    { W, _, B, _, C, _, W },
    { W, _, _, _, _, _, W },
    { W, W, W, W, W, W, W },
    spawn = {
        x = 2,
        y = 3,
    }
}