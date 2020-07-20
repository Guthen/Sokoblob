local P, W, _, B, D, DC, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_BUTTON, TILE_DOOR, TILE_DOOR_CLOSE, TILE_CUBE, TILE_SPOT

return {
	{ W, W, W, W, W, W, W, },
	{ W, _, _, _, W, W, W, },
	{ W, P, C, _, _, S, W, },
	{ W, _, _, _, W, W, W, },
	{ W, D, B, W, W, W, W, },
	{ W, _, C, _, _, S, W, },
	{ W, W, W, W, W, W, W, },
	high_score = 19,
}