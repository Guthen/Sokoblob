local P, W, _, B, D, DC, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_BUTTON, TILE_DOOR, TILE_DOOR_CLOSE, TILE_CUBE, TILE_SPOT

return {
	{ W, W, W, W, W, W, W, W, W, },
	{ W, S, _, _, D, _, _, S, W, },
	{ W, _, W, B, W, _, W, W, W, },
	{ W, _, _, _, D, _, W, W, W, },
	{ W, W, W,DC, W, _, W, W, W, },
	{ W, _, C, S, _, _, _, _, W, },
	{ W, _, W,DC, W, _, W, _, W, },
	{ W, _, W, C, W, P, W, _, W, },
	{ W, _, W, _, W, C, W, _, W, },
	{ W, _, _, _, _, _, _, _, W, },
	{ W, W, W, W, W, W, W, W, W, },
	high_score = 85,
	options = {
		scale = .8,
	}
}