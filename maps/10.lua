local P, W, _, B, D, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_BUTTON, TILE_DOOR, TILE_CUBE, TILE_SPOT

return {
    { W, W, W, W, W, W, W, W, W },
    { W, _, S, W, _, P, _, W, W },
    { W, _, _, D, _, C, _, W, W },
    { W, B, _, W, _, W, _, _, W },
    { W, C, _, D, _, B, _, _, W },
    { W, S, _, W, _, _, _, _, W },
    { W, W, W, W, W, W, W, W, W },
    high_score = 49,
}