local W, _, C, S = TILE_WALL_A, TILE_VOID, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W },
    { W, _, _, _, W },
    { W, _, C, W, W },
    { W, _, _, W, W },
    { W, _, _, S, W },
    { W, W, W, W, W },
    spawn = {
        x = 4,
        y = 2,
    }
}