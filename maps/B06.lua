local P, W, _, B, D, DC, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_BUTTON, TILE_DOOR, TILE_DOOR_CLOSE, TILE_CUBE, TILE_SPOT

return {
	{ W, W, W, W, W, W, W, W, },
	{ W, _, _, _, _, _, _, W, },
	{ W, _, D, C, _,DC, S, W, },
	{ W, _, _, _, _, _, _, W, },
	{ W, W, P, W, W, B, W, W, },
	{ W, _, _, _, _, _, _, W, },
	{ W, _,DC, C, _, D, S, W, },
	{ W, _, _, _, _, _, _, W, },
	{ W, W, W, W, W, W, W, W, },
	high_score = 39,
}