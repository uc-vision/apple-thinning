extends MeshInstance

var signal_sent = false
signal no_time_limit_pressed
signal time_attack_pressed

func _on_NoTimeLimitLevelButtonArea_area_entered(area):
	if "HandArea" in area.get_groups() and not signal_sent:
		play_button_press_sound()
		signal_sent = true
		emit_signal("no_time_limit_pressed")


func _on_TimeAttackLevelButtonArea_area_entered(area):
	if "HandArea" in area.get_groups() and not signal_sent:
		play_button_press_sound()
		signal_sent = true
		emit_signal("time_attack_pressed")

func play_button_press_sound():
	$ButtonPressSoundPlayer.play()
