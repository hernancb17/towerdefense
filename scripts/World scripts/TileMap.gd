extends TileMap

@export var occupied_tiles = {}

func is_space_occuppied(mouse_position):
	var tile_position = Vector2(floor(mouse_position.x / tile_set.tile_size.x),
								floor(mouse_position.y / tile_set.tile_size.y))
								
	#check if tile is ocuppied
	var isEnemyPath = is_enemy_path(tile_position)
	if occupied_tiles.has(tile_position) or isEnemyPath:
		##TODO: add toast message
		return null
	
	#mark the tile as occupied
	occupied_tiles[tile_position] = true
	
	return map_to_local(tile_position)
	
func is_enemy_path(tile_position):
	var tile_data = get_cell_tile_data(0,tile_position)
	if !tile_data is TileData:
		return null
	
	var terrain_mark = tile_data.get_custom_data_by_layer_id(0)
	return terrain_mark
