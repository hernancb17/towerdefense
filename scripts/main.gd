extends Node2D
class_name Game

@export var world_scene: PackedScene
@export var ui: UI

var world: World

func _ready():
	pass
	
func start_game():
	if world:
		remove_child(world)
		world.queue_free()
		world = null
	world = world_scene.instantiate()
	Global.reset_global_variables()
	get_tree().paused = false
	add_child(world)
	move_child(world,0)

func _on_ui_start_game():
	print("start")
	start_game()

func _on_ui_quit_to_menu():
	if world:
		world.queue_free()
		world = null

func _on_ui_menu_closed():
	get_tree().paused = false

func _on_ui_menu_opened():
	get_tree().paused = true


func _on_ui_on_game_over():
	if world:
		remove_child(world)
		world.queue_free()
		world = null
		Global.reset_global_variables()


func _on_ui_restart_game():
	pass # Replace with function body.
