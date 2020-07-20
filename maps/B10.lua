local P, W, _, B, D, DC, C, S = TILE_PLAYER, TILE_WALL_A, TILE_VOID, TILE_BUTTON, TILE_DOOR, TILE_DOOR_CLOSE, TILE_CUBE, TILE_SPOT

return {
	{ W, W, W, W, W, W, W, W, W, W, _, },
	{ W, S, W, W, P, _, DC, _, _, W, _, },
	{ W, DC, W, W, _, C, W, W, _, W, _, },
	{ W, _, W, W, _, _, _, _, C, W, _, },
	{ W, _, _, _, _, _, W, W, _, W, _, },
	{ W, _, W, W, _, B, S, W, D, W, _, },
	{ W, C, W, W, _, W, W, W, _, W, _, },
	{ W, _, _, D, _, _, _, W, S, W, _, },
	{ W, W, W, W, W, W, W, W, W, W, _, },
	high_score = 50,
	options = {
		scale = .95
	},
}