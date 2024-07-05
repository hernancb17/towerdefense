extends TextureRect

@export var tower_scene: PackedScene
@export var tower_icon: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = tower_icon

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			get_viewport().gui_start_drag(texture, Vector2(16,16), self)
	elif event is InputEventMouseMotion:
		## While dragging, ensure the icon follows the mouse
		if is_drag_successful():
			set_position(event.position)

