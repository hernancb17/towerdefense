extends CharacterBody2D

class_name Enemy

@export var enemy_type: int

@export var health: int
@export var health_max: int
@export var enemy_speed: float
@export var reward: int
@export var damage: int
@export var modifier: int = 1

@onready var enemy_sprite = %EnemySprite

@onready var health_bar = $HealthBar

@export var dead = false

# Called when the node enters the scene tree for the first time
func _ready():
	# Initialization code here
	match enemy_type:
		0: set_stats("bat")
		1: set_stats("spider")
		2: set_stats("slime")

# Function to handle taking damage
func take_damage(amount: int):
	if health >=0:
		health -= amount
		health_bar.update_health(amount)
		if health < health_max and !health_bar.visible:
			health_bar.show()
		if health <=0:
			die()

# Function to handle the enemy's death
func die():
	Global.Gold += 1
	health_bar.hide()
	enemy_sprite.play("death")
	enemy_speed = 0
	dead = true
	await get_tree().create_timer(1).timeout
	get_parent().queue_free()

func set_stats(type: String):
	var stats = Global.enemy_stats.get(type)
	if stats:
		health_max = stats.health * modifier
		health_bar.max_value = health_max * modifier
		health_bar.value = health_max * modifier
		health_bar.min_value = 0
		health = health_max * modifier
		enemy_speed = stats.speed * modifier
		reward = stats.reward 
		enemy_sprite.play(stats.animation)
		
	else:
		health_max = randi_range(1,10)
		health = health_max
		enemy_speed = randf_range(0.01,0.08)
		reward = randi_range(1,5)
