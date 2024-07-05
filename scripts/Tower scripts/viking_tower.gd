extends CharacterBody2D

var deployed = false
var rotation_speed = 1
@export var damage = 1

func _process(delta):
	if deployed:
		self.rotation += rotation_speed * delta
		
func _ready():
	pass

func deploy_tower(center_tile):
	self.global_position = center_tile
	self.process_mode = Node.PROCESS_MODE_INHERIT
	deployed = true

func _on_area_2d_area_entered(area):
	if area.name == "EnemyHitBox":
		var enemy = area.get_parent()
		enemy.take_damage(damage)
