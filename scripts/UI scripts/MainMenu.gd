extends Control

signal start_game

@onready var button_v_box = $MarginContainer/VBoxContainer/ButtonVBox

func _ready():
	focus_button()

func _on_start_game_button_pressed():
	start_game.emit()
	hide()


func _on_quit_game_button_pressed():
	get_tree().quit()
	
func _on_visibility_changed() -> void:
	if visible:
		focus_button()

func focus_button() -> void:
	if button_v_box:
		var button: Button = button_v_box.get_child(0)
		if button is Button:
			button.grab_focus()
