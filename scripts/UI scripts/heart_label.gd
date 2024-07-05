extends Label

signal health_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("health_changed", _decrease_health)
	self.text = str(Global.Heart)

func _decrease_health():
	self.text = str(Global.Heart)
