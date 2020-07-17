local P, W, _, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W, W },
    { W, P, _, _, _, W },
    { W, _, W, C, _, W },
    { W, _, W, _, _, W },
    { W, S, _, _, _, W },
    { W, W, W, W, W, W },
    high_score = 8,
}