extends Camera2D

func _ready():
	# Center the camera on the tilemap
	var tilemap = get_parent().get_node("TileMap")
	if tilemap:
		var map_width = tilemap.tile_set.tile_size.x * tilemap.get_used_rect().size.x
		var map_height = tilemap.tile_set.tile_size.y * tilemap.get_used_rect().size.y
		position = Vector2(map_width / 2, map_height / 2)
	
	# Set zoom to ensure pixel-perfect scaling
	zoom = Vector2(1, 1)
