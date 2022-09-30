extends "res://scripts/ConfirmationDialog.gd"

signal confirm_finish_pressed

func _on_ExitButtonArea_area_entered(area):
	if "HandArea" in area.get_groups() and not signal_sent:
		play_button_press_sound()
		signal_sent = true
		emit_signal("confirm_finish_pressed")
		
func disable():
	set_visible(false)
	$ExitButton/ExitButtonArea.set_monitoring(false)
	$CancelButton/CancelButtonArea.set_monitoring(false)
	$ExitButton/ExitButtonArea/CollisionShape.set_disabled(true)
	$CancelButton/CancelButtonArea/CollisionShape.set_disabled(true)
