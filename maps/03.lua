local P, W, _, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W, W, W },
    { W, S, _, _, P, _, W },
    { W, _, W, C, W, _, W },
    { W, _, _, _, C, _, W },
    { W, _, _, _, S, _, W },
    { W, W, W, W, W, W, W },
    high_score = 20,
}