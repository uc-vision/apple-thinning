extends MeshInstance

signal confirm_exit_pressed
signal cancel_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	disable()
	
func enable():
	set_visible(true)
	$ExitButton/ExitButtonArea.set_monitoring(true)
	$CancelButton/CancelButtonArea.set_monitoring(true)
	
func disable():
	set_visible(false)
	$ExitButton/ExitButtonArea.set_monitoring(false)
	$CancelButton/CancelButtonArea.set_monitoring(false)


func _on_ExitButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		emit_signal("confirm_exit_pressed")

func _on_CancelButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		emit_signal("cancel_button_pressed")
