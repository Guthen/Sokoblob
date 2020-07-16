local W, _, C, S = TILE_WALL_A, TILE_VOID, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W, W },
    { W, _, _, _, _, W },
    { W, _, W, C, _, W },
    { W, _, W, _, _, W },
    { W, S, _, _, _, W },
    { W, W, W, W, W, W },
    spawn = {
        x = 2,
        y = 2,
    },
    high_score = 8,
}