extends PathFollow2D

@export var enemy: CharacterBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	
func move(delta):
	if enemy:
		set_progress_ratio(get_progress_ratio() + enemy.enemy_speed * delta)
		if get_progress_ratio() >= 0.99:
			Global.decrease_health(1)
			enemy.queue_free()
			queue_free()
