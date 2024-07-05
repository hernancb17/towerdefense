extends Node2D

@export var speed: float = 200
@export var direction: Vector2 = Vector2.ZERO
@export var damage: int = 2
var travel_time: Timer

@onready var projectile_sprite = $ProjectileSprite

func _ready():
	travel_time = Timer.new()
	travel_time.wait_time = 3
	travel_time.timeout.connect(_on_travel_time_ended_timeout)
	add_child(travel_time)
	travel_time.start()
	
func _process(delta):
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta

func _on_area_2d_area_entered(area):
	if area.name == "EnemyHitBox":
		var enemy = area.get_parent()
		enemy.take_damage(damage)
		queue_free()

func _on_travel_time_ended_timeout():
	queue_free()
