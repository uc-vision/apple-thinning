extends MeshInstance

var signal_sent = false

signal exit_button_pressed

func enable():
	set_visible(true)
	$ExitToMenuButtonArea.set_monitoring(true)
	$ExitToMenuButtonArea/CollisionShape.set_disabled(false)
	signal_sent = false


func disable():
	$ExitToMenuButtonArea.set_monitoring(false)
	$ExitToMenuButtonArea/CollisionShape.set_disabled(true)
	
	
func _on_ExitToMenuButtonArea_area_entered(area):
	if "HandArea" in area.get_groups() and not signal_sent:
		signal_sent = true
		emit_signal("exit_button_pressed")
