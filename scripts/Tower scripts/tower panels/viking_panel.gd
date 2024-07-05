extends Panel

@onready var dwarf_tower_scene = preload("res://scenes/tower_scenes/viking_tower.tscn")

var tilemap = null

var current_tower = PackedScene
var tower_cost = 2
@export var dragging = false

func _ready():
	pass

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if Global.Gold < tower_cost:
				#not enough gold
				return
			if not dragging:
				# Instantiate the tower and add it as a child
				current_tower = dwarf_tower_scene.instantiate()
				add_child(current_tower)
				dragging = true
		else:
			if dragging:
				# Drop the tower at the current position
				var center_tile = get_tilemap().is_space_occuppied(get_global_mouse_position())
				if center_tile != null:
					var world_node = get_tree().root.get_node("Main").get_node("world")
					var towers_node = world_node.get_node("Towers")
					remove_child(current_tower)
					Global.Gold -= 2
					towers_node.add_child(current_tower)
					current_tower.deploy_tower(center_tile)
					dragging = false
					current_tower = null
				else:
					remove_child(current_tower)
					dragging = false
					current_tower = null
	elif event is InputEventMouseMotion:
		if dragging:
			# Move the tower with the mouse
			current_tower.global_position = get_global_mouse_position()

func get_tilemap():
	var main_node = get_tree().root.get_node("Main")
	var world_node = main_node.get_node("world")
	var tilemap_node = world_node.get_node("TileMap")
	if tilemap_node:
		return tilemap_node
	return null
