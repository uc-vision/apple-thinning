extends MeshInstance

signal resume_button_pressed
signal exit_button_pressed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_ResumeButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		emit_signal("resume_button_pressed")


func _on_ExitButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		emit_signal("exit_button_pressed")
