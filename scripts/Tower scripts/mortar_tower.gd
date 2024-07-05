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
var new_target = false
var sell_value = roundi(Global.Mortar_cost / 2)

func _process(_delta):
	if current_target and deployed:
		if current_target.get_parent().dead:
			current_targets.erase(current_target)
			current_target = null
			find_new_target()
		elif just_deployed or new_target:
			just_deployed = false
			new_target = false
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
	animated_sprite_2d.play("shooting")
	print("timeout")

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
	new_target = true

func _on_animated_sprite_2d_frame_changed():
	if animated_sprite_2d.animation == "shooting" and animated_sprite_2d.frame == 4:
		#instantiate projectile on frame 4
		projectile = projectile_scene.instantiate()
		get_tree().root.call_deferred( "add_child",projectile)
		projectile.position = global_position
		
		# Pass the current target to the projectile
		projectile.target = current_target
		projectile.start = global_position
		projectile.end = current_target.global_position
		projectile.travel_time = Global.bomb_travel_time  # Adjust as needed
		projectile.elapsed_time = 0.0


func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.stop()
	print("finished")
	find_new_target()


func _on_animated_sprite_2d_animation_looped():
	print("looped")
	animated_sprite_2d.stop()
