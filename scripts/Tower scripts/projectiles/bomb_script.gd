extends Node2D

@export var speed: float = 40
@export var damage: int = 3
var start: Vector2
var end: Vector2
var elapsed_time: float = 0.0
@export var travel_time: float = 1.0  # Time to reach the target
var target: Node2D
var exploded: bool
var enemies_on_explosion: Array

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var explosion_area = $ExplosionArea
@onready var collision_shape_2d = $ExplosionArea/CollisionShape2D
@onready var sprite_2d = $Sprite2D

func _ready():
	scale = scale / 2
	explosion_area.hide()
	collision_shape_2d.hide()
	
func _process(delta):
	if elapsed_time < travel_time:
		elapsed_time += delta
		var t = elapsed_time / travel_time
		# Calculate the parabolic path
		var position_x = lerp(start.x, end.x, t)
		var height = 4 * t * (t - 1)
		var position_y = lerp(start.y, end.y, t) + height * 30  # Adjust height multiplier as needed
		position = Vector2(position_x, position_y)
		
		# Optionally, adjust the rotation to face the movement direction (if you want)
		var direction = (Vector2(position_x, position_y) - position).normalized()
		rotation = direction.angle()
	
	if elapsed_time < travel_time / 2:
		scale = scale * (1 + delta)
	if elapsed_time >= travel_time / 2 and elapsed_time < travel_time / 1.5:
		scale = scale / (1 + delta)
	
	# Check if the projectile has reached the target
	if elapsed_time >= travel_time and !exploded:
		exploded = true
		sprite_2d.hide()
		animated_sprite_2d.show()
		animated_sprite_2d.play("explosion")
		explosion_area.show()
		collision_shape_2d.set_deferred("disabled", false)
	
func lerp(a: float, b: float, t: float) -> float:
	return a + (b - a) * t
	

func _on_explosion_area_area_entered(area):
	if area.name == "EnemyHitBox" and !area.get_parent().dead:
		enemies_on_explosion.append(area)

func _on_explosion_area_area_exited(area):
	if area in enemies_on_explosion:
		enemies_on_explosion.erase(area)

func _on_animated_sprite_2d_animation_finished():
	if exploded:
		explosion_area.hide()
		collision_shape_2d.set_deferred("disabled", true)
		animated_sprite_2d.stop()
		queue_free()
	
func _on_animated_sprite_2d_frame_changed():
	if animated_sprite_2d.frame == 1:
		for enemy in enemies_on_explosion:
			enemy.get_parent().take_damage(damage)
