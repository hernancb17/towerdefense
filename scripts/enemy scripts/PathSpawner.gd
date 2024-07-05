extends Node2D

# Bat enemy scene to instantiate
@export var enemy_scene: PackedScene
@export var path2d: NodePath

const EnemyPath = preload("res://scripts/enemy scripts/enemy_path.gd")
@export var two_factor: int = 0
@export var modifier: float = 1
@export var wave_interval: float = 5
@export var enemies_per_wave : int = 2 ** two_factor
@export var enemy_spacing : float = 0.2  # Spacing between enemies along the path
@export var number_of_waves: int = 2 ** two_factor

@onready var path_2d = $Path2D

var spawn_timer: Timer
var empty_wave_timer: Timer
var spawn_delay: Timer
signal wave_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = wave_interval
	
	empty_wave_timer = Timer.new()
	add_child(empty_wave_timer)
	empty_wave_timer.wait_time = 1
	empty_wave_timer.timeout.connect(_on_empty_wave_timer_timeout)
	
	spawn_delay = Timer.new()
	add_child(spawn_delay)
	spawn_delay.wait_time = 0.5

func spawn_wave():
	for j in range(0,number_of_waves):
		for i in range(0,enemies_per_wave):
			var path_follow = EnemyPath.new()
			path_2d.add_child(path_follow)
			var enemy = enemy_scene.instantiate()
			enemy.enemy_type = randi_range(0,2)
			enemy.modifier = modifier
			path_follow.enemy = enemy
			if !enemy.enemy_type == 1:
				path_follow.rotates = false
			path_follow.add_child(enemy)
			spawn_delay.start()
			await spawn_delay.timeout
		await spawn_timer.timeout
		
	spawn_timer.stop()
	empty_wave_timer.start()


func wave_increase_difficulty():
	print(modifier)
	two_factor += 1
	modifier += 0.1 * two_factor
	enemies_per_wave = 2 ** two_factor
	number_of_waves = 2 ** two_factor

func _on_empty_wave_timer_timeout():
	if get_child(0).get_child_count() == 0:
		empty_wave_timer.stop()
		wave_ended.emit()

func _on_hud_start_game():
	spawn_timer.start()
	spawn_wave()

func _on_hud_next_wave():
	wave_increase_difficulty()
	spawn_timer.start()
	spawn_wave()
