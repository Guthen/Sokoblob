local P, W, _, B, D, DC, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_BUTTON, TILE_DOOR, TILE_DOOR_CLOSE, TILE_CUBE, TILE_SPOT

return {
	{ W, W, W, W, W, W, W, W, W, W, W, },
	{ W, S, _, _, W, P, W, _, _, S, W, },
	{ W, _, _, _, D, _, D, _, C, _, W, },
	{ W, _, _, _, W, _, W, _, _, _, W, },
	{ W, W, DC, W, W, C, W, W, D, W, W, },
	{ W, _, _, _, _, B, _, _, C, _, W, },
	{ W, W, DC, W, W, _, W, W, D, W, W, },
	{ W, _, _, _, W, _, W, _, _, _, W, },
	{ W, _, C, _, DC, _, DC, _, _, _, W, },
	{ W, S, _, _, W, _, W, _, _, S, W, },
	{ W, W, W, W, W, W, W, W, W, W, W, },
	high_score = 51,
	options = {
		scale = .765,
	},
}