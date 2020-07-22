local P, W, _, B, D, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_BUTTON, TILE_DOOR, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W, W, W },
    { W, _, _, _, W, W, W },
    { W, P, C, _, D, S, W },
    { W, _, B, _, W, W, W },
    { W, _, _, _, C, _, W },
    { W, _, S, _, _, _, W },
    { W, W, W, W, W, W, W },
    high_score = 23,
}