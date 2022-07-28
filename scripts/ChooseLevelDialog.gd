extends MeshInstance

signal no_time_limit_pressed
signal time_attack_pressed

func _on_NoTimeLimitLevelButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		play_button_press_sound()
		emit_signal("no_time_limit_pressed")


func _on_TimeAttackLevelButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		play_button_press_sound()
		emit_signal("time_attack_pressed")

func play_button_press_sound():
	$ButtonPressSoundPlayer.play()

func disable_buttons():
	$NoTimeLimitLevelButton/NoTimeLimitLevelButtonArea.set_monitoring(false)
	$NoTimeLimitLevelButton/NoTimeLimitLevelButtonArea/CollisionShape.set_disabled(true)
	$TimeAttackLevelButton/TimeAttackLevelButtonArea.set_monitoring(false)
	$TimeAttackLevelButton/TimeAttackLevelButtonArea/CollisionShape.set_disabled(true)
