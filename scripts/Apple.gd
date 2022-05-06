extends RigidBody

signal on_picked
var picked_off = false
#var point
#
#const Point = {
#	HEALTHY_LARGE = 1.5,
#	HEALTHY_SMALL = 1,
#	DAMAGED = -3,
#}

func _ready():
	var apple_cluster = get_parent()
	apple_cluster.connect("on_picked", self, "_on_Apple_on_picked")
#	var name = get_tree().current_scene.get_name()
#	if name == "HealthyLargeApple":
#		point = Point.HEALTHY_LARGE
#	elif name == "HealthySmallApple":
#		point = Point.HEALTHY_SMALL
#	else:
#		point = Point.DAMAGED

func picked_up():
	if !picked_off:
		emit_signal("on_picked")
		picked_off = true
