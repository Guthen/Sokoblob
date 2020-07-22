local P, W, _, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W },
    { W, _, _, P, W },
    { W, _, C, W, W },
    { W, _, _, W, W },
    { W, _, _, S, W },
    { W, W, W, W, W },
    high_score = 6,
}