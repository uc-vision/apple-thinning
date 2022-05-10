extends RigidBody

signal on_picked
onready var picked_off = false

func _ready():
	pass
	

func picked_up():
	if !picked_off:
		emit_signal("on_picked")
		picked_off = true
		
func show_point():
	if !picked_off:
		get_node("PointNode").set_visible(true)
