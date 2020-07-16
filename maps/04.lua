local W, _, C, S = TILE_WALL_A, TILE_VOID, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W, W, W, W },
    { W, _, _, _, _, _, _, W },
    { W, _, C, W, _, W, _, W },
    { W, _, _, _, _, _, _, W },
    { W, W, W, W, _, W, _, W },
    { _, _, _, W, _, _, S, W },
    { _, _, _, W, W, W, W, W },
    spawn = {
        x = 6,
        y = 6,
    },
    high_score = 22,
}