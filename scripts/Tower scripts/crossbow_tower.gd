extends CharacterBody2D

@export var detection_area: Area2D
@export var projectile_scene: PackedScene
@onready var shooting_delay = $ShootingDelay
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var panel = $Panel

var projectile: Node2D = null
var current_targets = []
var current_target: Node2D = null
var deployed = false
var just_deployed = false

func _process(_delta):
	if current_target and deployed:
		# Calculate the direction to the bat
		var direction = (current_target.global_position - global_position).normalized()
		# Calculate the angle to the bat
		var angle = direction.angle()
		# Rotate the character to face the bat
		rotation = angle
		if current_target.get_parent().dead:
			current_targets.erase(current_target)
			current_target = null
			find_new_target()
		elif just_deployed:
			just_deployed = false
			shoot_projectile()

	if current_target == null || current_target.get_parent().dead:
		animated_sprite_2d.stop()
	
func _ready():
	pass

func deploy_tower(center_tile):
	global_position = center_tile
	process_mode = Node.PROCESS_MODE_INHERIT
	deployed = true
	just_deployed = true
	_on_shooting_delay_timeout()
	shooting_delay.start()
	panel.remove_theme_stylebox_override("1")
	panel.add_theme_stylebox_override("none", StyleBoxEmpty.new())
	panel.modulate = Color(1,1,1,0)

func shoot_projectile():
	if not current_target:
		return
	animated_sprite_2d.play("Shooting")

func _on_range_area_entered(area):
	if area.name == "EnemyHitBox":
		if area not in current_targets:
			current_targets.append(area)
		if current_target == null:
			find_new_target()

func _on_range_area_exited(area):
	if area in current_targets:
		current_targets.erase(area)
	if area == current_target:
		current_target = null
		find_new_target()

func _on_shooting_delay_timeout():
	if current_target and !current_target.get_parent().dead:
		print("timeout")
		shoot_projectile()

func find_new_target():
	current_targets = current_targets.filter(func(target):
		return target != null and not target.get_parent().dead
	)
	
	if current_targets.size() == 0:
		current_target = null
		return

	var farthest_target = current_targets[0]
	var max_distance = (farthest_target.global_position - global_position).length()

	for target in current_targets:
		var distance = (target.global_position - global_position).length()
		if distance > max_distance:
			farthest_target = target
			max_distance = distance

	current_target = farthest_target

func _on_animated_sprite_2d_frame_changed():
	if animated_sprite_2d.animation == "Shooting" and animated_sprite_2d.frame == 3:
		#instantiate projectile on frame 3
		projectile = projectile_scene.instantiate()
		get_tree().root.call_deferred( "add_child",projectile)
		projectile.position = global_position
		projectile.direction = (current_target.global_position - global_position).normalized()
		projectile.rotation = projectile.direction.angle()


func _on_animated_sprite_2d_animation_finished():
	if current_target.get_parent().dead:
		find_new_target()
