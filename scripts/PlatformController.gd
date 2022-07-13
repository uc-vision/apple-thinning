extends MeshInstance

onready var current_state = State.DISABLED

enum State {
	DISABLED,
	IDLE,
	ELEVATING,
	LOWERING
}


func _ready():
	pass # Replace with function body.


#func _process(delta):
#	pass
func enable_buttons():
	current_state = State.IDLE
	
func disable_buttons():
	current_state = State.DISABLED

func _on_ElevateButtonArea_area_entered(area):
	if (current_state == State.IDLE):
		current_state = State.ELEVATING


func _on_ElevateButtonArea_area_exited(area):
	if (current_state != State.DISABLED):
		current_state = State.IDLE


func _on_LowerButtonArea_area_entered(area):
	if (current_state == State.IDLE):
		current_state = State.LOWERING


func _on_LowerButtonArea_area_exited(area):
	if (current_state != State.DISABLED):
		current_state = State.IDLE
