extends Control
@onready var button_v_box = %ButtonVBox

signal return_game
signal main_menu
signal restart_game

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _on_visibility_changed() -> void:
	if visible:
		focus_button()

func focus_button() -> void:
	if button_v_box:
		var button: Button = button_v_box.get_child(0)
		if button is Button:
			button.grab_focus()

func _on_continue_button_pressed():
	return_game.emit()
	
func _on_return_button_pressed():
	main_menu.emit()

func _on_restart_button_pressed():
	restart_game.emit()



