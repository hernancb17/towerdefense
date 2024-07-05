extends CanvasLayer

signal start_game
signal next_wave
signal wave_ended

func _on_wave_button_start_game():
	start_game.emit()

func _on_wave_button_next_wave():
	next_wave.emit()


func _on_path_spawner_wave_ended():
	wave_ended.emit()
