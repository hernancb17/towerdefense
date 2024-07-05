extends Node

var Gold = 10
var Heart = 10
var is_game_over = false
var bomb_travel_time = 1.0
var Crossbow_cost = 1
var Mortar_cost = 3
var Dwarf_cost = 2

var enemy_stats = {
	"bat": {
		"health": 5,
		"speed": 0.02,
		"reward": 1,
		"damage":1,
		"animation": "bat_run"
	},
	"spider": {
		"health": 8,
		"speed": 0.01,
		"reward": 2,
		"damage": 2,
		"animation": "spider_run"
	},
	"slime": {
		"health": 10,
		"speed": 0.005,
		"reward": 2,
		"damage": 3,
		"animation": "slime_run"
	}
}

signal health_changed
signal game_over

func reset_global_variables():
	Gold = 10
	Heart = 10 
	is_game_over = false
	bomb_travel_time = 2.0

func decrease_health(amount: int):
	Heart -= amount
	if Heart <= 0 and !is_game_over:
		game_over.emit()
		is_game_over = true
	health_changed.emit()
