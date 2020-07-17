local P, W, _, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_CUBE, TILE_SPOT

return {
    { _, _, _, _, W, W, W, W, W, _, _, _, _ },
    { _, _, _, _, W, _, _, _, W, W, W, W, _ },
    { _, _, _, _, W, _, W, C, _, _, _, W, _ },
    { _, _, _, _, W, _, W, _, W, W, _, W, _ },
    { _, _, _, _, W, _, _, _, _, _, _, W, _ },
    { _, _, _, _, W, _, W, _, W, _, _, W, _ },
    { _, _, _, _, W, _, W, _, W, _, _, W, _ },
    { W, W, W, W, W, _, W, _, W, W, _, W, W },
    { W, _, _, _, _, P, _, _, W, W, _, _, W },
    { W, _, W, _, W, _, W, W, W, _, _, _, W },
    { W, _, C, _, W, _, W, W, W, _, _, _, W },
    { W, _, _, _, W, S, W, W, W, W, _, S, W },
    { W, W, W, W, W, W, W, W, W, W, W, W, W },
    options = {
        scale = .6,
    },
    high_score = 88,
}