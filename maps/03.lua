local W, _, C, S = TILE_WALL_A, TILE_VOID, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W, W, W },
    { W, S, _, _, _, _, W },
    { W, _, W, C, W, _, W },
    { W, _, _, _, C, _, W },
    { W, _, _, _, S, _, W },
    { W, W, W, W, W, W, W },
    spawn = {
        x = 5,
        y = 2,
    }
}