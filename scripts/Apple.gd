extends RigidBody

signal on_picked
onready var picked_off = false
onready var is_score_visible = false

func _ready():
	pass
	

func picked_up():
	if !picked_off:
		picked_off = true
		emit_signal("on_picked", self)
		
func show_point():
	if !picked_off:
		is_score_visible = true
		get_node("PointNode").set_visible(true)
		
func hide_point():
	if picked_off:
		is_score_visible = false
		get_node("PointNode").set_visible(false)

# Get apple being pickable or not from the parent apple cluster.
func is_interactable():
	return get_parent().is_interactable
