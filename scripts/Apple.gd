extends RigidBody

signal on_picked
onready var picked_off = false
onready var is_score_visible = false
export(int, FLAGS, "Has Strong Sun Exposure") var has_strong_sun_exposure = false

func _ready():
	if has_strong_sun_exposure:
		$AppleMesh.set_layer_mask(2)
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
	return get_parent().get_parent().is_interactable

func is_picked_off():
	return picked_off
