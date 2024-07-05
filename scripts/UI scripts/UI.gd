extends CanvasLayer
class_name UI

signal start_game
signal menu_opened
signal menu_closed
signal restart_game
signal quit_to_menu
signal on_game_over

@onready var main_menu = %MainMenu
@onready var pause_menu = %PauseMenu
@onready var transition = %Transition
@onready var screen_transition = $ScreenTransition
@onready var end_game_menu = %EndGameMenu

func _ready():
	Global.connect("game_over", _on_game_over_menu)

func _on_main_menu_start_game() -> void:
	print("transition")
	transition.show()
	screen_transition.play("screen_transition")
	start_game.emit()
	await screen_transition.animation_finished
	transition.hide()

func _input(event):
	if !main_menu.visible and event.is_action_pressed("ui_cancel"):
		pause_menu.visible = !pause_menu.visible
		if pause_menu.visible:
			menu_opened.emit()
		else:
			menu_closed.emit()

func _on_pause_menu_main_menu():
	if screen_transition.is_playing():
		await screen_transition.animation_finished
	pause_menu.hide()
	transition.show()
	screen_transition.play_backwards("screen_transition")
	await screen_transition.animation_finished
	transition.hide()
	quit_to_menu.emit()
	main_menu.show()

func _on_pause_menu_return_game():
	pause_menu.hide()
	menu_closed.emit()

func _on_pause_menu_restart_game():
	if screen_transition.is_playing():
		await screen_transition.animation_finished
	pause_menu.hide()
	start_game.emit()

func _on_end_game_menu_start_game():
	_on_main_menu_start_game()

func _on_game_over_menu():
	if screen_transition.is_playing():
		await screen_transition.animation_finished
	#add game over transition
	on_game_over.emit()
	end_game_menu.show()
