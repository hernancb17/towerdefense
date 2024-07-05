extends Control

@onready var next_wave_button = %NextWaveButton
@onready var start_game_button = %StartGameButton

signal start_game
signal next_wave

func _on_next_wave_button_pressed():
	next_wave_button.hide()
	next_wave.emit()

func _on_start_game_button_pressed():
	start_game_button.hide()
	start_game.emit()

func _on_hud_wave_ended():
	next_wave_button.show()
